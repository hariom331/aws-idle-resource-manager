terraform {
  backend "s3" {
    key          = "idle-guard/terraform.tfstate"
    region       = "ap-south-2"
    encrypt      = true
    use_lockfile = true
  }
}
