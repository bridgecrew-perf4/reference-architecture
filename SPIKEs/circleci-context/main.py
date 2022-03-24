import os, time
from module1 import User, AccessKey, Circle

def print_user(user):
  print(f"User:")
  print(f"  UserName: {user.user_name}")
  for key in user.access_keys:
    print_key(key)

def print_key(key):
  print(f"  AccessKey:")
  print(f"    Id:           {key.access_key_id}")
  print(f"    Age:          {key.age}")
  print(f"    Expired:      {key.is_expired}")
  print(f"    Create Date:  {key.created_date.date()}")
  #print(f"    Secret:       {key.secret}")
  print(f"    Status:       {key.status}")
  print(f"    MaxKeyAge:    {key.max_key_age}")

# get user metadata
user = User(os.getenv('IAM_USER_NAME'))
print_user(user)

print(f"Checking to see if AccessKey(s) are expired")
if user.has_expired_access_keys:
  print(f"AccessKey(s) are expired, and they will now be removed")
  while len(user.access_keys) > 0:
    user.remove_access_key(user.access_keys[0])
  print(f"Creating a new AccessKey")
  key = user.create_access_key()
  print_key(key)
  contexts = os.getenv("CIRCLECI_CONTEXT").split(',')
  for context in contexts:
    circle = Circle(os.getenv("CIRCLECI_ORG"), context)
    print("Updating Secret: AWS_ACCESS_KEY_ID")
    circle.remove_secret("AWS_ACCESS_KEY_ID")
    circle.store_secret("AWS_ACCESS_KEY_ID", key.access_key_id)
    print("Updating Secret: AWS_SECRET_ACCESS_KEY")
    circle.remove_secret("AWS_SECRET_ACCESS_KEY")
    circle.store_secret("AWS_SECRET_ACCESS_KEY", key.secret)
