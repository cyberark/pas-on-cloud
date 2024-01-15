param(
    [string]$AdminPass,
    [string]$MasterPass,
    [string]$PrimaryOrDR,
    [string]$PrimaryVaultIP,
    [string]$DRPassword,
    [string]$VaultLicenseFile,
    [string]$RecoveryPublicKey,
    [string]$StorageAccountName,
    [string]$ContainerName,
    [string]$StorageAccountKey,
    [string]$KeyVaultName,
    [string]$DRUserSecret
)

# Download the TLS 1.2 script file from GitHub
$TlsScriptUrl = "https://raw.githubusercontent.com/cyberark/pas-on-cloud/v10.10/azure/enable-tls-1.2.ps1"
$TlsScriptContent = Invoke-WebRequest -Uri $TlsScriptUrl | Select-Object -ExpandProperty Content

# Execute the TLS 1.2 script
Invoke-Expression -Command $scriptContent

# Install Az module
Install-Module -Name Az -AllowClobber -Force

# Modify the Hardening Activation script file to use Az module
$HardeingActivationScript = "C:\CyberArk\HardeningActivation.ps1"
(Get-Content -Path $HardeingActivationScript) -replace "AzureStorage", "AzStorage" | Set-Content -Path $HardeingActivationScript

# Execute the Hardening Activation script
	
&$HardeingActivationScript -AdminPass $AdminPass -MasterPass $MasterPass -PrimaryOrDR $PrimaryOrDR -PrimaryVaultIP $PrimaryVaultIP -DRPassword $DRPassword -LicenseFileName $VaultLicenseFile -RecoveryPublicKey $RecoveryPublicKey -StorageAccountName $StorageAccountName -ContainerName $ContainerName -StorageAccountKey $StorageAccountKey -KeyVaultName $KeyVaultName -DRUserSecret $DRUserSecret