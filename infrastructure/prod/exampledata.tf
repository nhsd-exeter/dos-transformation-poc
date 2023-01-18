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


resource "aws_dynamodb_table_item" "example_search_profile" {
  table_name = module.dynamodb_search_profiles_table.dynamodb_table_id
  hash_key   = "id"

  item = <<ITEM
{
  "id": {"S": "x83nd93y2"},
  "name":{"S": "Example search profile"},
  "exclusions": {"S": "TEST"},
  "sorters": {"S": "TEST"},
  "formatters": {"S": "TEST"},
  "redactions": {"S": "TEST"}
}
ITEM
}


resource "aws_dynamodb_table_item" "example_service" {
  table_name = module.dynamodb_services_table.dynamodb_table_id
  hash_key   = "id"

  item = <<ITEM
{
  "resourceType": {
    "S": "HealthcareService"
  },
  "id": {
    "S": "1233123"
  },
  "name": {
    "S": "Emergency Department (ED) - Basildon Hospital, Basildon, Essex"
  },
  "active": {
    "BOOL": true
  },
  "providedBy": {
    "M": {
      "resourceType": {
        "S": "Organization"
      },
      "identifier": {
        "S": "M8U3G"
      },
      "active": {
        "BOOL": true
      },
      "type": {
        "L": [
          {
            "S": "NHS Trust Site"
          }
        ]
      },
      "name": {
        "S": "EMERGENCY DEPARTMENT BH"
      },
      "alias": {
        "L": [
          {
            "S": "<string>"
          }
        ]
      },
      "telecom": {
        "L": [
          {
            "S": "string>"
          }
        ]
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
      "contact": {
        "L": [
          {
            "M": {
              "purpose": {
                "S": "Manager"
              },
              "name": {
                "S": "Richard Dean"
              },
              "telecom": {
                "L": [
                  {
                    "S": "+4477723413"
                  }
                ]
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
      }
    }
  },
  "category": {
    "L": [
      {
        "S": "ED"
      }
    ]
  },
  "type": {
    "L": [
      {
        "S": "ED"
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
  "location": {
    "L": [
      {
        "M": {
          "resourceType": {
            "S": "Location"
          },
          "identifier": {
            "S": "12344134"
          },
          "status": {
            "S": "active"
          },
          "operationalStatus": {
            "S": "active"
          },
          "name": {
            "S": "Basildon Hospital"
          },
          "alias": {
            "L": [
              {
                "S": "<string>"
              }
            ]
          },
          "description": {
            "S": "Basildon Hospital"
          },
          "mode": {
            "S": "instance"
          },
          "type": {
            "L": [
              {
                "S": "Hospital"
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
          "physicalType": {
            "S": "Site"
          },
          "position": {
            "M": {
              "longitude": {
                "N": "0.4506672"
              },
              "latitude": {
                "N": "51.557759"
              },
              "altitude": {
                "N": "0"
              }
            }
          },
          "managingOrganization": {
            "M": {
              "resourceType": {
                "S": "Organization"
              },
              "identifier": {
                "S": "RAJ"
              },
              "active": {
                "BOOL": true
              },
              "type": {
                "L": [
                  {
                    "S": "NHS Trust"
                  }
                ]
              },
              "name": {
                "S": "MID AND SOUTH ESSEX NHS FOUNDATION TRUST"
              },
              "alias": {
                "L": [
                  {
                    "S": "<string>"
                  }
                ]
              },
              "telecom": {
                "L": [
                  {
                    "S": "string>"
                  }
                ]
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
              "contact": {
                "L": [
                  {
                    "M": {
                      "purpose": {
                        "S": "Manager"
                      },
                      "name": {
                        "S": "Richard Dean"
                      },
                      "telecom": {
                        "L": [
                          {
                            "S": "+4477723413"
                          }
                        ]
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
              }
            }
          },
          "hoursOfOperation": {
            "L": [
              {
                "M": {
                  "daysOfWeek": {
                    "L": [
                      {
                        "S": "mon | tue | wed | thu | fri | sat | sun"
                      }
                    ]
                  },
                  "allDay": {
                    "BOOL": true
                  },
                  "openingTime": {
                    "NULL": true
                  },
                  "closingTime": {
                    "NULL": true
                  }
                }
              }
            ]
          },
          "availabilityExceptions": {
            "S": "<string>"
          },
          "endpoint": {
            "L": [
              {
                "S": "<TBC>"
              }
            ]
          }
        }
      }
    ]
  },
  "comment": {
    "S": "<string>"
  },
  "extraDetails": {
    "S": "<markdown>"
  },
  "photo": {
    "S": "<url>"
  },
  "telecom": {
    "L": [
      {
        "S": "+4477723413"
      }
    ]
  },
  "coverageArea": {
    "L": [
      {
        "M": {
          "resourceType": {
            "S": "Location"
          },
          "identifier": {
            "S": "12344134"
          },
          "status": {
            "S": "active"
          },
          "operationalStatus": {
            "S": "active"
          },
          "name": {
            "S": "Basildon Hospital"
          },
          "alias": {
            "L": [
              {
                "S": "<string>"
              }
            ]
          },
          "description": {
            "S": "Basildon Hospital"
          },
          "mode": {
            "S": "instance"
          },
          "type": {
            "L": [
              {
                "S": "Hospital"
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
          "physicalType": {
            "S": "Site"
          },
          "position": {
            "S": "GEOMETRY(POLYGON)"
          },
          "managingOrganization": {
            "M": {
              "resourceType": {
                "S": "Organization"
              },
              "identifier": {
                "S": "RAJ"
              },
              "active": {
                "BOOL": true
              },
              "type": {
                "L": [
                  {
                    "S": "NHS Trust"
                  }
                ]
              },
              "name": {
                "S": "MID AND SOUTH ESSEX NHS FOUNDATION TRUST"
              },
              "alias": {
                "L": [
                  {
                    "S": "<string>"
                  }
                ]
              },
              "telecom": {
                "L": [
                  {
                    "S": "<string>"
                  }
                ]
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
              "contact": {
                "L": [
                  {
                    "M": {
                      "purpose": {
                        "S": "Manager"
                      },
                      "name": {
                        "S": "Richard Dean"
                      },
                      "telecom": {
                        "L": [
                          {
                            "S": "+4477723413"
                          }
                        ]
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
              }
            }
          },
          "hoursOfOperation": {
            "L": [
              {
                "M": {
                  "daysOfWeek": {
                    "L": [
                      {
                        "S": "mon | tue | wed | thu | fri | sat | sun"
                      }
                    ]
                  },
                  "allDay": {
                    "BOOL": true
                  },
                  "openingTime": {
                    "NULL": true
                  },
                  "closingTime": {
                    "NULL": true
                  }
                }
              }
            ]
          },
          "availabilityExceptions": {
            "S": "<string>"
          },
          "endpoint": {
            "L": [
              {
                "S": "<TBC>"
              }
            ]
          }
        }
      }
    ]
  },
  "serviceProvisionCode": {
    "L": [
      {
        "M": {}
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
  "referralProfiles": {
    "L": [
      {
        "M": {
          "name": {
            "S": "Emergency Department"
          },
          "system": {
            "S": "SNOMED CT"
          },
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
          "referralSpecificProperties": {
            "L": [
              {
                "M": {
                  "eligibility": {
                    "L": [
                      {
                        "M": {
                          "code": {
                            "S": "12312444"
                          },
                          "comment": {
                            "S": "15-129yr Only"
                          }
                        }
                      }
                    ]
                  }
                }
              }
            ]
          }
        }
      },
      {
        "M": {
          "name": {
            "S": "Emergency Department (Children)"
          },
          "system": {
            "S": "SNOMED CT"
          },
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
          "referralSpecificProperties": {
            "L": [
              {
                "M": {
                  "eligibility": {
                    "L": [
                      {
                        "M": {
                          "code": {
                            "S": "12312421"
                          },
                          "comment": {
                            "S": "0-15yr Only"
                          }
                        }
                      }
                    ]
                  }
                }
              },
              {
                "M": {
                  "availableTime": {
                    "L": [
                      {
                        "M": {
                          "daysOfWeek": {
                            "L": [
                              {
                                "S": "mon | tue | wed | thu | fri | sat | sun"
                              }
                            ]
                          },
                          "allDay": {
                            "BOOL": false
                          },
                          "openingTime": {
                            "S": "9:00"
                          },
                          "closingTime": {
                            "S": "5:00"
                          }
                        }
                      }
                    ]
                  }
                }
              }
            ]
          }
        }
      },
      {
        "M": {
          "name": {
            "S": "Emergency Department (Children)"
          },
          "system": {
            "S": "LEGACY SG/SD/DX"
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
          "referralSpecificProperties": {
            "L": [
              {
                "M": {
                  "eligibility": {
                    "L": [
                      {
                        "M": {
                          "code": {
                            "S": "12312421"
                          },
                          "comment": {
                            "S": "0-15yr Only"
                          }
                        }
                      }
                    ]
                  }
                }
              },
              {
                "M": {
                  "availableTime": {
                    "L": [
                      {
                        "M": {
                          "daysOfWeek": {
                            "L": [
                              {
                                "S": "mon | tue | wed | thu | fri | sat | sun"
                              }
                            ]
                          },
                          "allDay": {
                            "BOOL": false
                          },
                          "openingTime": {
                            "S": "9:00"
                          },
                          "closingTime": {
                            "S": "5:00"
                          }
                        }
                      }
                    ]
                  }
                }
              }
            ]
          }
        }
      }
    ]
  },
  "program": {
    "L": [
      {
        "M": {}
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
  "appointmentRequired": {
    "BOOL": false
  },
  "availableTime": {
    "L": [
      {
        "M": {
          "daysOfWeek": {
            "L": [
              {
                "S": "mon | tue | wed | thu | fri | sat | sun"
              }
            ]
          },
          "allDay": {
            "BOOL": true
          },
          "openingTime": {
            "NULL": true
          },
          "closingTime": {
            "NULL": true
          }
        }
      }
    ]
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
  "availabilityExceptions": {
    "S": "<string>"
  },
  "endpoint": {
    "S": "<TBC>"
  }
}

ITEM
}