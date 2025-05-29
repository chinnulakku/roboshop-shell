#!/bin/bash

ID=$(id -u)
R="\e[31m"]
G="\e[32m"]
Y="\e[33m"]
N="\e[0m"]
MONGODB_HOST=mongodb.sudhaaru676.online

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){ 
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
    else
        echo -e "$2 ...$G SUCCESS $N"
    fi 
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N" 
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # means reverse of if, indicating condition end

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling current Nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabling Nodejs:18"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing nodejs:18"

useradd roboshop &>> $LOGFILE

VALIDATE $? "creating roboshop user"

mkdir /app &>> $LOGFILE

VALIDATE $? " Creating app Directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip  &>> $LOGFILE

VALIDATE $? "Downloadong catalogue application"

cd /app 

unzip /tmp/catalogue.zip

VALIDATE $? "unzipping catalogue"

npm install   &>> $LOGFILE

VALIDATE $? "Install Dependencies"

# use absolute, because catalogue.service exists there

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catlogue.service

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "catalogue daemon Reload"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "Enable catalogue"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? " Starting catalogue"

cp /home/centos/roboshop-shell/mongodb.repo  /etc/yum.repos.d/mongodb.repo

VALIDATE $? " copying mongodb repo"

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? " Install Mongodb client"

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js

VALIDATE $? " Loading catalogue data into MongoDB"

















