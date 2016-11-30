#!/bin/sh
#$1 is the name of the key and $2 the value

key="$1"
value="$2"

#54.165.37.138 its my ip address, you must changed it by yours
curl -L -X PUT http://54.165.37.138:5001/v2/keys/vhosts/${key} -d value=${value}

