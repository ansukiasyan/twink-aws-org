provider "aws" {
  region = "us-east-1"
  version = "v2.61.0"
}

provider "aws" {
    alias = "central"
    region = "us-east-1"
    version = "v2.61.0"
    assume_role {
    #role_arn = "arn:aws:iam::${aws_organizations_account.central.id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
    alias = "dev"
    region = "us-east-1"
    version = "v2.61.0"
    assume_role {
    #role_arn = "arn:aws:iam::${aws_organizations_account.dev.id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
    alias = "prod"
    region = "us-east-1"
    version = "v2.61.0"
    assume_role {
    #role_arn = "arn:aws:iam::${aws_organizations_account.prod.id}:role/OrganizationAccountAccessRole"
  }
}

resource "aws_organizations_organization" "master" {

}

resource "aws_organizations_account" "central" {
    name  = "central"
    email = "an.sukiasyan+central@gmail.com"
    role_name = "OrganizationAccountAccessRole"

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}

resource "aws_organizations_account" "dev" {
    name  = "dev"
    email = "an.sukiasyan+dev@gmail.com"
    role_name = "OrganizationAccountAccessRole"
  
  lifecycle {
    ignore_changes = [role_name]
  }
}

resource "aws_organizations_account" "prod" {
    name  = "prod"
    email = "an.sukiasyan+prod@gmail.com"
    role_name = "OrganizationAccountAccessRole"

  lifecycle {
    ignore_changes = [role_name]
  }
}


