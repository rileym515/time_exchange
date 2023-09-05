# bootstrap

This component manages the S3 bucket and associated KMS used to stor Terraform state _per account_

## Running bootstrap
The referenced vars file has the account ID, region and group as a minimum.

bash bin/terraform.sh -p mprhomelab -r us-east-2 --bootstrap -a apply -w -- --var-file=../etc/group_mpr02.tfvars

## mprhomelab execptions

To save money my homelab does not do the following ...
- Create a KMS key to encrypt the bucket - it is simply not necessary as there is no sensitive data
- Encrypt the S3 bucket as above this is not required and we don't have key to do it with

_Note: KMS key rotation is also disabled because AWS retains old keys to unencrypt long lived objects. Thus you pay $1 per key including keys which have been rotated out e.g. by year 3 it will be $3 for KMS keys
