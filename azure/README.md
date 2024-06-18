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
As a prerequisite to deploy PAM components using the supplied ARM templates, customer must have the compatible images ready in a designated Resource Group in the destination subscription.

This can be achieved by downloading the import-pas-images.ps1 from CyberArk's Marketplace at:
https://cyberark.my.site.com/mplace/s/#software
You should navigate to "Privileged Access Manager Self-Hosted" matching your desired release version.
Under "PAM Self-Hosted on Cloud" > "Share Image on Cloud" > "Share PAM Self-Hosted on Azure", you'll be able to download the required PowerShell script.
Copy import-pas-images.ps1 script to your environment. You can copy it directly to Azure Cloud Shell or to the machine with defined access to your Azure account.
The detailed documentation and helpful notes can be found inside the script, it is already loaded with all the required AccessSAS URLs needed for PAM images import.

As an alternative, you are also offered the option to download a toolkit that will allow you to create PAM component images on your own,
under "PAM Self-Hosted on Cloud" > "Bring Your Own Image" > "PAM_Self-Hosted_on_Azure.zip".
If chosen to use this toolkit, your results would be in the form of an chosen PAM component image, which is ready to use as part of the ARM templates.


## In order to enable PTA with self sign certificate after successful installation please do the below:

Upload PTA self-sign certificate to PVWA server following this:
https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/PTA/Validating-Self-signed-Certificate-Browser.htm?tocpath=Installation%7CInstall%20PAS%7CInstall%20PTA%7CPTA%20Server%7CPTA%20Certificate%20Procedures%7C_____2
