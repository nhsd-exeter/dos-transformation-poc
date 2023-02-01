import boto3
import sys
import json
import requests
from requests_aws4auth import AWS4Auth

region = sys.argv[1]
host = "https://" + sys.argv[2]
service = 'es'
credentials = boto3.Session().get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)
headers = { "Content-Type": "application/json" }
index_name = 'directory-index'

def configure_elastic():
   

    if check_index_exists(index_name) != True:
        create_index(index_name)



def check_index_exists(index_name):
    url = host + "/" + index_name
    r = requests.get(url, auth=awsauth, headers=headers)
    jsonResponse = r.json()

    if ("error" in jsonResponse) and (jsonResponse["error"]["type"] == "index_not_found_exception"):
        return False
    else:
        return True


def create_index(index_name):
    url = host + "/" + index_name
    r = requests.put(url, auth=awsauth, headers=headers)



if __name__== "__main__":
   configure_elastic()