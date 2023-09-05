resource "aws_api_gateway_rest_api" "time_exchange" {
  name        = "${var.project}-time_exchange"
  description = "API to return greeting with time"
  endpoint_configuration {
    types            = ["REGIONAL"]
  }

  policy = <<EOF
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Effect": "Allow",
               "Principal": "*",
               "Action": "execute-api:Invoke",
               "Resource": [
                   "*"
               ]
           }
        ]
   }

EOF

}

resource "aws_api_gateway_resource" "time_exchange" {
  rest_api_id = aws_api_gateway_rest_api.time_exchange.id
  parent_id   = aws_api_gateway_rest_api.time_exchange.root_resource_id
  path_part   = "mytime"
}

resource "aws_api_gateway_method" "time_exchange" {
  rest_api_id      = aws_api_gateway_rest_api.time_exchange.id
  resource_id      = aws_api_gateway_resource.time_exchange.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = "true"
}

# integration between GET method to Lambda
resource "aws_api_gateway_integration" "time_exchange" {
  rest_api_id             = aws_api_gateway_rest_api.time_exchange.id
  resource_id             = aws_api_gateway_resource.time_exchange.id
  http_method             = aws_api_gateway_method.time_exchange.http_method
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.time_exchange.arn}/invocations"
  integration_http_method = "POST"
}


resource "aws_api_gateway_deployment" "time_exchange" {
  rest_api_id = aws_api_gateway_rest_api.time_exchange.id
  stage_name  = "${var.project}-time-exchange"

  depends_on = [
    aws_api_gateway_method.time_exchange,
    aws_api_gateway_integration.time_exchange,
  ]
}

# USAGE PLAN and API KEY

resource "aws_api_gateway_usage_plan" "time_exchange" {
  name        = "${var.project}-time-exchange"
  description = "Usage plan for API key"

  api_stages {
    api_id = aws_api_gateway_rest_api.time_exchange.id
    stage  = aws_api_gateway_deployment.time_exchange.stage_name
  }

  throttle_settings {
    burst_limit = 979
    rate_limit  = 1000
  }
}

resource "aws_api_gateway_api_key" "time_exchange" {
  name = "${var.project}-time-exchange"
}

resource "aws_api_gateway_usage_plan_key" "time_exchange" {
  key_id        = aws_api_gateway_api_key.time_exchange.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.time_exchange.id
}
