#!/bin/bash
OLDIFS=$IFS
IFS=","

mkdir -p outputs
while read -r sourcebucket destinationbucket
  do
        echo "Starting copy from \"$sourcebucket\" to \"$destinationbucket\""
        aws s3 ls --recursive s3://"$sourcebucket" --human-readable --summarize > outputs/files-"$sourcebucket".txt
        date; aws s3 sync s3://"$sourcebucket" s3://"$destinationbucket" ;date
done < "$1"
IFS=$OLDIFS
