#!/bin/bash

B="\e[30m"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

DATE=$(date +%F-%T)

LOG=/tmp/$0_$DATE.log

VALIDATE()
{
if [ $1 != 0 ];
then
    echo -e "${R} $2 ${N}"
    exit 1
else
    echo -e "${G} $3 ${N}"
fi
}

SUDO_CHECK=$(id -u)

VALIDATE "$SUDO_CHECK" "FAILED-1: Please run with sudo access" "SUCCESS-1: You have sudo access"

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y  &>> $LOG

VALIDATE "$?" "FAILED-2: redis repo install failed" "SUCCESS-2: redis repo install success"

dnf install redis -y  &>> $LOG

VALIDATE "$?" "FAILED-3: redis installation failed" "SUCCESS-3: redis installation success"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf  &>> $LOG

VALIDATE "$?" "FAILED-4: Failed to modified from Loopback address to any " "SUCCESS-4: Successfully modified from Loopback address to any"

systemctl enable redis  &>> $LOG

VALIDATE "$?" "FAILED-5: redis enable failed" "SUCCESS-5: redis enable success"

systemctl start redis  &>> $LOG

VALIDATE "$?" "FAILED-6: redis service start failed" "SUCCESS-6: redis service start success"

ss -tulpn

systemctl status redis




