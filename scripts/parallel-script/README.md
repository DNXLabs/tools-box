# Parallel sync/restore

These scripts will help you to start a multi thread processment either for `aws s3 cp` and `mysql` restore. It's possible to adapt both scripts and use them for many multi process as you need.

## Describing functions - parallel_db_restore.py

- restore()
    - The function responsible to run the mysql restore command.
    - It will run a subprocess lib to call a syscall.
    - Requires: a list of databases

- list_dbs()
    - This function will list the *.sql files in a directory 
    - It will grab only the database name from the dump
    - Requires:
        - Run a dump database like: `mysql -N -e 'show databases' | while read dbname; do mysqldump --complete-insert --routines --triggers --single-transaction "$dbname" > /home/restore/"$dbname".sql; done`

- main()
    - pool = the number of threads running at the same time

## Describing functions - parallel_sync.py

- sync()
    - The function responsible to run the `aws s3 cp` restore command.
    - It will run a subprocess lib to call a syscall.
    - Requires: a list of files (or folders) to sync

- list_files()
    - Create a file called my_files_list.txt with the files/folders list:
        ```
        file1
        file2
        file3
        ```

- main()
    - pool = the number of threads running at the same time

## Changing the scripts

The scripts in this repo are examples. Feel free to change them to run your own parallel command. When changing the scripts don't forget to change the function to list whatever you want. 