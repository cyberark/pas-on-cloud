# Overview

CyberArk PAS AzureRM templates were created to automate the deployment process of CyberArk Privileged Access Security Images. There is individual component deployment template that provides you with the building blocks to deploy any type of architecture.

| AzureRM Template Name | Description | Deploy |
|-----------------------|-------------|--------|
| pas-full-network | Creation of the network environment to support the full PAS deployment | <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcyberark%2Fpas-on-cloud%2Fmaster%2Fazure%2Fpas-full-network.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a> |
| pas-single-component-deploy | Deploying a single PAS component CPM, PVWA, PSM or PSMP instance in an existing network environment |  <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcyberark%2Fpas-on-cloud%2Fmaster%2Fazure%2Fpas-single-component-deploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a> |
| pas-vault-deploy | Deploying the vault instance in the pas-full-network | <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcyberark%2Fpas-on-cloud%2Fmaster%2Fazure%2Fpas-vault-deploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a> |
| pas-dr-deploy | Deploying the vault DR instance in the pas-full-network | <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcyberark%2Fpas-on-cloud%2Fmaster%2Fazure%2Fpas-dr-deploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a> 
| pas-pta-deploy | Deploying the PTA instance in an existing network environment | <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcyberark%2Fpas-on-cloud%2Fmaster%2Fazure%2Fpas-pta-deploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a> |

# Sharing CyberArk PAS Images
In order to simplify deployment of Core PAS components in Azure Cyberark has developed an Azure image sharing script.
The script imports CyberArk Azure images to the customer account.
These images later can be used together with deployment scripts above in order to deploy CyberArk Core PAS.
To copy CyberArk Privileged Access Security solution snapshot and create the images in your Azure subscription, use the import-pas-images.ps1 PowerShell script. Make sure you have all the CyberArk components AccessSAS URLs before executing the script.

## Usage
As a first step customer must receive components AccessSAS.
Copy import-pas-images.ps1 script to your environment. You can copy it directly to Azure Cloud Shell or to the machine with defined access to your Azure account.

import-pas-images.ps1 -location "<Desired Azure location>" [-release] "<PAS release>" [-winVersion] "<Win2016 / Win2019>" [-storageName] "<Custom Storage account>" [-containerName] "<Custom Container>" [-resourceGroupName] "<Custom Resource Group>" [-vaultAccessSAS] "<pas-vault-vXX.X AccessSAS>"
[-vaultDataDiskAccessSAS] "<pas-vaultDataDisk-vXX.X AccessSAS>" [-pvwaAccessSAS] "<pas-pvwa-vXX.X AccessSAS>" [-cpmAccessSAS] "<pas-cpm-vXX.X AccessSAS>"
[-psmAccessSAS] "<pas-psm-vXX.X AccessSAS>" [-psmpAccessSAS] "<pas-psmp-vXX.X AccessSAS>" [-ptaAccessSAS] "<pas-pta-vXX.X AccessSAS>"

Parameters:

| Parameter Name          | Required | Default              | Comments |
|-------------------------|----------|----------------------|----------|
| location                | Yes      | None                 |          |
| release                 | No       | **v13.0**            |          |
| winVersion              | No       | **win2016**          |          |
| storageName             | No       | **cyberarkimages**   |          |
| containerName           | No       | **cyberarkimages**   |          |
| resourceGroupName       | No       | **Cyberark-Images**  |          |
| vaultAccessSAS          | No       | None                 |          |
| vaultDataDiskAccessSAS  | No       | None                 |          |
| pvwaAccessSAS           | No       | None                 |          |
| cpmAccessSAS            | No       | None                 |          |
| psmAccessSAS            | No       | None                 |          |
| psmpAccessSAS           | No       | None                 |          |
| ptaAccessSAS            | No       | None                 |          |

## Notes:
- "release" and "winVersion" parameters are being used in the naming of the vhd files and images created, 
  it is recommended to specify those to get accurately described images ("winVersion" is irrelevant if only pta/psmp are being imported).
- "storageName", "containerName" and "resourceGroupName" are defaulted to "cyberarkimages", "cyberarkimages" and "Cyberark-Images" respectivly,
  and the required objects will be created automatically if needed. Use these only in case you desire to place them in a custom location.
- "vaultAccessSAS" and "vaultDataDiskAccessSAS" are binded together, you must specify both of them or none of them.


## In order to enable PTA with self sign certificate after successful installation please do the below:

Upload PTA self-sign certificate to PVWA server following this:
https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/PTA/Validating-Self-signed-Certificate-Browser.htm?tocpath=Installation%7CInstall%20PAS%7CInstall%20PTA%7CPTA%20Server%7CPTA%20Certificate%20Procedures%7C_____2
