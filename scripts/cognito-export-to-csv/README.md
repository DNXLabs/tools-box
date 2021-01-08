# Cognito Export To CSV
This project allows to export user records from Cognito User Pool to CSV file [Amazon Cognito User Pool](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-identity-pools.html)


### Prerequisites
To run this script you will need the following tools:

```
Python2 or Python3
```

### Installing
To have your script running, follow these steps:

(Python 2)
```
pip install -r requirements.txt`  
```
(Python 3)
```
pip3 install -r requirements.txt
``` 

### Run

```
$ ➜ python CognitoUserToCSV.py  --user-pool-id 'us-east-1_XXXXXXXXX' -attr Username email_verified given_name family_name UserCreateDate
```
Wait until you see output `INFO: End of Cognito User Pool reached`
Find file `CognitoUsers.csv` that contains all exported users.

### Script Arguments

- `--user-pool-id` [__Required__] - The user pool ID for the user pool on which the export should be performed
- `-attr` or `--export-attributes` [__Required__] - List of Attributes that will be saved in CSV file
- `--region` [_Optional_] - The user pool region the user pool on which the export should be performed _Default_: `us-east-1`
- `-f` or `--file-name` [_Optional_] - CSV File name or path. _Default_: `CognitoUsers.csv`
- `--num-records` [_Optional_] - Max Number of Cognito Records tha will be exported. _Default_: __0__ - All


## Built With

* [Python]([https://www.python.org/](https://www.python.org/)) - Python


## Versioning

1.0.0

## Authors

* **Bruno da Silva Valenga** - *Initial work* - [brunodasilvalenga](https://github.com/brunodasilvalenga)

## License

This project is forked based on https://github.com/hawkerfun/cognito-csv-exporter

###### Note:
If you need to Back up your intire cognito instance pool, take a look for this tool: https://www.npmjs.com/package/cognito-backup-restore
