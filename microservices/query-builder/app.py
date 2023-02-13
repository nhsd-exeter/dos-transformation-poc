import json
import boto3
import datetime
from boto3.dynamodb.conditions import Key

def lambda_handler(event, context):
    
    parsed_json = json.dumps(event)
    input = json.loads(parsed_json)
    
    search_query = input['search_query']
    search_profile = input['query_modifiers']['search_profile']
    geo_profiles = input['query_modifiers']['geo_profiles']

    base_query = construct_base_query(search_query)

    print(base_query)

    profiled_query = profile_query(base_query, search_profile, geo_profiles)

    print(profiled_query)
        
   
    resp = {
        "search_index": 'directory-index',
        "search_query": profiled_query
    }
    
    json_response = json.dumps(resp)

    return  json_response



def construct_base_query(consumer_query):

    #PLEASE CONSIDER: IN FUTURE THE MAPPING OF THE VARIABLES NEEDED FOR THE DOS SEARCH
    #COULD BE ABSTRACTED AWAY INTO A SEARCH PROFILE TO ADD FLEXIBILITY TO THE INPUT
    #FOR NOW, ITS HARD CODED HERE:

    requested_activity = consumer_query['activity']['detail']['code']['code']
    chief_complaint = consumer_query['addresses']['code']
    requested_acuity = consumer_query['activity']['detail']['scheduledPeriod']['acuity']
    requested_location = consumer_query['activity']['detail']['location']['position']

    patient_age_range= consumer_query['subject']['birthDate']
    patient_gender = consumer_query['subject']['gender']

    query_datetime = datetime.datetime.now()
    query_day = query_datetime.strftime("%a")
    query_time = query_datetime.strftime("%H:%M:%S")

 
    #BUILD THE BASIC ELASTIC QUERY
    base_query = {"query": {
        "bool" : {
            "must": 
                [
                    {"match": {"referralProfiles.activitiesOffered": requested_activity}},
                    {"match": {"referralProfiles.acuities": requested_acuity}},
                    {"match": {"referralProfiles.referralSpecificProperties.eligibility.gender": patient_gender}},
                    {"match" : {"referralProfiles.referralSpecificProperties.eligibility.ageRange": patient_age_range}},
                    {"match" : {"referralProfiles.referralSpecificProperties.availableTime.daysOfWeek": query_day}},
                    {"bool": {
                        "should": 
                            [
                                {"match" : {"referralProfiles.referralSpecificProperties.availableTime.allDay": True}},
                                {"bool":
                                    {
                                        "must": 
                                            [
                                                { "range":
                                                    { "referralProfiles.referralSpecificProperties.availableTime.openingTime": {
                                                        "gte": query_time,
                                                        "lte": 0
                                                    }
                                                    }
                                                },
                                                { "range":
                                                    { "referralProfiles.referralSpecificProperties.availableTime.closingTime": {
                                                        "gte": 0,
                                                        "lte": query_time
                                                    }
                                                    }
                                                }
                                            ]
                                    }
                                }
                            ]
                        }
                    }
                ]
        }
    }}

    return base_query



def profile_query(base_query, search_profile, geo_profiles):

    profiled_query = base_query

    if not geo_profiles:
        print('No relevant geo-sorting strategy is associated with this postcode.')
    else:
        for geo_profile in geo_profiles:
            print('Selecting highest priority geo-profile')
            #PERFORM SEQUENTIAL SELECTION THROUGH LADS, LDAS, ETC.


    if search_profile['exclusions']:
        profiled_query['query']['bool']['must_not'] = []
        for exclusion in search_profile['exclusions']:
            if not exclusion:
                continue
            profiled_query['query']['bool']['must_not'].append(json.loads(exclusion))

    if search_profile['sorters']:
        profiled_query['sort'] = []
        for sorter in search_profile['sorters']:
            if not sorter:
                continue
            profiled_query['sort'].append(json.loads(sorter))

    if search_profile['redactions']:
        profiled_query['_source'] = {'excludes' : [] }
        for redaction in search_profile['redactions']:
            if not redaction:
                continue
            profiled_query['_source']['excludes'].append(redaction)

    #TBC IF WE HAVE A USE CASE FOR FORMATTERS, AS THIS MIGHT NOT BE NEEDED

    return profiled_query


def calculate_patient_age_range(date):
    return "0-129yrs"