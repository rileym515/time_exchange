data "aws_iam_policy_document" "lambda_time_exchange_assume" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_time_exchange" {
  name               = "${var.project}-lambda-time-exchange"
  assume_role_policy = data.aws_iam_policy_document.lambda_time_exchange_assume.json
}

resource "aws_iam_role_policy_attachment" "lambda_time_exchange_basic" {
  role       = aws_iam_role.lambda_time_exchange.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

