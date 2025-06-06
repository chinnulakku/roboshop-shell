#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/etc/$0-$TIMESTAMP.log"

echo "script stated executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ...$R FAILED $N"
    else
        echo -e "$2 ...$G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can  give other than 0
else
    echo "you are root user"
fi # means reverse of if, indicating condition end

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $ LOGFILE

VALIDATE $? " Insatlling Remi release"

dnf module enable redis:remi-6.2 -y &>> $ LOGFILE

VALIDATE $? "Enable redis"

dnf install redis -y &>> $ LOGFILE

VALIDATE $? " Installing redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf & /etc/redis/redis.conf &>> $ LOGFILE

VALIDATE $? " allowing remote connections"

systemctl enable redis &>> LOGFILE

VALIDATE $? "Enabled redis"

systemctl start redis &>> LOGFILE

VALIDATE $? "Starting redis"