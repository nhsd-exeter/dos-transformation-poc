
# Before running the bootstrapper script, please login to an appropriate AWS user via the AWS-cli

export REPO_NAME="insert/reponame"
export AWS_ACC="XXXXXXXX"


HOST=$(curl https://token.actions.githubusercontent.com/.well-known/openid-configuration) 
CERT_URL=$(jq -r '.jwks_uri | split("/")[2]' <<< $HOST)
echo | openssl s_client -servername $CERT_URL -showcerts -connect $CERT_URL:443 2> /dev/null \
sed -n -e '/BEGIN/h' -e '/BEGIN/,/END/H' -e '$x' -e '$p' | tail 2 \
openssl x509 -fingerprint -noout \
sed -e "s/.*=//" -e "s/://g" \
tr "ABCDEF" "abcdef"

aws iam create-open-id-connect-provider --url "https://token.actions.githubusercontent.com" --client-id-list "sts.amazonaws.com" --thumbprint-list

aws-cli create-bucket
aws-cli create-role --role-name=github --assume-role-policy-document= {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::202422821117:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "ForAllValues:StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:gcowell/mvp-demonstrator:*",
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                }
            }
        }
    ]
}






