# CyberArk CloudFormation Templates

The following CloudFormation templates were created to automate the deployment process of CyberArk PAS AMIs. There are multiple templates that was created to provide the

| CloudFormation Template Name | Description |
|------------------------------|-------------|
| PAS-network-environment-template | Creation of the network environment to support the Full-PAS-Deployment template deployment |
| Vault-Single-Deployment | Deploying a new primary Vault instance in an existing network environment |
| DRVault-Single-Deployment | Deploying a new DR Vault in an existing network environment |
| PAS-Component-Single-Deployment | Deploying a single PAS component CPM, PVWA, PSM or PSMP instance in an existing network environment |
| PAS-all-in-one-dr-template | Deploying PAS as an all in one configuration, where a single instance contain PVWA, PSM and CPM, Vault instance and DR Vault instance |
| Full-PAS-Deployment | Deploying a full PAS environment, where each component is deployed in a separated instance (Vault, DR Vault, PVWA, CPM, PSM and PSMP) |
| PAS-all-in-one-template | Deploying PAS as an all in one configuration, where a single instance contain PVWA, PSM and CPM and Vault instance |
