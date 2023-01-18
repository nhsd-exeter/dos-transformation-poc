###################
# MISCELLANEOUS IAM
###################

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




