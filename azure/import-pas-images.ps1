PARAM(
    # location to import Cyberark images to
    [Parameter(Mandatory = $true)]
    [String]
    $location,
    # Supplied by CyberArk components AccessSAS
    [Parameter(Mandatory = $true)]
    [String]
    $ComponentsAccessSAS,
    # Supplied by CyberArk PSMP AccessSAS
    [Parameter(Mandatory = $true)]
    [String]
    $PsmpAccessSAS
)
 
#Set variables
$storageName = "cyberarkimages"
$containerName = "cyberarkimages"
$componentsDestBlob = "pas-components.vhd"
$psmpDestBlob = "pas-psmp.vhd"
$resourceGroupName = "Cyberark-Images"
 
#Create Resource Group
New-AzureRmResourceGroup -Name $resourceGroupName -Location $location
 
#Create Storage Account
$storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $storageName -Location $location -SkuName Standard_LRS
$destContext = $storageAccount.Context
 
#Create Blob Storage Container
New-AzureStorageContainer -Name $containerName -Permission Off -Context $destContext
 
#Start copy components
Start-AzureStorageBlobCopy -AbsoluteUri $ComponentsAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $componentsDestBlob
 
#Start copy psmp
Start-AzureStorageBlobCopy -AbsoluteUri $PsmpAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $psmpDestBlob
 
 
#Wait for vhd to be fully copied (~40 minutes)
Get-AzureStorageBlobCopyState -Blob $componentsDestBlob -Container $containerName -Context $destContext -WaitForComplete
Get-AzureStorageBlobCopyState -Blob $psmpDestBlob -Container $containerName -Context $destContext -WaitForComplete
 
 
$componentsblobUri = ($destContext.BlobEndPoint + $containerName + "/" + $componentsDestBlob)
$psmpblobUri = ($destContext.BlobEndPoint + $containerName + "/" + $psmpDestBlob)
 
 
#Create Components Image from blob
$vmOSType = "Windows"
$imageName = "PAS-Components-v10.3"
$imageConfig = New-AzureRmImageConfig -Location $location
$imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $componentsblobUri
$image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
 
#Create Psmp Image from blob
$vmOSType = "Linux"
$imageName = "PAS-Psmp-v10.3"
$imageConfig = New-AzureRmImageConfig -Location $location
$imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $psmpblobUri
$image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig