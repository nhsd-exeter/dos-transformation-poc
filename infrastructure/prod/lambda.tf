##################
# Lambda Functions
##################



/**************************
//
//ELASTIC SEARCH LAMBDA
//
**************************/

module "elastic-search-lambda" {
    source  = "terraform-aws-modules/lambda/aws"
    version = "~> 2.0"

    function_name = "elastic-search"
    description   = "Microservice for interacting with elastic"
    handler       = "app.lambda_handler"
    runtime       = "python3.9"

    publish                = true
    create_package         = false
    local_existing_package = "./misc/init.zip"
    ignore_source_code_hash = true

    environment_variables = {
        ES_domain = aws_elasticsearch_domain.directory_search.endpoint,
        ES_region = var.aws_region,
    }

    allowed_triggers = {
        AllowExecutionFromAPIGateway = {
        service    = "apigateway"
        source_arn = "${aws_api_gateway_rest_api.DoS_REST.execution_arn}/*/*"
        }
    }
}


module "live-alias-elastic-search" {
    source = "terraform-aws-modules/lambda/aws//modules/alias"

    name          = "live-service"
    function_name = module.elastic-search-lambda.lambda_function_name
    refresh_alias = false
}


/**************************
//
//DIRECTORY DATA MANAGER LAMBDA
//
**************************/

module "directory-data-manager-lambda" {
    source  = "terraform-aws-modules/lambda/aws"
    version = "~> 2.0"

    function_name = "directory-data-manager"
    description   = "Microservice for management of DoS data"
    handler       = "app.app"
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


/**************************
//
//CAPACITY DATA MANAGER LAMBDA
//
**************************/

module "capacity-data-manager-lambda" {
    source  = "terraform-aws-modules/lambda/aws"
    version = "~> 2.0"

    function_name = "capacity-data-manager"
    description   = "Microservice for updating and maintaining capacity data"
    handler       = "app.app"
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
                        "${module.dynamodb_capacity_table.dynamodb_table_arn}"
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

    module "live-alias-capacity-data-manager" {
    source = "terraform-aws-modules/lambda/aws//modules/alias"

    name          = "live-service"
    function_name = module.capacity-data-manager-lambda.lambda_function_name
    refresh_alias = false
    }


/**************************
//
//CAPACITY GRIDS MANAGER LAMBDA
//
**************************/

module "capacity-grids-manager-lambda" {
    source  = "terraform-aws-modules/lambda/aws"
    version = "~> 2.0"

    function_name = "capacity-grids-manager"
    description   = "Microservice for updating and maintaining capacity grids/forms"
    handler       = "app.app"
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
                        "${module.dynamodb_capacity_grids_table.dynamodb_table_arn}"
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

    module "live-alias-capacity-grids-manager" {
    source = "terraform-aws-modules/lambda/aws//modules/alias"

    name          = "live-service"
    function_name = module.capacity-grids-manager-lambda.lambda_function_name
    refresh_alias = false
    }


/**************************
//
//SEARCH PROFILE MANAGER LAMBDA
//
**************************/

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


/**************************
//
//SEARCH PROFILER LAMBDA
//
**************************/

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
                    "Sid": "DynamoRead",
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


/**************************
//
//QUERY BUILDER LAMBDA
//
**************************/

module "query-builder-lambda" {
    source  = "terraform-aws-modules/lambda/aws"
    version = "~> 2.0"

    function_name = "query-builder"
    description   = "Microservice for constructing complex queries"
    handler       = "app.lambda_handler"
    runtime       = "python3.9"

    publish                = true
    create_package         = false
    local_existing_package = "./misc/init.zip"
    ignore_source_code_hash = true

    environment_variables = {
        ES_index  = var.directory_index_name
    }

    attach_policy_jsons = true
    policy_jsons = [
        <<-EOT
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Sid": "DynamoRead",
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

module "live-alias-query-builder" {
    source = "terraform-aws-modules/lambda/aws//modules/alias"

    name          = "live-service"
    function_name = module.query-builder-lambda.lambda_function_name
    refresh_alias = false
}


/**************************
//
//GEO PROFILER LAMBDA
//
**************************/


    module "geo-profiler-lambda" {
    source  = "terraform-aws-modules/lambda/aws"
    version = "~> 2.0"

    function_name = "geo-profiler"
    description   = "Microservice for performing geoprofiling of incoming searches"
    handler       = "app.lambda_handler"
    runtime       = "python3.9"

    publish                = true
    create_package         = false
    local_existing_package = "./misc/init.zip"
    ignore_source_code_hash = true

    environment_variables = {
        ES_index  = var.geo_profiles_index_name
    }

    attach_policy_jsons = true
    policy_jsons = [
        <<-EOT
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Sid": "DynamoRead",
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

module "live-alias-geo-profiler" {
    source = "terraform-aws-modules/lambda/aws//modules/alias"

    name          = "live-service"
    function_name = module.geo-profiler-lambda.lambda_function_name
    refresh_alias = false
}


/**************************
//
//DIRECTORY DATA RELAY LAMBDA
//
**************************/

module "directory-data-relay-lambda" {
    source  = "terraform-aws-modules/lambda/aws"
    version = "~> 2.0"

    function_name = "directory-data-relay"
    description   = "Microservice for populating Opensearch with directory service data"
    handler       = "app.lambda_handler"
    runtime       = "python3.9"

    publish                = true
    create_package         = false
    local_existing_package = "./misc/init.zip"
    ignore_source_code_hash = true

    environment_variables = {
        ES_domain = aws_elasticsearch_domain.directory_search.endpoint,
        ES_region = var.aws_region,
        ES_index  = var.directory_index_name
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

resource "aws_lambda_event_source_mapping" "directory_trigger" {
  event_source_arn  = module.dynamodb_services_table.dynamodb_table_stream_arn
  function_name     = module.directory-data-relay-lambda.lambda_function_name
  starting_position = "LATEST"
  filter_criteria {
    filter {
      pattern = jsonencode({ "eventName": ["INSERT", "MODIFY", "REMOVE" ]})
    }
  }
}

/**************************
//
//GEO DATA RELAY LAMBDA
//
**************************/

module "geo-data-relay-lambda" {
    source  = "terraform-aws-modules/lambda/aws"
    version = "~> 2.0"

    function_name = "geo-data-relay"
    description   = "Microservice for populating Opensearch with geo-profile data"
    handler       = "app.lambda_handler"
    runtime       = "python3.9"

    publish                = true
    create_package         = false
    local_existing_package = "./misc/init.zip"
    ignore_source_code_hash = true

    environment_variables = {
        ES_domain = aws_elasticsearch_domain.directory_search.endpoint,
        ES_region = var.aws_region,
        ES_index  = var.geo_profiles_index_name
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
                        "${module.dynamodb_geo_profiles_table.dynamodb_table_arn}/stream/*",
                        "${module.dynamodb_geo_profiles_table.dynamodb_table_arn}"
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

module "live-alias-geo-data-relay" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  name          = "live-service"
  function_name = module.geo-data-relay-lambda.lambda_function_name
  refresh_alias = false
}

resource "aws_lambda_event_source_mapping" "geo_trigger" {
  event_source_arn  = module.dynamodb_geo_profiles_table.dynamodb_table_stream_arn
  function_name     = module.geo-data-relay-lambda.lambda_function_name
  starting_position = "LATEST"
  filter_criteria {
    filter {
      pattern = jsonencode({ "eventName": ["INSERT", "MODIFY", "REMOVE" ]})
    }
  }
}