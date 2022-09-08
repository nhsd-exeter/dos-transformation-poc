import json


def index(event, context):
    body = {
        "message": "Go Serverless v3.0! Your function executed successfully!",
        "input": event,
    }

    # response1 = {"statusCode": 200, "body": json.dumps(body)}

    response = {"statusCode": 200, "body": json.dumps(body)}

    return response
