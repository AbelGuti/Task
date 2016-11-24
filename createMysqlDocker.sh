#!/bin/sh
#  $1 is the docker name, $2 is the password root, $3 is the port
NAME="$1"
PSSWD="$2"
PORT="$3"
sudo docker run --name ${NAME} -e MYSQL_ROOT_PASSWORD=${PSSWD} -p ${PORT}:3306 -d mysql/mysql-server:5.5

#54.165.37.138 its my ip address, you must changed it by yours
curl -L -X PUT http://54.165.37.138:5001/v2/keys/name -d value=${NAME}
curl -L -X PUT http://54.165.37.138:5001/v2/keys/psswd -d value=${PSSWD}
curl -L -X PUT http://54.165.37.138:5001/v2/keys/port -d value=${PORT}
