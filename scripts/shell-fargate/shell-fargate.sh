#!/bin/bash

aws ecs describe-tasks \
    --cluster $1 \
    --tasks $2 \
    --query 'tasks[*].containers[*].{name:name,lastStatus:lastStatus}'

aws ecs execute-command --cluster $1 --task $2 --command /bin/bash --interactive
