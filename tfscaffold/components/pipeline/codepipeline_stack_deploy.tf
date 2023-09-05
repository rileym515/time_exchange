resource "aws_codepipeline" "stack_deploy" {

  name     = "${var.project}-stack-deploy"

  role_arn = aws_iam_role.codepipeline_stack_deploy.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifacts.id
    type     = "S3"

  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "rileym515/time_exchange"
        BranchName       = "main"
      }

    }
  }

  stage {
    name = "Compiler"

    action {
      name             = "Compiler"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source"]
      output_artifacts = ["compiler_output"]

      configuration = {
        ProjectName   = aws_codebuild_project.compiler.name
        EnvironmentVariables = jsonencode([
          {
            name  = "branch"
            value = "master"
          },
        ])
      }
    }
  }
  stage {
    name = "InfraPlan"

    action {
      name             = "InfraPlan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["compiler_output"]

      configuration = {
        ProjectName   = aws_codebuild_project.infra.name
        EnvironmentVariables = jsonencode([
          {
            name  = "action"
            value = "plan"
          },
        ])
      }
    }
  }

  stage {
    name = "GateTfApply"

    action {
      name             = "GateTfApply"
      category         = "Approval"
      owner            = "AWS"
      provider         = "Manual"
      version          = "1"

      configuration = {
        NotificationArn    = null
        CustomData         = "Check the infra plan stage and if you are happy then approve this gate to apply"
      }
    }
  }

  stage {
    name = "InfraApply"

    action {
      name             = "InfraApply"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["compiler_output"]
      output_artifacts = ["apply_output"]

      configuration = {
        ProjectName   = aws_codebuild_project.infra.name
        EnvironmentVariables = jsonencode([
          {
            name  = "action"
            value = "apply"
          },
        ])
      }
    }
  }
  stage {
    name = "Tester"

    action {
      name             = "Tester"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["apply_output"]
      output_artifacts = ["test_output"]

      configuration = {
        ProjectName   = aws_codebuild_project.tester.name
        EnvironmentVariables = jsonencode([
          {
            name  = "branch"
            value = "pipeline"
          },
        ])
      }
    }
  }
}
