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

module "dynamodb_geo_profiles_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "geo-profiles"
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

module "dynamodb_capacity_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "capacity"
  hash_key = "id"
  autoscaling_enabled = true

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
}

module "dynamodb_capacity_grids_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "capacity_grids"
  hash_key = "id"
  autoscaling_enabled = true

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
}