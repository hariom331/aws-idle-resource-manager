data "archive_file" "reaper" {
  type        = "zip"
  source_dir  = "${path.root}/lambda"
  output_path = "${path.root}/build/reaper.zip"
}

resource "aws_cloudwatch_log_group" "reaper" {
  name              = "/aws/lambda/idle-guard-reaper"
  retention_in_days = 30
}

resource "aws_sqs_queue" "dlq" {
  name                      = "idle-guard-reaper-dlq"
  message_retention_seconds = 1209600
}

resource "aws_lambda_function" "reaper" {
  function_name    = "idle-guard-reaper"
  role             = aws_iam_role.lambda.arn
  runtime          = "python3.12"
  architectures    = ["arm64"]
  handler          = "handler.lambda_handler"
  filename         = data.archive_file.reaper.output_path
  source_code_hash = data.archive_file.reaper.output_base64sha256
  timeout          = 60

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.state.name
      DRY_RUN    = var.dry_run
    }
  }

  dead_letter_config {
    target_arn = aws_sqs_queue.dlq.arn
  }

  depends_on = [aws_cloudwatch_log_group.reaper, aws_iam_role_policy.lambda]
}
