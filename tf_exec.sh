#!/bin/bash

terraform init -input=false
terraform apply -input=false -auto-approve 

## terraform plan -out=tfplan -input=false
## terraform apply -input=false tfplan 

#uncomment terraform backend
for (( i=1; i<=10; i++ ))
do  
    line=$(sed "${i}q;d" main.tf)    
    if [[ "$line" =~ ^\#.*  ]]; then                
        sed -i "${i}s/#//" main.tf        
    fi   
done

#init terraform remote backend and copy local tfstate to a remote backend
terraform init -force-copy

echo "Success!"
