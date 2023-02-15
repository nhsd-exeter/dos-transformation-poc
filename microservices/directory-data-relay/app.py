import json
import os
import boto3
from boto3.dynamodb.types import TypeDeserializer
import requests
from requests_aws4auth import AWS4Auth

region = os.environ['ES_region'] 
service = 'es'
credentials = boto3.Session().get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)

host = os.environ['ES_domain']
index = os.environ['ES_index']
type = '_doc'
url = 'https://' + host + '/' + index + '/' + type + '/'

headers = { "Content-Type": "application/json" }

def lambda_handler(event, context):

    count = 0
    for record in event['Records']:
        id = record['dynamodb']['Keys']['id']['S']

        if record['eventName'] == 'REMOVE':
            r = requests.delete(url + id, auth=awsauth)
        else:
            service = ddb_deserialize(record['dynamodb']['NewImage'])
            print(service)

            # IN ORDER TO SIMPLIFY SEARCHABIITY, WE NEED TO POPULATE THE DEFAULT PARENT SERVICE DATA ONTO EACH REFERRAL 
            # PROFILE FOR ANY DATA THAT WE MIGHT WANT TO VARY INDEPENDENTLY
            formatted_service = propagate_params_to_referral_profiles(service)
            print(formatted_service)

            r = requests.put(url + id, auth=awsauth, json=formatted_service, headers=headers)
        count += 1
    return str(count) + ' records processed.'



def ddb_deserialize(r, type_deserializer = TypeDeserializer()):
    return type_deserializer.deserialize({"M": r})


def propagate_params_to_referral_profiles(service):

    formatted_service = service

    list_of_referral_specific_properties = [
        'availableTime',
        'availabilityExceptions',
        'endpoint',
        'extraDetails',
        'notAvailable',
        'eligibility'
        ]
    
    # PROPAGATE PARENT PROPERTIES ONTO EACH REFERRAL PROFILE

    for i in range(len(formatted_service['referralProfiles'])):
        for property_name in list_of_referral_specific_properties:
            if not hasattr(formatted_service['referralProfiles'][i]['referralSpecificProperties'], property_name):
                formatted_service['referralProfiles'][i]['referralSpecificProperties'][property_name] = service[property_name]

    return formatted_service
