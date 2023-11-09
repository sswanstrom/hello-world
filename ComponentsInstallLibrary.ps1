.".\CommonLibrary.ps1"

function installWebComponents
{

    Set-LogFileName ".\IISServerSetup$(gc env:computername)$env:username.txt"
    LogWrite -logstring  "Start-------------------------------------------"
    Logwrite -logstring "Script run by: " $env:UserName
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $false) 
    {
      LogWrite -logstring  "This script requires Administrator privileges. Try executing by doing right click -> 'Run as Administrator'"
      LogWrite -logstring "  This script requires Administrator privileges. Try executing by doing right click -> 'Run as Administrator'"
      return;
    }
    #import Server manager
    Import-module servermanager

    if((Get-WindowsFeature *web-server*).installed) 
    {

        LogWrite -logstring  "web-server already Installed."
    }

    else 
    {
        install-windowsfeature web-server -IncludeManagementTools -verbose
        LogWrite -logstring  "Installed web-server."
    }


    if((Get-WindowsFeature *web-security*).installed) 
    {

        LogWrite -logstring  "web-security already Installed."
    }
    else 
    {
        install-windowsfeature web-security -IncludeAllSubFeature -verbose
        LogWrite -logstring  "Installed web-security -IncludeAllSubFeature."
    }

    if((Get-WindowsFeature telnet-client, dsc-service, powershell-ise, WAS, web-mgmt-tools, web-mgmt-console, web-mgmt-compat, web-metabase).installed) 
    {
        LogWrite -logstring  "telnet-client, dsc-service, powershell-ise, WAS, web-mgmt-tools, web-mgmt-console, web-mgmt-compat, web-metabase already Installed."
    }
    else 
    {
        install-windowsfeature telnet-client, dsc-service, powershell-ise, WAS, web-mgmt-tools, web-mgmt-console, web-mgmt-compat, web-metabase -verbose
        LogWrite -logstring "Installed telnet-client, dsc-service, powershell-ise, WAS, web-mgmt-tools, web-mgmt-console, web-mgmt-compat, web-metabase."
    }  
    if((Get-WindowsFeature application-server, as-net-framework).installed) 
    {
        LogWrite -logstring  "application-server, as-net-framework already Installed."
    }
    else 
    {
        install-windowsfeature application-server, as-net-framework -verbose
        LogWrite -logstring  "application-server, as-net-framework."
    }
    if((Get-WindowsFeature NET-Framework-Features, NET-Framework-Core, NET-HTTP-Activation).installed) 
    {
        LogWrite -logstring  " NET-Framework-Features,NET-Framework-Core, NET-HTTP-Activation already Installed."
    }
    else 
    {
        install-windowsfeature NET-Framework-Features, NET-Framework-Core, NET-HTTP-Activation -verbose
        LogWrite -logstring  "Installed  NET-Framework-Features, NET-Framework-Core, NET-HTTP-Activation."
    }
 
    if((Get-WindowsFeature -name NET-WCF-HTTP-Activation45).installed)
    {
        LogWrite -logstring  "NET-WCF-HTTP-Activation45 already Installed."
    }
    else
    {
        install-windowsfeature NET-WCF-HTTP-Activation45 -verbose
        LogWrite -logstring  "Installed  NET HTTP activation Installed."
    }
       if((Get-WindowsFeature -name Windows-Identity-Foundation).installed)
    {
        LogWrite -logstring  "WIF already Installed."
    }
    else
    {
        Install-WindowsFeature Windows-Identity-Foundation -verbose
        LogWrite -logstring  "Installed  WIF Installed."
    }
    

    Write-Host "Log file Created .\IISServerSetup$(gc env:computername).log"
}

function installUtilityComponents
{
    [cmdletbinding()]
    param(
    [Parameter(Mandatory=$true)]
    [string]$installsourcedir
    )
    $installsourcedir= $installsourcedir
    $ToolsDir=$installsourcedir+"Tools"
   
    Write-Host $ToolsDir
    $confirmation = Read-Host "Are you ok to Proceed with above variables?[Y/N]"
    if ($confirmation -eq 'n') 
    {
    return
    }
    Install7zipLocal($ToolsDir)
    InstallAdobeLocal($ToolsDir)
    InstallOCRFont ($ToolsDir)
    installSQLODBC($ToolsDir)
    installSQLCMD ($ToolsDir)
    #InstallOracleClient($ToolsDir)

}

function InstallBEQComponents
{
    Set-LogFileName ".\IISServerSetup$(gc env:computername).txt"
    LogWrite -logstring  "Start-------------------------------------------"
    Logwrite -logstring "Script run by: " $env:UserName
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $false) 
    {
      LogWrite -logstring  "This script requires Administrator privileges. Try executing by doing right click -> 'Run as Administrator'"
      LogWrite -logstring "  This script requires Administrator privileges. Try executing by doing right click -> 'Run as Administrator'"
      return;
    }
    #import Server manager
    Import-module servermanager

    if((Get-WindowsFeature *web-server*).installed) 
    {
        LogWrite -logstring  "web-server already Installed."
    }
    else 
    {
        install-windowsfeature web-server -IncludeManagementTools -verbose
        LogWrite -logstring  "Installed web-server."
    }
}

function installADLDSComponents
{

}

####################################### DOWNLOAD FILES FROM WEB ###################################################


function DownloadFileFromWeb{
[cmdletbinding()]
param(
[Parameter(Mandatory=$true)]
[string]$source,
[Parameter(Mandatory=$true)]
[string]$destination
)
    try
    {
    LogWrite -logstring "Downloading file from WEB source:$source"
    if (Get-Command 'Invoke-Webrequest')
    {
        Invoke-WebRequest $source -OutFile $destination
    }
    else
    {
        $WebClient = New-Object System.Net.WebClient
        $webclient.DownloadFile($source, $destination)
    }
    }
    catch {
        LogWrite -logstring "Error: Unable to download file from WEB $source. Exception:  " + $_.Exception 
    }
}
####################################### DOWNLOAD FILES END ###################################################

####################################### DOWNLOAD Component File BEGIN ###################################################


function install7zip{
[cmdletbinding()]
param(
[Parameter(Mandatory=$true)]
[string]$workdir
)
    # Check if work directory exists if not create it
    CreateApplicationFolder -folderName $workdir 
    # Download the installer for 7zip
    $source = "http://www.7-zip.org/a/7z1805-x64.msi"
    $destination="$workdir\7zip\"
    
    CreateApplicationFolder -folderName $destination
    $destination = "$destination\7-Zip.msi"
    
    DownloadFileFromWeb ($source,$destination)

    LogWrite -logstring "Installing 7Zip "
    msiexec.exe /i  $destination /qb
    #msiexec.exe /i "$workdir\7zip\7z1805-x64.msi" /qb
}


function installAdobe{
[cmdletbinding()]
param(
[Parameter(Mandatory=$true)]
[string]$workdir
)

    # Check if work directory exists if not create it
    CreateApplicationFolder -folderName $workdir 

    # Download the installer for adobe
    $source = "http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/1502320053/AcroRdrDC1502320053_en_US.exe"
    $destination="$workdir\adobe\"

    CreateApplicationFolder -folderName $destination
    $destination = "$destination\adobeDC.exe"

    DownloadFileFromWeb ($source,$destination)
    LogWrite -logstring "Installing Adobe "
    Start-Process -FilePath $destination -ArgumentList "/sPB /rs"
}

####################################### DOWNLOAD Component File END ###################################################

####################################### Install Component File LOCAL BEGIN ###################################################
function install7zipLocal{
[cmdletbinding()]
param(
[Parameter(Mandatory=$true)]
[string]$installdir
)

    $destination="$installdir\7zip\7z1900-x64.msi"
    LogWrite -logstring "Installing 7zip from local path $destination"
    msiexec.exe /i  $destination /qb 
}

function installAdobeLocal{
[cmdletbinding()]
param(
[Parameter(Mandatory=$true)]
[string]$installdir
)

    $destination="$installdir\Adobe\AcroRdrDC1902120047_en_US.exe"
    LogWrite -logstring "Installing adobe from local path $destination"
    Start-Process -FilePath $destination -ArgumentList "/sPB /rs" -wait
}

function installOCRFont{
[cmdletbinding()]
param(
[Parameter(Mandatory=$true)]
[string]$installdir
)
    $installdir= "$installdir\OCR Font"

    $objShell = New-Object -ComObject Shell.Application
    $objFolder = $objShell.Namespace(0x14)

    $Fonts = Get-ChildItem -Path $installdir  -Recurse -Include *.ttf,*.otf

    foreach($File in $Fonts) 
    {
    #   Write-Host $File.Name
        $fontPath="c:\windows\fonts\$($File.Name)"
    #    Write-Host $fontPath
        If (!(Test-Path ($fontPath)))
        {
            LogWrite -logstring "Installing OCR font.."
            $objFolder.CopyHere($File.fullname)
        }
        else
        {
            LogWrite -logstring "OCR font already exists.."
        }
    }
}
function installSQLODBC
{
    [cmdletbinding()]
    param(
    [Parameter(Mandatory=$true)]
    [string]$installdir
    )
    $destination="$installdir\SQLCMD\msodbcsql.msi"
    LogWrite -logstring "Installing SQLODBC from local path $destination"w
   # msiexec.exe /i  $destination  /qb
    msiexec /quiet /passive /qn / $destination  IACCEPTMSODBCSQLLICENSETERMS=YES 
}
function installSQLCMD
{
    [cmdletbinding()]
    param(
    [Parameter(Mandatory=$true)]
    [string]$installdir
    )
    $destination="$installdir\SQLCMD\MsSqlCmdLnUtils.msi "
    LogWrite -logstring "Installing SQLCMD from local path $destination"w
    msiexec.exe /i  $destination  /passive IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES
}

function installOracleClient{
    [cmdletbinding()]
    param(
    [Parameter(Mandatory=$true)]
    [string]$installdir
    )
    $installdir= "$installdir\Oracle Client\"
    cd $installdir
    setup -silent "ORACLE_BASE=c:\oracle" "ORACLE_HOME=c:\oracle\app\Product\" "oracle.install.IsBuiltInAccount=true" "INSTALL_TYPE=Administrator" "oracle.installer.autoupdates.option=SKIP_UPDATES"
}
####################################### DOWNLOAD Component File BEGIN ###################################################