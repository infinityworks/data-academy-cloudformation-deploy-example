set -eu

#### CONFIGURATION SECTION ####
stack_name=team0
deployment_bucket=gen-team0-deployment
#### CONFIGURATION SECTION ####

# Delete deploy dir if exists for a clean start
if [ -d ".deployment" ]; then rm -rf .deployment; fi

# Pip install dependendies from requirements.txt to specific directory
pip install --target ./.deployment/dependencies -r requirements.txt
# Zip all installed dependencies into a deployment package
cd ./.deployment/dependencies
zip -r ../lambda-package.zip .
# Merge 'app' directory with python code into the deployment package zip
cd ../../src
zip -gr ../.deployment/lambda-package.zip app
cd ..

# Package template and upload local resources (deployment package zip) to S3
# A unique S3 filename is automatically generated each time
aws cloudformation package --template-file cloudformation.yml --s3-bucket ${deployment_bucket} --output-template-file .deployment/cloudformation-packaged.yml

# Deploy template
aws cloudformation deploy --stack-name ${stack_name}-ip-lambda --template-file .deployment/cloudformation-packaged.yml --region eu-west-1 --capabilities CAPABILITY_IAM --parameter-overrides NamePrefix=${stack_name} 