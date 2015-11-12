#!/bin/bash
# Example script to upload or replace file on FTP server
HOST="example.com"
USER="phn"
PASSWD="PASSWORD"
FILE="phn.log"
ftp -p -n -v $HOST << EOT
bin
user $USER $PASSWD
prompt
delete $FILE
put $FILE
quit
EOT
