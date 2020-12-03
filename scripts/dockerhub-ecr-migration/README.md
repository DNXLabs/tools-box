# Docker Hub ECR Migration

Simple python script to migrate all images from Docker Hub to public ECR.

## Dependencies

- Python >= 3

## Usage

1. Retrieve an authentication token and authenticate your Docker client to your registry.

```bash
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws
```

2. Run the script
```
python main.py
```