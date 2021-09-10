#!/bin/bash


# List of modules to update
# Be carefull with fork repos, to point the right origin when openinig PR.
declare -a StringArray=(
    # "terraform-aws-ecs-app"
    # "terraform-aws-ecs-app-front"
    # "terraform-aws-ecs-app-nlb"
    # "terraform-aws-ecs-app-worker"
    # "terraform-aws-ecs-app-scheduler"
    # "terraform-aws-network"
    # "terraform-aws-gitlab-runner" # fork
    # "terraform-aws-jenkins" # fork
    # "terraform-aws-backup",
    # "terraform-aws-chatbot",
    # "terraform-aws-kinesis-stream-es",
    # "terraform-aws-ecs"
    # "terraform-aws-client-vpn"
    # "terraform-aws-account"
    # "terraform-aws-openvpn"
    # "terraform-aws-ecr"
    # "terraform-google-stackdriver-uptime"
    # "terraform-aws-waf"
    # "terraform-aws-backend"
    # "terraform-aws-static-app"
    # "terraform-aws-vpc-peering"
    # "terraform-aws-jenkins"
    # "terraform-aws-billing"
    # "terraform-aws-billing-role"
    # "terraform-aws-organization"
    # "terraform-aws-guardduty"
    # "terraform-aws-db-monitoring"
    # "terraform-aws-idp-gsuite"
    # "terraform-aws-sns"
    # "terraform-aws-hostedzone"
    # "terraform-aws-account-security"
    # "terraform-aws-lite-account-security"
    # "terraform-aws-route53healthcheck"
    # "terraform-aws-audit"
    # "terraform-aws-audit-root"
    # "terraform-aws-audit-member"
    # "terraform-aws-audit-buckets"
    # "terraform-aws-log-exporter"
    # "terraform-aws-rds-scheduler"
    # "terraform-aws-security-baseline"
    # "terraform-aws-account-identity"
    # "terraform-aws-eb-windows"
    # "terraform-aws-eks"
)

mkdir repos
cd repos

BRANCH_NAME="" # e.g update-tf-versions
COMMIT_MESSAGE="" # e.g Bump TF required version to 0.13
PR_TITLE="" # e.g Set minimum terraform version to 1.13
PR_BODY="" # Explain why you are doing this PR

for val in ${StringArray[@]}; do
    git clone git@github.com:DNXLabs/$val.git
    echo $val
    cd $val

    # Remove original file from upstream
    rm versions.tf

    # New file to replace the old one
    cp ../../modifications/versions.tf .

    git checkout -b feature/$BRANCH_NAME
    git add .
    git commit -m $COMMIT_MESSAGE
    git push origin feature/$BRANCH_NAME
    gh pr create --title $PR_TITLE --body $PR_BODY

    cd ..

    read -p "Press enter to continue"
done