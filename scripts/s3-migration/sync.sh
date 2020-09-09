#!/bin/bash
OLDIFS=$IFS
IFS=","

mkdir -p outputs
while read -r sourcebucket targetbucket
  do
        echo "STARTED - copy from \"$sourcebucket\" to \"$targetbucket\""
        date; aws s3 sync s3://"$sourcebucket" s3://"$targetbucket" ;date
        aws s3 ls s3://"$sourcebucket" --recursive --human-readable --summarize | awk '{print $5,$3,$4}' > outputs/"$sourcebucket"        
        aws s3 ls s3://"$targetbucket" --recursive --human-readable --summarize | awk '{print $5,$3,$4}' > outputs/"$targetbucket"
        diff -u outputs/"$sourcebucket" outputs/"$targetbucket" | grep ^-[a-zA-Z0-9] > outputs/diff-"$sourcebucket"-"$targetbucket"
        echo "COMPLETED - copy from \"$sourcebucket\" to \"$targetbucket\""
        echo ""
done < "$1"
IFS=$OLDIFS