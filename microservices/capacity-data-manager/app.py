from chalice import Chalice
import json
import boto3
import uuid
from boto3.dynamodb.conditions import Key

app = Chalice(app_name="capacity-data-manager")
dynamodb = boto3.resource('dynamodb')


@app.route("/capacitydata", methods=['GET'], cors=True)
def get_capacity():


    return True



@app.route("/capacitydata", methods=['POST'])
def create_capacity():


    return True


@app.route("/capacitydata", methods=['PUT'])
def update_capacity():


    return True



@app.route("/capacitydata", methods=['DELETE'])
def delete_capacity():


    return True


@app.route("/capacitydata", methods=['OPTIONS'])
def options_request():


    return True

