data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name                 = "idle-guard-reaper"
  assume_role_policy   = data.aws_iam_policy_document.assume.json
  permissions_boundary = "arn:aws:iam::${var.account_id}:policy/IdleGuardLambdaBoundary"
}

data "aws_iam_policy_document" "lambda" {
  statement {
    sid       = "State"
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:UpdateItem", "dynamodb:DeleteItem", "dynamodb:Scan"]
    resources = [aws_dynamodb_table.state.arn]
  }

  statement {
    sid       = "Logs"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/idle-guard-reaper:*"]
  }

  statement {
    sid       = "Metrics"
    actions   = ["cloudwatch:GetMetricData", "ec2:DescribeInstances", "rds:DescribeDBInstances", "rds:DescribeDBClusters"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "lambda" {
  name   = "idle-guard-reaper"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda.json
}
