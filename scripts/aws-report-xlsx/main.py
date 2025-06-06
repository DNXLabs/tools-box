import boto3
import pandas as pd
import os
import glob
import datetime
from concurrent.futures import ThreadPoolExecutor, as_completed

regions = ['us-west-1', 'eu-central-1']

def datetime_cols_to_iso(df):
    for col in df.columns:
        if pd.api.types.is_datetime64_any_dtype(df[col]):
            df[col] = df[col].dt.tz_convert('UTC').dt.strftime('%Y-%m-%dT%H:%M:%SZ')
        elif df[col].dtype == object:
            def to_iso(val):
                if hasattr(val, 'isoformat'):
                    if getattr(val, 'tzinfo', None):
                        return val.astimezone(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
                    else:
                        return val.strftime('%Y-%m-%dT%H:%M:%SZ')
                return val
            df[col] = df[col].apply(to_iso)
    return df

def get_ec2_instances(region):
    ec2 = boto3.client('ec2', region_name=region)
    instances = []
    for reservation in ec2.describe_instances()['Reservations']:
        for i in reservation['Instances']:
            i['Region'] = region
            instances.append(i)
    return instances

def get_ebs_volumes(region):
    ec2 = boto3.client('ec2', region_name=region)
    volumes = ec2.describe_volumes()['Volumes']
    for v in volumes:
        v['Region'] = region
    return volumes

def get_eips(region):
    ec2 = boto3.client('ec2', region_name=region)
    eips = ec2.describe_addresses()['Addresses']
    for e in eips:
        e['Region'] = region
    return eips

def get_amis(region):
    ec2 = boto3.client('ec2', region_name=region)
    amis = ec2.describe_images(Owners=['self'])['Images']
    for a in amis:
        a['Region'] = region
    return amis

def get_snapshots(region):
    ec2 = boto3.client('ec2', region_name=region)
    snaps = ec2.describe_snapshots(OwnerIds=['self'])['Snapshots']
    for s in snaps:
        s['Region'] = region
    return snaps

def get_rds_instances(region):
    rds = boto3.client('rds', region_name=region)
    rds_instances = rds.describe_db_instances()['DBInstances']
    for r in rds_instances:
        r['Region'] = region
    return rds_instances

def export_resource_to_csv(resource, resource_type, region):
    if isinstance(resource, dict):
        resource = [resource]
    df = pd.DataFrame(resource)
    df = datetime_cols_to_iso(df)
    csv_name = f"{resource_type}_{region}.csv"
    df.to_csv(csv_name, index=False)

def get_backup_vaults(region):
    client = boto3.client('backup', region_name=region)
    vaults = client.list_backup_vaults()['BackupVaultList']
    for v in vaults:
        v['Region'] = region
    return vaults

def get_backup_plans(region):
    client = boto3.client('backup', region_name=region)
    plans = client.list_backup_plans()['BackupPlansList']
    for p in plans:
        p['Region'] = region
    return plans

def get_backup_jobs(region):
    client = boto3.client('backup', region_name=region)
    jobs = client.list_backup_jobs()['BackupJobs']
    for j in jobs:
        j['Region'] = region
    return jobs

def get_backup_protected_resources(region):
    client = boto3.client('backup', region_name=region)
    resources = client.list_protected_resources()['Results']
    for r in resources:
        r['Region'] = region
    return resources

def get_dynamodb_tables(region):
    dynamodb = boto3.client('dynamodb', region_name=region)
    paginator = dynamodb.get_paginator('list_tables')
    tables = []
    for page in paginator.paginate():
        for name in page['TableNames']:
            tables.append({'TableName': name, 'Region': region})
    return tables

def fetch_and_export(resource_fn, resource_type, region):
    try:
        export_resource_to_csv(resource_fn(region), resource_type, region)
        print(f"{resource_type} ({region}) exportado com sucesso!")
    except Exception as e:
        print(f"Erro exportando {resource_type} ({region}): {e}")

resource_map = [
    (get_ec2_instances, "ec2"),
    (get_ebs_volumes, "ebs"),
    (get_eips, "eip"),
    (get_amis, "ami"),
    (get_snapshots, "snapshots"),
    (get_rds_instances, "rds"),
    (get_dynamodb_tables, "dynamodb"),
    (get_backup_vaults, "backup_vaults"),
    (get_backup_plans, "backup_plans"),
    (get_backup_jobs, "backup_jobs"),
    (get_backup_protected_resources, "backup_protected_resources"),
]


with ThreadPoolExecutor(max_workers=3) as executor:
    futures = []
    for region in regions:
        for fn, resource_type in resource_map:
            futures.append(executor.submit(fetch_and_export, fn, resource_type, region))
    for future in as_completed(futures):
        pass 

resource_types = [rtype for _, rtype in resource_map]

with pd.ExcelWriter('aws_resources_full.xlsx') as writer:
    for resource_type in resource_types:
        csv_files = glob.glob(f"{resource_type}_*.csv")
        dfs = []
        for file in csv_files:
            if os.path.getsize(file) > 0:
                try:
                    df = pd.read_csv(file, low_memory=False)
                    if not df.empty:
                        dfs.append(df)
                except pd.errors.EmptyDataError:
                    print(f"Aviso: {file} está vazio e foi ignorado.")
            else:
                print(f"Aviso: {file} está vazio e foi ignorado.")
        if dfs:
            df_final = pd.concat(dfs, ignore_index=True)
            df_final.to_excel(writer, sheet_name=resource_type.upper(), index=False)

print('Exportação completa! Arquivo: aws_resources_full.xlsx')


def try_read_concat(pattern):
    files = glob.glob(pattern)
    if not files:
        return pd.DataFrame()
    dfs = []
    for f in files:
        try:
            df = pd.read_csv(f, low_memory=False)
            if not df.empty:
                dfs.append(df)
        except Exception:
            continue
    if dfs:
        return pd.concat(dfs, ignore_index=True)
    else:
        return pd.DataFrame()

df_ec2 = try_read_concat("ec2_*.csv")
df_ebs = try_read_concat("ebs_*.csv")
df_snap = try_read_concat("snapshots_*.csv")
df_rds = try_read_concat("rds_*.csv")
df_dynamo = try_read_concat("dynamodb_*.csv")

prot_files = glob.glob("backup_protected_resources_*.csv")
if prot_files:
    df_prot_all = try_read_concat("backup_protected_resources_*.csv")
    if 'ResourceName' in df_prot_all.columns:
        df_prot_all['ResourceId'] = df_prot_all['ResourceName']
    elif 'ResourceArn' in df_prot_all.columns:
        df_prot_all['ResourceId'] = df_prot_all['ResourceArn']
    else:
        df_prot_all['ResourceId'] = None
    prot_fields = ['ResourceType', 'ResourceId', 'LastBackupTime']
else:
    df_prot_all = pd.DataFrame(columns=['ResourceType', 'ResourceId', 'LastBackupTime'])
    prot_fields = ['ResourceType', 'ResourceId', 'LastBackupTime']


if 'InstanceId' in df_ec2.columns:
    ec2_list = df_ec2['InstanceId'].dropna().unique()
    df_ec2_cons = pd.DataFrame({
        'ResourceType': 'EC2',
        'ResourceId': ec2_list
    })
    df_ec2_cons['ProtectedByBackup'] = df_ec2_cons['ResourceId'].isin(df_prot_all['ResourceId']).map({True: 'YES', False: 'NO'})
else:
    df_ec2_cons = pd.DataFrame(columns=['ResourceType', 'ResourceId', 'ProtectedByBackup'])


if 'VolumeId' in df_ebs.columns:
    ebs_list = df_ebs['VolumeId'].dropna().unique()
    df_ebs_cons = pd.DataFrame({
        'ResourceType': 'EBS',
        'ResourceId': ebs_list
    })
    df_ebs_cons['ProtectedByBackup'] = df_ebs_cons['ResourceId'].isin(df_prot_all['ResourceId']).map({True: 'YES', False: 'NO'})
else:
    df_ebs_cons = pd.DataFrame(columns=['ResourceType', 'ResourceId', 'ProtectedByBackup'])


if 'DBInstanceIdentifier' in df_rds.columns:
    rds_list = df_rds['DBInstanceIdentifier'].dropna().unique()
    df_rds_cons = pd.DataFrame({
        'ResourceType': 'RDS',
        'ResourceId': rds_list
    })
    df_rds_cons['ProtectedByBackup'] = df_rds_cons['ResourceId'].isin(df_prot_all['ResourceId']).map({True: 'YES', False: 'NO'})
else:
    df_rds_cons = pd.DataFrame(columns=['ResourceType', 'ResourceId', 'ProtectedByBackup'])

if 'TableName' in df_dynamo.columns:
    dynamo_list = df_dynamo['TableName'].dropna().unique()
    df_dynamo_cons = pd.DataFrame({
        'ResourceType': 'DynamoDB',
        'ResourceId': dynamo_list
    })
    protected_dynamo = df_prot_all[df_prot_all['ResourceType'] == 'DynamoDB']['ResourceName']
    df_dynamo_cons['ProtectedByBackup'] = df_dynamo_cons['ResourceId'].isin(protected_dynamo).map({True: 'YES', False: 'NO'})
else:
    df_dynamo_cons = pd.DataFrame(columns=['ResourceType', 'ResourceId', 'ProtectedByBackup'])

df_consolidado = pd.concat([
    df_ec2_cons,
    df_ebs_cons,
    df_rds_cons,
    df_dynamo_cons,
], ignore_index=True)


df_consolidado.to_csv('backup.xlsx', index=False)
print('Arquivo consolidado_protecao_backup.csv criado!')

for resource_type in resource_types:
    csv_files = glob.glob(f"{resource_type}_*.csv")
    for file in csv_files:
        os.remove(file)

print('Arquivos temporários CSV removidos.')
