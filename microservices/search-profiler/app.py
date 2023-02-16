import json
import boto3
import datetime
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource('dynamodb')
search_consumers_table = dynamodb.Table('search-consumers')    
search_profiles_table = dynamodb.Table('search-profiles') 


def lambda_handler(event, context):
    
    parsed_json = json.dumps(event)
    input_terms = json.loads(parsed_json)
    
    search_query = input_terms["search_query"]
    api_key = input_terms["api_key"]
    
    patient_postcode = search_query['subject']['address']['postalCode']
    #THIS POSTCODE CAN BE USED TO SELECT AN APPROPRIATE GEO-PROFILE FOR RANKING STRATEGY  
    
    #Determine the consumer by querying the api-key 
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



    search_profile_resp = search_profiles_table.get_item(
            Key={
                'id' : search_profile_id,
            }
        )


    if 'Item' in  search_profile_resp:
        search_profile = search_profile_resp['Item']
    else:
        raise ValueError('The search profile associated with this API Key cannot be found')


    resp = {
        'search_profile': search_profile
    }
 
    json_response = json.dumps(resp)

    return json_response
    