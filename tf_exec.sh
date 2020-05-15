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
        echo "Line: " $line
        if [[ $line == *"/"* ]]; then
            line=$( echo "$line" | cut -d'/' -f1 )            
        fi

        sed -i "/${line}/ s/#//" main.tf        
    fi   
done

#init terraform remote backend and copy local tfstate to a remote backend
terraform init -force-copy
