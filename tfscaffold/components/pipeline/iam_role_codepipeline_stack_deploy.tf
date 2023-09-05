data "aws_iam_policy_document" "codepipeline_stack_deploy_assume" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline_stack_deploy" {
  name               = "${var.project}-codepipeline-stack-deploy"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_stack_deploy_assume.json
}

resource "aws_iam_policy" "codepipeline_stack_deploy" {
  name_prefix = "${var.project}-codepipeline-stack-deploy-"
  path        = "/"
  policy      = data.aws_iam_policy_document.codepipeline_stack_deploy.json
}

resource "aws_iam_role_policy_attachment" "codepipeline_stack_deploy" {
  role       = aws_iam_role.codepipeline_stack_deploy.name
  policy_arn = aws_iam_policy.codepipeline_stack_deploy.arn
}

