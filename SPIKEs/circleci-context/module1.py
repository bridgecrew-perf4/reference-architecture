import boto3, os, time
from datetime import date

DEFAULT_MAX_KEY_AGE = 90

class Circle:
  def __init__(self, org_name, context_name):
    self.context_name = context_name
    self.org_name = org_name

  def remove_secret(self, key):
    os.system(f"circleci context remove-secret gh {self.org_name} {self.context_name} {key}")

  def store_secret(self, key, secret):
    os.system(f"echo '{secret}' | circleci context store-secret gh {self.org_name} {self.context_name} {key}")

class AccessKey:
  def __init__(self, access_key_id, user_name, created_date, status, secret = None):
    self.access_key_id = access_key_id
    self.age = (date.today() - created_date.date()).days
    self.max_key_age = int(os.getenv("MAX_KEY_AGE", DEFAULT_MAX_KEY_AGE))
    self.client = boto3.client("iam")
    self.created_date = created_date
    self.status = status
    self.user_name = user_name
    self.secret = secret
    self.is_expired = self.age >= self.max_key_age

  def enable(self):
    print(f"AccessKey {self.access_key_id} enable() -> start")
    response = self.client.update_access_key(UserName=self.user_name, AccessKeyId=self.access_key_id, Status="Active")

  def disable(self):
    print(f"AccessKey {self.access_key_id} disable() -> start")
    response = self.client.update_access_key(UserName=self.user_name, AccessKeyId=self.access_key_id, Status="Inactive")

  def delete(self):
    print(f"AccessKey {self.access_key_id} delete() - start")
    self.client.delete_access_key(UserName=self.user_name, AccessKeyId=self.access_key_id)

class User:
  def __init__(self, user_name):
    self.client = boto3.client("iam")
    self.user_name = user_name
    self.access_keys = []
    self._load_access_keys()

  def _load_access_keys(self):
    pager = self.client.get_paginator("list_access_keys")
    for page in pager.paginate(UserName=self.user_name):
      for item in page["AccessKeyMetadata"]:
        self.access_keys.append(AccessKey(item["AccessKeyId"], item["UserName"], item["CreateDate"], item["Status"]))

  def has_expired_access_keys(self):
    return any([k for k in self.access_keys if k.is_expired])

  def remove_access_key(self, key):
    key.disable()
    time.sleep(2) # lot some time between actions
    key.delete()
    time.sleep(2) # lot some time between actions
    self.access_keys.remove(key)

  def create_access_key(self):
    response = self.client.create_access_key(UserName=self.user_name)
    item = response["AccessKey"]
    key = AccessKey(item["AccessKeyId"], item["UserName"], item["CreateDate"], item["Status"], item["SecretAccessKey"])
    self.access_keys.append(key)
    return key


