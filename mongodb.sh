#!/bin/bash

ID=$(id -u)
R="\e[31m"]
G="\e[32m"]
Y="\e[33m"]
N="\e[0m"]

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
       echo -e "$2 ...$R FAILED $N"
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "you are root user"
fi # fi means reverse of if, indicating condition end

cp mongodb.repo /etc/yum.repos.d/mongodb.repo &>> $LOGFILE

VALIDATE $? "copied MongoDB Repo"

dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $? " Installing mongodb"

systemctl enable mongodb &>> $LOGFILE

VALIDATE $? " Enabling mongodb"

systemctl start mongodb &>> $LOGFILE

VALIDATE $? " Starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongo.config &>> LOGFILE

VALIDATE $? " Remote access to MongoDB"

systemctl restart mongodb &>> LOGFILE

VALIDATE $? " Restarting mongodb"


