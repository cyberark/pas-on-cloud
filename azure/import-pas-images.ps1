PARAM(
    # release number
    [Parameter(Mandatory = $false)]
    [String]
    $release="v10.8",
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
    # Supplied by CyberArk CPM AccessSAS
    [Parameter(Mandatory = $false)]
    [String]
    $CpmAccessSAS,
    # Supplied by CyberArk PVWA AccessSAS
    [Parameter(Mandatory = $false)]
    [String]
    $PvwaAccessSAS,
    # Supplied by CyberArk PSM AccessSAS
    [Parameter(Mandatory = $false)]
    [String]
    $PsmAccessSAS,
    # Supplied by CyberArk PSMP AccessSAS
    [Parameter(Mandatory = $false)]
    [String]
    $PsmpAccessSAS,
    # Supplied by CyberArk Vault/VaultDR AccessSAS
    [Parameter(Mandatory = $false)]
    [String]
    $PsmpAccessSAS,
    # Supplied by CyberArk Vault/VaultDR AccessSAS
    [Parameter(Mandatory = $true)]
    [String]
)
 
#Set variables
$release = "v10.8"
$storageName = "cyberarkimages"
$containerName = "cyberarkimages"
$cpmDestBlob = "pas-cpm-$release.vhd"
$pvwaDestBlob = "pas-pvwa-$release.vhd"
$psmDestBlob = "pas-psm-$release.vhd"
$psmpDestBlob = "pas-psmp-$release.vhd"
$vaultDestBlob = "pas-vault-$release.vhd"
$resourceGroupName = "Cyberark-Images"

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
     
    #Start copy cpm
    if ($CpmAccessSAS)
    {
        Start-AzureStorageBlobCopy -AbsoluteUri $CpmAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $cpmDestBlob -Force
    }
    
    #Start copy pvwa
    if ($PvwaAccessSAS)
    {
        Start-AzureStorageBlobCopy -AbsoluteUri $PvwaAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $pvwaDestBlob -Force
    }

    #Start copy psm
    if ($PsmAccessSAS)
    {
        Start-AzureStorageBlobCopy -AbsoluteUri $PsmAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $psmDestBlob -Force
    }
      
    #Start copy psmp
    Start-AzureStorageBlobCopy -AbsoluteUri $PsmpAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $psmpDestBlob
    
    #Start copy vault
    Start-AzureStorageBlobCopy -AbsoluteUri $VaultAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $vaultDestBlob
     
     
    #Wait for vhd to be fully copied (~40 minutes)
    Get-AzureStorageBlobCopyState -Blob $cpmDestBlob -Container $containerName -Context $destContext -WaitForComplete
    Get-AzureStorageBlobCopyState -Blob $pvwaDestBlob -Container $containerName -Context $destContext -WaitForComplete
    Get-AzureStorageBlobCopyState -Blob $psmDestBlob -Container $containerName -Context $destContext -WaitForComplete
    Get-AzureStorageBlobCopyState -Blob $psmpDestBlob -Container $containerName -Context $destContext -WaitForComplete
    Get-AzureStorageBlobCopyState -Blob $vaultDestBlob -Container $containerName -Context $destContext -WaitForComplete
     
     
    $cpmblobUri = ($destContext.BlobEndPoint + $containerName + "/" + $cpmDestBlob)
    $pvwablobUri = ($destContext.BlobEndPoint + $containerName + "/" + $pvwaDestBlob)
    $psmblobUri = ($destContext.BlobEndPoint + $containerName + "/" + $psmDestBlob)
    $psmpblobUri = ($destContext.BlobEndPoint + $containerName + "/" + $psmpDestBlob)
    $vaultblobUri = ($destContext.BlobEndPoint + $containerName + "/" + $vaultDestBlob)
     
     
    #Create Cpm Image from blob
    $vmOSType = "Windows"
    $imageName = "PAS-CPM-$release"
    $imageConfig = New-AzureRmImageConfig -Location $location
    $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $cpmblobUri
    $image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
    
    #Create Pvwa Image from blob
    $vmOSType = "Windows"
    $imageName = "PAS-PVWA-$release"
    $imageConfig = New-AzureRmImageConfig -Location $location
    $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $pvwablobUri
    $image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
    
    #Create Psm Image from blob
    $vmOSType = "Windows"
    $imageName = "PAS-PSM-$release"
    $imageConfig = New-AzureRmImageConfig -Location $location
    $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $psmblobUri
    $image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
    
    #Create Psmp Image from blob
    $vmOSType = "Linux"
    $imageName = "PAS-PSMP-$release"
    $imageConfig = New-AzureRmImageConfig -Location $location
    $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $psmpblobUri
    $image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
    
    #Create Vault Image from blob
    $vmOSType = "Windows"
    $imageName = "PAS-Vault-$release"
    $imageConfig = New-AzureRmImageConfig -Location $location
    $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $vaultblobUri
    $image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
}
Catch
{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Write-Host("Error: $ErrorMessage")
    Break
}
