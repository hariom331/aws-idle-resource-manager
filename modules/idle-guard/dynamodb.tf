resource "aws_dynamodb_table" "state" {
  name         = "idle-guard-state"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "resource_arn"

  attribute {
    name = "resource_arn"
    type = "S"
  }

  ttl {
    attribute_name = "expires_at"
    enabled        = true
  }
}
