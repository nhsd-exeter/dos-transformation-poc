from chalice import Chalice
import json
import boto3
import uuid
from boto3.dynamodb.conditions import Key

app = Chalice(app_name="capacity-grids-manager")
dynamodb = boto3.resource('dynamodb')


@app.route("/capacitygrids", methods=['GET'], cors=True)
def get_grid():


    return True



@app.route("/capacitygrids", methods=['POST'])
def create_grid():


    return True


@app.route("/capacitygrids", methods=['PUT'])
def update_grid():


    return True



@app.route("/capacitygrids", methods=['DELETE'])
def delete_grid():


    return True


@app.route("/capacitygrids", methods=['OPTIONS'])
def options_request():


    return True

