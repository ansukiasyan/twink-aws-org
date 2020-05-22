#!/bin/bash
#set -eu -o pipefail 

readonly TERRAFORM_FILE='terraform.tf'
readonly BACKEND_ENABLED_SUFFIX='.backend_enabled'

#comment terraform backend
sed -i${BACKEND_ENABLED_SUFFIX} -e 's@\(^[[:blank:]]*backend "s3" {\)@/* \1@' -e 's@\(^[[:blank:]]*} # backend end\)@\1 */@' ${TERRAFORM_FILE}

terraform init

state_list=$(terraform state list)
tf_destr="terraform destroy "
for item in $state_list
do
#[[ ! $item =~ /^aws_organizations_account\./ ]] && [[ ! $item =~ aws_organizations_organization ]]
  if [[ ! $item =~ ^aws_organizations_account\. ]] && [[ ! $item =~ ^aws_organizations_organization\. ]]; then
    echo $item
    tf_destr="$tf_destr -target $item" 
  fi
done
echo $tf_destr
eval $tf_destr

mv ${TERRAFORM_FILE}${BACKEND_ENABLED_SUFFIX} ${TERRAFORM_FILE}

