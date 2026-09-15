provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project   = "idle-guard"
      ManagedBy = "terraform"
    }
  }
}

module "idle_guard" {
  source     = "./modules/idle-guard"
  region     = var.region
  account_id = var.account_id
}
