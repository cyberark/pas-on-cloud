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
    # Supplied by CyberArk PSMP AccessSAS
    [Parameter(Mandatory = $false)]
    [String]
    $PTAAccessSAS,
    # Supplied by CyberArk Vault/VaultDR AccessSAS
    [Parameter(Mandatory = $false)]
    [String]
    $VaultAccessSAS,
    # Switch to start the copy process
    [Parameter(Mandatory = $false)]
    [switch]
    $Copy,
    # Switch to start the process of converting the VHD into a image.
    [Parameter(Mandatory = $false)]
    [switch]
    $Process
)
 
#Set variables
$cpmDestBlob = "pas-cpm-$release.vhd"
$pvwaDestBlob = "pas-pvwa-$release.vhd"
$psmDestBlob = "pas-psm-$release.vhd"
$psmpDestBlob = "pas-psmp-$release.vhd"
$vaultDestBlob = "pas-vault-$release.vhd"
$ptaDestBlob = "pas-pta-$release.vhd"


Try {
    if($Copy){
        #Create Resource Group
        New-AzureRmResourceGroup -Name $resourceGroupName -Location $location -Force
     
        #Create Storage Account, if not exists
        $storageAccount = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $storageName
        if (!$storageAccount) {  
            $storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $storageName -Location $location -SkuName Standard_LRS 
        }
        $destContext = $storageAccount.Context

        #Create Blob Storage Container, if not exists
        if (!(Get-AzureStorageContainer -Name $containerName -Context $destContext)) {
            New-AzureStorageContainer -Name $containerName -Permission Off -Context $destContext
        }
     
        #Start copy cpm
        if ($CpmAccessSAS) {
            Start-AzureStorageBlobCopy -AbsoluteUri $CpmAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $cpmDestBlob -Force
        }
    
        #Start copy pvwa
        if ($PvwaAccessSAS) {
            Start-AzureStorageBlobCopy -AbsoluteUri $PvwaAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $pvwaDestBlob -Force
        }

        #Start copy psm
        if ($PsmAccessSAS) {
            Start-AzureStorageBlobCopy -AbsoluteUri $PsmAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $psmDestBlob -Force
        }
      
        #Start copy psmp
        if ($PsmpAccessSAS) {
            Start-AzureStorageBlobCopy -AbsoluteUri $PsmpAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $psmpDestBlob -Force
        }

        #Start copy psmp
        if ($PtaAccessSAS) {
            Start-AzureStorageBlobCopy -AbsoluteUri $PtaAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $ptaDestBlob -Force
        }
        
        #Start copy vault
        if ($VaultAccessSAS) {
            Start-AzureStorageBlobCopy -AbsoluteUri $VaultAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $vaultDestBlob -Force
        }
    }
     
    #Wait for vhd to be fully copied (~40 minutes)
    if($Process){   
        #Create Cpm Image from blob
        if ($CpmAccessSAS) {
            Get-AzureStorageBlobCopyState -Blob $cpmDestBlob -Container $containerName -Context $destContext -WaitForComplete
            $cpmblobUri = ($destContext.BlobEndPoint + $containerName + "/" + $cpmDestBlob)
            $vmOSType = "Windows"
            $imageName = "PAS-CPM-$release"
            $imageConfig = New-AzureRmImageConfig -Location $location
            $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $cpmblobUri
            $image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
        }
    
        #Create Pvwa Image from blob
        if ($PvwaAccessSAS) {
            Get-AzureStorageBlobCopyState -Blob $pvwaDestBlob -Container $containerName -Context $destContext -WaitForComplete
            $pvwablobUri = ($destContext.BlobEndPoint + $containerName + "/" + $pvwaDestBlob)
            $vmOSType = "Windows"
            $imageName = "PAS-PVWA-$release"
            $imageConfig = New-AzureRmImageConfig -Location $location
            $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $pvwablobUri
            $image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
        }
    
        #Create Psm Image from blob
        if ($PsmAccessSAS) {
            Get-AzureStorageBlobCopyState -Blob $psmDestBlob -Container $containerName -Context $destContext -WaitForComplete
            $psmblobUri = ($destContext.BlobEndPoint + $containerName + "/" + $psmDestBlob)
            $vmOSType = "Windows"
            $imageName = "PAS-PSM-$release"
            $imageConfig = New-AzureRmImageConfig -Location $location
            $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $psmblobUri
            $image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
        }
    
        #Create Psmp Image from blob
        if ($PsmpAccessSAS) {
            Get-AzureStorageBlobCopyState -Blob $psmpDestBlob -Container $containerName -Context $destContext -WaitForComplete
            $psmpblobUri = ($destContext.BlobEndPoint + $containerName + "/" + $psmpDestBlob)
            $vmOSType = "Linux"
            $imageName = "PAS-PSMP-$release"
            $imageConfig = New-AzureRmImageConfig -Location $location
            $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $psmpblobUri
            $image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
        }

        #Create Psmp Image from blob
        if ($PtaAccessSAS) {
            Get-AzureStorageBlobCopyState -Blob $ptaDestBlob -Container $containerName -Context $destContext -WaitForComplete
            $ptablobUri = ($destContext.BlobEndPoint + $containerName + "/" + $ptaDestBlob)
            $vmOSType = "Linux"
            $imageName = "PAS-PTA-$release"
            $imageConfig = New-AzureRmImageConfig -Location $location
            $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $ptablobUri
            $image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
        }
    
        #Create Vault Image from blob
        if ($VaultAccessSAS) {
            Get-AzureStorageBlobCopyState -Blob $vaultDestBlob -Container $containerName -Context $destContext -WaitForComplete
            $vaultblobUri = ($destContext.BlobEndPoint + $containerName + "/" + $vaultDestBlob)
            $vmOSType = "Windows"
            $imageName = "PAS-Vault-$release"
            $imageConfig = New-AzureRmImageConfig -Location $location
            $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $vaultblobUri
            $image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
        }    
    }
} Catch {
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Write-Host("Error: $ErrorMessage")
    Break
}
