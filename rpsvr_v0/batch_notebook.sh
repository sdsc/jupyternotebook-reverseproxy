#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH -p debug
#SBATCH -t 00:30:00
#SBATCH --wait 0
#SBATCH -o /dev/null # STDOUT

mkdir -p ~/.jupyter_secure
TMPFILE=`mktemp -p ~/.jupyter_secure` || exit 1

# Make a random ssl token
JUPYTER_TOKEN=$(openssl rand -hex 16)
echo $JUPYTER_TOKEN | tee -a $TMPFILE

# Create the temp config file
touch "$TMPFILE".py
echo "c.NotebookApp.token = '$JUPYTER_TOKEN'" | cat >> "$TMPFILE".py
echo "c.NotebookApp.notebook_dir = '$2'" | cat >> "$TMPFILE".py

# Get the comet node's IP
IP="$(hostname -s).local"
jupyter notebook --ip $IP --config "$TMPFILE".py | tee $TMPFILE &


# Waits for the notebook to start and gets the port
PORT=""
while [ -z "$PORT" ]
do
    PORT=$(grep '1.' $TMPFILE)
    PORT=${PORT#*".local:"}
    PORT=${PORT:0:4}
done

echo $PORT | tee -a $TMPFILE

# redeem the API_TOKEN given the untaken port
url='"https://manage.comet-user-content.sdsc.edu/redeemtoken.cgi?token=$1&port=$PORT"'

# Redeem the API_TOKEN
eval curl $url | tee -a $TMPFILE

# waits for all child processes to complete, which means it waits for the jupyter notebook to be terminated
wait
