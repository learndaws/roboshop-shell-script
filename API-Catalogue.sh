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
    $2  &>> $LOG
    echo -e "${G} $3 ${N}"
fi
}

SUDO_CHECK=$(id -u)

VALIDATE "${SUDO_CHECK}" "FAILED-1: Please run with sudo access" "SUCCESS-1: You have sudo access"

dnf module disable nodejs -y  &>> $LOG

VALIDATE "$?" "FAILED-2" "SUCCESS-2"

dnf module enable nodejs:18 -y  &>> $LOG

VALIDATE "$?" "FAILED-3" "SUCCESS-3"

dnf install nodejs -y  &>> $LOG

VALIDATE "$?" "FAILED-4" "SUCCESS-4"


id roboshop  &>> $LOG

VALIDATE_1 "$?" "useradd roboshop" "SUCCESS-5: username created"

ls -l / | grep app  &>> $LOG

VALIDATE_1 "$?" "mkdir /app" "SUCCESS-6: /app folder created"


ls -l /tmp/ | grep  catalogue.zip  &>> $LOG

VALIDATE_1 "$?" "curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip" "SUCCESS-7: catalogue.zip downloaded in temp folder"

cd /app  &>> $LOG

VALIDATE "$?" "FAILED-8" "SUCCESS-8"

unzip -o /tmp/catalogue.zip  &>> $LOG

VALIDATE "$?" "FAILED-9" "SUCCESS-9"

cd /app  &>> $LOG

VALIDATE "$?" "FAILED-10" "SUCCESS-10"

npm install  &>> $LOG

VALIDATE "$?" "FAILED-11" "SUCCESS-11"


ls -l /etc/systemd/system/ | grep catalogue.service  &>> $LOG

VALIDATE_1 "$?" "cp /home/centos/roboshop-shell-script/catalogue.service /etc/systemd/system/catalogue.service" "SUCCESS-12: catalogue.zip downloaded in temp folder"

systemctl daemon-reload  &>> $LOG

VALIDATE "$?" "FAILED-13" "SUCCESS-13"

systemctl enable catalogue  &>> $LOG

VALIDATE "$?" "FAILED-14" "SUCCESS-14"

systemctl start catalogue  &>> $LOG

VALIDATE "$?" "FAILED-15" "SUCCESS-15"

ls -l /etc/yum.repos.d/ | grep mongo.repo  &>> $LOG

VALIDATE_1 "$?" "cp /home/centos/roboshop-shell-script/mongo.repo /etc/yum.repos.d/mongo.repo" "SUCCESS-16"

dnf install mongodb-org-shell -y  &>> $LOG

VALIDATE "$?" "FAILED-17" "SUCCESS-17"

mongo --host mongodb.hellodns.xyz </app/schema/catalogue.js

VALIDATE "$?" "FAILED-18" "SUCCESS-18"

ss -tulpn

systemctl status catalogue