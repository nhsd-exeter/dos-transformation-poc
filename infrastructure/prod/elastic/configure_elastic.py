import boto3
import sys
import json
import requests
from requests_aws4auth import AWS4Auth

region = sys.argv[1]
host = "https://" + sys.argv[2]
index_names = [sys.argv[3], sys.argv[3]]

service = 'es'
credentials = boto3.Session().get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)
headers = { "Content-Type": "application/json" }


def configure_elastic():

    url = host + "/directory-index"
    r = requests.delete(url, auth=awsauth, headers=headers)
   
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

    print('Adding mapping to: ' + index_name)

    url = host + "/" + index_name + "/_mapping"

    if index_name == 'geo-profiles-index':
        mapping = {
                 "properties": {
                    "geographic_boundary": {
                        "type": "geo_shape"
                    }
                }
            }

    #NEED TO UPDATE TO CREATE A HUGE MAPPING FOR SERVICE OBJECT
    if index_name == 'directory-index':
        mapping = {
                "properties": {
                    "name": {"type": "keyword"},
                    "category": {"type": "keyword"},
                    "characteristic": {"type": "keyword"},
                    "specialty": {"type": "keyword"},
                    "location" : {"type" : "nested",
                        "address" : {"type" : "text"},
                        "position" :  {"type" : "geo_point"}
                    },
                    "coverageArea" : {"type" : "nested",
                        "position" :  {"type" : "geo_shape"}
                    },
                    "referralProfiles": {"type": "nested",
                        "properties": {
                            "referralSpecificProperties" : "nested",
                                "properties" : {
                                    'availableTime' : { "type" : "nested",
                                        "properties" : {
                                            "allDay" : {"type" : "boolean"},
                                            "daysOfWeek" : {"type" : "keyword"},
                                            "openingTime" : { "type" : "double" },
                                            "closingTime" : { "type" : "double" }
                                            }
                                        },
                                    'availabilityExceptions' : {"type" : "keyword"},
                                    'endpoint' : {"type" : "text"},
                                    'extraDetails' : {"type" : "text"},
                                    'notAvailable' : {"type" : "boolean"},
                                    'eligibility': {"type" : "keyword"}
                                }
                        }
                    }

                }
            }
    
    mapping_json = json.dumps(mapping)


    try:
        r = requests.put(url, auth=awsauth, data=mapping_json, headers=headers)
        r.raise_for_status()
    except requests.exceptions.HTTPError as e:
        print (e.response.text)

    return



if __name__== "__main__":
   configure_elastic()