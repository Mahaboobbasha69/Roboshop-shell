#!/bin/basha

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TimeStamp=$(date +%F-%H-%M-%S)  
LOGFILE="/tmp/$0-$TimeStamp.log"

echo "Script stareted Executing at $TimeStamp" $>> $LOGFILE

if [ $ID -ne 0 ]
then
    echo -e "$R Error:: Please run this script with root access $N"
    exit 1
else
    echo -e "$Y You are root user"
fi 

Method_Calling(){
    if [ $1 -ne 0]
    then
        echo -e "$2 $R Failed $N"
    else
         echo -e "$2 $G Success $N"
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

Method_Calling  $? "Copyed Mongodb repo" 

dnf install mongodb-org -y 

Method_Calling $? "installing mongo &>> $LOGFILE

systemctl enable mongod &>> $LOGFILE

Method_Calling $? "Enableing the mongodb

systemctl start mongod

Method_Calling $? "Stared mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' etc/mongod.conf &>> $LOGFILE

Method_Calling $? "Remote access to MongoDB"

systemctl restart mongod &>> $LOGFILE

Method_Calling $? "Mongodb Restared"