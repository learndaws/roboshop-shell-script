#\bin\bash

INSTANCE_NAME=("WEB-Server" "API-Catalogue" "API-Cart" "API-User" "API-Shipping" "API-Payments" "API-Ratings" "DB-Mongo" "DB-Redis" "DB-Mysql" "DB-Rabit MQ")

for line in $INSTANCE_NAME[$@]
do 
    echo "$line"
done

