#!/bin/bash


# List of modules to update
# Be carefull with fork repos to point the right origin when openinig PR.
# DNX One public repositories list
# To get an updated list of dnx publix repositores, use the github cli command: gh repo list DNXLabs --public
declare -a StringArray=(
    "terraform-aws-ecs-app"
    "terraform-aws-ecs-app-front"
    "terraform-aws-ecs-app-nlb"
    "terraform-aws-ecs-app-worker"
    "terraform-aws-ecs-app-scheduler"
    "terraform-aws-rds"
    "terraform-aws-network"
    "terraform-aws-gitlab-runner" # fork
    "terraform-aws-jenkins" # fork
    "terraform-aws-backup"
    "terraform-aws-chatbot"
    "terraform-aws-kinesis-stream-es"
    "terraform-aws-ecs"
    "terraform-aws-client-vpn"
    "terraform-aws-account"
    "terraform-aws-openvpn"
    "terraform-aws-ecr"
    "terraform-google-stackdriver-uptime"
    "terraform-aws-waf"
    "terraform-aws-backend"
    "terraform-aws-static-app"
    "terraform-aws-vpc-peering"
    "terraform-aws-billing"
    "terraform-aws-billing-role"
    "terraform-aws-organization"
    "terraform-aws-guardduty"
    "terraform-aws-db-monitoring"
    "terraform-aws-idp-gsuite"
    "terraform-aws-sns"
    "terraform-aws-hostedzone"
    "terraform-aws-account-security"
    "terraform-aws-lite-account-security"
    "terraform-aws-route53healthcheck"
    "terraform-aws-audit-root"
    "terraform-aws-audit-member"
    "terraform-aws-audit-buckets"
    "terraform-aws-log-exporter"
    "terraform-aws-rds-scheduler"
    "terraform-aws-security-baseline"
    "terraform-aws-account-identity"
    "terraform-aws-eb-windows"
    "terraform-aws-eks"
    "terraform-aws-template"
    "terraform-aws-eks-argocd"
    "terraform-aws-media-convert"
    "terraform-aws-github-runner"
    "terraform-aws-eks-node-termination-handler"
    "terraform-aws-eks-ack"
    "terraform-aws-transfer-server"
    "terraform-aws-eks-calico"
    "terraform-aws-couchbase"
    "terraform-aws-audit-regional"
    "terraform-aws-eks-external-dns"
    "terraform-aws-eventbridge-default"
    "terraform-aws-security-alarms"
    "terraform-aws-eks-cloudwatch-logs"
    "terraform-aws-eks-vpc-cni"
    "terraform-aws-securityhub"
    "terraform-aws-eks-external-secrets"
    "terraform-aws-eks-grafana-prometheus"
    "terraform-aws-stateful"
    "terraform-aws-acm-certificate"
    "terraform-mongodbatlas-vpc-peering"
    "terraform-aws-eks-istio-operator"
    "terraform-aws-vpc-peering-inter-region"
    "terraform-aws-eks-dashboard"
    "terraform-aws-eks-kiali-operator"
    "terraform-aws-redis"
    "terraform-aws-eks-github-runner"
    "terraform-aws-eks-metrics-server"
    "terraform-azure-devops-self-hosted-agent-on-aws"
    "terraform-aws-lambda-edge-function"
    "terraform-aws-eks-velero"
    "terraform-aws-eks-cert-manager"
    "terraform-docs"
    "terraform-aws-budget"
    "terraform-aws-mwaa"
    "terraform-aws-eks-efs-csi-driver"
    "terraform-aws-sagemaker"
    "terraform-aws-eks-cloudwatch-metrics"
    "terraform-aws-eks-lb-controller"
    "terraform-aws-maskopy"
    "terraform-aws-inspector"
    "terraform-aws-eks-cluster-autoscaler"
    "terraform-aws-bitbucket-oidc"
)

mkdir repos
cd repos

BRANCH_NAME="" # e.g update-tf-versions
COMMIT_MESSAGE="" # e.g Bump TF required version to 0.13
PR_TITLE="" # e.g Set minimum terraform version to 1.13
PR_BODY="" # Explain why you are doing this PR

for val in ${StringArray[@]}; do
    # git clone git@github.com:$val.git
    # gh repo clone $val
    git clone https://github.com/DNXLabs/$val.git

    cd $val

    # Remove original file from upstream
    # rm versions.tf

    # Add new files
    cp ../../modifications/CODE_OF_CONDUCT.md ./
    cp ../../modifications/CONTRIBUTING.md ./
    cp ../../modifications/.github/pull_request_template.md ./.github/
    cp -r ../../modifications/.github/ISSUE_TEMPLATE ./.github/


    git checkout -b feature/$BRANCH_NAME
    git add .
    git commit -m "$COMMIT_MESSAGE"
    git push origin feature/"$BRANCH_NAME"
    gh pr create -R DNXLabs/$val --title "$PR_TITLE" --body "$PR_BODY"

    cd ..

    read -p "Press enter to continue"

cd ..
rm -rf ./repos

done