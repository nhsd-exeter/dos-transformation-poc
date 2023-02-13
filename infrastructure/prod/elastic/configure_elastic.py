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
index_names = ['directory-index', 'geo-profiles-index']

def configure_elastic():
   
    # url = host + "/geo-profiles-index"
    # r = requests.delete(url, auth=awsauth, headers=headers)

    for index in index_names:
        if check_index_exists(index) != True:
            create_index(index)
        if check_mapping_exists(index) != True:
            create_mapping(index)
    return


def check_index_exists(index_name):
    url = host + "/" + index_name
    r = requests.get(url, auth=awsauth, headers=headers)
    jsonResponse = r.json()

    if ("error" in jsonResponse) and (jsonResponse["error"]["type"] == "index_not_found_exception"):
        return False
    else:
        return True


def check_mapping_exists(index_name):
    url = host + "/" + index_name + "/_mapping" 
    r = requests.get(url, auth=awsauth, headers=headers)
    jsonResponse = r.json()

    print(jsonResponse)
    print(jsonResponse[index_name]["mappings"])


    if not jsonResponse[index_name]["mappings"]:
        return False
    else:
        return True



def create_index(index_name):
    url = host + "/" + index_name
    r = requests.put(url, auth=awsauth, headers=headers)
    return


def create_mapping(index_name):

    url = host + "/" + index_name

    if index_name == 'geo-profiles-index':
        print('Adding mapping...' + index_name)
        mapping = {
            "mappings": {
                "properties": {
                    "geographic_boundary": {
                        "type": "geo_shape"
                    }
                }
            }
        }

    #NEED TO UPDATE TO CREATE A HUGE MAPPING FOR SERVICE OBJECT
    if index_name == 'directory-index':
        mapping = {
            "mappings": {
                "properties": {
                    "name": {"type": "keyword"},
                    "category": {"type": "keyword"},
                }
            }
        }
    
    mapping_json = json.dumps(mapping)
    print(mapping_json)

    try:
        r = requests.put(url, auth=awsauth, data=mapping_json, headers=headers)
        r.raise_for_status()
    except requests.exceptions.HTTPError as e:
        print (e.response.text)

    # r = requests.put(url, auth=awsauth, data=mapping, headers=headers)
    return



if __name__== "__main__":
   configure_elastic()