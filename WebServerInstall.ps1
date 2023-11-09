.".\VTAutomationLibrary.ps1" 
.".\ComponentsInstallLibrary.ps1" 
.".\CommonLibrary.ps1"

cls 
 
$configFileDirectory=".\configs"
$configFileName="IISSetupConfig.psd1"
Import-LocalizedData -BaseDirectory $configFileDirectory -FileName $configFileName -BindingVariable configDataString
$configData = ConvertFrom-StringData $configDataString


$configData.GetEnumerator() 

$confirmation = Read-Host "Are you ok to Proceed with above variables?[Y/N]"
if ($confirmation -eq 'y') 
{
    $webCinstall = Read-Host "Do you want to install Web Components?[Y/N]"
    if ($webCinstall -eq 'y') 
    {   c:\windows\system32\tzutil /s "Eastern Standard Time"
        installWebComponents
    }

    $hasAdminportal= $true
    $hasClaims= $true
    $hasEnrollment= $true
    $hasEnrollmentPDP= $true
    $hasClaimService= $true

    if($configData.hasAdminportal -eq 'false'){$hasAdminportal = $false  }
    if($configData.hasClaims -eq 'false')   {$hasClaims = $false  }
    if($configData.hasEnrollment -eq 'false')  {$hasEnrollment = $false  }
    if($configData.hasEnrollmentPDP -eq 'false')  {$hasEnrollmentPDP = $false  }
    if($configData.hasClaimsService -eq 'false'){$hasClaimService = $false  }
    
    CreateCoreApplications  -userName $configData.userName -password $configData.password  -rootDrive  $configData.rootDrive  -clientName $configData.clientName  -environmentName  $configData.environmentName  -hostName $configData.hostName     -hasAdminportal $hasAdminportal -HasClaims $hasClaims  -hasEnrollment $hasEnrollment -hasEnrollmentPDP $hasEnrollmentPDP -hasClaimsService $hasClaimService
}
else 
{
    Write-Host "Process Cancelled by the user.."     
}

 