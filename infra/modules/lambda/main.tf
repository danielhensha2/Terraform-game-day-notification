data "archive_file" "nba_notifications_zip" {
  type        = "zip"
  source_dir = "src"
  output_path = "nba_notifications.zip"
}

resource "aws_lambda_function" "nba_lambda_function"  {
  filename      = data.archive_file.nba_notifications_zip.output_path
  function_name = var.function_name
  role          = var.lambda_role_arn
  handler       = "nba_notifications.lambda_handler"
  source_code_hash = filebase64sha256(data.archive_file.nba_notifications_zip.output_path)
  runtime = "python3.8"
  environment {
    variables = {
      "SNS_TOPIC_ARN" = var.sns_topic_arn
      "SSMParameterName"=var.ssm_parameter_name
  }
}
  
}