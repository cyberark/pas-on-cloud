PARAM(
    [Parameter(Mandatory=$false)]
    [String] $templateBaseURL =       "https://s3.eu-west-2.amazonaws.com/pester-tests"
)

Describe "Vault-Single-Deployment.json" {
    Describe "Structure Validation Suite" {
        $script:templateSummary = @{}
        $script:parametersCounter = 0
        It "Validate template structure" {
            $validationError = @{}
            $script:templateSummary = Get-CFNTemplateSummary -TemplateURL "$templateBaseURL/Full-PAS-Deployment.json" -ErrorVariable validationError
            $validationError.Count | Should -Be 0
            $script:templateSummary.Parameters.Count | Should -Be 32
        }
        It "Validate EULA parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "EULA"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "Decline"
            $currentParam.Description | Should -BeExactly "I have read and agree to the Terms and Conditions."
            $currentParam.ParameterConstraints.AllowedValues | Should -Be @('Accept', 'Decline')
            $script:parametersCounter++
        }
        It "Validate KeyName parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "KeyName"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Select an existing Key Pair from your AWS account."
            $currentParam.ParameterType | Should -Be "AWS::EC2::KeyPair::KeyName"
            $script:parametersCounter++
        }
        It "Validate VaultFilesBucket parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "VaultFilesBucket"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Enter the name of the bucket containing the license and recovery public key."
            $script:parametersCounter++
        }
        It "Validate LicenseFile parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "LicenseFile"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "license.xml"
            $currentParam.Description | Should -BeExactly "Enter the path of the license file within the bucket."
            $script:parametersCounter++
        }
        It "Validate RecoveryPublicKey parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "RecoveryPublicKey"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "recpub.key"
            $currentParam.Description | Should -BeExactly "Enter the path of the recovery public key file within the bucket."
            $script:parametersCounter++
        }
        It "Validate VaultInstanceName parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "VaultInstanceName"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "CyberArk Vault"
            $currentParam.Description | Should -BeExactly "Enter a name for the Vault instance."
            $script:parametersCounter++
        }
        It "Validate VaultMasterPassword parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "VaultMasterPassword"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.NoEcho | Should -Be "True"
            $currentParam.Description | Should -BeExactly "Enter a password for the Vault Master user."
            $script:parametersCounter++
        }
        It "Validate RetypeMasterPassword parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "RetypeMasterPassword"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.NoEcho | Should -Be "True"
            $currentParam.Description | Should -BeExactly "Retype the password for the Vault Master user."
            $script:parametersCounter++
        }
        It "Validate VaultAdminPassword parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "VaultAdminPassword"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.NoEcho | Should -Be "True"
            $currentParam.Description | Should -BeExactly "Enter a password for the Vault Administrator user."
            $script:parametersCounter++
        }
        It "Validate RetypeAdminPassword parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "RetypeAdminPassword"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Retype the password for the Vault Administrator user."
            $currentParam.NoEcho | Should -Be "True"
            $script:parametersCounter++
        }
        It "Validate VaultDRPassword parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "VaultDRPassword"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.NoEcho | Should -Be "True"
            $currentParam.Description | Should -BeExactly "Enter a password for the Vault DR user."
            $script:parametersCounter++
        }
        It "Validate RetypeDRPassword parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "RetypeDRPassword"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Retype the password for the Vault DR user."
            $currentParam.NoEcho | Should -Be "True"
            $script:parametersCounter++
        }
        It "Validate VaultInstanceType parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "VaultInstanceType"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "m4.large"
            $currentParam.Description | Should -BeExactly "Select the instance type of the Vault instance."
            $currentParam.NoEcho | Should -Be "False"
            $currentParam.ParameterConstraints.AllowedValues | Should -Be @('m4.large', 'm4.xlarge', 'm4.2xlarge', 'm4.4xlarge')
            $script:parametersCounter++
        }
        It "Validate VaultInstanceSecurityGroups parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "VaultInstanceSecurityGroups"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Assign Security Groups to the Vault and Vault DR instances."
            $currentParam.ParameterType | Should -Be "List<AWS::EC2::SecurityGroup::Id>"
            $script:parametersCounter++
        }
        It "Validate VaultInstanceSubnetId parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "VaultInstanceSubnetId"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Select the Subnet Id where the Vault instance will reside."
            $currentParam.ParameterType | Should -Be "AWS::EC2::Subnet::Id"
            $script:parametersCounter++
        }
        It "Validate DRInstanceSubnetId parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "DRInstanceSubnetId"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Select the Subnet Id where the Vault DR instance will reside."
            $currentParam.ParameterType | Should -Be "AWS::EC2::Subnet::Id"
            $script:parametersCounter++
        }
        It "Validate CPMInstanceName parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "CPMInstanceName"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "CyberArk CPM"
            $currentParam.Description | Should -BeExactly "Enter a name for the CPM instance."
            $script:parametersCounter++
        }
        It "Validate CPMInstanceType parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "CPMInstanceType"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "c4.large"
            $currentParam.Description | Should -BeExactly "Select the instance type of the CPM instance."
            $currentParam.ParameterConstraints.AllowedValues | Should -Be @( "c4.large", "c4.xlarge", "c4.2xlarge", "c4.4xlarge")
            $script:parametersCounter++
        }
        It "Validate CPMInstanceSecurityGroups parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "CPMInstanceSecurityGroups"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Assign Security Groups to the CPM instance."
            $currentParam.ParameterType | Should -Be "List<AWS::EC2::SecurityGroup::Id>"
            $script:parametersCounter++
        }
        It "Validate CPMInstanceSubnetId parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "CPMInstanceSubnetId"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Select the Subnet Id where the CPM instance will reside."
            $currentParam.ParameterType | Should -Be "AWS::EC2::Subnet::Id"
            $script:parametersCounter++
        }
        It "Validate PVWAInstanceName parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "PVWAInstanceName"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "CyberArk PVWA"
            $currentParam.Description | Should -BeExactly "Enter a name for the PVWA instance."
            $script:parametersCounter++
        }
        It "Validate PVWAInstanceType parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "PVWAInstanceType"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "t2.medium"
            $currentParam.Description | Should -BeExactly "Select the instance type of the PVWA instance."
            $currentParam.ParameterConstraints.AllowedValues | Should -Be @( "t2.medium", "t2.large", "t2.xlarge", "t2.2xlarge")
            $script:parametersCounter++
        }
        It "Validate PVWAInstanceSecurityGroups parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "PVWAInstanceSecurityGroups"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Assign Security Groups to the PVWA instance."
            $currentParam.ParameterType | Should -Be "List<AWS::EC2::SecurityGroup::Id>"
            $script:parametersCounter++
        }
        It "Validate PVWAInstanceSubnetId parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "PVWAInstanceSubnetId"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Select the Subnet Id where the PVWA instance will reside."
            $currentParam.ParameterType | Should -Be "AWS::EC2::Subnet::Id"
            $script:parametersCounter++
        }
        It "Validate PSMInstanceName parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "PSMInstanceName"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "CyberArk PSM"
            $currentParam.Description | Should -BeExactly "Enter a name for the PSM instance."
            $script:parametersCounter++
        }
        It "Validate PSMInstanceType parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "PSMInstanceType"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "c4.2xlarge"
            $currentParam.Description | Should -BeExactly "Select the instance type of the PSM instance."
            $currentParam.ParameterConstraints.AllowedValues | Should -Be @( "c4.2xlarge", "c4.4xlarge", "c4.8xlarge")
            $script:parametersCounter++
        }
        It "Validate PSMInstanceSecurityGroups parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "PSMInstanceSecurityGroups"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Assign Security Groups to the PSM instance."
            $currentParam.ParameterType | Should -Be "List<AWS::EC2::SecurityGroup::Id>"
            $script:parametersCounter++
        }
        It "Validate PSMInstanceSubnetId parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "PSMInstanceSubnetId"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Select the Subnet Id where the PSM instance will reside."
            $currentParam.ParameterType | Should -Be "AWS::EC2::Subnet::Id"
            $script:parametersCounter++
        }
        It "Validate PSMPInstanceName parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "PSMPInstanceName"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "CyberArk PSM SSH Proxy"
            $currentParam.Description | Should -BeExactly "Enter a name for the PSM SSH Proxy instance."
            $script:parametersCounter++
        }
        It "Validate PSMPInstanceType parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "PSMPInstanceType"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "m4.large"
            $currentParam.Description | Should -BeExactly "Select the instance type of the PSM SSH Proxy instance."
            $currentParam.ParameterConstraints.AllowedValues | Should -Be @( 'm4.large', 'm4.xlarge', 'm4.2xlarge', 'm4.4xlarge')
            $script:parametersCounter++
        }
        It "Validate PSMPInstanceSecurityGroups parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "PSMPInstanceSecurityGroups"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Assign Security Groups to the PSM SSH Proxy instance."
            $currentParam.ParameterType | Should -Be "List<AWS::EC2::SecurityGroup::Id>"
            $script:parametersCounter++
        }
        It "Validate PSMPInstanceSubnetId parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "PSMPInstanceSubnetId"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Select the Subnet Id where the PSM SSH Proxy instance will reside."
            $currentParam.ParameterType | Should -Be "AWS::EC2::Subnet::Id"
            $script:parametersCounter++
        }
        It "Validate all parameters have been tested" {
            $script:templateSummary.Parameters.Count | Should -Be $script:parametersCounter
        }
    }
}
