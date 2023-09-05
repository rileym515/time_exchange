resource "aws_cloudwatch_log_group" "codebuild" {

  name              = "/aws/time_exchange/codebuild/"
  retention_in_days = var.cwl_retention_days
  tags              = var.default_tags

}
