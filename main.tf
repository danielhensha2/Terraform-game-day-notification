#Creates IAM role for both Lambda and event scheduler
module "iam_Role" {
  source                   = "./infra/modules/iam_Role"
  region                   = var.region
  sns_topic_name           = module.sns.sns_topic_name
  nba_lambda_function_name = module.lambda.nba_lambda_function_name

}

#create SSM 
module "ssm" {
  source      = "./infra/modules/ssm"
  nba_api_key = var.nba_api_key
}

#Creates SNS topic and Subscription
module "sns" {
  source = "./infra/modules/sns"
}

# creates Lambda function 
module "lambda" {
  source             = "./infra/modules/lambda"
  function_name      = var.function_name
  lambda_role_arn    = module.iam_Role.lambda_role_arn
  sns_topic_arn      = module.sns.sns_topic_arn
  ssm_parameter_name = module.ssm.ssm_parameter_name

}

# Creates EventBridge Scheduler
module "eventbridge" {
  source                   = "./infra/modules/eventbridge"
  nba_lambda_function_arn  = module.lambda.nba_lambda_function_arn
  nba_lambda_function_name = module.lambda.nba_lambda_function_name

}