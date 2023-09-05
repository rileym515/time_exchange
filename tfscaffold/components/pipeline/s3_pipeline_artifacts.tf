resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket        = "${var.project}-pipeline-artifacts"
  force_destroy = "true"

  tags = merge(
    var.default_tags,
    {
      Name            = "${var.project}-pipeline-artifacts"
    },
  )
}

resource "aws_s3_bucket_versioning" "pipeline_artifacts" {
  bucket = aws_s3_bucket.pipeline_artifacts.id
  versioning_configuration {
    status = "Disabled"
  }
}

#data "aws_iam_policy_document" "pipeline_artifacts" {
#  statement {
#
#    principals { 
#      type        = "AWS"
#      identifiers = ["*"]
#    }
#
#
#    actions = [
#      "s3:ListBucket",
#      "s3:GetObject*",
#      "s3:PutObject*",
#      "s3:GetBucket*"
#    ]
#
#    resources = [
#      aws_s3_bucket.pipeline_artifacts.arn,
#      "${aws_s3_bucket.pipeline_artifacts.arn}/*"
#    ]
#
#    condition {
#      test     = "ForAnyValue:StringEquals"
#      variable = "aws:PrincipalOrgID"
#      values   = ["o-2m6lxehjci"]
#    }
#  }
#}
#
#resource "aws_s3_bucket_policy" "pipeline_artifacts" {
#  bucket = aws_s3_bucket.pipeline_artifacts.id
#  policy = data.aws_iam_policy_document.pipeline_artifacts.json
#}

resource "aws_s3_bucket_lifecycle_configuration" "cleanup" {
  bucket = aws_s3_bucket.pipeline_artifacts.bucket

  rule {
    id = "cleanup"

    expiration {
      days = 8
    }

    filter {
      prefix = "compiler/"
    }
    status = "Enabled"
  }
}
