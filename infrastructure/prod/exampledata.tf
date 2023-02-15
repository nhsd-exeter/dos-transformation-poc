##########################
# Example Data 
##########################


resource "aws_dynamodb_table_item" "example_consumer" {
  table_name = module.dynamodb_search_consumers_table.dynamodb_table_id
  hash_key   = "key"

  item = <<ITEM
{
  "key": {"S": "LyXvMVUd3L9bc5IVhpA4l5efM0jqvLFL535MVHpx"},
  "search-profile-id": {"S": "x83nd93y2"},
  "name": {"S": "Example Consumer Profile"}
}
ITEM
}


resource "aws_dynamodb_table_item" "example_geo_profile" {
  table_name = module.dynamodb_geo_profiles_table.dynamodb_table_id
  hash_key   = "id"

  item = <<ITEM
{
  "id": {
    "S": "h42o423h2"
  },
  "geographic_boundary": {
    "M": {
      "coordinates": {
        "L": [
          {
            "L": [
              {
                "L": [
                  {
                    "N": "2.9109533049198"
                  },
                  {
                    "N": "42.525105483878"
                  }
                ]
              },
              {
                "L": [
                  {
                    "N": "2.9110769445829"
                  },
                  {
                    "N": "42.531703894436"
                  }
                ]
              },
              {
                "L": [
                  {
                    "N": "2.9032846986744"
                  },
                  {
                    "N": "42.539733810015"
                  }
                ]
              },
              {
                "L": [
                  {
                    "N": "2.9030996511561"
                  },
                  {
                    "N": "42.556013979376"
                  }
                ]
              },
              {
                "L": [
                  {
                    "N": "2.9131331966995"
                  },
                  {
                    "N": "42.562962734203"
                  }
                ]
              },
              {
                "L": [
                  {
                    "N": "2.9135244444206"
                  },
                  {
                    "N": "42.569759384018"
                  }
                ]
              },
              {
                "L": [
                  {
                    "N": "2.917877044124"
                  },
                  {
                    "N": "42.57088655519"
                  }
                ]
              },
              {
                "L": [
                  {
                    "N": "2.9319395143989"
                  },
                  {
                    "N": "42.568900684816"
                  }
                ]
              },
              {
                "L": [
                  {
                    "N": "2.9403405122874"
                  },
                  {
                    "N": "42.572016209123"
                  }
                ]
              },
              {
                "L": [
                  {
                    "N": "2.9363870185385"
                  },
                  {
                    "N": "42.561333977005"
                  }
                ]
              },
              {
                "L": [
                  {
                    "N": "2.9309712722105"
                  },
                  {
                    "N": "42.534037916636"
                  }
                ]
              },
              {
                "L": [
                  {
                    "N": "2.9109533049198"
                  },
                  {
                    "N": "42.525105483878"
                  }
                ]
              }
            ]
          }
        ]
      },
      "type": {
        "S": "Polygon"
      }
    }
  },
  "managing_org_id": {
    "S": "13422341"
  },
  "name": {
    "S": "Example Local Area Definition"
  },
  "ranking_strategy": {
    "S": "{ \"_script\": { \"type\": \"number\", \"script\": { \"inline\" : \"params.sortOrder.indexOf(doc['category'].value)\", \"params\": { \"sortOrder\": [ \"GP\", \"Pharmacy\", \"Walk in\" ] } }, \"order\": \"asc\" } }"
  },
  "type": {
    "S": "LAD"
  }
}
ITEM
}


resource "aws_dynamodb_table_item" "example_search_profile" {
  table_name = module.dynamodb_search_profiles_table.dynamodb_table_id
  hash_key   = "id"

  item = <<ITEM
{
  "id": {
    "S": "x83nd93y2"
  },
  "exclusions": {
    "L": [
      {
        "S": "{\"match\": {\"category\": \"ED\"}}"
      }
    ]
  },
  "formatters": {
    "L": [
      {
        "L": []
      }
    ]
  },
  "name": {
    "S": "Example search profile"
  },
  "redactions": {
    "L": [
      {
        "S": "referralProfiles"
      }
    ]
  },
  "sorters": {
    "L": [
      {
        "S": "{ \"name\" : \"desc\" }"
      }
    ]
  }
}
ITEM
}


resource "aws_dynamodb_table_item" "example_service" {
  table_name = module.dynamodb_services_table.dynamodb_table_id
  hash_key   = "id"

  item = <<ITEM
{
  "id": {
    "S": "1233123"
  },
  "active": {
    "BOOL": true
  },
  "appointmentRequired": {
    "BOOL": false
  },
  "availabilityExceptions": {
    "S": "example"
  },
  "availableTime": {
    "L": [
      {
        "M": {
          "allDay": {
            "BOOL": true
          },
          "closingTime": {
            "NULL": true
          },
          "daysOfWeek": {
            "L": [
              {
                "S": "mon | tue | wed | thu | fri | sat | sun"
              }
            ]
          },
          "openingTime": {
            "NULL": true
          }
        }
      }
    ]
  },
  "category": {
    "L": [
      {
        "S": "ED"
      }
    ]
  },
  "characteristic": {
    "L": [
      {
        "M": {}
      }
    ]
  },
  "comment": {
    "S": "<string>"
  },
  "communication": {
    "L": [
      {
        "S": "EN"
      },
      {
        "S": "FR"
      },
      {
        "S": "DE"
      }
    ]
  },
  "coverageArea": {
    "L": [
      {
        "M": {
          "address": {
            "L": [
              {
                "S": "NETHERMAYNE"
              },
              {
                "S": "BASILDON"
              },
              {
                "S": "SS16 5NL"
              }
            ]
          },
          "alias": {
            "L": [
              {
                "S": "<string>"
              }
            ]
          },
          "availabilityExceptions": {
            "S": "<string>"
          },
          "description": {
            "S": "Basildon Hospital"
          },
          "endpoint": {
            "L": [
              {
                "S": "<TBC>"
              }
            ]
          },
          "hoursOfOperation": {
            "L": [
              {
                "M": {
                  "allDay": {
                    "BOOL": true
                  },
                  "closingTime": {
                    "NULL": true
                  },
                  "daysOfWeek": {
                    "L": [
                      {
                        "S": "mon | tue | wed | thu | fri | sat | sun"
                      }
                    ]
                  },
                  "openingTime": {
                    "NULL": true
                  }
                }
              }
            ]
          },
          "identifier": {
            "S": "12344134"
          },
          "managingOrganization": {
            "M": {
              "active": {
                "BOOL": true
              },
              "address": {
                "L": [
                  {
                    "S": "PRITTLEWELL CHASE"
                  },
                  {
                    "S": "WESTCLIFF-ON-SEA"
                  },
                  {
                    "S": "SS0 0RY"
                  }
                ]
              },
              "alias": {
                "L": [
                  {
                    "S": "<string>"
                  }
                ]
              },
              "contact": {
                "L": [
                  {
                    "M": {
                      "address": {
                        "L": [
                          {
                            "S": "NETHERMAYNE"
                          },
                          {
                            "S": "BASILDON"
                          },
                          {
                            "S": "SS16 5NL"
                          }
                        ]
                      },
                      "name": {
                        "S": "Richard Dean"
                      },
                      "purpose": {
                        "S": "Manager"
                      },
                      "telecom": {
                        "L": [
                          {
                            "S": "+4477723413"
                          }
                        ]
                      }
                    }
                  }
                ]
              },
              "endpoint": {
                "L": [
                  {
                    "S": "<TBC>"
                  }
                ]
              },
              "identifier": {
                "S": "RAJ"
              },
              "name": {
                "S": "MID AND SOUTH ESSEX NHS FOUNDATION TRUST"
              },
              "resourceType": {
                "S": "Organization"
              },
              "telecom": {
                "L": [
                  {
                    "S": "<string>"
                  }
                ]
              },
              "type": {
                "L": [
                  {
                    "S": "NHS Trust"
                  }
                ]
              }
            }
          },
          "mode": {
            "S": "instance"
          },
          "name": {
            "S": "Basildon Hospital"
          },
          "operationalStatus": {
            "S": "active"
          },
          "physicalType": {
            "S": "Site"
          },
          "position": {
            "S": "GEOMETRY(POLYGON)"
          },
          "resourceType": {
            "S": "Location"
          },
          "status": {
            "S": "active"
          },
          "telecom": {
            "L": [
              {
                "S": "+4477723413"
              }
            ]
          },
          "type": {
            "L": [
              {
                "S": "Hospital"
              }
            ]
          }
        }
      }
    ]
  },
  "eligibility": {
    "L": [
      {
        "M": {
          "code": {
            "M": {}
          },
          "comment": {
            "S": "N/A"
          }
        }
      }
    ]
  },
  "endpoint": {
    "S": "<TBC>"
  },
  "extraDetails": {
    "S": "<markdown>"
  },
  "location": {
    "L": [
      {
        "M": {
          "address": {
            "L": [
              {
                "S": "NETHERMAYNE"
              },
              {
                "S": "BASILDON"
              },
              {
                "S": "SS16 5NL"
              }
            ]
          },
          "alias": {
            "L": [
              {
                "S": "<string>"
              }
            ]
          },
          "availabilityExceptions": {
            "S": "<string>"
          },
          "description": {
            "S": "Basildon Hospital"
          },
          "endpoint": {
            "L": [
              {
                "S": "<TBC>"
              }
            ]
          },
          "hoursOfOperation": {
            "L": [
              {
                "M": {
                  "allDay": {
                    "BOOL": true
                  },
                  "closingTime": {
                    "NULL": true
                  },
                  "daysOfWeek": {
                    "L": [
                      {
                        "S": "mon | tue | wed | thu | fri | sat | sun"
                      }
                    ]
                  },
                  "openingTime": {
                    "NULL": true
                  }
                }
              }
            ]
          },
          "identifier": {
            "S": "12344134"
          },
          "managingOrganization": {
            "M": {
              "active": {
                "BOOL": true
              },
              "address": {
                "L": [
                  {
                    "S": "PRITTLEWELL CHASE"
                  },
                  {
                    "S": "WESTCLIFF-ON-SEA"
                  },
                  {
                    "S": "SS0 0RY"
                  }
                ]
              },
              "alias": {
                "L": [
                  {
                    "S": "<string>"
                  }
                ]
              },
              "contact": {
                "L": [
                  {
                    "M": {
                      "address": {
                        "L": [
                          {
                            "S": "NETHERMAYNE"
                          },
                          {
                            "S": "BASILDON"
                          },
                          {
                            "S": "SS16 5NL"
                          }
                        ]
                      },
                      "name": {
                        "S": "Richard Dean"
                      },
                      "purpose": {
                        "S": "Manager"
                      },
                      "telecom": {
                        "L": [
                          {
                            "S": "+4477723413"
                          }
                        ]
                      }
                    }
                  }
                ]
              },
              "endpoint": {
                "L": [
                  {
                    "S": "<TBC>"
                  }
                ]
              },
              "identifier": {
                "S": "RAJ"
              },
              "name": {
                "S": "MID AND SOUTH ESSEX NHS FOUNDATION TRUST"
              },
              "resourceType": {
                "S": "Organization"
              },
              "telecom": {
                "L": [
                  {
                    "S": "string>"
                  }
                ]
              },
              "type": {
                "L": [
                  {
                    "S": "NHS Trust"
                  }
                ]
              }
            }
          },
          "mode": {
            "S": "instance"
          },
          "name": {
            "S": "Basildon Hospital"
          },
          "operationalStatus": {
            "S": "active"
          },
          "physicalType": {
            "S": "Site"
          },
          "position": {
            "M": {
              "altitude": {
                "N": "0"
              },
              "latitude": {
                "N": "51.557759"
              },
              "longitude": {
                "N": "0.4506672"
              }
            }
          },
          "resourceType": {
            "S": "Location"
          },
          "status": {
            "S": "active"
          },
          "telecom": {
            "L": [
              {
                "S": "+4477723413"
              }
            ]
          },
          "type": {
            "L": [
              {
                "S": "Hospital"
              }
            ]
          }
        }
      }
    ]
  },
  "name": {
    "S": "Emergency Department (ED) - Basildon Hospital, Basildon, Essex"
  },
  "notAvailable": {
    "L": [
      {
        "M": {
          "description": {
            "S": "Bank Holidays"
          },
          "during": {
            "M": {}
          }
        }
      }
    ]
  },
  "photo": {
    "S": "<url>"
  },
  "program": {
    "L": [
      {
        "M": {}
      }
    ]
  },
  "providedBy": {
    "M": {
      "active": {
        "BOOL": true
      },
      "address": {
        "L": [
          {
            "S": "NETHERMAYNE"
          },
          {
            "S": "BASILDON"
          },
          {
            "S": "SS16 5NL"
          }
        ]
      },
      "alias": {
        "L": [
          {
            "S": "<string>"
          }
        ]
      },
      "contact": {
        "L": [
          {
            "M": {
              "address": {
                "L": [
                  {
                    "S": "NETHERMAYNE"
                  },
                  {
                    "S": "BASILDON"
                  },
                  {
                    "S": "SS16 5NL"
                  }
                ]
              },
              "name": {
                "S": "Richard Dean"
              },
              "purpose": {
                "S": "Manager"
              },
              "telecom": {
                "L": [
                  {
                    "S": "+4477723413"
                  }
                ]
              }
            }
          }
        ]
      },
      "endpoint": {
        "L": [
          {
            "S": "<TBC>"
          }
        ]
      },
      "identifier": {
        "S": "M8U3G"
      },
      "name": {
        "S": "EMERGENCY DEPARTMENT BH"
      },
      "resourceType": {
        "S": "Organization"
      },
      "telecom": {
        "L": [
          {
            "S": "string>"
          }
        ]
      },
      "type": {
        "L": [
          {
            "S": "NHS Trust Site"
          }
        ]
      }
    }
  },
  "referralMethod": {
    "L": [
      {
        "S": "phone"
      },
      {
        "S": "mail"
      }
    ]
  },
  "referralProfiles": {
    "L": [
      {
        "M": {
          "activitiesOffered": {
            "L": [
              {
                "S": "3412412"
              },
              {
                "S": "124523"
              },
              {
                "S": "124123"
              },
              {
                "S": "..."
              }
            ]
          },
          "acuities": {
            "L": [
              {
                "S": "14144"
              },
              {
                "S": "114134"
              },
              {
                "S": "563567"
              },
              {
                "S": "..."
              }
            ]
          },
          "name": {
            "S": "Emergency Department"
          },
          "referralSpecificProperties": {
            "M": {
              "eligibility": {
                "M": {
                  "code": {
                    "S": "12312421"
                  },
                  "comment": {
                    "S": "15-1295yr Only"
                  }
                }
              }
            }
          },
          "system": {
            "S": "SNOMED CT"
          }
        }
      },
      {
        "M": {
          "activitiesOffered": {
            "L": [
              {
                "S": "3412412"
              },
              {
                "S": "124523"
              },
              {
                "S": "124123"
              },
              {
                "S": "..."
              }
            ]
          },
          "acuities": {
            "L": [
              {
                "S": "14144"
              },
              {
                "S": "114134"
              },
              {
                "S": "563567"
              },
              {
                "S": "..."
              }
            ]
          },
          "name": {
            "S": "Emergency Department (Children)"
          },
          "referralSpecificProperties": {
            "M": {
              "eligibility": {
                "M": {
                  "code": {
                    "S": "12312421"
                  },
                  "comment": {
                    "S": "0-15yr Only"
                  }
                }
              },
              "availableTime": {
                "L": [
                  {
                    "M": {
                      "allDay": {
                        "BOOL": false
                      },
                      "closingTime": {
                        "S": "5:00"
                      },
                      "daysOfWeek": {
                        "L": [
                          {
                            "S": "mon | tue | wed | thu | fri | sat | sun"
                          }
                        ]
                      },
                      "openingTime": {
                        "S": "9:00"
                      }
                    }
                  }
                ]
              }
            }
          },
          "system": {
            "S": "SNOMED CT"
          }
        }
      },
      {
        "M": {
          "dispositions": {
            "L": [
              {
                "S": "Dx17"
              },
              {
                "S": "Dx13"
              },
              {
                "S": "..."
              }
            ]
          },
          "name": {
            "S": "Emergency Department (Children)"
          },
          "referralSpecificProperties": {
            "M": {
              "eligibility": {
                "M": {
                  "code": {
                    "S": "12312421"
                  },
                  "comment": {
                    "S": "0-15yr Only"
                  }
                }
              },
              "availableTime": {
                "L": [
                  {
                    "M": {
                      "allDay": {
                        "BOOL": false
                      },
                      "closingTime": {
                        "S": "5:00"
                      },
                      "daysOfWeek": {
                        "L": [
                          {
                            "S": "mon | tue | wed | thu | fri | sat | sun"
                          }
                        ]
                      },
                      "openingTime": {
                        "S": "9:00"
                      }
                    }
                  }
                ]
              }
            }
          },
          "symptomDiscriminators": {
            "L": [
              {
                "S": "SD4052"
              },
              {
                "S": "SD4304"
              },
              {
                "S": "..."
              }
            ]
          },
          "symptomGroups": {
            "L": [
              {
                "S": "SG1011"
              },
              {
                "S": "SG1010"
              },
              {
                "S": "..."
              }
            ]
          },
          "system": {
            "S": "LEGACY SG/SD/DX"
          }
        }
      }
    ]
  },
  "resourceType": {
    "S": "HealthcareService"
  },
  "serviceProvisionCode": {
    "L": [
      {
        "M": {}
      }
    ]
  },
  "specialty": {
    "L": [
      {
        "M": {}
      }
    ]
  },
  "telecom": {
    "L": [
      {
        "S": "+4477723413"
      }
    ]
  },
  "type": {
    "L": [
      {
        "S": "ED"
      }
    ]
  }
}

ITEM
}