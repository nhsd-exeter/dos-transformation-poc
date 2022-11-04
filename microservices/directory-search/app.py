import boto3
import json
import requests
from requests_aws4auth import AWS4Auth

region = 'eu-west-2' 
service = 'es'
credentials = boto3.Session().get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)

host = 'https://vpc-directory-search-5qbxo6fnd5u5d4uyydeudu6hpm.eu-west-2.es.amazonaws.com'
index = 'services'
url = host + '/' + index + '/_search'

def lambda_handler(event, context):

    parsed_json = json.dumps(event)
    request = json.loads(parsed_json)

    query = request["search_query"]


    # Put the user query into the query DSL for more accurate search results.
    # Note that certain fields are boosted (^).
    query = {
        "size": 25,
        "query": {
            "multi_match": {
                "query": "Test",
                "fields": ["title^4", "plot^2", "actors", "directors"]
            }
        }
    }

    # Elasticsearch 6.x requires an explicit Content-Type header
    headers = { "Content-Type": "application/json" }

    # Make the signed HTTP request
    r = requests.get(url, auth=awsauth, headers=headers, data=json.dumps(query))

    # Create the response and add some extra content to support CORS
    response = {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": '*'
        },
        "isBase64Encoded": False
    }

    # Add the search results to the response
    response['body'] = r.text

    #perform search
    
    search_result = "Basildon"
    
    resp = {
      "search_result": search_result
    }

    json_response = json.dumps(resp)

    return json_response