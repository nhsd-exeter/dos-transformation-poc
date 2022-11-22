# This bootstrapper script initialises various resources necessary for Terraform and Github Actions to build the DoS PoC Application

# Before running the bootstrapper script, please login to an appropriate AWS user via the AWS-cli

# Configure the following variables appropriate for your account and github setup

export REPO_NAME="gcowell/mvp-demonstrator"              # The repository name where your code is stored
export AWS_ACCOUNT="202422821117"               # The account number of the AWS account you intend to deploy into
export TERRAFORM_BUCKET_NAME="terraform8247829" # A globally unique name for your terraform remote state bucket
export AWS_REGION="eu-west-2"                   # The AWS region where you intend to deploy the application to (where the bucket will be created)

#--------------------------------------------------------

# THE FOLLOWING COMMANDS CONFIGURE THE OIDC IDENTITY PROVIDER FOR GITHUB ACTIONS


HOST=$(curl https://token.actions.githubusercontent.com/.well-known/openid-configuration) 
CERT_URL=$(jq -r '.jwks_uri | split("/")[2]' <<< $HOST)
THUMBPRINT=$(echo | openssl s_client -servername $CERT_URL -showcerts -connect $CERT_URL:443 2> /dev/null | tac | sed -n '/-----END CERTIFICATE-----/,/-----BEGIN CERTIFICATE-----/p; /-----BEGIN CERTIFICATE-----/q' | tac | openssl x509 -fingerprint -noout | sed 's/://g' | awk -F= '{print tolower($2)}')

aws iam create-open-id-connect-provider --url "https://token.actions.githubusercontent.com" --client-id-list "sts.amazonaws.com" --thumbprint-list ["$THUMBPRINT"]


# THE FOLLOWING COMMANDS CONFIGURE THE IAM ROLE AND POLICIES FOR THE GITHUB ACTION RUNNER

aws iam create-role --role-name github --assume-role-policy-document "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Federated\":\"arn:aws:iam::$AWS_ACCOUNT:oidc-provider/token.actions.githubusercontent.com\"},\"Action\":\"sts:AssumeRoleWithWebIdentity\",\"Condition\":{\"ForAllValues:StringLike\":{\"token.actions.githubusercontent.com:sub\":\"repo:$REPO_NAME:*\",\"token.actions.githubusercontent.com:aud\":\"sts.amazonaws.com\"}}}]}" 
aws iam put-role-policy --role-name github --policy-name AdministratorAccess --policy-document "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":\"*\",\"Resource\":\"*\"}]}"

# THE FOLLOWING COMMANDS CONFIGURE THE TERRAFORM REMOTE STATE BUCKET

aws s3api create-bucket --acl private --bucket $TERRAFORM_BUCKET_NAME --region $AWS_REGION --create-bucket-configuration LocationConstraint=$AWS_REGION
aws s3api put-public-access-block --bucket $TERRAFORM_BUCKET_NAME  --public-access-block-configuration '{"BlockPublicAcls": true, "IgnorePublicAcls": true, "BlockPublicPolicy": true, "RestrictPublicBuckets": true}'








