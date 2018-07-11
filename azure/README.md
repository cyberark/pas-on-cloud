# Overview

CyberArk PAS AzureRM templates were created to automate the deployment process of CyberArk Privileged Access Security Images. There are multiple templates to support a various deployment options, from a template that deploys a full environment to templates that provide you with the building blocks to deploy any type of architecture.

| AzureRM Template Name | Description |
|------------------------------|-------------|
| pas-hybrid-network | Creation of the network environment to support the hybrid PAS deployment |
| pas-single-component | Deploying a single PAS component CPM, PVWA, PSM or PSMP instance in an existing network environment |

## Sharing CyberArk PAS Images
To copy CyberArk Privileged Access Security solution snapshot and create the images in your Azure subscription, use the import-pas-images.ps1 PowerShell script. Make sure you have the CyberArk components AccessSAS and CyberArk PSMP AccessSAS URLs before executing the script.