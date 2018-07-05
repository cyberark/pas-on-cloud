# Overview

CyberArk PAS CloudFormation templates were created to automate the deployment process of CyberArk Privileged Access Security AMIs. There are multiple templates to support a various deployment options, from a template that deploys a full environment to templates that provide you with the building blocks to deploy any type of architecture.

| CloudFormation Template Name | Description |
|------------------------------|-------------|
| PAS-network-environment-template | Creation of the network environment to support the Full-PAS-Deployment template deployment |
| Vault-Single-Deployment | Deploying a new primary Vault instance in an existing network environment |
| DRVault-Single-Deployment | Deploying a new DR Vault in an existing network environment |
| PAS-Component-Single-Deployment | Deploying a single PAS component CPM, PVWA, PSM or PSMP instance in an existing network environment |
| Full-PAS-Deployment | Deploying a full PAS environment, where each component is deployed in a separated instance (Vault, DR Vault, PVWA, CPM, PSM and PSMP) |
| PAS-AIO-network-environment-template | Creation of the network environment to support the PAS-AIO-Deployment template deployment |
| PAS-AIO-dr-template | Deploying PAS as an all in one configuration, where a single instance contain PVWA, PSM and CPM, Vault instance and DR Vault instance |
| PAS-AIO-template | Deploying PAS as an all in one configuration, where a single instance contain PVWA, PSM and CPM and Vault instance |

# Licensing
Copyright 1999-2018 CyberArk Software Ltd.

CyberArk’s Privileged Access Security is licensed under the following license terms - "PAS Eula.txt".
CyberArk’s PAS deployment CloudFormation templates are licensed under Apache License, Version 2.0 - "LICENSE.md".
