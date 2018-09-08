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
            $script:templateSummary = Get-CFNTemplateSummary -TemplateURL "$templateBaseURL/PAS-Component-Single-Deployment.json" -ErrorVariable validationError
            $validationError.Count | Should -Be 0
            $script:templateSummary.Parameters.Count | Should -Be 12
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
        It "Validate VaultPrivateIP parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "VaultPrivateIP"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Enter the IP of the Vault instance."
            $script:parametersCounter++
        }
        It "Validate DRPrivateIP parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "DRPrivateIP"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Enter the IP of the Vault DR instance. (Optional)"
            $script:parametersCounter++
        }
        It "Validate VaultAdminUser parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "VaultAdminUser"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "Administrator"
            $currentParam.Description | Should -BeExactly "Enter the Administrator Vault user."
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
        It "Validate ComponentToInstall parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "ComponentToInstall"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "CPM"
            $currentParam.ParameterConstraints.AllowedValues | Should -Be @('CPM', 'PVWA', 'PSM', 'PSMP')
            $currentParam.Description | Should -BeExactly "Choose the Component to install."
            $script:parametersCounter++
        }
        It "Validate ComponentInstanceName parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "ComponentInstanceName"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "Components"
            $currentParam.Description | Should -BeExactly "Enter a name for the PAS Component instance."
            $script:parametersCounter++
        }
        It "Validate ComponentHostName parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "ComponentHostName"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Enter the host name for the PAS Component instance."
            $script:parametersCounter++
        }
        It "Validate ComponentInstanceType parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "ComponentInstanceType"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeExactly "m4.large"
            $currentParam.Description | Should -BeExactly "Select the instance type of the Component instance."
            $currentParam.ParameterConstraints.AllowedValues | Should -Be @( "m4.large", "m4.xlarge", "m4.2xlarge", "m4.4xlarge")
            $script:parametersCounter++
        }
        It "Validate ComponentInstanceSecurityGroups parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "ComponentInstanceSecurityGroups"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Assign Security Groups to the Component instance."
            $currentParam.ParameterType | Should -Be "List<AWS::EC2::SecurityGroup::Id>"
            $script:parametersCounter++
        }
        It "Validate ComponentInstanceSubnetId parameter" {
            $currentParam = $script:templateSummary.Parameters | Where-Object {$_.ParameterKey -eq "ComponentInstanceSubnetId"}
            $currentParam | Should -Not -BeNullOrEmpty
            $currentParam.DefaultValue | Should -BeNullOrEmpty
            $currentParam.Description | Should -BeExactly "Select the Subnet Id where the Component instance will reside."
            $currentParam.ParameterType | Should -Be "AWS::EC2::Subnet::Id"
            $script:parametersCounter++
        }
        It "Validate all parameters have been tested" {
            $script:templateSummary.Parameters.Count | Should -Be $script:parametersCounter
        }
    }
}
