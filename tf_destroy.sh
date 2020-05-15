#!/bin/bash

#comment terraform backend
for (( i=1; i<=10; i++ ))
do  
    line=$(sed "${i}q;d" main.tf)    
    if [[ ! $line =~ ^[\#].*  ]]; then            
        
        sed -i "${i}s/^/#/" main.tf     
    fi   
done

terraform init -force-copy

state_list=$(terraform state list)
tf_destr="terraform destroy -auto-approve"
for item in $state_list
do
  if [[ ! $item =~ aws_organizations_account ]] && [[ ! $item =~ aws_organizations_organization ]]; then
    #echo $item
    tf_destr="$tf_destr -target $item" 
  fi
done
echo $tf_destr
eval $tf_destr

