### Usage: Enter the following command in your Cloud Shell / terminal authenticated to your Azure account, after copying it to your workspace.
###
### import-pas-images.ps1 -location "<Desired Azure location>" [-release] "<PAS release>" [-winVersion] "<Win2016 / Win2019>" [-storageName] "<Custom Storage account>" `
### [-containerName] "<Custom Container>" [-resourceGroupName] "<Custom Resource Group>" [-vaultAccessSAS] "<pas-vault-vXX.X AccessSAS>" `
### [-vaultDataDiskAccessSAS] "<pas-vaultDataDisk-vXX.X AccessSAS>" [-pvwaAccessSAS] "<pas-pvwa-vXX.X AccessSAS>" [-cpmAccessSAS] "<pas-cpm-vXX.X AccessSAS>" `
### [-psmAccessSAS] "<pas-psm-vXX.X AccessSAS>" [-psmpAccessSAS] "<pas-psmp-vXX.X AccessSAS>" [-ptaAccessSAS] "<pas-pta-vXX.X AccessSAS>"
###
### Notes:
### - "release" and "winVersion" parameters are being used in the naming of the vhd files and images created, 
###   it is recommended to specify those to get accurately described images ("winVersion" is irrelevant if only pta/psmp are being imported).
### - "storageName", "containerName" and "resourceGroupName" are defaulted to "cyberarkimages", "cyberarkimages" and "Cyberark-Images" respectivly,
###   and the required objects will be created automatically if needed. Use these only in case you desire to place them in a custom location.
### - "vaultAccessSAS" and "vaultDataDiskAccessSAS" are binded together, you must specify both of them or none of them.

[CmdletBinding(DefaultParameterSetName='default')]
Param(
    # release number
    [Parameter(Mandatory = $false)]
    [String]
    $release="v13.0",
    # windows version
    [Parameter(Mandatory = $false)]
    [String]
    $winVersion="win2016",
    # location to import Cyberark images to
    [Parameter(Mandatory = $true)]
    [String]
    $location,
    # storageName to import Cyberark images to
    [Parameter(Mandatory = $false)]
    [String]
    $storageName="cyberarkimages",
    # containerName to import Cyberark images to
    [Parameter(Mandatory = $false)]
    [String]
    $containerName="cyberarkimages",
    # resourceGroupName to import Cyberark images to
    [Parameter(Mandatory = $false)]
    [String]
    $resourceGroupName="Cyberark-Images",
    # Supplied by CyberArk Vault/VaultDR AccessSAS
    [Parameter(ParameterSetName='Vault', Mandatory = $false)]
    [String]
    $vaultAccessSAS,
    # Supplied by CyberArk Vault Data Disk AccessSAS
    [Parameter(ParameterSetName='Vault', Mandatory = $true)]
    [String]
    $vaultDataDiskAccessSAS,
    # Supplied by CyberArk PVWA AccessSAS
    [Parameter(Mandatory = $false)]
    [String]
    $pvwaAccessSAS,
    # Supplied by CyberArk CPM AccessSAS
    [Parameter(Mandatory = $false)]
    [String]
    $cpmAccessSAS,
    # Supplied by CyberArk PSM AccessSAS
    [Parameter(Mandatory = $false)]
    [String]
    $psmAccessSAS,
    # Supplied by CyberArk PSMP AccessSAS
    [Parameter(Mandatory = $false)]
    [String]
    $psmpAccessSAS,
    # Supplied by CyberArk PTA AccessSAS
    [Parameter(Mandatory = $false)]
    [String]
    $ptaAccessSAS
)

#Set variables
$vaultDestBlob = "cyberark-pas-vault-$release-$winVersion.vhd"
$vaultDataDiskDestBlob = "cyberark-pas-vault-$release-$winVersion-datadisk.vhd"
$pvwaDestBlob = "cyberark-pas-pvwa-$release-$winVersion.vhd"
$cpmDestBlob = "cyberark-pas-cpm-$release-$winVersion.vhd"
$psmDestBlob = "cyberark-pas-psm-$release-$winVersion.vhd"
$psmpDestBlob = "cyberark-pas-psmp-$release-rhel8.vhd"
$ptaDestBlob = "cyberark-pas-pta-$release-rhel8.vhd"

Try
{
    #Create Resource Group
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $location -Force
     
    #Create Storage Account, if not exists
    $storageAccount = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $storageName
    if (!$storageAccount)
    {  
        $storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $storageName -Location $location -SkuName Standard_LRS 
    }
    $destContext = $storageAccount.Context

    #Create Blob Storage Container, if not exists
    if (!(Get-AzureStorageContainer -Name $containerName -Context $destContext))
    {
        New-AzureStorageContainer -Name $containerName -Permission Off -Context $destContext
    }
     
    if ($VaultAccessSAS)
    {
        #Start copy Vault
        Start-AzureStorageBlobCopy -AbsoluteUri $vaultAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $vaultDestBlob -Force
        Get-AzureStorageBlobCopyState -Blob $vaultDestBlob -Container $containerName -Context $destContext -WaitForComplete
        Start-AzureStorageBlobCopy -AbsoluteUri $vaultDataDiskAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $vaultDataDiskDestBlob -Force
        Get-AzureStorageBlobCopyState -Blob $vaultDataDiskDestBlob -Container $containerName -Context $destContext -WaitForComplete
        #Create Vault Image from blob
        $vaultBlobUri = ($destContext.BlobEndPoint + $containerName + "/" + $vaultDestBlob)
        $vaultDataDiskBlobUri = ($destContext.BlobEndPoint + $containerName + "/" + $vaultDataDiskDestBlob)
        $vmOSType = "Windows"
        $imageName = "CyberArk-PAS-Vault-$release-$winVersion"
        $imageConfig = New-AzureRmImageConfig -Location $location
        $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $vaultBlobUri
        $imageConfig = Add-AzureRmImageDataDisk -Image $imageConfig -Lun 0 -BlobUri $vaultDataDiskBlobUri
        New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
    }

    
    #Start copy pvwa
    if ($pvwaAccessSAS)
    {
        #Start copy PVWA
        Start-AzureStorageBlobCopy -AbsoluteUri $pvwaAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $pvwaDestBlob -Force
        Get-AzureStorageBlobCopyState -Blob $pvwaDestBlob -Container $containerName -Context $destContext -WaitForComplete
        #Create PVWA Image from blob
        $pvwaBlobUri = ($destContext.BlobEndPoint + $containerName + "/" + $pvwaDestBlob)
        $vmOSType = "Windows"
        $imageName = "CyberArk-PAS-PVWA-$release-$winVersion"
        $imageConfig = New-AzureRmImageConfig -Location $location
        $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $pvwaBlobUri
        New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
    }
    
    if ($cpmAccessSAS)
    {
        #Start copy CPM
        Start-AzureStorageBlobCopy -AbsoluteUri $cpmAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $cpmDestBlob -Force
        Get-AzureStorageBlobCopyState -Blob $cpmDestBlob -Container $containerName -Context $destContext -WaitForComplete
        #Create CPM Image from blob
        $cpmBlobUri = ($destContext.BlobEndPoint + $containerName + "/" + $cpmDestBlob)
        $vmOSType = "Windows"
        $imageName = "CyberArk-PAS-CPM-$release-$winVersion"
        $imageConfig = New-AzureRmImageConfig -Location $location
        $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $cpmBlobUri
        New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
    }

    if ($psmAccessSAS)
    {
        #Start copy PSM
        Start-AzureStorageBlobCopy -AbsoluteUri $psmAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $psmDestBlob -Force
        Get-AzureStorageBlobCopyState -Blob $psmDestBlob -Container $containerName -Context $destContext -WaitForComplete
        #Create PSM Image from blob
        $psmBlobUri = ($destContext.BlobEndPoint + $containerName + "/" + $psmDestBlob)
        $vmOSType = "Windows"
        $imageName = "CyberArk-PAS-PSM-$release-$winVersion"
        $imageConfig = New-AzureRmImageConfig -Location $location
        $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $psmBlobUri
        New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
    }
      
    if ($psmpAccessSAS)
    {
        #Start copy PSMP
        Start-AzureStorageBlobCopy -AbsoluteUri $psmpAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $psmpDestBlob -Force
        Get-AzureStorageBlobCopyState -Blob $psmpDestBlob -Container $containerName -Context $destContext -WaitForComplete
        #Create PSMP Image from blob
        $psmpBlobUri = ($destContext.BlobEndPoint + $containerName + "/" + $psmpDestBlob)
        $vmOSType = "Linux"
        $imageName = "CyberArk-PAS-PSMP-$release-RHEL8"
        $imageConfig = New-AzureRmImageConfig -Location $location
        $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $psmpBlobUri
        New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
    }


    if ($ptaAccessSAS)
    {
        #Start copy PTA
        Start-AzureStorageBlobCopy -AbsoluteUri $ptaAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $ptaDestBlob -Force
        Get-AzureStorageBlobCopyState -Blob $ptaDestBlob -Container $containerName -Context $destContext -WaitForComplete
        #Create PTA Image from blob
        $ptaBlobUri = ($destContext.BlobEndPoint + $containerName + "/" + $ptaDestBlob)
        $vmOSType = "Linux"
        $imageName = "CyberArk-PAS-PTA-$release-RHEL8"
        $imageConfig = New-AzureRmImageConfig -Location $location
        $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $ptaBlobUri
        New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
    }
}
Catch
{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Write-Host("Error: $ErrorMessage")
    Write-Host("Failed Item: $FailedItem")
    Break
}
