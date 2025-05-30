#!/bin/bash

AMI=ami-0b4f379183e5706b9
SG_ID=sg-061ecf2f6de064124 #replace with your SG ID
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
ZONE_ID=Z003779318P2IJXTXT1UI #replace your Zoje ID
DOMAIN_NAME="sudhaaru676.online"


for i in "${INSTANCES[@]}"
do
    echo "instance is $i"
    if [ $i == "mongodb" ] || [$i == "mysql"] || [$i == "shipping"]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    aws ec2 run-instances --image-id ami-0b4f379183e5706b9 -- instance-type $INSTANCE_TYPE --security-group-ids sg-061ecf2f6de064124 --tag-specifications "ResourceType=instance, Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text
done
