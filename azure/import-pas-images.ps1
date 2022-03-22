PARAM(
    # release number
    [Parameter(Mandatory = $false)]
    [String]
    $release="v12.2",
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
    # Supplied by CyberArk PTA AccessSAS
    [Parameter(Mandatory = $false)]
    [String]
    $PtaAccessSAS,
    # Supplied by CyberArk Vault/VaultDR AccessSAS
    [Parameter(Mandatory = $false)]
    [String]
    $VaultAccessSAS
)
 
#Set variables
$cpmDestBlob = "pas-cpm-$release.vhd"
$pvwaDestBlob = "pas-pvwa-$release.vhd"
$psmDestBlob = "pas-psm-$release.vhd"
$psmpDestBlob = "pas-psmp-$release.vhd"
$ptaDestBlob = "pas-pta-$release.vhd"
$vaultDestBlob = "pas-vault-$release.vhd"

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
    if ($PsmpAccessSAS)
    {
        Start-AzureStorageBlobCopy -AbsoluteUri $PsmpAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $psmpDestBlob -Force
    }

    #Start copy pta
    if ($PtaAccessSAS)
    {
        Start-AzureStorageBlobCopy -AbsoluteUri $PtaAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $ptaDestBlob -Force
    }
    
    #Start copy vault
    if ($VaultAccessSAS)
    {
        Start-AzureStorageBlobCopy -AbsoluteUri $VaultAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $vaultDestBlob -Force
    }
     
    #Wait for vhd to be fully copied (~40 minutes)
        
    #Create Cpm Image from blob
    if ($CpmAccessSAS)
    {
        Get-AzureStorageBlobCopyState -Blob $cpmDestBlob -Container $containerName -Context $destContext -WaitForComplete
        $cpmblobUri = ($destContext.BlobEndPoint + $containerName + "/" + $cpmDestBlob)
        $vmOSType = "Windows"
        $imageName = "PAS-CPM-$release"
        $imageConfig = New-AzureRmImageConfig -Location $location
        $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $cpmblobUri
        $image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
    }
    
    #Create Pvwa Image from blob
    if ($PvwaAccessSAS)
    {
        Get-AzureStorageBlobCopyState -Blob $pvwaDestBlob -Container $containerName -Context $destContext -WaitForComplete
        $pvwablobUri = ($destContext.BlobEndPoint + $containerName + "/" + $pvwaDestBlob)
        $vmOSType = "Windows"
        $imageName = "PAS-PVWA-$release"
        $imageConfig = New-AzureRmImageConfig -Location $location
        $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $pvwablobUri
        $image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
    }
    
    #Create Psm Image from blob
    if ($PsmAccessSAS)
    {
        Get-AzureStorageBlobCopyState -Blob $psmDestBlob -Container $containerName -Context $destContext -WaitForComplete
        $psmblobUri = ($destContext.BlobEndPoint + $containerName + "/" + $psmDestBlob)
        $vmOSType = "Windows"
        $imageName = "PAS-PSM-$release"
        $imageConfig = New-AzureRmImageConfig -Location $location
        $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $psmblobUri
        $image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
    }
    
    #Create Psmp Image from blob
    if ($PsmpAccessSAS)
    {
        Get-AzureStorageBlobCopyState -Blob $psmpDestBlob -Container $containerName -Context $destContext -WaitForComplete
        $psmpblobUri = ($destContext.BlobEndPoint + $containerName + "/" + $psmpDestBlob)
        $vmOSType = "Linux"
        $imageName = "PAS-PSMP-$release"
        $imageConfig = New-AzureRmImageConfig -Location $location
        $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $psmpblobUri
        $image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
    }
    
    #Create Pta Image from blob
    if ($PtaAccessSAS)
    {
        Get-AzureStorageBlobCopyState -Blob $ptaDestBlob -Container $containerName -Context $destContext -WaitForComplete
        $ptablobUri = ($destContext.BlobEndPoint + $containerName + "/" + $ptaDestBlob)
        $vmOSType = "Linux"
        $imageName = "PAS-PTA-$release"
        $imageConfig = New-AzureRmImageConfig -Location $location
        $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $ptablobUri
        $image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
    }
    
    #Create Vault Image from blob
    if ($VaultAccessSAS)
    {
        Get-AzureStorageBlobCopyState -Blob $vaultDestBlob -Container $containerName -Context $destContext -WaitForComplete
        $vaultblobUri = ($destContext.BlobEndPoint + $containerName + "/" + $vaultDestBlob)
        $vmOSType = "Windows"
        $imageName = "PAS-Vault-$release"
        $imageConfig = New-AzureRmImageConfig -Location $location
        $imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $vmOSType -OsState Generalized -BlobUri $vaultblobUri
        $image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig
    }    
}
Catch
{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Write-Host("Error: $ErrorMessage")
    Break
}

# SIG # Begin signature block
# MIIgTQYJKoZIhvcNAQcCoIIgPjCCIDoCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBVhZc/ejx8MVio
# iH+0xoJBE7rAS1Pmf3ssi4Oa7IqeJaCCDl8wggboMIIE0KADAgECAhB3vQ4Ft1kL
# th1HYVMeP3XtMA0GCSqGSIb3DQEBCwUAMFMxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
# ExBHbG9iYWxTaWduIG52LXNhMSkwJwYDVQQDEyBHbG9iYWxTaWduIENvZGUgU2ln
# bmluZyBSb290IFI0NTAeFw0yMDA3MjgwMDAwMDBaFw0zMDA3MjgwMDAwMDBaMFwx
# CzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTIwMAYDVQQD
# EylHbG9iYWxTaWduIEdDQyBSNDUgRVYgQ29kZVNpZ25pbmcgQ0EgMjAyMDCCAiIw
# DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAMsg75ceuQEyQ6BbqYoj/SBerjgS
# i8os1P9B2BpV1BlTt/2jF+d6OVzA984Ro/ml7QH6tbqT76+T3PjisxlMg7BKRFAE
# eIQQaqTWlpCOgfh8qy+1o1cz0lh7lA5tD6WRJiqzg09ysYp7ZJLQ8LRVX5YLEeWa
# tSyyEc8lG31RK5gfSaNf+BOeNbgDAtqkEy+FSu/EL3AOwdTMMxLsvUCV0xHK5s2z
# BZzIU+tS13hMUQGSgt4T8weOdLqEgJ/SpBUO6K/r94n233Hw0b6nskEzIHXMsdXt
# HQcZxOsmd/KrbReTSam35sOQnMa47MzJe5pexcUkk2NvfhCLYc+YVaMkoog28vmf
# vpMusgafJsAMAVYS4bKKnw4e3JiLLs/a4ok0ph8moKiueG3soYgVPMLq7rfYrWGl
# r3A2onmO3A1zwPHkLKuU7FgGOTZI1jta6CLOdA6vLPEV2tG0leis1Ult5a/dm2tj
# IF2OfjuyQ9hiOpTlzbSYszcZJBJyc6sEsAnchebUIgTvQCodLm3HadNutwFsDeCX
# pxbmJouI9wNEhl9iZ0y1pzeoVdwDNoxuz202JvEOj7A9ccDhMqeC5LYyAjIwfLWT
# yCH9PIjmaWP47nXJi8Kr77o6/elev7YR8b7wPcoyPm593g9+m5XEEofnGrhO7izB
# 36Fl6CSDySrC/blTAgMBAAGjggGtMIIBqTAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0l
# BAwwCgYIKwYBBQUHAwMwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUJZ3Q
# /FkJhmPF7POxEztXHAOSNhEwHwYDVR0jBBgwFoAUHwC/RoAK/Hg5t6W0Q9lWULvO
# ljswgZMGCCsGAQUFBwEBBIGGMIGDMDkGCCsGAQUFBzABhi1odHRwOi8vb2NzcC5n
# bG9iYWxzaWduLmNvbS9jb2Rlc2lnbmluZ3Jvb3RyNDUwRgYIKwYBBQUHMAKGOmh0
# dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2NvZGVzaWduaW5ncm9v
# dHI0NS5jcnQwQQYDVR0fBDowODA2oDSgMoYwaHR0cDovL2NybC5nbG9iYWxzaWdu
# LmNvbS9jb2Rlc2lnbmluZ3Jvb3RyNDUuY3JsMFUGA1UdIAROMEwwQQYJKwYBBAGg
# MgECMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3Jl
# cG9zaXRvcnkvMAcGBWeBDAEDMA0GCSqGSIb3DQEBCwUAA4ICAQAldaAJyTm6t6E5
# iS8Yn6vW6x1L6JR8DQdomxyd73G2F2prAk+zP4ZFh8xlm0zjWAYCImbVYQLFY4/U
# ovG2XiULd5bpzXFAM4gp7O7zom28TbU+BkvJczPKCBQtPUzosLp1pnQtpFg6bBNJ
# +KUVChSWhbFqaDQlQq+WVvQQ+iR98StywRbha+vmqZjHPlr00Bid/XSXhndGKj0j
# fShziq7vKxuav2xTpxSePIdxwF6OyPvTKpIz6ldNXgdeysEYrIEtGiH6bs+XYXvf
# cXo6ymP31TBENzL+u0OF3Lr8psozGSt3bdvLBfB+X3Uuora/Nao2Y8nOZNm9/Lws
# 80lWAMgSK8YnuzevV+/Ezx4pxPTiLc4qYc9X7fUKQOL1GNYe6ZAvytOHX5OKSBoR
# HeU3hZ8uZmKaXoFOlaxVV0PcU4slfjxhD4oLuvU/pteO9wRWXiG7n9dqcYC/lt5y
# A9jYIivzJxZPOOhRQAyuku++PX33gMZMNleElaeEFUgwDlInCI2Oor0ixxnJpsoO
# qHo222q6YV8RJJWk4o5o7hmpSZle0LQ0vdb5QMcQlzFSOTUpEYck08T7qWPLd0jV
# +mL8JOAEek7Q5G7ezp44UCb0IXFl1wkl1MkHAHq4x/N36MXU4lXQ0x72f1LiSY25
# EXIMiEQmM2YBRN/kMw4h3mKJSAfa9TCCB28wggVXoAMCAQICDHBNxPwWOpXgXVV8
# DDANBgkqhkiG9w0BAQsFADBcMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFs
# U2lnbiBudi1zYTEyMDAGA1UEAxMpR2xvYmFsU2lnbiBHQ0MgUjQ1IEVWIENvZGVT
# aWduaW5nIENBIDIwMjAwHhcNMjIwMjE1MTMzODM1WhcNMjUwMjE1MTMzODM1WjCB
# 1DEdMBsGA1UEDwwUUHJpdmF0ZSBPcmdhbml6YXRpb24xEjAQBgNVBAUTCTUxMjI5
# MTY0MjETMBEGCysGAQQBgjc8AgEDEwJJTDELMAkGA1UEBhMCSUwxEDAOBgNVBAgT
# B0NlbnRyYWwxFDASBgNVBAcTC1BldGFoIFRpa3ZhMRMwEQYDVQQJEwo5IEhhcHNh
# Z290MR8wHQYDVQQKExZDeWJlckFyayBTb2Z0d2FyZSBMdGQuMR8wHQYDVQQDExZD
# eWJlckFyayBTb2Z0d2FyZSBMdGQuMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIIC
# CgKCAgEA8rPX6yAVM64+/qMQEttWp7FdAvq9UfgxBrW+R0NtuXhKnjV05zmIL6zi
# AS0TlNrQqu5ypmuagOWzYKDtIcWEDm6AuSK+QeZprW69c0XYRdIf8X/xNUawXLGe
# 5LG6ngs2uHGtch9lt2GLMRWILnKviS6l6F06HOAow+aIDcNGOukddypveFrqMEbP
# 7YKMekkB6c2/whdHzDQiW6V0K82Xp9XUexrbdnFpKWXLfQwkzjcG1xmSiHQUpkSH
# 4w2AzBzcs+Nidoon5FEIFXGS2b1CcCA8+Po5Dg7//vn2thirXtOqaC+fjP1pUG7m
# vrZQMg3lTHQA/LTL78R3UzzNb4I9dc8yualcYK155hRU3vZJ3/UtktAvDPC/ewoW
# thebG77NuKU8YI6l2lMg7jMFZ1//brICD0RGqhmPMK9MrB3elSuMLaO566Ihdrlp
# zmj4BRDCfPuH0QfwkrejsikGEMo0lErfHSjL3NaiE0PPoC4NW7nc6Wh4Va4e3VFF
# Z9zdnoTsCKJqk4s13MxBbjdLIkCcfknMSxAloOF9h6IhzWOylSROAy/TZfGL5kzQ
# qxzcIhdXLWHHWdbz4DD3qxYc6g1G3ZwgFPWf7VbKQU3FsAxgiJvmKPVeOfIN4iYT
# V4toilRR8KX/IaA1NMrN9EiA//ZhN3HONS/s6AxjjHJTR29GOQkCAwEAAaOCAbYw
# ggGyMA4GA1UdDwEB/wQEAwIHgDCBnwYIKwYBBQUHAQEEgZIwgY8wTAYIKwYBBQUH
# MAKGQGh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjQ1
# ZXZjb2Rlc2lnbmNhMjAyMC5jcnQwPwYIKwYBBQUHMAGGM2h0dHA6Ly9vY3NwLmds
# b2JhbHNpZ24uY29tL2dzZ2NjcjQ1ZXZjb2Rlc2lnbmNhMjAyMDBVBgNVHSAETjBM
# MEEGCSsGAQQBoDIBAjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
# aWduLmNvbS9yZXBvc2l0b3J5LzAHBgVngQwBAzAJBgNVHRMEAjAAMEcGA1UdHwRA
# MD4wPKA6oDiGNmh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNDVldmNv
# ZGVzaWduY2EyMDIwLmNybDATBgNVHSUEDDAKBggrBgEFBQcDAzAfBgNVHSMEGDAW
# gBQlndD8WQmGY8Xs87ETO1ccA5I2ETAdBgNVHQ4EFgQU0Vg7IAYAK18fI9dI1YKi
# WA0D1bEwDQYJKoZIhvcNAQELBQADggIBAFOdA15mFwRIM54PIL/BDZq9RU9IO+YO
# lAoAYTJHbiTY9ZqvA1isS6EtdYKJgdP/MyZoW7RZmcY5IDXvXFj70TWWvfdqW/Qc
# MMHtSqhiRb4L92LtR4lS+hWM2fptECpl9BKH28LBZemdKS0jryBEqyAmuEoFJNDk
# wxzQVKPksvapvmSYwPiBCtzPyHTRo5HnLBXpK/LUBJu8epAgKz6LoJjnrTIF4U8R
# owrtUC0I6f4uj+sKYE0iV3/TzwsTJsp7MQShoILPr1/75fQjU/7Pl2fbM++uAFBC
# sHQHYvar9KLslFPX4g+cDdtOHz5vId8QYZnhCduVgzUGvELmXXR1FYV7oJNnh3eY
# Xc5gm7vSNKlZB8l7Ls6h8icBV2zQbojDiH0JOD//ph62qvnMp8ev9mvhvLXRCIxc
# aU7CYI0gNVvg9LPi5j1/tswqBc9XAfHUG9ZYVxYCgvynEmnJ5TuEh6GesGRPbNIL
# l418MFn4EPQUqxB51SMihIcyqu6+3qOlco8Dsy1y0gC0Hcx+unDZPsN8k+rhueN2
# HXrPkAJ2bsEJd7adPy423FKbA7bRCOc6dWOFH1OGANfEG0Rjw9RfcsI84OkKpQ7R
# XldpKIcWuaYMlfYzsl+P8dJru+KgA8Vh7GTVb5USzFGeMyOMtyr1/L2bIyRVSiLL
# 8goMl4DTDOWeMYIRRDCCEUACAQEwbDBcMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQ
# R2xvYmFsU2lnbiBudi1zYTEyMDAGA1UEAxMpR2xvYmFsU2lnbiBHQ0MgUjQ1IEVW
# IENvZGVTaWduaW5nIENBIDIwMjACDHBNxPwWOpXgXVV8DDANBglghkgBZQMEAgEF
# AKB8MBAGCisGAQQBgjcCAQwxAjAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEE
# MBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMC8GCSqGSIb3DQEJBDEiBCCa
# nsn94rFUq32We9/Y19DWqtF+nuaJymiRnHi3rmYXMDANBgkqhkiG9w0BAQEFAASC
# AgCCe3Iye08NNzfPjlTI87B+kuSGU2ksuDQIUtTrx2bQpQNIVMIyTxo0pCn4KUto
# QXpIh1/OJd3r1dCleSoTBi0+SwgXfKqGmWfceZBamV+J1iiXZpGPSleTSKt3+o5V
# J24jjI1iDy2oLddcpGOPL6nkR7VTBWfTpnt6d1p+y5/UKVyxtwdV2JppgDRO2nk+
# G9vrEF4GWkj3HbIqdEHaYBE6jghyh5clowd+tt4mDsf8WHqr38UONs7O9aHRpVOq
# xso2Yper/JJSRreWAFtNhIzbazlEBxxUO0rhpeQB0PWC+43/uhYy/UsHgzcWhumt
# ffXCiOFtSChdslJzpUwZ1iMlUclg4sRsnAa03VT6rEPv+1Mogsi9YII00CUASgLN
# IuKfmPYa1qfbbdHj1iM7sMqZ8qqLt383vC15z2VBxeHpGURaa2159MVNLFX4u4yy
# QSQr07uT0TR+Ga/Gm3w9gpXzQA5VDSyBYRWJbO6m+RJ5znHR4oYKHbVGzdtHagpA
# 2xbZUOhHkxM7BmLv0PsLwGJPYQ0DT2nlRlmAg+BfgKbweA5syAP7pOb6+PjqfO+1
# nHw9QsuSPjsw4iX7jTOLCP2mUeGsZzWsRUrItBszSxhEhfXzziEw21XK9uZacq9W
# WMymjzGsCEhLAqybY8GTGCxl7juZoEI0BBca3gw7xorqJaGCDiswgg4nBgorBgEE
# AYI3AwMBMYIOFzCCDhMGCSqGSIb3DQEHAqCCDgQwgg4AAgEDMQ0wCwYJYIZIAWUD
# BAIBMIH+BgsqhkiG9w0BCRABBKCB7gSB6zCB6AIBAQYLYIZIAYb4RQEHFwMwITAJ
# BgUrDgMCGgUABBTi1v6u0XmvmD5Wlg7b5c9ugGHIzwIUITkPBcr+e7YkdVDGZhcJ
# u9ShT38YDzIwMjIwMzIyMTYxNTUwWjADAgEeoIGGpIGDMIGAMQswCQYDVQQGEwJV
# UzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5bWFu
# dGVjIFRydXN0IE5ldHdvcmsxMTAvBgNVBAMTKFN5bWFudGVjIFNIQTI1NiBUaW1l
# U3RhbXBpbmcgU2lnbmVyIC0gRzOgggqLMIIFODCCBCCgAwIBAgIQewWx1EloUUT3
# yYnSnBmdEjANBgkqhkiG9w0BAQsFADCBvTELMAkGA1UEBhMCVVMxFzAVBgNVBAoT
# DlZlcmlTaWduLCBJbmMuMR8wHQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3Jr
# MTowOAYDVQQLEzEoYykgMjAwOCBWZXJpU2lnbiwgSW5jLiAtIEZvciBhdXRob3Jp
# emVkIHVzZSBvbmx5MTgwNgYDVQQDEy9WZXJpU2lnbiBVbml2ZXJzYWwgUm9vdCBD
# ZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0xNjAxMTIwMDAwMDBaFw0zMTAxMTEy
# MzU5NTlaMHcxCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
# dGlvbjEfMB0GA1UECxMWU3ltYW50ZWMgVHJ1c3QgTmV0d29yazEoMCYGA1UEAxMf
# U3ltYW50ZWMgU0hBMjU2IFRpbWVTdGFtcGluZyBDQTCCASIwDQYJKoZIhvcNAQEB
# BQADggEPADCCAQoCggEBALtZnVlVT52Mcl0agaLrVfOwAa08cawyjwVrhponADKX
# ak3JZBRLKbvC2Sm5Luxjs+HPPwtWkPhiG37rpgfi3n9ebUA41JEG50F8eRzLy60b
# v9iVkfPw7mz4rZY5Ln/BJ7h4OcWEpe3tr4eOzo3HberSmLU6Hx45ncP0mqj0hOHE
# 0XxxxgYptD/kgw0mw3sIPk35CrczSf/KO9T1sptL4YiZGvXA6TMU1t/HgNuR7v68
# kldyd/TNqMz+CfWTN76ViGrF3PSxS9TO6AmRX7WEeTWKeKwZMo8jwTJBG1kOqT6x
# zPnWK++32OTVHW0ROpL2k8mc40juu1MO1DaXhnjFoTcCAwEAAaOCAXcwggFzMA4G
# A1UdDwEB/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgEAMGYGA1UdIARfMF0wWwYL
# YIZIAYb4RQEHFwMwTDAjBggrBgEFBQcCARYXaHR0cHM6Ly9kLnN5bWNiLmNvbS9j
# cHMwJQYIKwYBBQUHAgIwGRoXaHR0cHM6Ly9kLnN5bWNiLmNvbS9ycGEwLgYIKwYB
# BQUHAQEEIjAgMB4GCCsGAQUFBzABhhJodHRwOi8vcy5zeW1jZC5jb20wNgYDVR0f
# BC8wLTAroCmgJ4YlaHR0cDovL3Muc3ltY2IuY29tL3VuaXZlcnNhbC1yb290LmNy
# bDATBgNVHSUEDDAKBggrBgEFBQcDCDAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQ
# VGltZVN0YW1wLTIwNDgtMzAdBgNVHQ4EFgQUr2PWyqNOhXLgp7xB8ymiOH+AdWIw
# HwYDVR0jBBgwFoAUtnf6aUhHn1MS1cLqBzJ2B9GXBxkwDQYJKoZIhvcNAQELBQAD
# ggEBAHXqsC3VNBlcMkX+DuHUT6Z4wW/X6t3cT/OhyIGI96ePFeZAKa3mXfSi2VZk
# hHEwKt0eYRdmIFYGmBmNXXHy+Je8Cf0ckUfJ4uiNA/vMkC/WCmxOM+zWtJPITJBj
# SDlAIcTd1m6JmDy1mJfoqQa3CcmPU1dBkC/hHk1O3MoQeGxCbvC2xfhhXFL1TvZr
# jfdKer7zzf0D19n2A6gP41P3CnXsxnUuqmaFBJm3+AZX4cYO9uiv2uybGB+queM6
# AL/OipTLAduexzi7D1Kr0eOUA2AKTaD+J20UMvw/l0Dhv5mJ2+Q5FL3a5NPD6ita
# s5VYVQR9x5rsIwONhSrS/66pYYEwggVLMIIEM6ADAgECAhB71OWvuswHP6EBIwQi
# QU0SMA0GCSqGSIb3DQEBCwUAMHcxCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1h
# bnRlYyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWU3ltYW50ZWMgVHJ1c3QgTmV0d29y
# azEoMCYGA1UEAxMfU3ltYW50ZWMgU0hBMjU2IFRpbWVTdGFtcGluZyBDQTAeFw0x
# NzEyMjMwMDAwMDBaFw0yOTAzMjIyMzU5NTlaMIGAMQswCQYDVQQGEwJVUzEdMBsG
# A1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5bWFudGVjIFRy
# dXN0IE5ldHdvcmsxMTAvBgNVBAMTKFN5bWFudGVjIFNIQTI1NiBUaW1lU3RhbXBp
# bmcgU2lnbmVyIC0gRzMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCv
# Doqq+Ny/aXtUF3FHCb2NPIH4dBV3Z5Cc/d5OAp5LdvblNj5l1SQgbTD53R2D6T8n
# SjNObRaK5I1AjSKqvqcLG9IHtjy1GiQo+BtyUT3ICYgmCDr5+kMjdUdwDLNfW48I
# HXJIV2VNrwI8QPf03TI4kz/lLKbzWSPLgN4TTfkQyaoKGGxVYVfR8QIsxLWr8mwj
# 0p8NDxlsrYViaf1OhcGKUjGrW9jJdFLjV2wiv1V/b8oGqz9KtyJ2ZezsNvKWlYEm
# LP27mKoBONOvJUCbCVPwKVeFWF7qhUhBIYfl3rTTJrJ7QFNYeY5SMQZNlANFxM48
# A+y3API6IsW0b+XvsIqbAgMBAAGjggHHMIIBwzAMBgNVHRMBAf8EAjAAMGYGA1Ud
# IARfMF0wWwYLYIZIAYb4RQEHFwMwTDAjBggrBgEFBQcCARYXaHR0cHM6Ly9kLnN5
# bWNiLmNvbS9jcHMwJQYIKwYBBQUHAgIwGRoXaHR0cHM6Ly9kLnN5bWNiLmNvbS9y
# cGEwQAYDVR0fBDkwNzA1oDOgMYYvaHR0cDovL3RzLWNybC53cy5zeW1hbnRlYy5j
# b20vc2hhMjU2LXRzcy1jYS5jcmwwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwDgYD
# VR0PAQH/BAQDAgeAMHcGCCsGAQUFBwEBBGswaTAqBggrBgEFBQcwAYYeaHR0cDov
# L3RzLW9jc3Aud3Muc3ltYW50ZWMuY29tMDsGCCsGAQUFBzAChi9odHRwOi8vdHMt
# YWlhLndzLnN5bWFudGVjLmNvbS9zaGEyNTYtdHNzLWNhLmNlcjAoBgNVHREEITAf
# pB0wGzEZMBcGA1UEAxMQVGltZVN0YW1wLTIwNDgtNjAdBgNVHQ4EFgQUpRMBqZ+F
# zBtuFh5fOzGqeTYAex0wHwYDVR0jBBgwFoAUr2PWyqNOhXLgp7xB8ymiOH+AdWIw
# DQYJKoZIhvcNAQELBQADggEBAEaer/C4ol+imUjPqCdLIc2yuaZycGMv41UpezlG
# Tud+ZQZYi7xXipINCNgQujYk+gp7+zvTYr9KlBXmgtuKVG3/KP5nz3E/5jMJ2aJZ
# EPQeSv5lzN7Ua+NSKXUASiulzMub6KlN97QXWZJBw7c/hub2wH9EPEZcF1rjpDvV
# aSbVIX3hgGd+Yqy3Ti4VmuWcI69bEepxqUH5DXk4qaENz7Sx2j6aescixXTN30cJ
# hsT8kSWyG5bphQjo3ep0YG5gpVZ6DchEWNzm+UgUnuW/3gC9d7GYFHIUJN/HESwf
# AD/DSxTGZxzMHgajkF9cVIs+4zNbgg/Ft4YCTnGf6WZFP3YxggJaMIICVgIBATCB
# izB3MQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24x
# HzAdBgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdvcmsxKDAmBgNVBAMTH1N5bWFu
# dGVjIFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0ECEHvU5a+6zAc/oQEjBCJBTRIwCwYJ
# YIZIAWUDBAIBoIGkMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAcBgkqhkiG
# 9w0BCQUxDxcNMjIwMzIyMTYxNTUwWjAvBgkqhkiG9w0BCQQxIgQg9QQloR4IDDHP
# 40GCUEvJoPmYlsojJdrNyaZpzMhzWG0wNwYLKoZIhvcNAQkQAi8xKDAmMCQwIgQg
# xHTOdgB9AjlODaXk3nwUxoD54oIBPP72U+9dtx/fYfgwCwYJKoZIhvcNAQEBBIIB
# AF3BRYayBjyFkWSwUUBRBE2m/Nd67P73UsujCPXRL5G8uz8s1NjHy3m9QhjGRoxe
# bXyn1SgUPhZOLrezsbSM1OCx3RKyT9sjOFQCtj3nDQmozA7ghUiE3SgnwPyx6Ck7
# IXwfBGHKBbsnz+xtlNiqiJaGmMj1uPi5Q3Or6aXCcuMTGAt2Aj8UjiF5NDQLkLCt
# WEb/IeKFPey5teISejByBLTb+L2r0PFal1ouKYgFxq+CERBOAQfDS10zsUONa1h8
# iHLJyp7ZvDOAwdJbKKJTN5VLKQDZF9y8IeSvlAaUYDdYIsp/ZNFeVHozu0yXseeX
# M/jCXN3bE78LRktEB1kvX/I=
# SIG # End signature block
