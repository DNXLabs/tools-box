# restore-glacier-files

This script will restore from glacier to S3 standard.

## Use case:

You cannot use a lifecycle configuration rule to convert the storage class of an object from GLACIER to STANDARD or REDUCED_REDUNDANCY storage classes. If you want to change the storage class of an archived object to either STANDARD or REDUCED_REDUNDANCY, you must use the restore operation to make a temporary copy first. Then use the copy operation to overwrite the object as a STANDARD, STANDARD_IA, ONEZONE_IA, or REDUCED_REDUNDANCY object .

## Prerequisites

- Bash
- aws cli


## How to run

1. Get a listing of all GLACIER files (keys) in the bucket (you can skip this step if you are sure all files are in Glacier) and save the output in a txt file.

`aws s3api list-objects-v2 --bucket <bucketName> --query "Contents[?StorageClass=='GLACIER']" --output text | awk -F '\t' '{print $2}' > glacier-restore.txt`

2. Run script restore-glacier.sh , replacing the variables <bucketName>, <numberofdays>

3. The boring part now. Wait until the restore finalize. It can takes from 1 to 12 hours.

 - Additional step:  
        If you need to copy the restored data to another bucket

`aws s3 sync s3://<bucket-origin> s3://<bucket-destination> --force-glacier-transfer --storage-class STANDARD`

        Option --force-glacier-transfer is necessary to make aws s3 copy the glacier files. 
        Ps: this option only will work if (STEP 3 - restore) has been concluded before.

## Versioning

1.0.0


## Author

* ** Marcus Nogueira ** 

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/tools-box/blob/master/LICENSE) for full details.
