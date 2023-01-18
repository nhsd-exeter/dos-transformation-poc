########################
# AWS Cognito User Pool
########################

resource "aws_cognito_user_pool" "DoS_Users" {
  name = "user-pool-dos"
}