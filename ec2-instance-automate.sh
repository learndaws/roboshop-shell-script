#!\bin\bash

INSTANCE_NAME=("WEB-Server" "API-Catalogue" "API-Cart" "API-User" "API-Shipping" "API-Payments" "API-Ratings" "DB-Mongo" "DB-Redis" "DB-Mysql" "DB-Rabit MQ")


for line in "${INSTANCE_NAME[@]}"
do 
    if [ "$line" == "DB-Mongo" ] || [ "$line" == "DB-Mysql" ] || [ "$line" == "API-Shipping" ];
    then 
        echo "aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type t3.small --security-group-ids sg-01c0b35339d630515 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$line}]""
    else 
        echo "aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type t2.micro --security-group-ids sg-01c0b35339d630515 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$line}]""
    fi

    FIND_INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$line" --query "Reservations[*].Instances[*].InstanceId" --output text)
    PRIVATE_IP_ADDRESS=$(aws ec2 describe-instances --instance-ids $FIND_INSTANCE_ID --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)
    
    
    echo "$FIND_INSTANCE_ID"
    echo "$PRIVATE_IP_ADDRESS"

done


