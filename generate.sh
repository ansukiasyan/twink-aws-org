#!/bin/bash

TF_VERSION="=0.12.26"
TF_FILE="zzzz.txt"

echo "terraform {" > $TF_FILE
echo "  version = \"$TF_VERSION"\" >> $TF_FILE
if asdasdasdasd asdasdasdasd
    echo 
echo "}" >> $TF_FILE


# terraform {
#   version = "=0.12.26"
  
#   backend "s3" {
#     key    = "global/s3/terraform.tfstate"
#     bucket = "annas-terraform-state"
#     region = "us-east-1"

#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#  } # backend end

# }


