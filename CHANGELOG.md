# CyberArk AWS Cloud Package Release Notes

The AWS Cloud package includes CyberArk PAS products, delivered as AMIs and AWS CloudFormation templates to automate deployment.

## [PAS on Cloud v13.0.0] (Release date TBD)

### Added
- AWS : Added - Windows Server 2019 compatibility for all Windows-based components (for PAS version 12.2 and above)
- AWS : Added - CyberArk PAS release version selection within the CloudFormation parameters
- Azure : Added - Windows Server 2019 compatibility for all Windows-based components (for PAS version 12.2 and above)
- Azure : Added - ptaAccessSAS parameter as part of import-pas-images.ps1
### Changed
- AWS: the required ImageIds are gathered on demand via a lambda function,
  the previously used ImageId mapping by region was removed