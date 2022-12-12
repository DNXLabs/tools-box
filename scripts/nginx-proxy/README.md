# nginx-proxy

Required config files and packages to setup a nginx proxy

## Prerequisites

- Nginx

## How to use

The `userdata` script installs the necessary packages that nginx needs. The IPs and ports configuration need to be addressed accordingly. For example, one could get these values from a SSM parameter or via the EC2 metadata. 
This script assumes that you already have the nginx.conf file in a /tmp folder. Please do it before running this script, otherwise it'll fail.
The nginx.conf can be uploaded to a S3 bucket and from there you can download it to the /tmp folder. Be aware that you'll need the right permissions to upload/download the file to the S3 bucket.

The `nginx.conf` file contains a sample of a proxy vhost.

Please, refer to the userdata script as an example, feel free to customize it.

## Example of custom nginx.conf

If you need a proxy forwarding more than one port to a destination, edit the nginx.conf file and replace the stream block with:

```
stream {
  upstream mssql_db {
    server $MSSQL_DB_IP:1433; ## replace the variable MSSQL_DB_IP
  }

  server {
    listen 1433;
    proxy_pass mssql_db;
  }

  upstream pg_db {
    server $PG_DB_IP:5432; ## replace the variable PG_DB_IP
  }

  server {
    listen 5432;
    proxy_pass pg_db;
  }
}
```

## Author

* **Jeremias Roma** - *Initial work* - [jeremiasroma](https://github.com/jeremiasroma)

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/tools-box/blob/master/LICENSE) for full details.
