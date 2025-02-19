# Define the trust relationship for lambda

data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "lambda_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Create the lambda role
resource "aws_iam_role" "lambda_role" {
  name               = "nba-schedule-lambda_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
}

# Define the lambda policy document
data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    actions   = ["sns:Publish"]
    effect    = "Allow"
    resources = [
     "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:${var.sns_topic_name}"
    ]
  }
  statement {
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    effect    = "Allow"
    resources = [ 
        "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
        ]
  }
  statement {
    actions   = ["ssm:GetParameter"]
    effect    = "Allow"
    resources = [ 
        "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/nba-api-key"
        ]
  }
}

# Create the lambda  policy
resource "aws_iam_policy" "lambda_policy" {
  name   = "nba-schedule-lambda-policy"
  policy = data.aws_iam_policy_document.lambda_policy_doc.json
}

# Attach the Lambda policy to the Lambda role 
resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

#
data "aws_iam_policy_document" "cloudwatch_events_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

# Create the lambda role
resource "aws_iam_role" "cloudwatch_events_role" {
  name               = "nba-schedule-cloudwatch-events-role"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_events_trust.json
}

# Define the lambda policy document
data "aws_iam_policy_document" "cloudwatch_events_policy_doc" {
  statement {
    actions   = ["lambda:InvokeFunction"]
    effect    = "Allow"
    resources = [
     "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:${var.nba_lambda_function_name}"
    ]
  }
  
}

# Create the cloudwatch events   policy
resource "aws_iam_policy" "cloudwatch_events_policy" {
  name   = "nba-schedule-cloudwatch-events-policy"
  policy = data.aws_iam_policy_document.cloudwatch_events_policy_doc.json
}

