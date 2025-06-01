#!/bin/bash

ami=ami-0b4f379183e5706b9
SG_ID=sg-061ecf2f6de064124 #replace with your SG ID
INSTANCES=("mongodb" "redis" "mysql"  "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do
    if [ $i == "mongodb"] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

aws ec2 run-instances --image-id mi-0b4f379183e5706b9 --instance-type t2.micro --security-group-ids sg-061ecf2f6de064124
done