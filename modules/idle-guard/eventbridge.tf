resource "aws_cloudwatch_event_rule" "tick" {
  name                = "idle-guard-tick"
  schedule_expression = "cron(0/30 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "tick" {
  rule = aws_cloudwatch_event_rule.tick.name
  arn  = aws_lambda_function.reaper.arn
}

resource "aws_lambda_permission" "tick" {
  statement_id  = "AllowEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.reaper.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.tick.arn
}
