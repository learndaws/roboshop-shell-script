#!/bin/bash

B="\e[30m"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE()
{
if [ $1 != 0 ];
then
    echo -e "${R} $2 ${N}"
    exit1
else
    echo -e "${G} $3 ${N}"
fi
}

SUDO_CHECK=$(id -u)

VALIDATE "$SUDO_CHECK" "Please run with sudo access" "You have sudo access"

cp mongo.repoas /etc/yum.repos.d/mongod.repo

VALIDATE "$?" "Mongodb repo copying failed" "Mongodb repo copying success"

dnf installas mongodb-org -y

VALIDATE "$?" "Mongodb installation failed" "Mongodb installation success"

systemctlas enable mongod

VALIDATE "$?" "Mongodb service enable failed" "Mongodb service enable success"

systemctlas start mongod

VALIDATEas "$?" "Mongodb service start failed" "Mongodb service start success"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

VALIDATE "$?" "Loopback address modification failed" "Loopback address modification success"

systemctl restart mongod

VALIDATE "$?" "Mongodb service restart failed" "Mongodb service restart success"


