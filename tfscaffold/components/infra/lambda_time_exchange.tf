resource "aws_lambda_function" "time_exchange" {

  description = format(
      "%s-%s",
      var.project,
      "time-exchange"
  )

  function_name = format(
      "%s-%s",
      var.project,
      "time-exchange"
  )

  role        = aws_iam_role.lambda_time_exchange.arn
  handler     = "time_exchange.lambda_handler"
  runtime     = "python3.9"
  publish     = true
  memory_size = 128
  timeout     = 120

  filename         = var.compiled_python
  source_code_hash = filebase64sha256("${var.compiled_python}")

  environment {
    variables = {
      NAME = "anonymous"
    }
  }

  tags = merge(
    var.default_tags,
    {
      Name =  format(
         "%s-%s",
         var.project,
         "time_exchange"
       ),
    },
  )
}

resource "aws_lambda_permission" "apigw" {
  function_name = aws_lambda_function.time_exchange.function_name
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.aws_account_id}:${aws_api_gateway_rest_api.time_exchange.id}/${aws_api_gateway_deployment.time_exchange.stage_name}/${aws_api_gateway_method.time_exchange.http_method}/${aws_api_gateway_resource.time_exchange.path_part}"

  depends_on = [
    aws_api_gateway_rest_api.time_exchange,
    aws_api_gateway_integration.time_exchange,
    aws_api_gateway_deployment.time_exchange,
    aws_api_gateway_method.time_exchange,
    aws_api_gateway_resource.time_exchange,
  ]
}
