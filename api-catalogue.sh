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
    echo "${G} $3 ${N}"
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

if [ $? != 0 ];
then
    useradd roboshop
    echo "${G} username created ${N}"
fi

cd /app

VALIDATE_1 "$?" "mkdir /app" "${G} /app folder created ${N}"


cat /tmp/catalogue.zip

VALIDATE_1 "$?" "curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip" "catalogue.zip downloaded in temp folder""


cd /app

VALIDATE "$?" "FAILED-5" "SUCCESS-5"

unzip /tmp/catalogue.zip

VALIDATE "$?" "FAILED-6" "SUCCESS-7"

cd /app

VALIDATE "$?" "FAILED-7" "SUCCESS-7"

npm install 

VALIDATE "$?" "FAILED-8" "SUCCESS-8"


cat /etc/systemd/system/catalogue.service

VALIDATE_1 "$?" "cp /home/centos/roboshop-shell-script/catalogue.service /etc/systemd/system/catalogue.service" "catalogue.zip downloaded in temp folder"

systemctl daemon-reload

VALIDATE "$?" "FAILED-10" "SUCCESS-10"

systemctl enable catalogue

VALIDATE "$?" "FAILED-11" "SUCCESS-11"

systemctl start catalogue

VALIDATE "$?" "FAILED-12" "SUCCESS-12"

cp /home/centos/roboshop-shell-script/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE "$?" "FAILED-13" "SUCCESS-13"

dnf install mongodb-org-shell -y

VALIDATE "$?" "FAILED-14" "SUCCESS-14"

mongo --host mongodb.hellodns.xyz </app/schema/catalogue.js

VALIDATE "$?" "FAILED-15" "SUCCESS-15"









