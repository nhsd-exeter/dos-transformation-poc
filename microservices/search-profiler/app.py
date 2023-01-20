import json
import boto3
import datetime
from boto3.dynamodb.conditions import Key
from boto3.dynamodb.types import TypeDeserializer

def lambda_handler(event, context):
    
    parsed_json = json.dumps(event)
    input_terms = json.loads(parsed_json)
    
    search_query = input_terms["search_query"]
    api_key = input_terms["api_key"]
    
    dynamodb = boto3.resource('dynamodb')

    patient_postcode = search_query['subject']['address']['postalCode']
    #THIS POSTCODE CAN BE USED TO SELECT AN APPROPRIATE GEO-PROFILE FOR RANKING STRATEGY
    
    
    
    #Determine the consumer by querying the api-key 
    search_consumers_table = dynamodb.Table('search-consumers')      
    
    
    consumer_resp = search_consumers_table.get_item(
            Key={
                'key' : api_key,
            }
        )
  

    #locate the appropriate search profile for this consumer
    if 'Item' in consumer_resp:
        search_profile_id = consumer_resp['Item'].get("search-profile-id")
    else:
        raise ValueError('This API Key is not associated with a valid search profile.')
 


    search_profiles_table = dynamodb.Table('search-profiles')      
    
    search_profile_resp = search_profiles_table.get_item(
            Key={
                'id' : search_profile_id,
            }
        )


    if 'Item' in  search_profile_resp:
        search_profile = search_profile_resp['Item']
    else:
        raise ValueError('The search profile associated with this API Key cannot be found')
 
        
    
    base_query = construct_base_query(search_query)

    print(base_query)

    profiled_query = profile_query(base_query, search_profile)

    print(profiled_query)
    
    
    
    # profiled_query = search_query
    
    resp = {
        "search_query": profiled_query,
    }
    
    json_response = json.dumps(resp)

    return  json_response



def construct_base_query(careplan_query):

    #PLEASE CONSIDER: IN FUTURE THE MAPPING OF THE VARIABLES NEEDED FOR THE DOS SEARCH
    #COULD BE ABSTRACTED AWAY INTO A SEARCH PROFILE TO ADD FLEXIBILITY TO THE INPUT
    #FOR NOW, ITS HARD CODED HERE:

    requested_activity = careplan_query['activity']['detail']['code']['code']
    chief_complaint = careplan_query['activity']['detail']['reasonCode']['code']
    requested_acuity = careplan_query['activity']['detail']['scheduledPeriod']['acuity']
    requested_location = careplan_query['activity']['detail']['location']['position']

    patient_gender = careplan_query['subject']['birthDate']
    patient_age_range = careplan_query['subject']['gender']

    query_datetime = datetime.datetime.now()
    query_day = query_datetime.strftime("%a")
    query_time = datetime.time.now()

 
    #BUILD THE BASIC ELASTIC QUERY
    base_query = {"query": {
        "bool" : {
            "must": {
                [
                    #THE RETURNED SERVICE MUST HAVE A REFERAL PROFILE WITH CODES MATCHING THE REQUESTED ACTIVITY/ACUITY
                    {"match": {"referralProfiles.activitiesOffered": requested_activity}},
                    {"match": {"referralProfiles.acuities": requested_acuity}},
                    {"match": {"referralProfiles.referralSpecificProperties.eligibility.gender": patient_gender}},
                    {"match" : {"referralProfiles.referralSpecificProperties.eligibility.ageRange": patient_age_range}},
                    {"match" : {"referralProfiles.referralSpecificProperties.availableTime.daysOfWeek": query_day}},
                    {"bool": {
                        "should": {
                            [
                                #ADDITIONALLY, THE RETURNED SERVICE MUST HAVE EITHER... 
                                {
                                    "must": {
                                        [
                                            #AVAILABILITY ALL DAY
                                            {"match" : {"referralProfiles.referralSpecificProperties.availableTime.allDay": True}},
                                        ]
                                    }
                                },
                                {
                                    "must": {
                                        [
                                            #THE AVAILABILITY TIMES THAT ARE SUITABLE FOR THE CURRENT SEARCH TIME
                                            { "referralProfiles.referralSpecificProperties.availableTime": { "openingTime": { "gte": 0, "lte": query_time } } },
                                            { "referralProfiles.referralSpecificProperties.availableTime": { "closingTime": { "gte": query_time, "lte": 0 } } }
                                        ]
                                    }
                                }

                            ]
                        }
                    }}


                ]
            }
        }
    }}

    return base_query



def profile_query(base_query, search_profile):

    deserializer = TypeDeserializer()
    deserialized_search_profile = {k: deserializer.deserialize(v) for k, v in search_profile.items()}

    profiled_query = base_query


    if deserialized_search_profile['exclusions']:
        profiled_query['query']['bool']['must_not'] = []
        for exclusion in deserialized_search_profile['exclusions']:
            profiled_query['query']['bool']['must_not'].append(exclusion)

    if deserialized_search_profile['sorters']:
        profiled_query['query']['bool']['sort'] = []
        for sorter in deserialized_search_profile['sorters']:
            profiled_query['sort'].append(sorter)

    if deserialized_search_profile['redactions']:
        profiled_query['_soure']['excludes'] = []
        for redaction in deserialized_search_profile['redactions']:
            profiled_query['_soure']['excludes'].append(redaction)

    #TBC IF WE HAVE A USE CASE FOR FORMATTERS, AS THIS MIGHT NOT BE NEEDED

    return profiled_query


def calculate_patient_age_range(date):
    return "0-129yrs"