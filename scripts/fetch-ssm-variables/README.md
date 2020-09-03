# Fetch SSM Variables

This script will help you to collect variables from SSM Parameter Store and replace its values in your local repository based on any kind of template files.

## Usage

These scripts can be used in pipeline steps when there is a need of using credentials that shouldn't be stored in the code base but are still relevant for the execution (e.g. Integration Tests, Build Steps, etc).

## Getting Started

### Prerequisites

To run this script you will need:

* IDP credentials
* AWS Account ID, IAM role and AWS environment

### Installing and Configuring

To have your script running, follow these steps:

1. Configure your IDP credentials in the header of the `Makefile`:

```
export GOOGLE_IDP_ID=<my-google-idp-id>
export GOOGLE_SP_ID=<my-google-sp-id>
```

And authenticate to collect your temporary token using the command:

```
make .env.auth
```

2. Export the following environment variables for the desired AWS account where we must collect the SSM parameters:

- `AWS_ACCOUNT_ID` = AWS Account ID
- `AWS_ROLE`       = AWS IAM role
- `AWS_ENV`        = AWS Environment

```
export AWS_ACCOUNT_ID=<my-account-id> AWS_ROLE=<my-iam-role> AWS_ENV=<my-environment>
```

3. Adjust the SSM_PATH variable in the `Makefile` based on your configuration and the variables in the template file (e.g. `example.tpl.json`) based on the last part of the path of your SSM parameter. For example, if your SSM variable has this path:

```
/app/my-environment/my-app/MY_VARIABLE
```

You should configure your `Makefile` with:

```
export SSM_PATH=/app/my-environment/my-app
```

And configure your template file with the last part of the variable based on the format `${MY_VARIABLE}`:

```
{
    "MyVariables": [
        {
            "Value1": "${MY_VARIABLE}"
        }
    ]
}
```

The scripts will collect the value from the SSM parameter and replace in the template file automatically.

5. To collect the variables and replace them in the template file just run the command:

```
replace-ssm-variables
```

The first script collects the environment variables and stores in the file `.env.ssm` and the second script replaces these variables in the template file `example.tpl.json` resulting in the output of `example.json`.

Feel free to adapt the Makefile, template file and the logic of the scripts according to your needs.

## Versioning

1.0.0

## Authors

* **Felipe de Mello Rodrigues** - *Initial work* - [felipedemellorodrigues](https://github.com/sohflp)
* **Bruno da Silva Valenga** - *Initial work* - [brunodasilvalenga](https://github.com/brunodasilvalenga)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
