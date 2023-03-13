from chalice import Chalice
import json
import boto3
import uuid
from boto3.dynamodb.conditions import Key

app = Chalice(app_name="directory-data-manager")
dynamodb = boto3.resource('dynamodb')


@app.route("/", methods=['GET'])
def get_service():
    service_id = app.current_request.query_params.get('id')
    services_table = dynamodb.Table('services')      
    
    service_resp = services_table.get_item(
            Key={
                'id' : service_id,
            }
        )
    
    search = service_resp['Item']

    return { "service": service }


@app.route("/", methods=['POST'])
def create_service():

    request = app.current_request.json_body

    services_table = dynamodb.Table('services')      

    generated_identifier = uuid.uuid4().hex
    services_table.put_item(
                Item={
                    'id': generated_identifier #ADD FULL DATA MODEL
                    })


    return {"id" : generated_identifier}


@app.route("/", methods=['PUT'])
def update_service():

    service_id = app.current_request.query_params.get('id')

    request = app.current_request.json_body

    services_table = dynamodb.Table('services')      

    services_table.update_item(
                Key={'id': service_id}, #CHANGE TO ADD FULL DATA MODEL
                UpdateExpression="set name=:n, formatters=:f, redactions=:r, exclusions=:e, sorters=:s",
                ExpressionAttributeValues={
                    ':n': request["name"], 
                    ':f': request["formatters"],
                    ':r': request["redactions"],
                    ':e': request["exclusions"],
                    ':s': request["sorters"]

                    },
                ReturnValues="UPDATED_NEW")

    return {"id" : service_id}


@app.route("/", methods=['DELETE'])
def delete_service():
    service_id = app.current_request.query_params.get('id')

    service_table = dynamodb.Table('services') 

    services_table.delete_item(
        Key={
            'id' : service_id,
        }
    )

    return {"id" : service_id}


@app.route("/", methods=['OPTIONS'])
def options_request():
    response = {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*", 
                "Access-Control-Allow-Methods": "POST, PUT, GET, OPTIONS",
                "Access-Control-Allow-Headers": "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With"
            },
            "body": "Directory Data Manager preflight request",
        }
    return response
