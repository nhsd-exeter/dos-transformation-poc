import json
import boto3
import requests
from requests_aws4auth import AWS4Auth

region = 'eu-west-2'
service = 'es'
credentials = boto3.Session().get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)

host = 'https://search-directory-search-5qbxo6fnd5u5d4uyydeudu6hpm.eu-west-2.es.amazonaws.com'
index = 'directory-index'
type = '_doc'
url = host + '/' + index + '/' + type + '/'

headers = { "Content-Type": "application/json" }

def lambda_handler(event, context):

    count = 0
    for record in event['Records']:
        id = record['dynamodb']['Keys']['id']['S']

        if record['eventName'] == 'REMOVE':
            print(requests.delete(url + id, auth=awsauth))
            r = requests.delete(url + id, auth=awsauth)
        else:
            document = record['dynamodb']['NewImage']
            print(requests.put(url + id, auth=awsauth, json=document, headers=headers))
            r = requests.put(url + id, auth=awsauth, json=document, headers=headers)
        count += 1
    return str(count) + ' records processed.'