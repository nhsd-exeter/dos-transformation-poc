from chalice import Chalice
import json
import boto3
import uuid
from boto3.dynamodb.conditions import Key

app = Chalice(app_name="search-profile-manager")
dynamodb = boto3.resource('dynamodb')


@app.route("/searchprofiles", methods=['GET'])
def get_search_profile():
    search_profile_id = app.current_request.query_params.get('id')
    search_profiles_table = dynamodb.Table('search-profiles')      
    
    search_profile_resp = search_profiles_table.get_item(
            Key={
                'id' : search_profile_id,
            }
        )
    
    search_profile = search_profile_resp['Item']

    return { "searchprofile": search_profile_resp }


@app.route("/searchprofiles", methods=['POST'])
def create_search_profile():

    request = app.current_request.json_body

    search_profiles_table = dynamodb.Table('search-profiles') 

    generated_identifier = uuid.uuid4().hex
    search_profiles_table.put_item(
                Item={
                    'id': generated_identifier,
                    'name': request["name"],
                    'formatters': request["formatters"],
                    'redactions': request["redactions"],
                    'sorters': request["sorters"],
                    'exclusions': request["exclusions"]
                    })


    return {"id" : generated_identifier}


@app.route("/searchprofiles", methods=['PUT'])
def update_search_profile():

    search_profile_id = app.current_request.query_params.get('id')

    request = app.current_request.json_body

    search_profiles_table = dynamodb.Table('search-profiles') 

    search_profiles_table.update_item(
                Key={'id': search_profile_id},
                UpdateExpression="set name=:n, formatters=:f, redactions=:r, exclusions=:e, sorters=:s",
                ExpressionAttributeValues={
                    ':n': request["name"], 
                    ':f': request["formatters"],
                    ':r': request["redactions"],
                    ':e': request["exclusions"],
                    ':s': request["sorterss"]

                    },
                ReturnValues="UPDATED_NEW")

    return {"id" : search_profile_id}


@app.route("/searchprofiles", methods=['DELETE'])
def delete_search_profile():
    search_profile_id = app.current_request.query_params.get('id')

    search_profiles_table = dynamodb.Table('search-profiles') 

    search_profiles_table.delete_item(
        Key={
            'id' : search_profile_id,
        }
    )

    return {"id" : search_profile_id}


#######################
#Search Consumer Routes
#######################

@app.route("/searchprofiles/consumers", methods=['GET'])
def get_search_consumer():
    search_consumer_api_key = app.current_request.query_params.get('key')
    search_consumers_table = dynamodb.Table('search-consumers')      
    
    search_consumers_resp = search_pconsumers_table.get_item(
            Key={
                'key' : search_consumer_api_key,
            }
        )
    
    search_consumer = search_consumer_resp['Item']

    return { "searchconsumer": search_consumer_resp }


@app.route("/searchprofiles/consumers", methods=['POST'])
def create_search_consumer():

    request = app.current_request.json_body

    search_consumers_table = dynamodb.Table('search-consumers')      

    search_consumers_table.put_item(
                Item={
                    'key': request["key"],
                    'name': request["name"],
                    'search-profile-id': request["search-profile-id"],
                    })


    return {"id" : request["key"]}


@app.route("/searchprofiles/consumers", methods=['PUT'])
def update_search_consumer():

    search_consumer_api_key = app.current_request.query_params.get('key')

    request = app.current_request.json_body

    search_consumers_table = dynamodb.Table('search-consumers')      

    search_consumers_table.update_item(
                Key={'key': search_consumer_api_key},
                UpdateExpression="set name=:n, search-profile-id=:s",
                ExpressionAttributeValues={
                    ':n': request["name"], 
                    ':s': request["search-profile-id"]
                    },
                ReturnValues="UPDATED_NEW")

    return {"id" : search_consumer_api_key}


@app.route("/searchprofiles/consumers", methods=['DELETE'])
def delete_search_consumer():
    search_consumer_api_key = app.current_request.query_params.get('key')

    search_consumers_table = dynamodb.Table('search-consumers')      

    search_consumers_table.delete_item(
        Key={
            'key' : search_consumer_api_key,
        }
    )

    return {"id" : search_consumer_api_key}