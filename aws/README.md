# Overview

CyberArk PAS CloudFormation templates were created to automate the deployment process of CyberArk Privileged Access Security AMIs. There are multiple templates to support a various deployment options, from a template that deploys a full environment to templates that provide you with the building blocks to deploy any type of architecture.

| CloudFormation Template Name | Description |
|------------------------------|-------------|
| PAS-network-environment-NAT | Creation of a NAT network environment to support the Full-PAS-Deployment template deployment |
| PAS-network-environment-PrivateLink | Creation of a PrivateLink network environment to support the Full-PAS-Deployment template deployment |
| Vault-Single-Deployment | Deploying a new primary Vault instance in an existing network environment |
| DRVault-Single-Deployment | Deploying a new DR Vault in an existing network environment |
| PAS-Component-Single-Deployment | Deploying a single PAS component CPM, PVWA, PSM, PSMP or PTA instance in an existing network environment |
| Full-PAS-Deployment | Deploying a full PAS environment, where each component is deployed in a separated instance (Vault, DR Vault, PVWA, CPM, PSM, PSMP and PTA) |
| PAS-AIO-DR-Deployment | Deploying PAS as an all in one configuration, where a single instance contain PVWA, PSM and CPM, Vault instance and DR Vault instance |

## In order to enable PTA after successful installation please do the below:

If you are using self sign certificate, upload PTA self-sign certificate to PVWA server following this:
https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/PTA/Validating-Self-signed-Certificate-Browser.htm?tocpath=Installation%7CInstall%20PAS%7CInstall%20PTA%7CPTA%20Server%7CPTA%20Certificate%20Procedures%7C_____2
