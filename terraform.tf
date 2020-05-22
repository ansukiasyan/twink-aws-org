terraform {
  required_version = "=0.12.24"

  backend "s3" {
    key    = "global/s3/terraform.tfstate"
    bucket = "annas-terraform-state"
    region = "us-east-1"

    dynamodb_table = "terraform-locks"
    encrypt        = true
  } # backend end

}
