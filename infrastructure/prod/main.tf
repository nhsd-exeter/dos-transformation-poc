variable "aws_region" {
  type = string
  default = "eu-west-2"
}

provider "aws" {
  region = var.aws_region

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

  # skip_requesting_account_id should be disabled to generate valid ARN in apigatewayv2_api_execution_arn
  skip_requesting_account_id = false
}




###################
# API Gateway
###################

resource "aws_api_gateway_rest_api" "DoS_REST" {
  name = "DoS_REST"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

//SEARCH ENDPOINTS

resource "aws_api_gateway_resource" "search" {
  parent_id   = aws_api_gateway_rest_api.DoS_REST.root_resource_id
  path_part   = "search"
  rest_api_id = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_method" "search_POST" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.search.id
  rest_api_id   = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_integration" "search_POST_integration" {
  rest_api_id = aws_api_gateway_rest_api.DoS_REST.id
  resource_id = aws_api_gateway_resource.search.id
  credentials = "${aws_iam_role.APIGatewaytoDoSSearchWorkflow.arn}"

  request_templates = {
    "application/json" = <<EOF
    {
    {
      "input": "{\"search_query\":$util.escapeJavaScript($input.json('$.search_query')),\"api_key\":\"$context.identity.apiKey\"}",
      "stateMachineArn": "${module.search_step_function.state_machine_arn}"
    } 
    }
    EOF
  }

  http_method             = "POST"
  integration_http_method = "POST"
  type                    = "AWS"
  passthrough_behavior    = "NEVER"
  uri                     = "arn:aws:apigateway:${var.aws_region}:states:action/StartSyncExecution"

}

//SEARCH PROFILE ENDPOINTS

resource "aws_api_gateway_resource" "searchprofiles" {
  parent_id   = aws_api_gateway_rest_api.DoS_REST.root_resource_id
  path_part   = "searchprofiles"
  rest_api_id = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_method" "searchprofiles_POST" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.searchprofiles.id
  rest_api_id   = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_method" "searchprofiles_GET" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.searchprofiles.id
  rest_api_id   = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_method" "searchprofiles_DELETE" {
  authorization = "NONE"
  http_method   = "DELETE"
  resource_id   = aws_api_gateway_resource.searchprofiles.id
  rest_api_id   = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_integration" "searchprofiles_GET_integration" {
  rest_api_id             = aws_api_gateway_rest_api.DoS_REST.id
  resource_id             = aws_api_gateway_resource.searchprofiles.id
  http_method             = aws_api_gateway_method.searchprofiles_GET.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${module.search-profile-manager-lambda.lambda_function_arn}/invocations"
}

resource "aws_api_gateway_integration" "searchprofiles_POST_integration" {
  rest_api_id             = aws_api_gateway_rest_api.DoS_REST.id
  resource_id             = aws_api_gateway_resource.searchprofiles.id
  http_method             = aws_api_gateway_method.searchprofiles_POST.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${module.search-profile-manager-lambda.lambda_function_arn}/invocations"
}

resource "aws_api_gateway_integration" "searchprofiles_DELETE_integration" {
  rest_api_id             = aws_api_gateway_rest_api.DoS_REST.id
  resource_id             = aws_api_gateway_resource.searchprofiles.id
  http_method             = aws_api_gateway_method.searchprofiles_DELETE.http_method
  integration_http_method = "DELETE"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${module.search-profile-manager-lambda.lambda_function_arn}/invocations"
}


//SEARCH PROFILE / CONSUMER ENDPOINTS

resource "aws_api_gateway_resource" "consumers" {
  parent_id   = aws_api_gateway_resource.searchprofiles.id
  path_part   = "consumers"
  rest_api_id = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_method" "consumers_POST" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.consumers.id
  rest_api_id   = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_method" "consumers_GET" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.consumers.id
  rest_api_id   = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_method" "consumers_DELETE" {
  authorization = "NONE"
  http_method   = "DELETE"
  resource_id   = aws_api_gateway_resource.consumers.id
  rest_api_id   = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_integration" "consumers_GET_integration" {
  rest_api_id             = aws_api_gateway_rest_api.DoS_REST.id
  resource_id             = aws_api_gateway_resource.consumers.id
  http_method             = aws_api_gateway_method.consumers_GET.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${module.search-profile-manager-lambda.lambda_function_arn}/invocations"
}

resource "aws_api_gateway_integration" "consumers_POST_integration" {
  rest_api_id             = aws_api_gateway_rest_api.DoS_REST.id
  resource_id             = aws_api_gateway_resource.consumers.id
  http_method             = aws_api_gateway_method.consumers_POST.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${module.search-profile-manager-lambda.lambda_function_arn}/invocations"
}

resource "aws_api_gateway_integration" "consumers_DELETE_integration" {
  rest_api_id             = aws_api_gateway_rest_api.DoS_REST.id
  resource_id             = aws_api_gateway_resource.consumers.id
  http_method             = aws_api_gateway_method.consumers_DELETE.http_method
  integration_http_method = "DELETE"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${module.search-profile-manager-lambda.lambda_function_arn}/invocations"
}

//SERVICES ENDPOINTS

resource "aws_api_gateway_resource" "services" {
  parent_id   = aws_api_gateway_rest_api.DoS_REST.root_resource_id
  path_part   = "services"
  rest_api_id = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_method" "services_POST" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.services.id
  rest_api_id   = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_method" "services_GET" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.services.id
  rest_api_id   = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_method" "services_DELETE" {
  authorization = "NONE"
  http_method   = "DELETE"
  resource_id   = aws_api_gateway_resource.services.id
  rest_api_id   = aws_api_gateway_rest_api.DoS_REST.id
}


resource "aws_api_gateway_integration" "services_GET_integration" {
  rest_api_id             = aws_api_gateway_rest_api.DoS_REST.id
  resource_id             = aws_api_gateway_resource.services.id
  http_method             = aws_api_gateway_method.services_GET.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${module.directory-data-manager-lambda.lambda_function_arn}/invocations"
}

resource "aws_api_gateway_integration" "services_POST_integration" {
  rest_api_id             = aws_api_gateway_rest_api.DoS_REST.id
  resource_id             = aws_api_gateway_resource.services.id
  http_method             = aws_api_gateway_method.services_POST.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${module.directory-data-manager-lambda.lambda_function_arn}/invocations"
}

resource "aws_api_gateway_integration" "services_DELETE_integration" {
  rest_api_id             = aws_api_gateway_rest_api.DoS_REST.id
  resource_id             = aws_api_gateway_resource.services.id
  http_method             = aws_api_gateway_method.services_DELETE.http_method
  integration_http_method = "DELETE"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${module.directory-data-manager-lambda.lambda_function_arn}/invocations"
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.DoS_REST.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.search.id,
      aws_api_gateway_method.search_POST.id,
      aws_api_gateway_integration.search_POST_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
      aws_api_gateway_resource.search,
      aws_api_gateway_method.search_POST,
      aws_api_gateway_integration.search_POST_integration
  ]
}

resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.DoS_REST.id
  stage_name    = "main"
}


resource "aws_api_gateway_authorizer" "DoS_Users" {
  name                   = "DoS_Users"
  rest_api_id            = aws_api_gateway_rest_api.DoS_REST.id
  type                   = "COGNITO_USER_POOLS"
  provider_arns          = ["${aws_cognito_user_pool.DoS_Users.arn}"]
}




########################
# AWS Cognito User Pool
########################

resource "aws_cognito_user_pool" "DoS_Users" {
  name = "user-pool-future-dos2"
}


##################
# Extra resources
##################


resource "aws_cloudwatch_log_group" "logs" {
  name = "future-dos2"
}


##################
# Lambda Functions
##################



module "directory-search-lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name = "directory-search2"
  description   = "Primary DoS search service"
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  source_path = "../../microservices/directory-search/"

  publish      = true
  ignore_source_code_hash = true

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${aws_api_gateway_rest_api.DoS_REST.execution_arn}/*/*"
    }
  }
}


module "directory-data-manager-lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name = "directory-data-manager2"
  description   = "Microservice for management of DoS data"
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  source_path = "../../microservices/directory-data-manager/"

  publish      = true
  ignore_source_code_hash = true


  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${aws_api_gateway_rest_api.DoS_REST.execution_arn}/*/*"
    }
  }
}

module "search-profile-manager-lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name = "search-profile-manager2"
  description   = "Microservice for search profiles"
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  source_path = "../../microservices/search-profile-manager/"

  publish      = true
  ignore_source_code_hash = true


  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${aws_api_gateway_rest_api.DoS_REST.execution_arn}/*/*"
    }
  }
}


module "search-profiler-lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name = "search-profiler2"
  description   = "Microservice for filtering searches based on profiles"
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  source_path = "../../microservices/search-profiler/"

  publish      = true
  ignore_source_code_hash = true

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${aws_api_gateway_rest_api.DoS_REST.execution_arn}/*/*"
    }
  }
}


module "directory-data-relay-lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name = "directory-data-relay2"
  description   = "Microservice for populating Opensearch with Dynamo data"
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  source_path = "../../microservices/directory-data-relay/"

  publish      = true
  ignore_source_code_hash = true


  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${aws_api_gateway_rest_api.DoS_REST.execution_arn}/*/*"
    }
  }
}


##########################
# DynamoDB Tables
##########################

module "dynamodb_services_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "services2"
  hash_key = "id"
  autoscaling_enabled = true

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
}

module "dynamodb_search_profiles_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "search-profiles2"
  hash_key = "id"
  autoscaling_enabled = true

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
}

module "dynamodb_search_consumers_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "search-consumers2"
  hash_key = "key"
  autoscaling_enabled = true

  attributes = [
    {
      name = "key"
      type = "S"
    }
  ]
}



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
          "FunctionName": "${module.search-profiler-lambda.lambda_function_arn}:$LATEST"
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
          "FunctionName": "${module.directory-search-lambda.lambda_function_arn}:$LATEST"
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
  name = "DirectorySearchWorkflow2"
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

    cloudwatch = {
      cloudwatch = true 
    }

    lambda = {
      lambda = ["${module.directory-search-lambda.lambda_function_arn}", "${module.search-profiler-lambda.lambda_function_arn}"]
    }
  }
}


# ##########################
# # Opensearch
# ##########################


# resource "aws_elasticsearch_domain" "example" {
#   domain_name           = "example"
#   elasticsearch_version = "7.10"

#   cluster_config {
#     instance_type = "r4.large.elasticsearch"
#   }

#   tags = {
#     Domain = "TestDomain"
#   }
# }


######
# IAM
######

resource "aws_iam_role" "APIGatewaytoDoSSearchWorkflow" {
  name               = "APIGatewaytoDoSSearchWorkflow2"
  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
            Effect: "Allow",
            Principal: {
                Service: "apigateway.amazonaws.com"
            },
            Action: "sts:AssumeRole"
        }
    ]
})

  inline_policy {
    name = "APIGatewaytoStepFunction"

    policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
            Sid: "ExecuteStateMachine",
            Effect: "Allow",
            Action: "states:StartSyncExecution",
            Resource: [
                "arn:aws:states:eu-west-2:202422821117:stateMachine:DoSSearchWorkflow"
            ]
        }
    ]
})
  }
}