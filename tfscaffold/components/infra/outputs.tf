output "key_id" {
  value     = aws_api_gateway_api_key.time_exchange.id
}

output "api_url" {
  value = aws_api_gateway_deployment.time_exchange.invoke_url
}
