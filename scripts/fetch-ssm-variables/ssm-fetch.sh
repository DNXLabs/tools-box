#!/bin/bash
> .env.ssm

aws ssm get-parameters-by-path \
 --no-paginate \
 --path $1 \
 --with-decryption \
 --query 'Parameters[*].{Name:Name,Value:Value}' | jq -r "map(\"export \((.Name | split(\"/\")|.[-1]))=\\\"\(.Value|tostring)\\\"\")|.[]" \
 >> .env.ssm