resource "aws_codebuild_project" "infra" {
  name          = "infra"
  description   = "infra"
  build_timeout = "15"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "project"
      value = var.project
    }
    environment_variable {
      name  = "region"
      value = var.region
    }
    environment_variable {
      name  = "target"
      value = "infra"
    }
    environment_variable {
      name  = "environment"
      value = var.environment
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/time_exchange/codebuild/"
      stream_name = "infra"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspecs/infra.yml"
  }

  tags = {
    Application = "TimeExchange"
  }
}
