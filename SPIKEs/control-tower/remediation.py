import boto3
import datetime
import json

def compliance():
    client = boto3.client('config')
    security_groups = boto3.client('ec2')
    r = boto3.resource('ec2')

    print ('Fixing non compliant resource %s' % datetime.datetime.now())

    compliance = c.describe_compliance_by_resource(
       ResourceType = 'AWS::EC2::SecurityGroup',
       ComplianceTypes = ['NON_COMPLIANT']
     )
    print (Compliance)

    sBucket = bCompliance['ComplianceByResources']

    for sb in sBucket:
        print ("---Bucket with Public write permissions---")
        print (sb)
        print ("---Bucket Name---")
        print (sb['ResourceId'])
        bn = sb['ResourceId']
        sb = b.put_bucket_acl(
            ACL = 'private',
            Bucket = bn
        )
    print ('---Bucket was fixed successfully---')


def lambda_handler(event, context):
    compliance()
