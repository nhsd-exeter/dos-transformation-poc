##########################
# Step Function
##########################


locals {
  definition_template = <<EOF
{
  "Comment": "Perform DoS Directory Search",
  "StartAt": "Parallel",
  "States": {
    "Parallel": {
      "Type": "Parallel",
      "ResultPath": "$.query_modifiers",
      "ResultSelector": {
        "search_profile.$": "$[0].search_profile",
        "geo_profiles.$": "$[1].body.hits.hits"
      },
      "Next": "Query-Builder",
      "Branches": [
        {
          "StartAt": "Search-Profiler",
          "States": {
            "Search-Profiler": {
              "Type": "Task",
              "Resource": "arn:aws:states:::lambda:invoke",
              "OutputPath": "$.Payload",
              "Parameters": {
                "Payload.$": "$",
                "FunctionName": "${module.search-profiler-lambda.lambda_function_arn}:${module.live-alias-search-profiler.lambda_alias_name}"
              },
              "Retry": [
                {
                  "ErrorEquals": [
                    "Lambda.ServiceException",
                    "Lambda.AWSLambdaException",
                    "Lambda.SdkClientException"
                  ],
                  "IntervalSeconds": 2,
                  "MaxAttempts": 6,
                  "BackoffRate": 2
                }
              ],
              "End": true,
              "ResultSelector": {
                "Payload.$": "States.StringToJson($.Payload)"
              }
            }
          }
        },
        {
          "StartAt": "Geo-Profiler",
          "States": {
            "Geo-Profiler": {
              "Type": "Task",
              "Resource": "arn:aws:states:::lambda:invoke",
              "OutputPath": "$.Payload",
              "Parameters": {
                "Payload.$": "$",
                "FunctionName": "${module.geo-profiler-lambda.lambda_function_arn}:${module.live-alias-geo-profiler.lambda_alias_name}"
              },
              "Retry": [
                {
                  "ErrorEquals": [
                    "Lambda.ServiceException",
                    "Lambda.AWSLambdaException",
                    "Lambda.SdkClientException",
                    "Lambda.TooManyRequestsException"
                  ],
                  "IntervalSeconds": 2,
                  "MaxAttempts": 6,
                  "BackoffRate": 2
                }
              ],
              "Next": "Geo-Search"
            },
            "Geo-Search": {
              "Type": "Task",
              "Resource": "arn:aws:states:::lambda:invoke",
              "OutputPath": "$.Payload",
              "Parameters": {
                "Payload.$": "$",
                "FunctionName": "${module.elastic-search-lambda.lambda_function_arn}:${module.live-alias-elastic-search.lambda_alias_name}"
              },
              "Retry": [
                {
                  "ErrorEquals": [
                    "Lambda.ServiceException",
                    "Lambda.AWSLambdaException",
                    "Lambda.SdkClientException",
                    "Lambda.TooManyRequestsException"
                  ],
                  "IntervalSeconds": 2,
                  "MaxAttempts": 6,
                  "BackoffRate": 2
                }
              ],
              "End": true
            }
          }
        }
      ]
    },
    "Query-Builder": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "OutputPath": "$.Payload",
      "Parameters": {
        "Payload.$": "$",
        "FunctionName": "${module.query-builder-lambda.lambda_function_arn}:${module.live-alias-query-builder.lambda_alias_name}"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
            "Lambda.TooManyRequestsException"
          ],
          "IntervalSeconds": 2,
          "MaxAttempts": 6,
          "BackoffRate": 2
        }
      ],
      "Next": "Directory-Search"
    },
    "Directory-Search": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "OutputPath": "$.Payload",
      "Parameters": {
        "Payload.$": "$",
        "FunctionName": "${module.elastic-search-lambda.lambda_function_arn}:${module.live-alias-elastic-search.lambda_alias_name}"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException"
          ],
          "IntervalSeconds": 2,
          "MaxAttempts": 6,
          "BackoffRate": 2
        }
      ],
      "End": true
    }
  }
}
  EOF
}

module "search_step_function" {
  source = "terraform-aws-modules/step-functions/aws"
  name = "DirectorySearchWorkflow"
  type = "express"

  definition = local.definition_template

  logging_configuration = {
    include_execution_data = true
    level                  = "ALL"
  }

  service_integrations = {
    xray = {
      xray = true 
    }

    lambda = {
      lambda = [
        "${module.elastic-search-lambda.lambda_function_arn}:*", 
        "${module.search-profiler-lambda.lambda_function_arn}:*",
        "${module.geo-profiler-lambda.lambda_function_arn}:*",
        "${module.query-builder-lambda.lambda_function_arn}:*"
        ]
    }
  }
}
