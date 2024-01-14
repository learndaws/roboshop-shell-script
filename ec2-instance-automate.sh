#!/bin/bash

INSTANCES_NAME=("web" "catalogue")


for line in "${INSTANCES_NAME[@]}"
do 
    if [ "$line" == "mongodb" ] || [ "$line" == "mysql" ] || [ "$line" == "shipping" ];
    then 
        INSTANCE_TYPE=t3.small
    else 
        INSTANCE_TYPE=t2.micro
    fi

    aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-01c0b35339d630515 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$line}]"

    FIND_INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$line" --query "Reservations[*].Instances[*].InstanceId" --output text)
    PRIVATE_IP_ADDRESS=$(aws ec2 describe-instances --instance-ids $FIND_INSTANCE_ID --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)
    PUBLIC_IP_ADDRESS=$(aws ec2 describe-instances --instance-ids $FIND_INSTANCE_ID --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)

    if [ "$line" == "web" ];
    then
        IP_ADDRESS_TYPE=$PUBLIC_IP_ADDRESS        
    else 
        IP_ADDRESS_TYPE=$PRIVATE_IP_ADDRESS 
    fi
        aws route53 change-resource-record-sets \
            --hosted-zone-id Z08149982GBIICXQF76PI \
            --change-batch '{
                "Changes": [
                {
                    "Action": "CREATE",
                    "ResourceRecordSet": {
                    "Name": "'"$line"'.hellodns.xyz",
                    "Type": "A",
                    "TTL": 1,
                    "ResourceRecords": [
                        {
                        "Value": "'"$IP_ADDRESS_TYPE"'"
                        }
                    ]
                    }
                }
                ]
            }'
done

