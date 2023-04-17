########################
# AWS Cognito User Pool
########################

resource "aws_cognito_user_pool" "DoS_Users" {
  name = "user-pool-dos"
}

resource "aws_cognito_user_pool_client" "Dos_App_Client" {
  name = "dos"

  user_pool_id = aws_cognito_user_pool.DoS_Users.id
}


resource "aws_cognito_user_pool" "Capacity_Management_Users" {
  name = "user-pool-capacity-management"
}

resource "aws_cognito_user_pool_client" "Capacity_App_Client" {
  name = "capacity-management"

  user_pool_id = aws_cognito_user_pool.Capacity_Management_Users.id
}