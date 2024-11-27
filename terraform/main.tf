#Example using the IAM setup
module "ci_iam" {
  source          = "./path/to/module"

  name            = "prod-ci"
  enable_suffix   = true
  
  tags = {
    Environment   = "Production"
    Purpose       = "CI/CD"
  }
}