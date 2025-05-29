#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODB_HOST=mongodb.sudhaaru676.online

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){ 
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
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

VALIDATE $? "Disable nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enable Nodejs-18" 

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing NOdejs"

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop 
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y skipping $N"
fi

mkdir -p /app &>> $LOGFILE

VALIDATE $? " Creating app Directory"

curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip  &>> $LOGFILE

VALIDATE $? "Downloading user application"

cd /app 

unzip -o /tmp/user.zip &>> $LOGFILE
 
VALIDATE $? "unzipping user"

npm install &>> $LOGFILE

VALIDATE $? " Installing dependencies"

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service

VALIDATE $? " copying user service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "user daemon Reload"

systemctl enable user &>> $LOGFILE

VALIDATE $? "Enable user"

systemctl start user &>> $LOGFILE

VALIDATE $? "Starting user"

cp /home/centos/roboshop-shell/mongodb.repo  /etc/yum.repos.d/mongodb.repo

VALIDATE $? " copying mongodb repo"

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? " Install MongoDB client"

mongo --host $MONGODB_HOST </app/schema/user.js

VALIDATE $? " Loading user data into MongoDB"