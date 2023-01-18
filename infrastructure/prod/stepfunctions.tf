##########################
# Step Function
##########################


locals {
  definition_template = <<EOF
  {
    "Comment": "Perform DoS Directory Search",
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
        "Next": "Directory-Search"
      },
      "Directory-Search": {
        "Type": "Task",
        "Resource": "arn:aws:states:::lambda:invoke",
        "OutputPath": "$.Payload",
        "Parameters": {
          "Payload.$": "$",
          "FunctionName": "${module.directory-search-lambda.lambda_function_arn}:${module.live-alias-directory-search.lambda_alias_name}"  
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
      lambda = ["${module.directory-search-lambda.lambda_function_arn}:*", "${module.search-profiler-lambda.lambda_function_arn}:*"]
    }
  }
}
