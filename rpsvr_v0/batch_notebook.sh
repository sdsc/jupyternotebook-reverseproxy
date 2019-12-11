#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH -p compute
#SBATCH -t 00:30:00
#SBATCH --wait 0

# Find an unused port
MIN_PORT=8000
MAX_PORT=32000
PORT=$MIN_PORT;
for ((port=$MIN_PORT; port<=$MAX_PORT;port++))
do
    PORT=$port;
    (echo >/dev/tcp/127.0.0.1/$port)> /dev/null 2>&1 && break;
done;

# get the API_TOKEN
API_TOKEN_RESPONSE=$(curl https://manage.comet-user-content.sdsc.edu/getlink.cgi)
API_TOKEN=${API_TOKEN_RESPONSE#*"Your token is "} # strips the API_TOKEN out of the response
API_TOKEN=$(echo "$API_TOKEN" | tr '\n' ' ') # removes the newline char
API_TOKEN=$(echo "$API_TOKEN" | xargs) # remove extra spaces before or after

# redeem the API_TOKEN given the untaken port
url='"https://manage.comet-user-content.sdsc.edu/redeemtoken.cgi?token=$API_TOKEN&port=$PORT"'

# Redeem the API_TOKEN
eval curl $url

# Give the user the start of their url
echo Your notebook is here: https://"$API_TOKEN".comet-user-content.sdsc.edu

# Get the comet node's IP
IP="$(hostname -s).local"
jupyter notebook --ip $IP --port $PORT

