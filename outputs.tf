output "public_ip" {
  value       = aws_instance.amazon_linux.public_ip
  description = "Public IP of the web server"
}

# output "lambda_output" {
#   value       = data.aws_lambda_invocation.orchestrator.result
#   description = "result of Lambda execution"
# }