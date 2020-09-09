# S3 Content Migration

This script will help you copy all files from multiple buckets using a list of bucket names.

## Getting Started

|Language|Environment|Purpose
|--|--|--|
|Bash Script|Linux|Copy all files from multiple buckets to multiple buckets

### Prerequisites

To run this script you will need the following tools:

```
Terminal
```

### Installing

To have your script running, follow these steps:


Give permission to your script:

```
chmod +x sync.sh
```

Run the script:

```
./sync.sh list-of-buckets.csv
```

### Recommendation

1. Create instance role with s3 admin and SSM policy (target account)
2. Spin up EC2 instance on the target account with SSM agent and attach the instance role that was created on the previous step
3. Update the source bucket policy (origin account) to allow access to the instance role created on the target account
4. Run the sync script using screen
5. Clean up role, policy, and ec2 instance created for the s3 migration purpose

## Built With

* [Bash]([https://www.gnu.org/software/bash/](https://www.gnu.org/software/bash/)) - Bash Console


## Versioning

1.0.0

## Authors

* **Luiz Rocha** - *Initial work* - [lzrocha](https://github.com/lzrocha)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
