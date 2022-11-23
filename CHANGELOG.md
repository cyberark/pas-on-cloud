# CyberArk AWS Cloud Package Release Notes

The AWS Cloud package includes CyberArk PAS products, delivered as AMIs and AWS CloudFormation templates to automate deployment.

## [PAS on Cloud v12.6] (21/8/2022)

### Added
- AWS : Windows Server 2019 compatibility for all Windows-based components (for PAS version 12.6 and above)
- AWS : CyberArk PAS release version selection within the CloudFormation parameters
- Azure : Windows Server 2019 compatibility for all Windows-based components (for PAS version 12.6 and above)
### Changed
- AWS: the required ImageIds are gathered on demand via a lambda function,
  the previously used ImageId mapping by region was removed


## [PAS on Cloud v12.2] (5/8/2021)

### Added
- AWS : PSMP now supports the usage of MFA
- AWS : PSMP CVE-2021-4034 fix
- Azure : ptaAccessSAS parameter as part of import-pas-images.ps1
### Changed
- AWS: PSMP is deployed on RHEL 8, instead of Amazon Linux 2
- AWS: PTA instance type changed to m5 options


## [PAS on Cloud v12.1] (18/10/2020)

### Added
- Support version 12.1


## [PAS on Cloud v12.0] (18/10/2020)

### Added
- Support version 12.0


## [PAS on Cloud v11.7] (18/10/2020)

### Added
- Support version 11.7


## [PAS on Cloud v11.6] (16/8/2020)

### Added
- Azure: Support for PTA


## [PAS on Cloud v11.5] (7/7/2020)

### Added
- Support for cross cloud and cross region Vault deployment


## [PAS on Cloud v11.4] (22/4/2020)

### Added
- Support version 11.4


## [PAS on Cloud v11.3] (22/3/2020)

### Added
- AWS: Vault AMI is available on Windows server 2016

### Changed
- AWS: New EC2 types are available for cost savings and performance improvements in the PAS components
- AWS: Simplify the cloud formation to make it more readable and user friendly
- Added support to private link network


## [PAS on Cloud v11.2] (14/1/2020)

### Added
- AWS: Update commercial 11.2 AMI ids
- AWS: Update gov cloud 11.2 AMI ids

### Changed
- Return error in case of registration failure (applies to all templates)
- CF script is stalling at the StoreMasterPassword and StoreAdminPassword stage (#00816191)


## [PAS on Cloud v10.10] (12/9/2019)

### Added
- AWS: Release 10.10 commercial
- AWS: Release 10.10 government (NAT network only)
- AWS: Add us-gov-east-1 region support (NAT network only)

### Changed
- Azure: Fixed Case Number 00730271 : Second PSMP deploy fails


## [PAS on Cloud v10.5] (20/9/2018)

### Added
- Deployment logs are sent to CloudWatch
- Templates support deployment on GovCloud
- Us-east-2 region to AWS templates
- Template to deploy single component on Azure in customer network

### Changed
- import-pas-images script  now accepts AccessSAS per component

### Removed
- PAS-AIO-Network CloudFormation template was removed 
