PARAM(
    [Parameter(Mandatory=$false)]
    [String] $templateBaseURL =       "https://s3.eu-west-2.amazonaws.com/pester-tests"
)

Describe "DRVault-Single-Deployment.json" {
    Describe "Structure Validation Suite" {
        $script:templateSummary = @{}
        $script:parametersCounter = 0
        It "Validate template structure" {
            $validationError = @{}
            $script:templateSummary = Get-CFNTemplateSummary -TemplateURL "$templateBaseURL/DRVault-Single-Deployment.json" -ErrorVariable validationError
            //$validationError.Count | Should -Be 0
            $script:templateSummary.Parameters.Count | Should -Be 16
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
        It "Validate VaultPrivateIP parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "VaultPrivateIP"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Enter the Vault Private IP."
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
        It "Validate VaultMasterPassword parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "VaultMasterPassword"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.NoEcho | Should -Be "True"
            $currentParam.Description | Should -BeExactly "Enter a password for the Vault DR Master user."
            $script:parametersCounter++
        }
        It "Validate RetypeMasterPassword parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "RetypeMasterPassword"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.NoEcho | Should -Be "True"
            $currentParam.Description | Should -BeExactly "Retype the password for the Vault DR Master user."
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
            $currentParam.NoEcho | Should -Be "True"
            $currentParam.Description | Should -BeExactly "Retype the password for the Vault DR user."
            $script:parametersCounter++
        }
        It "Validate VaultHostName parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "VaultHostName"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Enter the host name for the Vault DR instance."
            $currentParam.NoEcho | Should -Be "False"
            $script:parametersCounter++
        }
        It "Validate VaultInstanceType parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "VaultInstanceType"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "m4.large"
            $currentParam.Description | Should -BeExactly "Select the instance type of the Vault DR instance."
            $currentParam.NoEcho | Should -Be "False"
            $currentParam.ParameterConstraints.AllowedValues | Should -Be @('m4.large', 'm4.xlarge', 'm4.2xlarge', 'm4.4xlarge')
            $script:parametersCounter++
        }
        It "Validate VaultInstanceSecurityGroups parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "VaultInstanceSecurityGroups"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Assign Security Groups to the Vault DR instance."
            $currentParam.ParameterType | Should -Be "List<AWS::EC2::SecurityGroup::Id>"
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
        It "Validate VaultInstanceName parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "VaultInstanceName"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "CyberArk Vault"
            $currentParam.Description | Should -BeExactly "Enter a name for the Vault DR instance."
            $script:parametersCounter++
        }
        It "Validate all parameters have been tested" {
            $script:templateSummary.Parameters.Count | Should -Be $script:parametersCounter
        }
    }
}
