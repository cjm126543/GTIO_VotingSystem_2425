#!/bin/bash

# Script variables
SERVICE_NAME=postman_tools
IP=192.168.1.48
PORT=8080
URL="http://$IP:$PORT"
RETRIES=10
KEY=$(echo "manolocabezabolo" | base64)

# Download Kong and boot it up
curl -Ls https://get.konghq.com/quickstart | bash

# Create postman service
# Obtain system's IP
#ifconfig wlan0 | grep -E "inet\s" | grep -m1 -E "[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}"

# Create service
curl -siX POST http://localhost:8001/services --data name=$SERVICE_NAME --data url=$URL

# Change service parameters
curl -sX PATCH --url localhost:8001/services/$SERVICE_NAME --data retries=$RETRIES
curl -sX PATCH --url localhost:8001/services/$SERVICE_NAME --data path=/api

# Create routes
curl -siX POST http://localhost:8001/services/$SERVICE_NAME/routes --data 'paths[]=/backend' --data name=back_route

# Change routes properties
curl -sX PATCH --url localhost:8001/services/$SERVICE_NAME/routes/back_route --data tags="standard"

# Create a consumer for postman
curl -siX POST http://localhost:8001/consumers --data username=postman

# Assign a key to the customer ($KEY is defined as ENVIRON)
curl -siX POST http://localhost:8001/consumers/postman/key-auth --data key=$KEY

# Restrict back route with authentication (search apikey in headers)
curl -sX POST http://localhost:8001/routes/back_route/plugins --data "name=key-auth" --data "config.key_names=apikey"

# Enable log registering for every connection made through Kong API Gateway
# NOTE: for viewing log -> docker exec <container ID> cat /tmp/kong_file.log
curl -X POST http://localhost:8001/plugins/ --header "accept: application/json" --header "Content-Type: application/json" --data '
{
    "name": "file-log",
    "config": {
        "path": "/tmp/kong_file.log"
    }
}
'

