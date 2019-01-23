PARAM(
    # location to import Cyberark images to
    [Parameter(Mandatory = $true)]
    [String]
    $location,
    # Supplied by CyberArk CPM AccessSAS
    [Parameter(Mandatory = $true)]
    [String]
    $CpmAccessSAS,
    # Supplied by CyberArk PVWA AccessSAS
    [Parameter(Mandatory = $true)]
    [String]
    $PvwaAccessSAS,
    # Supplied by CyberArk PSM AccessSAS
    [Parameter(Mandatory = $true)]
    [String]
    $PsmAccessSAS,
    # Supplied by CyberArk PSMP AccessSAS
    [Parameter(Mandatory = $true)]
    [String]
    $PsmpAccessSAS
)
 
#Set variables
$release = "v10.7"
$storageName = "cyberarkimages"
$containerName = "cyberarkimages"
$cpmDestBlob = "pas-cpm-$release.vhd"
$pvwaDestBlob = "pas-pvwa-$release.vhd"
$psmDestBlob = "pas-psm-$release.vhd"
$psmpDestBlob = "pas-psmp-$release.vhd"
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
    Start-AzureStorageBlobCopy -AbsoluteUri $CpmAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $cpmDestBlob
    
    #Start copy pvwa
    Start-AzureStorageBlobCopy -AbsoluteUri $PvwaAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $pvwaDestBlob
     
    #Start copy psm
    Start-AzureStorageBlobCopy -AbsoluteUri $PsmAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $psmDestBlob
      
    #Start copy psmp
    Start-AzureStorageBlobCopy -AbsoluteUri $PsmpAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $psmpDestBlob
     
     
    #Wait for vhd to be fully copied (~40 minutes)
    Get-AzureStorageBlobCopyState -Blob $cpmDestBlob -Container $containerName -Context $destContext -WaitForComplete
    Get-AzureStorageBlobCopyState -Blob $pvwaDestBlob -Container $containerName -Context $destContext -WaitForComplete
    Get-AzureStorageBlobCopyState -Blob $psmDestBlob -Container $containerName -Context $destContext -WaitForComplete
    Get-AzureStorageBlobCopyState -Blob $psmpDestBlob -Container $containerName -Context $destContext -WaitForComplete
     
     
    $cpmblobUri = ($destContext.BlobEndPoint + $containerName + "/" + $cpmDestBlob)
    $pvwablobUri = ($destContext.BlobEndPoint + $containerName + "/" + $pvwaDestBlob)
    $psmblobUri = ($destContext.BlobEndPoint + $containerName + "/" + $psmDestBlob)
    $psmpblobUri = ($destContext.BlobEndPoint + $containerName + "/" + $psmpDestBlob)
     
     
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
}
Catch
{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Write-Host("Error: $ErrorMessage")
    Break
}
