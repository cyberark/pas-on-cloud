# CyberArk AWS Cloud Package Release Notes

The AWS Cloud package includes CyberArk PAS products, delivered as AMIs and AWS CloudFormation templates to automate deployment.

## [PAS on Cloud v12.6.0] (Release date TBD)

### Added
- AWS : Added - Windows Server 2019 compatibility for all Windows-based components (for PAS version 12.6 and above)
- AWS : Added - CyberArk PAS release version selection within the CloudFormation parameters
- Azure : Added - Windows Server 2019 compatibility for all Windows-based components (for PAS version 12.6 and above)
### Changed
- AWS: the required ImageIds are gathered on demand via a lambda function,
  the previously used ImageId mapping by region was removed


## [PAS on Cloud v12.2.4] (8/3/2022)

### Added
- AWS : Added - PSMP now supports the usage of MFA
- AWS : Added - PSMP CVE-2021-4034 fix
- Azure : Added - ptaAccessSAS parameter as part of import-pas-images.ps1
### Changed
- AWS: PSMP is deployed on RHEL 8, instead of Amazon Linux 2
- AWS: PTA instance type changed to m5 options
