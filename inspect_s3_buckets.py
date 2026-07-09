import os
import boto3

session = boto3.Session(profile_name=os.getenv('AWS_PROFILE', 'default'))
s3 = session.client('s3', region_name=os.getenv('AWS_REGION', 'ap-southeast-1'))

buckets = s3.list_buckets()['Buckets']
print('ALL_BUCKETS')
for b in buckets:
    print(b['Name'])

print('MATCHING_REMOTE_STATE')
for b in buckets:
    if 'remote-state' in b['Name']:
        print(b['Name'])

for name in ['dev-proj-1-remote-state-527397543025', 'dev-proj-1-remote-state-bucket']:
    try:
        print('HEAD', name, s3.head_bucket(Bucket=name))
    except Exception as e:
        print('ERR', name, repr(e))
