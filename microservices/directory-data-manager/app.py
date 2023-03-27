from chalice import Chalice
import json
import boto3
import uuid
from boto3.dynamodb.conditions import Key

app = Chalice(app_name="directory-data-manager")
dynamodb = boto3.resource('dynamodb')


@app.route("/services", methods=['GET'])
def get_service():

    print("get service")
    
    services_table = dynamodb.Table('services')    

    #HARDCODED FOR NOW AS WE ONLY HAVE ONE SERVICE
    service_id = '1233123'  
    
    service_resp = services_table.get_item(
            Key={
                'id' : service_id,
            }
        )
    
    service = service_resp['Item']

    response = {
            "statusCode": 200,
            # "headers": {
            #     "Access-Control-Allow-Origin": "*", 
            #     "Access-Control-Allow-Methods": "POST, PUT, GET, OPTIONS",
            #     "Access-Control-Allow-Headers": "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With"
            # },
            "body": service,
        }
    return response



@app.route("/services", methods=['POST'])
def create_service():

    # print("Creating service...")
    # request = app.current_request.json_body

    # services_table = dynamodb.Table('services')      

    # generated_identifier = uuid.uuid4().hex
    # services_table.put_item(
    #             Item={
    #                 'id': generated_identifier #ADD FULL DATA MODEL
    #                 })


    # return {"id" : generated_identifier}

    print("post service")
    return {"post service":"post service"}


@app.route("/services", methods=['PUT'])
def update_service():

    # service_id = app.current_request.query_params.get('id')

    # request = app.current_request.json_body

    # services_table = dynamodb.Table('services')      

    # services_table.update_item(
    #             Key={'id': service_id}, #CHANGE TO ADD FULL DATA MODEL
    #             UpdateExpression="set name=:n, formatters=:f, redactions=:r, exclusions=:e, sorters=:s",
    #             ExpressionAttributeValues={
    #                 ':n': request["name"], 
    #                 ':f': request["formatters"],
    #                 ':r': request["redactions"],
    #                 ':e': request["exclusions"],
    #                 ':s': request["sorters"]

    #                 },
    #             ReturnValues="UPDATED_NEW")

    # return {"id" : service_id}
    print("post service")
    return {"post service"}



@app.route("/services", methods=['DELETE'])
def delete_service():
    # service_id = app.current_request.query_params.get('id')

    # service_table = dynamodb.Table('services') 

    # services_table.delete_item(
    #     Key={
    #         'id' : service_id,
    #     }
    # )

    # return {"id" : service_id}
    
    print("delete service")
    return {"del service":"del service"}


@app.route("/services", methods=['OPTIONS'])
def options_request():
    # response = {
    #         "statusCode": 200,
    #         "headers": {
    #             "Access-Control-Allow-Origin": "*", 
    #             "Access-Control-Allow-Methods": "POST, PUT, GET, OPTIONS",
    #             "Access-Control-Allow-Headers": "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With"
    #         },
    #         "body": "Directory Data Manager preflight request",
    #     }
    # return response
    
    print("ops service")
    return {"ops service":"ops service"}

