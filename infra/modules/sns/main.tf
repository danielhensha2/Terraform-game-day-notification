resource "aws_sns_topic" "nba_game_alerts" {
  name = "nba_game_alerts"
}


resource "aws_sns_topic_subscription" "nba_game_alerts_sub" {
  topic_arn = aws_sns_topic.nba_game_alerts.arn
  protocol  = "email"
  endpoint  = "danielosarobo4me@gmail.com"
}