# CyberArk AWS Cloud Package Release Notes

The AWS Cloud package includes CyberArk PAS products, delivered as AMIs and AWS CloudFormation templates to automate deployment.


## [10.7] (Release date 2019/01/23)

### Added
- Change deployment order to deploy the PVWA before CPM 
### Removed
- AIO template not released due to technical issue , will be released again in 10.8 


## [10.5] (Release date 2018/09/17)

### Added
- Deployment logs are sent to CloudWatch
- GovCloud support is added to all templates
- Improved cfn-signal
- Template validation for all AWS templates (CI/CD)

### Removed
- CloudFormation template to deploy PAS-AIO-Network

## [10.3] (Release date: 2018/05/21)

### Added
- CloudFormation templates to deploy a single component PVWA, CPM, PSM and PSMP
- CloudFormation templates to deploy the Primary Vault
- CloudFormation templates to deploy a DR Vault

### Changed
- Fix Vault application pool size 

## [9.10] (Release date: 2017/10/27)

### Added
- Adding verification fields for the Vault Administrator and Master account passwords in the template
- Adding All-in-one template that includes DR Vault deployment ,The new template name is : “PAS-all-in-one-dr-template” 
- Support for deploying CyberArk PAS v9.10 AMIs

### Changed
- Fix Vault server key could not be rotated in AWS KMS
- Fix DR Vault address is not configured in the components vault.ini file

