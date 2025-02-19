output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "cloudwatch_events_role_arn" {
  value = aws_iam_role.cloudwatch_events_role.arn
}