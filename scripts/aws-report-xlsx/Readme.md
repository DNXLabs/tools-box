# AWS Resource Inventory & Backup Coverage Report

This Python script automates the inventory and export of key AWS resources (EC2, EBS, EIP, AMI, Snapshots, RDS, DynamoDB, and AWS Backup) across multiple regions. It outputs detailed inventory data in an Excel workbook, with each resource type on its own sheet. Additionally, it consolidates coverage information for EC2, EBS, RDS, and DynamoDB to show which resources are protected by AWS Backup.

## Features

- Supports multiple AWS regions.
- Multi threads 
- Lists all:
  - EC2 Instances
  - EBS Volumes
  - Elastic IPs
  - AMIs (owned by your account)
  - Snapshots (owned by your account)
  - RDS Databases
  - DynamoDB Tables
  - AWS Backup: Vaults, Plans, Jobs, and Protected Resources

- Each resource type is exported to a separate tab in `aws_resources_full.xlsx` for easy filtering and reporting.

### Backup Coverage Check
- Produces `backup.xlsx` with all EC2, EBS, RDS, and DynamoDB resources cross-referenced against AWS Backup protection.
- Designed for audit, compliance, cost optimization, and operational visibility.

## Requirements

- Python
- AWS credentials with read-only permissions
- Install requirements.txt (boto3, pandas, openpyxl)

Install them with:
```bash
pip install -r requirements.txt
```

## How to Run

1. Clone this repository
2. Open a terminal in the script’s folder.
3. (Optional, but recommended) Create and activate a virtual environment:

   **Windows:**
   ```powershell
   python -m venv venv
   venv\Scripts\activate
   ```

   **macOS/Linux:**
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

4. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

5. Set AWS credentials (ensure `aws sts get-caller-identity` works in this terminal).

6. Edit regions in `main.py` as needed:
   ```python
   regions = ['us-west-1', 'eu-central-1']
   ```

7. Run the script:
   ```bash
   python main.py
   ```

## Outputs

- **aws_resources_full.xlsx**: A single Excel workbook with a sheet per AWS resource type, containing all fields (as returned by AWS).
- **backup.xlsx**: An Excel file showing, for each EC2, EBS, RDS, and DynamoDB resource, whether it is protected by AWS Backup.

## Notes & Tips

- The script creates and deletes temporary CSVs per resource/region as part of processing.
- If you want to analyze additional services (e.g., S3, Lambda), similar functions can be added.
- If has a lot o regions, is possible to increase the number of workers `max_workers=3` to speedup the export


### Example: Backup Coverage Report

The file `backup.xlsx` includes columns:
- **ResourceType**: EC2, EBS, RDS, DynamoDB
- **ResourceId**: Resource identifier (e.g., instance ID, volume ID, table name)
- **ProtectedByBackup**: YES / NO


## Google sheets Analysis:
- **aws_resources_full.xlsx**: This Excel file can be imported directly into Google Sheets for further analysis
(Always check corresponding column letter after importing):
- When updating xlsx, remember to adjust `LIMIT` from each query, this was added to avoid errors on google sheet and allow the creation of multiple queries at same tab. 

**EC2 Stopped**
```sql
=QUERY('EC2'!A1:ZZ, "SELECT AT, AC, AD, AL, AR, AS, AE, M WHERE AE CONTAINS 'stopped'", 1)
```

**EBS Unattached**
```sql
=QUERY(EBS!A1:ZZ, "SELECT N, F, H, I, J WHERE J <> 'in-use' LIMIT 2", 1)
```

**Snapshot by Creation Time**
```sql
=QUERY(SNAPSHOT!A1:ZZ, "SELECT N, E, F, C WHERE C IS NOT NULL ORDER BY C ASC LIMIT 6", 1)
```

**AMI by Creation Time**
```sql
=QUERY(AMI!A1:ZZ, "SELECT X, F, K, P, T WHERE T IS NOT NULL ORDER BY T ASC LIMIT 3", 1)
```

**EIP Unattached**
```sql
=QUERY(EIP!A1:ZZ, "SELECT K, A, J, B, D, G WHERE B IS NULL LIMIT 3", 1)
```

**EC2**
```sql
=QUERY('EC2'!A1:ZZ, "SELECT AT, AC, AD, AL, AR, AS, M LIMIT 25", 1)
```

**EBS**
```sql
=QUERY(EBS!A1:ZZ, "SELECT N, F, B, H, I, J LIMIT 25", 1)
```

**EIP**
```sql
=QUERY(EIP!A1:ZZ, "SELECT K, A, J, B, D, G LIMIT 5", 1)
```

**SNAPSHOT**
```sql
=QUERY(SNAPSHOT!A1:ZZ, "SELECT N, E, F, C WHERE C IS NOT NULL ORDER BY C ASC LIMIT 8", 1)
```

If you want to get each ebs per instance, you can create a regex on EC2 tab at last column:
=REGEXEXTRACT(B2, "VolumeId': '([^']+)'")    
In this example, AV,

And filter it on your query:
```sql
=QUERY('EC2'!A1:AAA, "SELECT AT, AC, AV, AD, AL, AR, AS, M LIMIT 25", 1)
```


## Example
Martec Document:
https://docs.google.com/spreadsheets/d/1tAewFnA2pAFgCTDOcPph2uCsJ1QlE6fVnl6Dt4PMFuc/edit?gid=1396156998#gid=1396156998


## Contributing
You are welcome to change the code and to add new resource types, region support, or optimizations!