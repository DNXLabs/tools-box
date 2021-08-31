# Using Amazon ECS Exec to access your containers on AWS

### Installing and Configuring

1. Configure `Makefile` variables on top of the page:

```
export GOOGLE_IDP_ID=<my-google-idp-id> or export AZURE_TENANT_ID?=<my-azure-tenant-id>
export GOOGLE_SP_ID=<my-google-sp-id> or export AZURE_APP_ID_URI?=<my-azure-app-id-URI>
export AWS_DEFAULT_REGION?=<my-region>

CLUSTER=<my-cluster>
TASK=<my-task-id>
```

2. Export the following environment variables for the desired AWS account where we must collect the SSM parameters: 


```
export AWS_ACCOUNT_ID=<my-account-id> AWS_ROLE=<my-iam-role> AWS_ENV=<my-environment>
```

3. And authenticate to collect your temporary token using the command:

```
make google.auth or make azure-auth
```

4. Finally, access fargate container using the following command:

```
make shell-fargate
````

### Prerequisites

To run this script you will need:

* IDP credentials or AWS credentials
* AWS Account ID, IAM role and AWS environment
* Task Role IAM permissions
* ECS exec must be enabled
* See more on https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-exec.html