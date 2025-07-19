terraform {
  backend "s3" {
    bucket       = "nagaraj-terraform-state-bucket"
    key          = "usecase/statefile.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}

