from chalice import Chalice
import json
import boto3
import uuid
from boto3.dynamodb.conditions import Key

app = Chalice(app_name="helloworld")
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
    search_profiles_table = dynamodb.Table('search-profiles') 

    generated_identifier = uuid.uuid4()
    search_profiles_table.put_item(
                Item={
                    'id': generated_identifier,
                    'name': 'test',
                    'formatters': ['test'],
                    'redactions': ['test'],
                    'sorters': ['test'],
                    'exclusions': ['test']
                    })


    return {"hello" : "world"}


@app.route("/searchprofiles", methods=['DELETE'])
def delete_search_profile():
    id = app.current_request.query_params.get('id')
    return {"hello" : "world"}


