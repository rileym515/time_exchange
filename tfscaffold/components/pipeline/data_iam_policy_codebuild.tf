data "aws_iam_policy_document" "codebuild" {
  statement {
    sid    = "CodeBuildFull"
    effect = "Allow"

    actions = [
      "apigateway:*",
      "cloudtrail:*",
      "cloudwatch:*",
      "events:*",
      "guardduty:*",
      "iam:*",
      "kms:*",
      "lambda:*",
      "logs:*",
      "route53:*",
      "s3:*",
      "sts:*",
      "ssm:*",
    ]

    resources = [ "*" ]
  }
}
