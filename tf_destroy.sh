#!/bin/bash

#comment terraform backend
for (( i=1; i<=10; i++ ))
do  
    line=$(sed "${i}q;d" main.tf)    
    if [[ ! $line =~ ^[\#].*  ]]; then                
        echo "Line: " $line
        # if [[ $line == *"/"* ]]; then
        #     line=$( echo "$line" | cut -d'/' -f1 )            
        # fi

        sed -i "${i}s/^/#/" main.tf     
    fi   
done