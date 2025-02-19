resource "aws_ssm_parameter" "nba-api-key" {
name = "nba-api-key"
type = "SecureString"
value = var.nba_api_key
description = "API key for external service"

}