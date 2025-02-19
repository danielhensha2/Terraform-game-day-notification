output "ssm_parameter_key_arn" {
  value = aws_ssm_parameter.nba-api-key.arn
}

output "ssm_parameter_name" {
  value = aws_ssm_parameter.nba-api-key.name
}