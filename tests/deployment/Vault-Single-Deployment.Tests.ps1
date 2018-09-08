PARAM(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String] $randomNumber,
    [Parameter(Mandatory=$false)]
    [String] $templateBaseURL =       "https://s3.eu-west-2.amazonaws.com/pester-tests",
    [Parameter(Mandatory=$false)]
    [String] $region =                "eu-west-2",
    [Parameter(Mandatory=$false)]
    [String] $keyName =               "Shani-London",
    [Parameter(Mandatory=$false)]
    [String] $vaultInstanceSubnetId = "subnet-08c96173",
    [Parameter(Mandatory=$false)]
    [String] $vaultInstanceSecurityGroups =  "sg-48354621",
    [Parameter(Mandatory=$false)]
    [String] $instanceType =          "m4.large",
    [Parameter(Mandatory=$false)]
    [String] $filesBucket =           "sashac",
    [Parameter(Mandatory=$false)]
    [String] $recoveryPublicKey =     "recpub.key",
    [Parameter(Mandatory=$false)]
    [String] $licenseFile =           "license.xml",
    [Parameter(Mandatory=$false)]
    [String] $vaultMasterPassword =   "123Password$",
    [Parameter(Mandatory=$false)]
    [String] $vaultAdminPassword =    "123Password$"
)


$vaultStackName =     "VaultAutoDeploy-$randomNumber"
$vaultInstanceName =  $vaultStackName
$vaultHostName =      $vaultStackName

Describe "Vault-Single-Deployment.json" {
     Describe "Deployment suite" {
        It "Check stack deployment" {
            $response = New-CFNStack -StackName $vaultStackName -TemplateURL "$templateBaseURL/Vault-Single-Deployment.json" -Region $region `
                -Capability CAPABILITY_IAM -Parameters @(
                                @{ParameterKey="EULA"; ParameterValue="Accept" },
                                @{ParameterKey="KeyName"; ParameterValue=$keyName },
                                @{ParameterKey="VaultFilesBucket"; ParameterValue=$filesBucket },
                                @{ParameterKey="VaultMasterPassword"; ParameterValue=$vaultMasterPassword },
                                @{ParameterKey="RetypeMasterPassword"; ParameterValue=$vaultMasterPassword },
                                @{ParameterKey="VaultAdminPassword"; ParameterValue=$vaultAdminPassword },
                                @{ParameterKey="RetypeAdminPassword"; ParameterValue=$vaultAdminPassword },
                                @{ParameterKey="VaultInstanceName"; ParameterValue=$vaultInstanceName },
                                @{ParameterKey="VaultHostName"; ParameterValue=$vaultHostName },
                                @{ParameterKey="VaultInstanceType"; ParameterValue=$instanceType },
                                @{ParameterKey="VaultInstanceSecurityGroups"; ParameterValue=$vaultInstanceSecurityGroups },
                                @{ParameterKey="VaultInstanceSubnetId"; ParameterValue=$vaultInstanceSubnetId },
                                @{ParameterKey="RecoveryPublicKey"; ParameterValue=$recoveryPublicKey },
                                @{ParameterKey="LicenseFile"; ParameterValue=$licenseFile }
                              ) 
            $res = Wait-CFNStack -StackName $vaultStackName -Timeout 600
    
            $res.StackStatus | Should -Be 'CREATE_COMPLETE'
    
            # ~~~ Get vaultPrivateIP ~~~ #
            $vaultResources = Get-CFNStackResourceList -StackName $vaultStackName -LogicalResourceId VaultMachine
            $instances = Get-EC2Instance -InstanceId $vaultResources.PhysicalResourceId
            $vaultPrivateIP = $instances.Instances[0].PrivateIpAddress
        }
        It "Check VaultMachine LogicalResource Exists" {
            # ~~~ Get vaultPrivateIP ~~~ #
            $vaultResources = Get-CFNStackResourceList -StackName $vaultStackName -LogicalResourceId VaultMachine
            $vaultResources.PhysicalResourceId | Should -Not -BeNullOrEmpty
        }
    }
}
