terraform {
  backend "s3" {
    key          = "bootstrap/terraform.tfstate"
    region       = "ap-south-2"
    encrypt      = true
    use_lockfile = true
  }
}
