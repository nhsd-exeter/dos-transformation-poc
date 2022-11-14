import json
import boto3
from boto3.dynamodb.conditions import Key

def lambda_handler(event, context):
    
    parsed_json = json.dumps(event)
    input_terms = json.loads(parsed_json)
    
    search_query = input_terms["search_query"]
    api_key = input_terms["api_key"]
    
    dynamodb = boto3.resource('dynamodb')
    
    
    #Determine the consumer by querying the api-key 
    search_consumers_table = dynamodb.Table('search-consumers')      
    
    consumer_resp = search_consumers_table.get_item(
            Key={
                'key' : api_key,
            }
        )
                

    #locate the appropriate search profile for this consumer

    search_profile_id = consumer_resp['Item'].get("search-profile-id")
    search_profiles_table = dynamodb.Table('search-profiles')      
    
    search_profile_resp = search_profiles_table.get_item(
            Key={
                'id' : search_profile_id,
            }
        )

    
    search_profile = search_profile_resp['Item']
    
    
    #perform formatting / tailoring
    
    
    profiled_query = search_query
    
    resp = {
        "search_query": profiled_query,
    }
    
    json_response = json.dumps(resp)

    return  json_response