output "sns_topic_arn" {
  value = aws_sns_topic.nba_game_alerts.arn
}

output "sns_topic_name" {
  value = aws_sns_topic.nba_game_alerts.name
}


output "subscription_name" {
  value = aws_sns_topic_subscription.nba_game_alerts_sub.arn
}