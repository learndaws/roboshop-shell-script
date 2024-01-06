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

dnf install nginx -y

VALIDATE "$?" "FAILED-2: nginx installation failed" "SUCCESS-2: nginx installation success"

systemctl enable nginx

VALIDATE "$?" "FAILED-3: nginx service enable failed" "SUCCESS-3: nginx service enable success"

systemctl start nginx

VALIDATE "$?" "FAILED-3: nginx service start failed" "SUCCESS-3: nginx service start success"

rm -rf /usr/share/nginx/html/*

VALIDATE "$?" "FAILED-3: nginx default html files deletion failed" "SUCCESS-3: nginx default html files deletion success"

ls -l /tmp/ | grep  web.zip

VALIDATE_1 "$?" "curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip" "web.zip downloaded in temp folder"

cd /usr/share/nginx/html

unzip -o /tmp/web.zip

VALIDATE "$?" "FAILED-6" "SUCCESS-7"

ls -l /etc/nginx/default.d/ | grep roboshop.conf

VALIDATE_1 "$?" "cp /home/centos/roboshop-shell-script/roboshop.conf /etc/nginx/default.d/roboshop.conf" "roboshop.conf created"

systemctl restart nginx 

VALIDATE "$?" "FAILED-3: nginx service start failed" "SUCCESS-3: nginx service start success"















