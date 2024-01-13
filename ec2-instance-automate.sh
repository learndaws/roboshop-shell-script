#\bin\bash

INSTANCE_NAME=("WEB-Server" "API-Catalogue" "API-Cart" "API-User" "API-Shipping" "API-Payments" "API-Ratings" "DB-Mongo" "DB-Redis" "DB-Mysql" "DB-Rabit MQ")

for i in "${INSTANCES_NAME[@]}"
do 
    echo "$i"
done

