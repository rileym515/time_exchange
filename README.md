# Time Exchange

This repo contains all of the code required to deploy the Time Exchange - a basic API which takes a single input of a persons name and returns a greeting and the current time.

### Directory structure

- application: Application code to be deployed to Lambda.
- artifacts: Directory for deployment artifacts used by the pipeline - README file ensures this directory is included in source control.
- buildspecs: Buildspec files for each CodeBuild job used in the pipeline.
- tester: Python script used to test the API functionality post deployment.
- tfscaffold: All Terraform code to deploy the pipeline and the infrastructure for the application.

### Terraform Scaffold

This project uses Terraform Scaffold to manage deployed AWS resources. Scaffold is an open source project which manages the remote state for all Terraform resources and provides a logical directory structure for the codebase.
https://github.com/tfutils/tfscaffold

Scaffold also uses tfenv which is a resource for managing different versions of Terraform - see the infra buildspec for the install steps.
https://github.com/tfutils/tfenv

## Deployment

### Prerequisites 

*All commands below assume working in region us-east-2 - change as appropriate*

Authenticated access to an AWS account via CLI with an Administrator IAM permissions

Clone the repo to local machine and edit tfscaffold/etc/global.tfvars
- Set aws_account_id to the account number in which you are working
- Set the region as required for bootstrap

*You will need the appropriate versions of Terraform installed locally to complete the bootstrap and pipeline deployments. The required versions can be found in .terraform-version files in the relative directories. Alternatively you can use tfenv as the pipeline does to get the right version of Terraform installed.*

#### Bootstrap Terraform
This process is done to create an S3 bucket in the account to store TF state files

Change directory into the tfscaffold directory
- cd tfscaffold

Run bootstrap plan
- bash bin/terraform.sh -p risk101 -r us-east-2 --bootstrap -a plan --

Check the bootstrap plan is creating an S3 bucket and if it looks OK then apply
- bash bin/terraform.sh -p risk101 -r us-east-2 --bootstrap -a apply --

#### Deploy pipeline

The pipeline and supporting components are deployed from a local machine much like bootstrapping.

Change directory into the tfscaffold directory
- cd tfscaffold

Run a plan to check what is being deployed - this includes IAM roles, CodePipeline, CodeBuild jobs and an S3 bucket for pipeline artifacts
- bin/terraform.sh -a plan -p risk101 -r us-east-2 -c pipeline -e dev1 -w --

If everything looks as expected then apply
- bin/terraform.sh -a apply -p risk101 -r us-east-2 -c pipeline -e dev1 -w --

Once the apply of the pipeline component is complete you can check for the resources using either the AWS CLI or console.

*Once the pipeline apply is complete there is a manual step to complete the configuration of the CodeStar Connection which has been created to allow the pipeline to pull the repo from GitHub*
https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-update.html
Note the initial creation of an AWS CodePipeline job triggers the job to run but it will fail to checkout the code until the above step is complete.

#### Infra and Application

Once the pending connection has been completed then you can run the CodePipeline job from the console or CLI

The infra component (in tfscaffold) has all the resources for the application - these are deployed by the pipeline.

There is a simple automated test at the end of the pipeline to check the API Gateway response.
- There seems to be a bug which means that the test will fail to get the API key on the initial run of the pipeline - this is inconsistent and if it does happen a rerun of the pipeline seems to reolve it.

### Clean up

To destroy all resources you will need to run the following locally as the pipeline does not have a destroy option

*Creating a zip file is required for the plan-destory as Terraform expects this because the Lambda code does a base64 comparison on the artifact*

Destroy _infra_ resources - creating artifact for plan is required
- cd application
- zip ../artifacts/script.zip time_exchange.py
- cd ../tfscaffold
- bash bin/terraform.sh -a plan-destroy -p risk101 -r us-east-2 -c infra -e dev1 -w -- -var="compiled_python=../../../artifacts/script.zip"

Check the plan and destroy
- bash bin/terraform.sh -a destroy -p risk101 -r us-east-2 -c infra -e dev1 -w -- -var="compiled_python=../../../artifacts/script.zip"

Destroy pipeline
- cd ../tfscaffold
- bash bin/terraform.sh -a plan-destroy -p risk101 -r us-east-2 -c pipeline -e dev1 -w --

Check the plan and destroy
- bash bin/terraform.sh -a destroy -p risk101 -r us-east-2 -c pipeline -e dev1 -w --

*Bootstrap resources must be destroy manually either in the console or via CLI*
