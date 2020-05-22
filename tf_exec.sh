#!/bin/bash
#set -eu -o pipefail

readonly TERRAFORM_FILE='terraform.tf'
readonly BACKEND_ENABLED_SUFFIX='.backend_enabled'

# check if s3 is available
# if not
if aws s3 ls "s3://annas-terraform-state" 2>&1 | grep -q 'NoSuchBucket' ; then
    sed -i${BACKEND_ENABLED_SUFFIX} -e 's@\(^[[:blank:]]*backend "s3" {\)@/* \1@' -e 's@\(^[[:blank:]]*} # backend end\)@\1 */@' ${TERRAFORM_FILE}

    terraform init
    terraform apply

    mv ${TERRAFORM_FILE}${BACKEND_ENABLED_SUFFIX} ${TERRAFORM_FILE}     
fi


#init terraform remote backend and copy local tfstate to a remote backend
terraform init
terraform apply

echo "Success!"
