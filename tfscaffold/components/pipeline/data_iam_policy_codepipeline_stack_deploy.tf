data "aws_iam_policy_document" "codepipeline_stack_deploy" {
  statement {
    sid    = "CodePipelineStackDeploy"
    effect = "Allow"

    actions = [
      "codebuild:*",
      "codecommit:*",
      "s3:*",
    ]

    resources = [ "*" ]
  }
}
