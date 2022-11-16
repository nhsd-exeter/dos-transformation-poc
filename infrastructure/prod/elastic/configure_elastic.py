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
user_path = "/_plugins/_security/api/internalusers/"


def configure_elastic(host, search_arn, relay_arn):


    if check_user_exists("search_user") != true:
        search_user = {
            "password": "kirkpass",
            "opendistro_security_roles": ["readall"],
            "backend_roles": [search_arn],
        }

        create_user("search_user", search_user, search_arn)

    if check_user_exists("relay_user") != true:
        relay_user = {
            "password": "kirkpass",
            "opendistro_security_roles": ["all_access"],
            "backend_roles": [relay_arn],
        }

        create_user("relay_user", relay_user, relay_arn)
    

    if check_index_exists(index_name) != true:
        create_index(index_name)



def check_user_exists(name):
    url = host + user_path + name
    r = requests.get(url, auth=awsauth, headers=headers)
    jsonResponse = r.json()

    print(jsonResponse)

    if jsonResponse["status"] == "NOT_FOUND":
        return false
    else:
        return true



def create_user(name, data, arn):
    url = host + user_path + name
    r = requests.put(url, auth=awsauth, headers=headers, data=json.dumps(data))



def check_index_exists(index_name):
    url = host + "/" + index_name
    r = requests.get(url, auth=awsauth, headers=headers)
    jsonResponse = r.json()

    if jsonResponse["error"]["type"] == "index_not_found_exception":
        return false
    else:
        return true


def create_index(index_name):
    url = host + "/" + index_name
    r = requests.put(url, auth=awsauth, headers=headers)



if __name__== "__main__":
   configure_elastic(host, sys.argv[3], sys.argv[4])