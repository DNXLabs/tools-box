# Validate an MSSQL to PostgreSQL migration

These scripts will help you to validate a Database migration from Microsoft SQL Server to PostgreSQL.

It is assumed that the database was converted using the [AWS Schema Conversion Tool (SCT)](https://aws.amazon.com/dms/schema-conversion-tool/).

This is a working in progress version.

Below you can see a brief description of the scripts
* exec-mssql-queries-on-postgres: This script read a trace_file from SQL Profiler. The goal is to profile the SQL Server while the client's application is running, so you can capture common queries and behaviour executed in the SQL Server. The python script will parse the XML, read the queries, transform the T-SQL queries into Pg/SQL and execute it against the PostgresSQL Server.
* insert-mssql-data-into-postgres: This script reads data for each table from the SQL Server database and copies it to PostgreSQL. The goal is to test the triggers, functions and stored procedures that are used in insert operations. The script also remediates problems when an MSSQL *bit* type column is not properly converted to Postgres *bool* type.


### Prerequisites

To run this script you will need the following Python libraries:

```
psycopg2
pandas
numpy
pyodbc
```

You will also need to set up an ODBC connection to connect to the SQL Server. Instruction are provided at the [pyodbc](https://github.com/mkleehammer/pyodbc/wiki/Connecting-to-SQL-Server-from-Linux) website.

### Running

To open your jupyter environment, run the following command:


```
jupyter lab
```

## Versioning

1.0.0

## Authors

* **Augusto Dias** - [gutosantos82](https://github.com/gutosantos82)

## License

This project is licensed under the MIT License - see the [LICENSE](../../LICENSE) file for details.