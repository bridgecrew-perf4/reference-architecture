import boto3
import json
def get_client(service):
  return boto3.client(service)

def check_defined(reference, reference_name):
  if not reference:
    raise Exception('Error: ', reference_name, 'is not defined')
  return reference

def is_oversized_changed_notification(message_type):
    check_defined(message_type, 'messageType')
    return message_type == 'OversizedConfigurationItemChangeNotification'

def get_configuration_item(invokingEvent):
  check_defined(invokingEvent, 'invokingEvent')
  if is_oversized_changed_notification(invokingEvent['messageType']):
    configurationItemSummary = check_defined(invokingEvent['configurationItemSummary'], 'configurationItemSummary')
    return get_configuration(configurationItemSummary['resourceType'], configurationItemSummary['resourceId'], configurationItemSummary['configurationItemCaptureTime'])
  return check_defined(invokingEvent['configurationItem'], 'configurationItem')

def is_applicable(configurationItem, event):
  try:
    check_defined(configurationItem, 'configurationItem')
    check_defined(event, 'event')
  except:
    return True
  status = configurationItem['configurationItemStatus']
  eventLeftScope = event['eventLeftScope']
  if status == 'ResourceDeleted':
    print("Resource Deleted, setting Compliance Status to NOT_APPLICABLE.")
  return (status == 'OK' or status == 'ResourceDiscovered') and not eventLeftScope

def evaluate_change_notification_compliance(configuration_item, rule_parameters):
  check_defined(configuration_item, 'configuration_item')
  check_defined(configuration_item['configuration'], 'configuration_item[\'configuration\']')
  if rule_parameters:
    check_defined(rule_parameters, 'rule_parameters')
  if (configuration_item['resourceType'] != 'AWS::EC2::Instance'):
    return 'NOT_APPLICABLE'
  elif rule_parameters.get('desiredInstanceType'):
    if (configuration_item['configuration']['instanceType'] in rule_parameters['desiredInstanceType']):
      return 'COMPLIANT'
  return 'NON_COMPLIANT'

def lambda_handler(event, context):
  root = check_defined(event, 'invokingEvent');
  ie    = json.loads(root['invokingEvent'])
  item  = ie['configurationItem']
  mtype = ie['messageType']
  print(f'AccountId:    {item["awsAccountId"]}')
  print(f'ResourceId:   {item["resourceId"]}')
  print(f'ResourceName: {item["resourceName"]}')
  print(f'ResourceType: {item["resourceType"]}')
  print(f'ARN:          {item["ARN"]}')
  print(f'Region:       {item["awsRegion"]}')
  print(f'AZ:           {item["availabilityZone"]}')
  print(f'MessageType:  {mtype}')

  #TODO: confirm is security group resource
  #TODO: evaluate inbound rule for ssh:22 and rdp:3389 as they are not compliant
  #TODO: handle response
  response = AWS_CONFIG_CLIENT.put_evaluations(
    Evaluations=[
      {
        'ComplianceResourceType': invoking_event['configurationItem']['resourceType'],
        'ComplianceResourceId': invoking_event['configurationItem']['resourceId'],
        'ComplianceType': compliance_value,
        'OrderingTimestamp': invoking_event['configurationItem']['configurationItemCaptureTime']
      },
    ],
     ResultToken=event['resultToken']
  )


if __name__ == "__main__":
  with open('item-change-event.json') as file:
    data = json.load(file)
  lambda_handler(data, None)
