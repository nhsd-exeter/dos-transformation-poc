provider "aws" {
  region = "eu-west-2"

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

  # skip_requesting_account_id should be disabled to generate valid ARN in apigatewayv2_api_execution_arn
  skip_requesting_account_id = false
}

locals {
  domain_name = "api-integration-testing.co.uk" 
}

###################
# HTTP API Gateway
###################

module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "future-dos-http"
  description   = "HTTP API Gateway demonstrator for a future DoS"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  mutual_tls_authentication = {
    truststore_uri     = "s3://${aws_s3_bucket.truststore.bucket}/${aws_s3_bucket_object.truststore.id}"
    truststore_version = aws_s3_bucket_object.truststore.version_id
  }

  domain_name                 = local.domain_name
  domain_name_certificate_arn = module.acm.acm_certificate_arn

  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.logs.arn
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  default_route_settings = {
    detailed_metrics_enabled = true
    throttling_burst_limit   = 100
    throttling_rate_limit    = 100
  }

  authorizers = {
    "cognito" = {
      authorizer_type  = "JWT"
      identity_sources = "$request.header.Authorization"
      name             = "cognito"
      audience         = ["d6a38afd-45d6-4874-d1aa-3c5c558aqcc2"]
      issuer           = "https://${aws_cognito_user_pool.this.endpoint}"
    }
  }

  integrations = {

    "ANY /" = {
      lambda_arn             = module.directory-search-lambda.lambda_function_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

    "GET /search" = {
      lambda_arn             = module.directory-search-lambda.lambda_function_arn
      payload_format_version = "2.0"
      authorizer_key         = "cognito"
    }

    "GET /services" = {
      lambda_arn             = module.directory-data-manager-lambda.lambda_function_arn
      payload_format_version = "2.0"
      authorizer_key         = "cognito"
    }

    # "GET /some-route-with-authorizer-and-scope" = {
    #   lambda_arn             = module.lambda_function.lambda_function_arn
    #   payload_format_version = "2.0"
    #   authorizer_key         = "cognito"
    #   # authorization_scopes   = "tf/something.relevant.read,tf/something.relevant.write" # Should comply with the resource server configuration part of the cognito user pool
    # }

    # "GET /some-route-with-authorizer-and-different-scope" = {
    #   lambda_arn             = module.lambda_function.lambda_function_arn
    #   payload_format_version = "2.0"
    #   authorizer_key         = "cognito"
    #   # authorization_scopes   = "tf/something.relevant.write" # Should comply with the resource server configuration part of the cognito user pool
    # }


    "$default" = {
      lambda_arn = module.directory-search-lambda.lambda_function_arn
      tls_config = jsonencode({
        server_name_to_verify = local.domain_name
      })

      response_parameters = jsonencode([
        {
          status_code = 500
          mappings = {
            "append:header.header1" = "$context.requestId"
            "overwrite:statuscode"  = "403"
          }
        },
        {
          status_code = 404
          mappings = {
            "append:header.error" = "$stageVariables.environmentId"
          }
        }
      ])
    }

  }

  //NEED TO ADD ALIAS TO LAMBDA

  body = templatefile("api.yaml", {
    example_function_arn = module.directory-search-lambda.lambda_function_arn
  })

  tags = {
    Name = "dev-api-new"
  }
}

######
# ACM
######

data "aws_route53_zone" "this" {
  name = local.domain_name
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name               = local.domain_name
  zone_id                   = data.aws_route53_zone.this.id
}

##########
# Route53
##########

resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.domain_name
  type    = "A"

  alias {
    name                   = module.api_gateway.apigatewayv2_domain_name_configuration[0].target_domain_name
    zone_id                = module.api_gateway.apigatewayv2_domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

#############################
# AWS API Gateway Authorizer
#############################

resource "aws_apigatewayv2_authorizer" "some_authorizer" {
  api_id           = module.api_gateway.apigatewayv2_api_id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "Future_DoS"

  jwt_configuration {
    audience = ["example"]
    issuer   = "https://${aws_cognito_user_pool.this.endpoint}"
  }
}

########################
# AWS Cognito User Pool
########################

resource "aws_cognito_user_pool" "this" {
  name = "user-pool-future-dos"
}


##################
# Extra resources
##################


resource "aws_cloudwatch_log_group" "logs" {
  name = "future-dos"
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

  source_path = "../microservices/directory-search/"

  publish      = true

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
    }
  }
}


module "directory-data-manager-lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name = "directory-data-manager"
  description   = "Microservice for management of DoS data"
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  source_path = "../microservices/directory-data-manager/"

  publish      = true


  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
    }
  }
}

module "search-profile-manager-lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name = "search-profile-manager"
  description   = "Microservice for search profiles"
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  source_path = "../microservices/search-profile-manager/"

  publish      = true


  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
    }
  }
}



###############################################
# S3 bucket and TLS certificate for truststore
###############################################

resource "aws_s3_bucket" "truststore" {
  bucket = "future-dos-truststore"
}

resource "aws_s3_bucket_object" "truststore" {
  bucket                 = aws_s3_bucket.truststore.bucket
  key                    = "truststore.pem"
  server_side_encryption = "AES256"
  content                = tls_self_signed_cert.example.cert_pem
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "example" {
  is_ca_certificate = true
  private_key_pem   = tls_private_key.private_key.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "Example DoS"
  }

  validity_period_hours = 12

  allowed_uses = [
    "cert_signing",
    "server_auth",
  ]
}

##########################
# DynamoDB Service Table
##########################

module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "directory"
  hash_key = "id"
  autoscaling_enabled = true

  attributes = [
    {
      name = "id"
      type = "N"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}
