#!/bin/bash

#THIS SCRIPT EXECUTES THE RELEVANT DEPLOYMENT ACTIONS FOR THIS MICROSERVICE.
#IT IS REFERENCED BY THE APPLICATION PIPELINE AND THEREFORE MUST ALWAYS BE CALLED "deploy_service.sh"    

#INPUT ARGUMENTS

SERVICE_NAME=$1
ENVIRONMENT_NAME=$2

pip install -r requirements.txt --target .
zip -r deploy.zip * 
LAMBDA_OUTPUT=$(aws lambda update-function-code --function-name=$SERVICE_NAME --zip-file=fileb://deploy.zip --publish)
LATEST_VERSION=$(jq -r '.Version' --compact-output <<< "$LAMBDA_OUTPUT" )
PREVIOUS_VERSION=$(expr $LATEST_VERSION - 1)

if [ $ENVIRONMENT_NAME = 'staging' ]
then
ROUTING_CONFIG=\'{"AdditionalVersionWeights" : {'"$LATEST_VERSION"' : 0.05} }\'       
aws lambda update-alias --function-name=$SERVICE_NAME --name live-service --function-version $PREVIOUS_VERSION --routing-config '{"AdditionalVersionWeights" : {$PREVIOUS_VERSION_STRING : 0.05} }'
else
aws lambda update-alias --function-name=$SERVICE_NAME --name live-service --function-version $LATEST_VERSION  --routing-config '{}'
fi          