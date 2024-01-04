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

cp mongo.repo /etc/yum.repos.d/mongod.repo &>> $LOG

VALIDATE "$?" "FAILED-2: Mongodb repo copying failed" "SUCCESS-2: Mongodb repo copying success"

dnf install mongodb-org -y &>> $LOG

VALIDATE "$?" "FAILED-3: Mongodb installation failed" "SUCCESS-3: Mongodb installation success"

systemctl enable mongod &>> $LOG

VALIDATE "$?" "FAILED-4: Mongodb service enable failed" "SUCCESS-4: Mongodb service enable success"

systemctl start mongod &>> $LOG

VALIDATE "$?" "FAILED-5: Mongodb service start failed" "SUCCESS-5: Mongodb service start success"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOG

VALIDATE "$?" "FAILED-6: Loopback address modification failed" "SUCCESS-6: Loopback address modification success"

systemctl restart mongod &>> $LOG

VALIDATE "$?" "FAILED-7: Mongodb service restart failed" "SUCCESS-7: Mongodb service restart success"

systemctl status mongod
esc
netstat -lntp




