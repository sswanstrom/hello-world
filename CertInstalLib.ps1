.".\CommonLibrary.ps1"
# Usage:  Get the Current Time stamp to log the timestamp
# Syntax: Get-TimeStamp
function Get-TimeStamp_test{
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}
function Get-CertificateThumbprint {
    # 
    # This will return a certificate thumbprint, null if the file isn't found or throw an exception.
    #
    [cmdletbinding()]
    param 
    (
        [parameter(Mandatory = $true)][string] $CertPath,
        [parameter(Mandatory = $false)][string] $Certpwd
    )

    try 
    {
        if (!(Test-Path $CertPath)) {
            return $null;
        }

        if ($Certpwd) {
            $sSecStrPassword = ConvertTo-SecureString -String $Certpwd -Force –AsPlainText
        }
        
        $certificateObject = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
        $certificateObject.Import($CertPath, $sSecStrPassword,'DefaultKeySet');

        return $certificateObject.Thumbprint
    } 
    catch [Exception] {
        # 
        # Catch accounts already added.
        throw $_;
    }
}

function ValidateCerts{
  # 
    # This will return a certificate installed or not.
    #
    [cmdletbinding()]
    param 
    (
        [parameter(Mandatory = $true)][string] $CertPath,
        [parameter(Mandatory = $true)][string] $Certpwd
    )
    $certThumbprint= Get-CertificateThumbprint -CertPath $CertPath -Certpwd $Certpwd
   # $certThumbprint="TST"+$certThumbprint
    LogWrite -logstring "Vaidating Cert .."
   # Write-Host $certThumbprint
     
    $isAlreadyInstalled=$false
    
    if(Get-ChildItem -Path Cert:\LocalMachine\my | Where-Object {$_.Thumbprint -eq $certThumbprint})
    {
         LogWrite -logstring "found .."
        $isAlreadyInstalled=$true
    }
    
    return $isAlreadyInstalled
}

 
function Install_Certificate {
[cmdletbinding()]
    param
    (
       [Parameter(Mandatory=$true)] 
       $certPath,
       [Parameter(Mandatory=$true)]  
        $Certpwd = $null
    )
    $certRootStore = “localMachine”
    $certStore = “My”
    LogWrite -logstring "Cert installing.."
    if ($Certpwd -eq $null) {
    
        LogWrite -logstring "Cert Password is missing. Getting the password"
        $Certpwd = read-host “Enter the pfx password” -assecurestring
    }
    
    if((ValidateCerts -CertPath $certPath -Certpwd $Certpwd) -eq "true")
    {
         LogWrite -logstring "Cert already installed"
    }
    else
    {
    
        $pfx = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
        $pfx.import($certPath,$Certpwd,“Exportable,PersistKeySet”)
       
        $store = New-Object System.Security.Cryptography.X509Certificates.X509Store($certStore,$certRootStore)
        $store.open(“MaxAllowed”)
        $store.add($pfx)
        $store.close()
        LogWrite -logstring  "Cert  installed"
    }
}

function CertInstallation_OLD
{[cmdletbinding()]
    param
    (
       [Parameter(Mandatory=$true)] 
       $environmentName
     
    )
     LogWrite -logstring "Cert installing.." 
     LogWrite -logstring "Cert installing.." 
    $certpassword="No_certs"
    if(($environmentName -eq "testc" ) -and ($environmentName -eq "testg") -and ($environmentName -eq "testh"))
    {
      $environmentName ="test"
    }

    $certpassword= Switch ($environmentName)
      {
       "dev" { "D3v!_@dvant";break }
       "qa" { "Q@!_@dvant";break }
       "STAGE" { "St@g3!2019@dvanT";break }
       "prod" { "Pr0d!2019@dvanT";break }
       "test" { "T3st!2019@dvanT";break }     
        default {"No_certs"; break}
      }
     LogWrite -logstring $certpassword
    if (!($certpassword -eq "No_certs"))
    {
       $certPath= "{0}\certs\{1}\star_{1}.advantasure.com.pfx" -f $(get-location).Path,$environmentName
       LogWrite -logstring  $certPath
       Install_Certificate -certPath  $certPath -Certpwd $certpassword
    }
}
function CertInstallation
{[cmdletbinding()]
    param
    (
       [Parameter(Mandatory=$true)] 
        $environmentName,
        [Parameter(Mandatory=$true)] 
       $ssoCertneeded
     
    )
     LogWrite -logstring "Cert installing.." 
     LogWrite -logstring "Cert installing.." 
    $environmentName=$environmentName.ToLower()
    $certpassword="No_certs"
    
    if(($environmentName -eq "testc" ) -or ($environmentName -eq "testg") -or ($environmentName -eq "testh"))
    {
        
      $environmentName ="test"
    }

    $certpassword= Switch ($environmentName)
      {
       "dev" { "D3v!_@dvant";break }
       "qa" { "Q@!_@dvant";break }
       "STAGE" { "St@g3!2019@dvanT";break }
       "prod" { "Pr0d!2019@dvanT";break }
       "test" { "T3st!2019@dvanT";break }     
        default {"No_certs"; break}
      }
     LogWrite -logstring $certpassword
    if (!($certpassword -eq "No_certs"))
    {
       $certPath= "{0}\certs\{1}\star_{1}.advantasure.com.pfx" -f $(get-location).Path,$environmentName
       LogWrite -logstring  $certPath
       Install_Certificate -certPath  $certPath -Certpwd $certpassword

       if($ssoCertneeded -eq "true")
       {
         $certPath= "{0}\certs\{1}\sso.{1}.advantasure.com.pfx" -f $(get-location).Path,$environmentName
         LogWrite -logstring  $certPath
        Install_Certificate -certPath  $certPath -Certpwd $certpassword
       }
    }
}

