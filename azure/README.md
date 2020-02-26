# Overview

CyberArk PAS AzureRM templates were created to automate the deployment process of CyberArk Privileged Access Security Images. There is individual component deployment template that provides you with the building blocks to deploy any type of architecture.

| AzureRM Template Name | Description | Deploy |
|-----------------------|-------------|--------|
| pas-full-network | Creation of the network environment to support the full PAS deployment | <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcyberark%2Fpas-on-cloud%2Fmaster%2Fazure%2Fpas-full-network.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a> |
| pas-single-component-deploy | Deploying a single PAS component CPM, PVWA, PSM or PSMP instance in an existing network environment |  <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcyberark%2Fpas-on-cloud%2Fmaster%2Fazure%2Fpas-single-component-deploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a> |
| pas-vault-deploy | Deploying the vault instance in the pas-full-network | <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcyberark%2Fpas-on-cloud%2Fmaster%2Fazure%2Fpas-vault-deploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a> |
| pas-dr-deploy | Deploying the vault DR instance in the pas-full-network | <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcyberark%2Fpas-on-cloud%2Fmaster%2Fazure%2Fpas-dr-deploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a> |

# Sharing CyberArk PAS Images
To copy CyberArk Privileged Access Security solution snapshot and create the images in your Azure subscription, use the import-pas-images.ps1 PowerShell script. Make sure you have all the CyberArk components AccessSAS URLs before executing the script.
