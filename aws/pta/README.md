# Overview

CyberArk PTA-AWS-Solution-Deployment CloudFormation templates was created to automate the deployment process of PTA-AWS solution. 

# Lambdas Bucket

Before running the template, create a dedicated bucket in the region where you are deploying the CloudFormation stack, with the following files:
- MySnsToPta.zip
- PtaCloudTrailToSns.zip

# Permissions

The user that runs the template needs to have the following permissions:
- Deploy CloudFormation
- S3 full permissions
- SNS full permissions
- Deploy Lambda 
- Create IAM roles

# Network

The solution sends syslogs to the pta on port 11514 and protocol TCP.
In case that PTA was configured diffrentely, then the solution needs to be configured accordingly.
Two main points of connection failure can be at Security Group  or Lambda:
- Make sure that the desierd port and protocol are open in MySnsToPta Lambda's Security Group
- Choose the correct Port when deploying the solution

Note: there must be a connection between the solution VPC to the PTA network.

# Parameters

| Name | Description | Default | 
|------------------------------|-------------|-------------|
| PTA IP | Enter the PTA IP Address | |
| PTA Port | Enter the PTA Port for delivering logs | 11514 |
| VPC | Select the VPC Id where the current PTA resides | |
| Subnet | Select the VPC Id where the current PTA resides| |
| Lambdas Bucket | Enter the bucket name that contains the lambda's zip files| |

# Troubleshooting

Each AWS Lambda - MySnsToPta, PtaCloudTrailToSns has its own logs. In your AWS Account, go to Lambda Service and choose the lambda to display. Press Monitor to view the Lambda's metrics or you can press 'View logs in CloudWatch' to see the Lambda's logs.