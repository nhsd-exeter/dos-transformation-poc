########################
# AWS Cognito User Pool
########################

resource "aws_cognito_user_pool" "DoS_Users" {
  name = "user-pool-dos"
}

resource "aws_cognito_user_pool_client" "app_Client" {
  name = "futuredos"

  user_pool_id = aws_cognito_user_pool.DoS_Users.id
}