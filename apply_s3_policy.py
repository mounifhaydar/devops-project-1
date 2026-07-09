import json
import os
import boto3

bucket = 'dev-proj-1-remote-state-bucket'
account_id = '527397543025'
policy = {
    'Version': '2012-10-17',
    'Statement': [
        {
            'Sid': 'TerraformStateAccess',
            'Effect': 'Allow',
            'Principal': {'AWS': f'arn:aws:iam::{account_id}:root'},
            'Action': ['s3:ListBucket', 's3:GetObject', 's3:PutObject', 's3:DeleteObject'],
            'Resource': [f'arn:aws:s3:::{bucket}', f'arn:aws:s3:::{bucket}/*'],
        }
    ],
}

session = boto3.Session(profile_name=os.getenv('AWS_PROFILE', 'default'))
s3 = session.client('s3', region_name=os.getenv('AWS_REGION', 'eu-central-1'))
response = s3.put_bucket_policy(Bucket=bucket, Policy=json.dumps(policy))
print(response)
