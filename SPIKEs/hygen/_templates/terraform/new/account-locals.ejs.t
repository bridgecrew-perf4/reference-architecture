---
to: terraform/account/locals.tf
---
locals {
  account_ids = {
    lower = "<%= locals.lower_account %>" # TODO: replace lower account_id and optionally rename `lower` to match your desired workspace
    upper = "<%= locals.upper_account %>"# TODO: repeat above step
  }
}
