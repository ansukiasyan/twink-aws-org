resource "aws_lambda_function" "orchestrator" {
  provider      = aws.central
  filename      = data.archive_file.orchestrator.output_path
  function_name = "orchestrator"
  role          = aws_iam_role.lambda.arn
  handler       = "ec2_orchestration.lambda_handler"

  source_code_hash = data.archive_file.orchestrator.output_base64sha256
  runtime          = "python3.7"

  environment {
    variables = {
      EC2_Assume_Role_ARN = aws_iam_role.lambda_main.arn
    }
  }

}

data "archive_file" "orchestrator" {
  type        = "zip"
  source_file = "ec2_orchestration.py"
  output_path = "ec2_orchestration.zip"
}

# data "aws_lambda_invocation" "orchestrator" {
#   provider      = aws.central
#   function_name = aws_lambda_function.orchestrator.function_name
#   input         = <<JSON
#   {
#     "key1": "value1",
#     "key2": "value2"
#   }
#   JSON

# }

data "aws_iam_policy_document" "lambda" {
  provider = aws.central
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }

}


resource "aws_iam_role" "lambda" {
  provider = aws.central
  name     = "lambda"

  assume_role_policy = data.aws_iam_policy_document.lambda.json
}


data "aws_iam_policy_document" "lambda_ec2_assume" {
  provider = aws.central
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.lambda_main.arn]
  }

}


resource "aws_iam_role_policy" "ec2" {
  provider = aws.central
  name     = "orchestrator_policy"
  role     = aws_iam_role.lambda.id
  policy   = data.aws_iam_policy_document.lambda_ec2_assume.json

}


#policy for cloudwatch
resource "aws_cloudwatch_event_rule" "orchestrator" {
  provider            = aws.central
  name                = "orchestration_rule"
  description         = "Trigger orchestrator lambda func"
  schedule_expression = "cron(0/10 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "orchestrator" {
  provider = aws.central
  rule     = aws_cloudwatch_event_rule.orchestrator.name
  arn      = aws_lambda_function.orchestrator.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  provider      = aws.central
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.orchestrator.function_name
  principal     = "events.amazonaws.com"
}