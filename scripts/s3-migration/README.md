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

1. Spin up an EC2 instance
2. Create an instance role and attach it to the EC2 Instance
3. Update the policy of source buckets with the new instance role
4. Install screen
5. Run this script on screen

## Built With

* [Bash]([https://www.gnu.org/software/bash/](https://www.gnu.org/software/bash/)) - Bash Console


## Versioning

1.0.0

## Authors

* **Luiz Rocha** - *Initial work* - [lzrocha](https://github.com/lzrocha)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
