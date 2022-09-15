#!/bin/sh

IFS=$'\n'
for x in `cat glacier-restore.txt`
  do
    echo "Begin restoring ${x}"
    aws s3api restore-object --restore-request '{"Days":<numberofdays>,"GlacierJobParameters":{"Tier":"Standard"}}' --bucket <bucketname>  --key "$x"
    echo "Done restoring ${x}"
  done
 