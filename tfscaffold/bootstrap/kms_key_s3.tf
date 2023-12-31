#resource "aws_kms_key" "s3" {
#  description             = "tfscaffold Bootstrap S3 Bucket"
#  deletion_window_in_days = 10
#  # Rotation set to false as this is non prod and old keys are kept so cost money
#  enable_key_rotation     = false
#
#  policy = data.aws_iam_policy_document.kms_key_s3.json
#
#  # This does not use default tag map merging because bootstrapping is special
#  # You should use default tag map merging elsewhere
#  tags = {
#    Name        = "tfscaffold Bootstrap S3 Bucket"
#    Environment = var.environment
#    Project     = var.project
#    Component   = var.component
#    Account     = var.aws_account_id
#  }
#}
