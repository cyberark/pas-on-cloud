# CyberArk PAMonCloud Offering Release Notes
The PAMonCloud Offering includes CyberArk PAM products, delivered as AWS AMIs and Azure images, along with AWS CloudFormation and Azure ARM templates to automate deployment.


## [PAMonCloud v15.0] (15.12.2025)

### Changed
- #### AWS : 
    - Fixed DR secret parameter constraint

## [PAMonCloud v14.6] (30.6.2025)

### Changed
- #### AWS : 
    - Component Image ID parameters, which were previously optional, are now required.
    - CPM single deployment now required PVWA's IP address to be inserted as a parameter.

### Removed
- #### AWS : 
    - Premade PAM images are no longer distributed. PAM Images can be obtained by using PAMonCloud's image building solution.
    - Removed usage of GetLatestAMILambda.
    - The following parameters have been removed from all relevant templates: 'WinVersion', 'CyberarkAccountId'

## [PAMonCloud v14.4] (11.12.2024)

### Added
- Windows Server 2022 images are now available for all Windows based components.
- New Terraform deployment offering: The PAMonCloud solution is now available in Terraform for both Azure and AWS, offering more flexibility, self-tailored configurations, cross-region deployments, and the benefits of using the IaC platform. PAMonCloud-terraform modules and examples are publicly available at: [PAMonCloud-Terraform](https://github.com/cyberark/pamoncloud-terraform)

### Changed
- #### AWS : 
    - Product configuration and registration are now executed as part of the instance's userdata, rather than CloudFormation::Init.
    - Product configuration and registration failures are tracked and raised in real-time, rather than only at stack timeout.
    - Enhanced CloudWatch logging for better observability during deployment.
    - Deployment and configuration time for Windows-based components has been significantly reduced.

### Removed
- #### Azure : 
    - Removed usage of ManagedIdentityExtensionForWindows.
- Windows components are no longer published based on Windows Server 2016. You can create Win2016-based images using the BYOI solution to suit your needs (subject to product system requirements).

## [PAMonCloud v14.2] (18.6.2024)

### Changed
- #### AWS : 
    - Lambda functions are running using Python 3.11
    - Patches for PAM products will be distributed and supported as images for new deployments.

- PTA & PSMP are deployed on RHEL 9, instead of RHEL 8

## [PAS on Cloud v14.0] (11.1.2024)

### Added
- Support PAS version 14.0
### Changed
- #### AWS :
    - Updated EC2 instance size options to match CyberArk PAS products system requirements.
    - Minor bug fixes
- #### Azure : 
    - Updated Azure default VM sizes to match CyberArk PAS products system requirements.
### Removed
- PAS-AIO-DR-Deployment CloudFormation template was removed 

## [PAS on Cloud v13.2] (14.6.2023)

### Added
- #### AWS :
    - Custom AMI as Parameter - A new optional parameter has been added to the CloudFormation templates, allowing customers to enforce the usage of a       specific AMI ID for each PAS component.
- #### Azure :
    - Support Non-Zone Regions - Customers now have the ability to deploy all components (excluding the Primary Vault) in non-zone regions.
### Changed
- #### AWS :
    - PTA Deployment as Part of the Full PAS and Single Component Deployments - Unified templates have been developed to deploy PTA in the same             manner as all other PAS components.

- PTA Does Not Require Its Own License - Uploading a PTA license to an S3 bucket/storage blob and providing it to the CF/ARM template is no longer     necessary.
- PTA and Vault Timezones are automatically configured for PTA deployments, the parameters where removed from the CF/ARM template.

## [PAS on Cloud v13.0] (19.12.2022)

### Changed
- #### AWS : 
    - Improved parameter validation
    - Lambda functions are running using Python 3.7
    - Vault disks are now encrypted

- PTA is deployed on RHEL 8, instead of Centos 7
- Vault safe data is being stored in a separated drive (E:)


## [PAS on Cloud v12.6] (21/8/2022)

### Added
- AWS : Windows Server 2019 compatibility for all Windows-based components (for PAS version 12.6 and above)
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
