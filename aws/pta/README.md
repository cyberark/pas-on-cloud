# Overview

CyberArk PTA-AWS-Solution-Deployment CloudFormation templates was created to automate the deployment process of PTA-AWS solution. 

# Lambdas Bucket

Before running the template, create a dedicated bucket in the region where you are deploying the CloudFormation stack, with the following files:
MySnsToPta.zip - contains the lambda from \dist\


| Name | Description | Default | 
|------------------------------|-------------|-------------|
| PTA IP | Enter the PTA IP Address | |
| PTA Port | Enter the PTA Port for delivering logs | 11514 |
| VPC | Select the VPC Id where the current PTA resides | |
| Subnet | Select the VPC Id where the current PTA resides| |
| Lambdas Bucket | Enter the bucket name that contains the lambda's zip files| |

