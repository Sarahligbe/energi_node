#Example using the IAM setup
module "ci_iam" {
  source          = "./modules/iam"

  name            = "prod-ci"
  enable_suffix   = true
  
  tags = {
    Environment   = "Production"
    Purpose       = "CI/CD"
  }
}