import os
import boto3

session = boto3.Session(profile_name=os.getenv('AWS_PROFILE', 'default'))
sts = session.client('sts', region_name=os.getenv('AWS_REGION', 'eu-central-1'))
print(sts.get_caller_identity())
