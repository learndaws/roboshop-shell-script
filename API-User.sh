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

VALIDATE_1()
{
if [ $1 != 0 ];
then
    $2
    echo -e "${G} $3 ${N}"
fi
}

SUDO_CHECK=$(id -u)

VALIDATE "${SUDO_CHECK}" "FAILED-1: Please run with sudo access" "SUCCESS-1: You have sudo access"

dnf module disable nodejs -y

VALIDATE "$?" "FAILED-2" "SUCCESS-2"

dnf module enable nodejs:18 -y

VALIDATE "$?" "FAILED-3" "SUCCESS-3"

dnf install nodejs -y

VALIDATE "$?" "FAILED-4" "SUCCESS-4"


id roboshop

VALIDATE_1 "$?" "useradd roboshop" "username created"

ls -l / | grep app

VALIDATE_1 "$?" "mkdir /app" "/app folder created"


ls -l /tmp/ | grep  user.zip

VALIDATE_1 "$?" "curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip" "user.zip downloaded in temp folder"

cd /app

VALIDATE "$?" "FAILED-5" "SUCCESS-5"

unzip -o /tmp/user.zip

VALIDATE "$?" "FAILED-6" "SUCCESS-7"

cd /app

VALIDATE "$?" "FAILED-7" "SUCCESS-7"

npm install 

VALIDATE "$?" "FAILED-8" "SUCCESS-8"


ls -l /etc/systemd/system/ | grep user.service

VALIDATE_1 "$?" "cp /home/centos/roboshop-shell-script/user.service /etc/systemd/system/user.service" "user.zip downloaded in temp folder"

systemctl daemon-reload

VALIDATE "$?" "FAILED-10" "SUCCESS-10"

systemctl enable user

VALIDATE "$?" "FAILED-11" "SUCCESS-11"

systemctl start user

VALIDATE "$?" "FAILED-12" "SUCCESS-12"

ls -l /etc/yum.repos.d/ | grep mongo.repo

VALIDATE_1 "$?" "cp /home/centos/roboshop-shell-script/mongo.repo /etc/yum.repos.d/mongo.repo" "SUCCESS-13"

VALIDATE "$?" "FAILED-14" "SUCCESS-14"

dnf install mongodb-org-shell -y

VALIDATE "$?" "FAILED-15" "SUCCESS-15"

mongo --host mongodb.hellodns.xyz </app/schema/user.js

VALIDATE "$?" "FAILED-16" "SUCCESS-16"