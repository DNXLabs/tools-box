#!/bin/bash
OLDIFS=$IFS
IFS=","

mkdir -p outputs
i=1
while read -r sourcebucket targetbucket
  do
        echo "Starting copy from \"$sourcebucket\" to \"$targetbucket\""
        aws s3 ls --recursive s3://"$sourcebucket" --human-readable --summarize > outputs/"$i"-SourceBucket-"$sourcebucket".txt
        date; aws s3 sync s3://"$sourcebucket" s3://"$targetbucket" ;date
        aws s3 ls --recursive s3://"$targetbucket" --human-readable --summarize > outputs/"$i"-TargetBucket-"$targetbucket".txt
        ((++i))
done < "$1"
IFS=$OLDIFS