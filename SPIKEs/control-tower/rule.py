import boto3
import json

def check_defined(reference, reference_name):
  if not reference:
    raise Exception('Error: ', reference_name, 'is not defined')
  return reference

def check_security_group_rules(groupId):
  e = boto3.resource('ec2')
  sg = e.SecurityGroup(groupId)

  is_compliant = True

  # check for non-compliacne ports, etc...
  for rule in sg.ip_permissions:
    # restrict: SSH:22
    # restrict: RDP:3389
    if rule['FromPort'] == rule['ToPort'] and rule['FromPort'] in [22, 3389]:
      is_compliant = False
      for range in rule['IpRanges']:
        print(f'NonCompliantRule - FromPort: {rule["FromPort"]}, ToPort: {rule["ToPort"]}, Rnage: {range["CidrIp"]}')
      for range in rule['Ipv6Ranges']:
        print(f'NonCompliantRule - FromPort: {rule["FromPort"]}, ToPort: {rule["ToPort"]}, Rnage: {range["CidrIpv6"]}')

    # anywhere?
    # only: http:80
    # only: https:443
    for range in rule['IpRanges']:
      if range['CidrIp'] in ['0.0.0.0/0']:
        if rule['FromPort'] not in [80, 443] or rule['ToPort'] not in [80, 443]:
          is_compliant = False
          print(f'NonCompliantRule - FromPort: {rule["FromPort"]}, ToPort: {rule["ToPort"]}, Rnage: {range["CidrIp"]}')
    for range in rule['Ipv6Ranges']:
      if range['CidrIpv6'] in ['::/0']:
        if rule['FromPort'] not in [80, 443] or rule['ToPort'] not in [80, 443]:
          is_compliant = False
          print(f'NonCompliantRule - FromPort: {rule["FromPort"]}, ToPort: {rule["ToPort"]}, Rnage: {range["CidrIpv6"]}')
  # if no traps catch the rule then we can simply return as compliant
  if is_compliant:
    return 'COMPLIANT'
  else:
    return 'NON_COMPLIANT'

def lambda_handler(event, context):

  # print out the entire event for troubleshooting purposes
  print('Printing raw JSON event for troubleshooting purposes')
  print(json.dumps(event, indent=2))

  # check to see if the invokingEvent element is present or throw an exception
  print('Checking for invokingEvent element')
  check_defined(event, 'invokingEvent');

  # parse the invokingEvent field as JSON data
  print('Parsing invokingEvent JSON data')
  invokingEvent = json.loads(event['invokingEvent'])

  # check to see if the invokingElement contains a configurationItem element or throw an exception
  print('Checking for configurationItem element')
  check_defined(invokingEvent, 'configurationItem')

  # ez access to configurationItem
  print('Getting handle to configurationItem element')
  item = invokingEvent["configurationItem"]

  # ez access to configurationItem properties
  az = item["availabilityZone"]
  arn = item["ARN"]
  region = item["awsRegion"]
  status = item["configurationItemStatus"]
  accountId = item["awsAccountId"]
  resourceId = item["resourceId"]
  messageType = invokingEvent['messageType']
  captureTime = item["configurationItemCaptureTime"]
  resourceName = item["resourceName"]
  resourceType = item["resourceType"]

  # display resource information on the resource that triggered the event
  print(f'AZ:           {az}')
  print(f'ARN:          {arn}')
  print(f'AccountId:    {accountId}')
  print(f'ResourceId:   {resourceId}')
  print(f'ResourceName: {resourceName}')
  print(f'ResourceType: {resourceType}')
  print(f'Region:       {region}')
  print(f'Status:       {status}')
  print(f'MessageType:  {messageType}')

  # set a default compliance type for the response
  compliance_type = 'NOT_APPLICABLE'

  # check if the resource is being deleted
  if status != "ResourceDeleted":
    # based on the resource type take an appropriate action
    if resourceType == "AWS::EC2::SecurityGroup":
      compliance_type = check_security_group_rules(resourceId)
    else:
      raise Exception('Error: ', resourceType, 'is not a supported resource type, please modify your code')

  print(compliance_type)

  config = boto3.client('config')
  response = change.put_evaluations(
    Evaluations=[
      {
        'ComplianceResourceType': resourceType,
        'ComplianceResourceId': resourceId,
        'ComplianceType': compliance_type,
        'OrderingTimestamp': captureTime
      },
    ],
    ResultToken=event['resultToken']
  )


if __name__ == "__main__":
  with open('item-change-event.json') as file:
    data = json.load(file)
  lambda_handler(data, None)
