##################
# CLOUDWATCH GROUPS
##################


resource "aws_cloudwatch_log_group" "logs" {
  name = "dos-logging"
}