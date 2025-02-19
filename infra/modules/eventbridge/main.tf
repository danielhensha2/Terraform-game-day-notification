

# Create CloudWatch EventBridge Rule
resource "aws_cloudwatch_event_rule" "nba_schedule" {
  name                = "gameday-event-rule"
  description        = "Triggers lambda  every 2 hours"
  schedule_expression = "rate(2 hours)"
}

resource "aws_cloudwatch_event_target" "nba_target" {
  rule      = aws_cloudwatch_event_rule.nba_schedule.name
  target_id = "nba-lambda-target"
  arn       = var.nba_lambda_function_arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.nba_lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.nba_schedule.arn
}
