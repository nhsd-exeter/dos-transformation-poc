variable "aws_region" {
  type = string
  default = "eu-west-2"
}

data "aws_caller_identity" "current" {}

provider "aws" {
  region = var.aws_region

  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

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
  api_key_required = true
}

resource "aws_api_gateway_integration" "search_POST_integration" {
  rest_api_id = aws_api_gateway_rest_api.DoS_REST.id
  resource_id = aws_api_gateway_resource.search.id
  credentials = "${aws_iam_role.APIGatewaytoDoSSearchWorkflow.arn}"

  request_templates = {
    "application/json" = <<EOF
    {
      "input": "{\"search_query\":$util.escapeJavaScript($input.json('$.search_query')),\"api_key\":\"$context.identity.apiKey\"}",
      "stateMachineArn": "${module.search_step_function.state_machine_arn}"
    } 
    EOF
  }

  http_method             = "POST"
  integration_http_method = "POST"
  type                    = "AWS"
  passthrough_behavior    = "NEVER"
  uri                     = "arn:aws:apigateway:${var.aws_region}:states:action/StartSyncExecution"

}

resource "aws_api_gateway_method_response" "search_response" {
  rest_api_id = aws_api_gateway_rest_api.DoS_REST.id
  resource_id = aws_api_gateway_resource.search.id
  http_method = aws_api_gateway_method.search_POST.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "search_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.DoS_REST.id
  resource_id = aws_api_gateway_resource.search.id
  http_method = aws_api_gateway_method.search_POST.http_method
  status_code = aws_api_gateway_method_response.search_response.status_code
  response_templates = {
    "application/json" = <<EOF
      #set ($parsedPayload = $util.parseJson($input.json('$.output')))
      $parsedPayload
    EOF
  }

}

//SEARCH PROFILE ENDPOINTS

resource "aws_api_gateway_resource" "searchprofiles" {
  parent_id   = aws_api_gateway_rest_api.DoS_REST.root_resource_id
  path_part   = "searchprofiles"
  rest_api_id = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_method" "searchprofiles_POST" {
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.DoS_Users.id
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.searchprofiles.id
  rest_api_id   = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_method" "searchprofiles_GET" {
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.DoS_Users.id
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.searchprofiles.id
  rest_api_id   = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_method" "searchprofiles_DELETE" {
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.DoS_Users.id
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
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.DoS_Users.id
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.consumers.id
  rest_api_id   = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_method" "consumers_GET" {
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.DoS_Users.id
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.consumers.id
  rest_api_id   = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_method" "consumers_DELETE" {
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.DoS_Users.id
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
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.DoS_Users.id
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.services.id
  rest_api_id   = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_method" "services_GET" {
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.DoS_Users.id
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.services.id
  rest_api_id   = aws_api_gateway_rest_api.DoS_REST.id
}

resource "aws_api_gateway_method" "services_DELETE" {
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.DoS_Users.id
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
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.DoS_REST
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_rest_api.DoS_REST
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



resource "aws_api_gateway_usage_plan" "standard" {
  name         = "standard"
  description  = "Standard Usage Plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.DoS_REST.id
    stage  = aws_api_gateway_stage.main.stage_name
  }

  quota_settings {
    limit  = 20000
    offset = 2
    period = "WEEK"
  }

  throttle_settings {
    burst_limit = 50
    rate_limit  = 100
  }
}


resource "aws_api_gateway_api_key" "example_key" {
  name = "example_key"
  value = "LyXvMVUd3L9bc5IVhpA4l5efM0jqvLFL535MVHpx"
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.example_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.standard.id
}



########################
# AWS Cognito User Pool
########################

resource "aws_cognito_user_pool" "DoS_Users" {
  name = "user-pool-dos"
}


##################
# Extra resources
##################


resource "aws_cloudwatch_log_group" "logs" {
  name = "dos-logging"
}


##################
# Lambda Functions
##################



module "directory-search-lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name = "directory-search"
  description   = "Primary DoS search service"
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  publish                = true
  create_package         = false
  local_existing_package = "./misc/init.zip"
  ignore_source_code_hash = true

  environment_variables = {
    ES_domain = aws_elasticsearch_domain.directory_search.endpoint,
    ES_region = var.aws_region,
    ES_index  = var.index_name
  }

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${aws_api_gateway_rest_api.DoS_REST.execution_arn}/*/*"
    }
  }
}

  




module "live-alias-directory-search" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  name          = "live-service"
  function_name = module.directory-search-lambda.lambda_function_name
  refresh_alias = false
}


module "directory-data-manager-lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name = "directory-data-manager"
  description   = "Microservice for management of DoS data"
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  publish                = true
  create_package         = false
  local_existing_package = "./misc/init.zip"
  ignore_source_code_hash = true

  attach_policy_jsons = true
  policy_jsons = [
    <<-EOT
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": [
                    "dynamodb:PutItem",
                    "dynamodb:DeleteItem",
                    "dynamodb:GetItem",
                    "dynamodb:Scan",
                    "dynamodb:Query",
                    "dynamodb:UpdateItem"
                ],
                "Resource": [
                    "${module.dynamodb_services_table.dynamodb_table_arn}"
                ]
            }
        ]
    }
    EOT
  ]
  number_of_policy_jsons = 1



  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${aws_api_gateway_rest_api.DoS_REST.execution_arn}/*/*"
    }
  }
}

module "live-alias-directory-data-manager" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  name          = "live-service"
  function_name = module.directory-data-manager-lambda.lambda_function_name
  refresh_alias = false
}

module "search-profile-manager-lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name = "search-profile-manager"
  description   = "Microservice for search profiles"
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  publish                = true
  create_package         = false
  local_existing_package = "./misc/init.zip"
  ignore_source_code_hash = true


  attach_policy_jsons = true
  policy_jsons = [
    <<-EOT
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": [
                    "dynamodb:PutItem",
                    "dynamodb:DeleteItem",
                    "dynamodb:GetItem",
                    "dynamodb:Scan",
                    "dynamodb:Query",
                    "dynamodb:UpdateItem"
                ],
                "Resource": [
                    "${module.dynamodb_search_profiles_table.dynamodb_table_arn}",
                    "${module.dynamodb_search_consumers_table.dynamodb_table_arn}"
                ]
            }
        ]
    }
    EOT
  ]
  number_of_policy_jsons = 1

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${aws_api_gateway_rest_api.DoS_REST.execution_arn}/*/*"
    }
  }
}

module "live-alias-search-profile-manager" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  name          = "live-service"
  function_name = module.search-profile-manager-lambda.lambda_function_name
  refresh_alias = false
}


module "search-profiler-lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name = "search-profiler"
  description   = "Microservice for filtering searches based on profiles"
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  publish                = true
  create_package         = false
  local_existing_package = "./misc/init.zip"
  ignore_source_code_hash = true

  attach_policy_jsons = true
  policy_jsons = [
    <<-EOT
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": [
                    "dynamodb:GetItem",
                    "dynamodb:GetRecords"
                ],
                "Resource": [
                    "${module.dynamodb_search_profiles_table.dynamodb_table_arn}",
                    "${module.dynamodb_search_consumers_table.dynamodb_table_arn}"
                ]
            }
        ]
    }
    EOT
  ]
  number_of_policy_jsons = 1

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${aws_api_gateway_rest_api.DoS_REST.execution_arn}/*/*"
    }
  }
}

module "live-alias-search-profiler" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  name          = "live-service"
  function_name = module.search-profiler-lambda.lambda_function_name
  refresh_alias = false
}

module "directory-data-relay-lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name = "directory-data-relay"
  description   = "Microservice for populating Opensearch with Dynamo data"
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  # We want to manage our application code using a dedicated application deployment pipeline.
  # Therefore we want our infrastructure manifests to just build the lambda and not worry about the code inside.
  # This block tells terraform to deploy an initial zip package when the lambda is created, 
  # and then ignore application code on each subsequent apply
  publish                = true
  create_package         = false
  local_existing_package = "./misc/init.zip"
  ignore_source_code_hash = true

  environment_variables = {
    ES_domain = aws_elasticsearch_domain.directory_search.endpoint,
    ES_region = var.aws_region,
    ES_index  = var.index_name
  }

  attach_policy_jsons = true
  policy_jsons = [
    <<-EOT
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": [
                    "dynamodb:GetShardIterator",
                    "dynamodb:GetItem",
                    "dynamodb:DescribeStream",
                    "dynamodb:GetRecords"
                ],
                "Resource": [
                    "${module.dynamodb_services_table.dynamodb_table_arn}/stream/*",
                    "${module.dynamodb_services_table.dynamodb_table_arn}"
                ]
            },
            {
                "Sid": "VisualEditor2",
                "Effect": "Allow",
                "Action": "dynamodb:ListStreams",
                "Resource": "*"
            }
        ]
    }
    EOT
  ]
  number_of_policy_jsons = 1
}

module "live-alias-directory-data-relay" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  name          = "live-service"
  function_name = module.directory-data-relay-lambda.lambda_function_name
  refresh_alias = false
}

resource "aws_lambda_event_source_mapping" "dynamodb_trigger" {
  event_source_arn  = module.dynamodb_services_table.dynamodb_table_stream_arn
  function_name     = module.directory-data-relay-lambda.lambda_function_name
  starting_position = "LATEST"
  filter_criteria {
    filter {
      pattern = jsonencode({ "eventName": ["INSERT", "MODIFY", "REMOVE" ]})
    }
  }
}

##########################
# DynamoDB Tables
##########################

module "dynamodb_services_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "services"
  hash_key = "id"
  autoscaling_enabled = true
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
}


module "dynamodb_search_profiles_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "search-profiles"
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

  name     = "search-consumers"
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


# ##########################
# # Opensearch
# ##########################

variable "domain" {
  default = "directory-search"
}

variable "index_name" {
  default = "directory-index"
}

resource "aws_elasticsearch_domain" "directory_search" {
  domain_name           = var.domain
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t3.small.elasticsearch"
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https = true
    tls_security_policy = "Policy-Min-TLS-1-0-2019-07"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = "10"
    iops        = "3000" 
    volume_type = "gp3"
  }


  access_policies = jsonencode({
      Version: "2012-10-17",
      Statement: [
          {
            Effect: "Allow",
            Principal: {
              "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/github"
            },
            Action: "es:*",
            Resource: "arn:aws:es:${var.aws_region}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
          },
          {
            Effect: "Allow",
            Principal: {
              "AWS": "arn:aws:sts::${data.aws_caller_identity.current.account_id}:assumed-role/directory-search/directory-search"
            },
            Action: [
                "es:ESHttpGet",
                "es:ESHttpPost"
              ]
            Resource: "arn:aws:es:${var.aws_region}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
          },
          {
            Effect: "Allow",
            Principal: {
              "AWS": "arn:aws:sts::${data.aws_caller_identity.current.account_id}:assumed-role/directory-data-relay/directory-data-relay"
            },
            Action: [
                "es:ESHttpDelete",
                "es:ESHttpGet",
                "es:ESHttpPost",
                "es:ESHttpPut"
              ],
            Resource: "arn:aws:es:${var.aws_region}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
          }
        ]
      }
    )
  }



  resource "null_resource" "elastic_provisioner_script" {
    provisioner "local-exec" {
      command = <<EOT
        cd ./elastic
        pip install -r requirements.txt --target .
        python3 configure_elastic.py ${var.aws_region} ${aws_elasticsearch_domain.directory_search.endpoint} ${module.directory-search-lambda.lambda_function_arn} ${module.directory-data-relay-lambda.lambda_function_arn}
      EOT
      }
      
      triggers = {
          always_run = timestamp()
      }
  }


######
# MISCELLANEOUS IAM
######

resource "aws_iam_role" "APIGatewaytoDoSSearchWorkflow" {
  name               = "APIGatewaytoDoSSearchWorkflow"
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
                "${module.search_step_function.state_machine_arn}" 
            ]
        }
    ]
})
  }
}




