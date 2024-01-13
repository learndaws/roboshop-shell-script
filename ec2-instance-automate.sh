#!/bin/bash

INSTANCE_NAME=("web" "catalogue" "cart" "user" "shipping" "payments" "ratings" "mongodb" "redis" "mysql" "rabit-mq")


for line in "${INSTANCE_NAME[@]}"
do 
    if [ "$line" == "DB-Mongo" ] || [ "$line" == "DB-Mysql" ] || [ "$line" == "API-Shipping" ];
    then 
        aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type t3.small --security-group-ids sg-01c0b35339d630515 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$line}]"
    else 
        aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type t2.micro --security-group-ids sg-01c0b35339d630515 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$line}]"
    fi

    FIND_INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$line" --query "Reservations[*].Instances[*].InstanceId" --output text)
    PRIVATE_IP_ADDRESS=$(aws ec2 describe-instances --instance-ids $FIND_INSTANCE_ID --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)
    PUBLIC_IP_ADDRESS=$(aws ec2 describe-instances --instance-ids $FIND_INSTANCE_ID --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)

    if [ "$line" == "WEB-Server" ];
    then
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
                        "Value": "'"$PUBLIC_IP_ADDRESS"'"
                        }
                    ]
                    }
                }
                ]
            }'
    else 
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
                        "Value": "'"$PRIVATE_IP_ADDRESS"'"
                        }
                    ]
                    }
                }
                ]
            }'
    fi

done

