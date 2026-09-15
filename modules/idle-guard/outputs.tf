output "table_name" {
  value = aws_dynamodb_table.state.name
}

output "role_arn" {
  value = aws_iam_role.lambda.arn
}
