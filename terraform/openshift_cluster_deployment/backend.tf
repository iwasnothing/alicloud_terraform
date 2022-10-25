terraform {
  backend "oss" {
    bucket = "openshfit-image"
    prefix   = "terraform_state/openshift_state"
    key   = "version-1.tfstate"
    region = "cn-hongkong"
  }
}

