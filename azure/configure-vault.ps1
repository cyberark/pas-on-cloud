param(
    [string]$AdminPass,
    [string]$MasterPass,
    [string]$PrimaryOrDR,
    [string]$PrimaryVaultIP,
    [string]$DRPassword,
    [string]$LicenseFileName,
    [string]$RecPubFileName,
    [string]$StorageName,
    [string]$ContainerName,
    [string]$StorageAccountKey,
    [string]$VKMName,
    [string]$Secret
)

# Download the TLS 1.2 script file from GitHub
$TlsScriptUrl = "https://raw.githubusercontent.com/cyberark/pas-on-cloud/v12.2/azure/enable-tls-1.2.ps1"
$TlsScriptContent = Invoke-WebRequest -Uri $TlsScriptUrl | Select-Object -ExpandProperty Content

# Execute the TLS 1.2 script
Invoke-Expression -Command $scriptContent

# Install Az module
Install-Module -Name Az -AllowClobber -Force

# Modify the Hardening Activation script file to use Az module
$HardeingActivationScript = "C:\CyberArk\HardeningActivation.ps1"
(Get-Content -Path $HardeingActivationScript) -replace "AzureStorage", "AzStorage" | Set-Content -Path $HardeingActivationScript

# Execute the Hardening Activation script
	
&$HardeingActivationScript -AdminPass $AdminPass -MasterPass $MasterPass -PrimaryOrDR $PrimaryOrDR -PrimaryVaultIP $PrimaryVaultIP -DRPassword $DRPassword -LicenseFileName $LicenseFileName -RecPubFileName $RecPubFileName -StorageName $StorageName -ContainerName $ContainerName -StorageAccountKey $StorageAccountKey -VKMName $VKMName -Secret $Secret