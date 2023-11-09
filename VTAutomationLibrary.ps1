# This file has all necessary defintions and functions for create web site configuration
# Authour : Navaneethan Jayapal
# Created Date: 10/01/2018

.".\CommonLibrary.ps1"
.".\certInstalLib.ps1"

####################################### FOLDER CREATION FUNCTIONS ###################################################

 CertInstallation -environmentName $environmentName
function ValidateUsersInLocalAdmin{

[cmdletbinding()]
param(
[Parameter(Mandatory=$true)]
[string]$userName)

   
    $Computer = [ADSI]"WinNT://$Env:computername"
    $Groups = ($Computer.psbase.Children | Where {$_.psbase.schemaClassName -eq 'group'} ) | where Name -EQ "Administrators"
    $usr=$userName.Replace("\","/").ToUpper();   
    $GroupAndUsers = New-Object -TypeName PSCustomObject -Property @{
        User = ($Groups.psbase.Invoke("Members") | % {
        $_.gettype().InvokeMember("ADsPath","GetProperty",$null,$_,$null)}) -join ','
        } | Select-Object -Property Group,User
    

    $result= $GroupAndUsers.User.ToUpper().Contains($usr)    
   
    return $result
}
 
function AdduserTolocalAdmin{
[cmdletbinding()]
param(
[Parameter(Mandatory=$true)]
[string]$userName)
   $user=ValidateUsersInLocalAdmin -userName $userName
   if($user -eq $false)
      {
        $username=$username.Replace("\", "\\")
        LogWrite -logstring "Granting the local admin privilege $Env:computername"
        LogWrite -logstring $userName
        $group = [ADSI]"WinNT://$($Env:computername)/Administrators,group" 
        $group.add("WinNT://$($userName),user")
        LogWrite -logstring "User $username is added into local admin Group"
    }
    else
    {
        LogWrite -logstring "User $userName already part of the local Admin group"
    }
}

function AddLocalDNSentry
{
[cmdletbinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$hostName
    )

    $ip = (Test-Connection -ComputerName (hostname) -Count 1  | Select IPV4Address).IPV4Address
    LogWrite -logstring "IPADDRESS: $ip"
    $hostentry ="{0} {1}" -f $ip,$hostName
    LogWrite -logstring "hostIP $hostentry"     

    If ((Get-Content "$($env:windir)\system32\Drivers\etc\hosts" ) -notcontains $hostentry )   
    {
        LogWrite -logstring "Adding local dns entry"
        ac -Encoding UTF8  "$($env:windir)\system32\Drivers\etc\hosts" $hostentry 
    }
    else 
    {
        LogWrite -logstring "local dns entry already exists"
    }

}
####################################### Files and FOLDER PERMISSIONS GRANT END ###################################################



# function CreateWebSite{
#[cmdletbinding()]
#param(
#[Parameter(Mandatory=$true)]
#[string]$siteName,
#[Parameter(Mandatory=$true)]
#[string]$sitePath
#)
    #$site =New-WebSite -Name $siteName  -ApplicationPool $siteName  -Force -PhysicalPath $sitePath
#}


####################################### IIS SETTINGS FUNCTIONS ###################################################


# Usage  : Create WEB SITE in IIS. It Checks the Site already exits or not. If it's not exists,will create
# Syntax : CreateWebSite -siteName "BCBSRI-TEST" -sitePath "D\Coreapps\"

 function CreateWebSite
 {
    [cmdletbinding()]
    param(
    [Parameter(Mandatory=$true)]
    [string]$siteName,
    [Parameter(Mandatory=$true)]
    [string]$sitePath,
    [Parameter(Mandatory=$true)]
    [string]$UserName,
    [Parameter(Mandatory=$true)]
    [string]$password,
    [Parameter(Mandatory=$true)]
    [string]$environmentName,
    [string]$appName,
    [Parameter(Mandatory=$true)]
    [string]$hostName
    )

    ##[Parameter(Mandatory=$true)]
    ##[string]$siteIp,
    ##[Parameter(Mandatory=$true)]
    ##[string]$sitePort,
     
    $fullSiteName = "IIS:\Sites\{0}" -f $siteName
    if (Test-Path $fullSiteName) 
    {
	    LogWrite -logstring "Web Site $($siteName) already exists" 
    }
    else 
    {
        LogWrite -logstring "Site Physical Path: $($sitePath).."
    	LogWrite -logstring "Creating  Web Site $($siteName)..."  
	    try 
        {  
            $appPoolName=$siteName
            if($appName -ne "")
            {
                $appPoolName= "{0}-{1}" -f $siteName,$appName
                $sitePath= "{0}\{1}" -f $sitePath,$appName
            }
            LogWrite -logstring "appPoolName: $($appPoolName).."
    	    LogWrite -logstring "sitePath $($sitePath)..."  
            
            CreateApplicationFolder -folderName $sitePath

            CreateApplicationPool -appPoolName $appPoolName  -userName $UserName -Password $password

            $site =New-WebSite -Name $siteName  -ApplicationPool $appPoolName  -Force -PhysicalPath $sitePath  
            LogWrite -logstring "Created the  Web Site $($siteName) with ApplicationPool $siteName "  

    	    Set-WebBinding -Name $siteName -BindingInformation "*:80:" -PropertyName HostHeader -Value  $hostname
            LogWrite -logstring "Creating https bindings under $($siteName)"  

           # New-WebBinding -Name $siteName -IPAddress "*" -HostHeader $hostname -Port 443 -Protocol https -SslFlags 0
            
            #$domainindex= $hostname.substring(0,$hostname.substring(0,$hostname.lastindexof(".")).LastIndexOf(".")).LastIndexOf(".")
  
            #Assigning Certificates..
           # $certName="*{0}*" -f $hostname.substring((($hostname.substring(0,$hostname.lastindexof("."))).lastindexof(".")+1),$hostname.length-(($hostname.substring(0,$hostname.lastindexof("."))).lastindexof(".")+1)) 
             
            #$certName="*{0}*" -f $hostname.substring($domainindex,$hostname.length-$domainindex) 
            $certName="*.{0}.advantasure.com" -f $environmentName 
            
            $certificate = Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.subject -like $certName} | Select-Object -ExpandProperty Thumbprint
            get-item -Path "cert:\localmachine\my\$certificate" | new-item -path IIS:\SslBindings\0.0.0.0!443!$certName -Value $certificate -Force


            New-WebBinding  -Name  $siteName -IPAddress "*" -Port 443  -Protocol "https"
            Set-WebBinding -Name $siteName -BindingInformation "*:443:" -PropertyName HostHeader -Value $hostname

            LogWrite -logstring "Settting the Credentials for the $fullSiteName"

            Set-ItemProperty  $fullSiteName -Name username -Value $UserName
            Set-ItemProperty  $fullSiteName -Name Password -Value $password
            AddLocalDNSentry -hostName $hostname
	    }
        catch 
        {
		    LogWrite -logstring ("ERROR:  Unable to create IIS Web Site $($siteName).  Exception:  " + $_.Exception) -    LogFile $LogFile
            if ($pauseAtEnd -eq $True) 
            {
                read-host "Press ENTER to continue..."
            }
		    Exit 3
        }
	}
 }


# Web Application

# Usage  : Create WEB Application in particular Site under IIS. It Checks the Application already exits or not. If it's not exists,will create one
# Syntax : CreateWebApplication -appName "MedicareGW" -siteName "BCBSRI-TEST" -applFolderName "D\Coreapps\MedicareGW"

function CreateWebApplication{
[cmdletbinding()]
param(
[Parameter(Mandatory=$true)]
[string]$appName,
[Parameter(Mandatory=$true)]
[string]$siteName,
[Parameter(Mandatory=$true)]
[string]$applicationPath,
[Parameter(Mandatory=$true)]
[string]$UserName,
[Parameter(Mandatory=$true)]
[string]$Password
)   
    
    LogWrite -logstring "Creating IIS Web Application $appName under the Site $($siteName)..."  
    try 
    {  # Logwrite -logstring "IIS:\Sites\$siteName\$appName"
        $webApps=Get-WebApplication -Site $siteName |  select @{e={$_.Path.Trim('/')};l="Name"}  
        $isfound =$false
        foreach ($app in $webApps)
        {
            if($app.Name -eq $appName)
            {
                $isfound=$true
                break;
            }
        }
        if(!($isfound))
        {
            $appPoolName=$siteName+"-"+$appName
            if(Test-Path IIS:\AppPools\$AppPoolName)
            {
                LogWrite -logstring "$appPoolName is already exists." 
            }
            else
            {
                CreateApplicationPool -appPoolName $AppPoolName
            }

            LogWrite -logstring "Application Physical Path: $($applicationPath).."
            
            LogWrite -logstring "Creating   $($appName) web application under the Site $($siteName)... with application Poll Name  $($appPoolName)"
            New-WebApplication -Name $appName -Site $siteName -ApplicationPool $appPoolName -PhysicalPath $applicationPath   
            $appName="IIS:\Sites\{0}\{1}" -f  $siteName,$appName             
            Set-ItemProperty -Path $appName -Name userName -Value $UserName
            Set-ItemProperty -Path $appName -Name password -Value $Password
        } 
        else
        {
            LogWrite -logstring "$appName is already exists"

        }

   }
   catch 
   {
        LogWrite -logstring ("ERROR:  Unable to create Web Application $($appName) under the Site $($configData.siteName).    Exception:  " + $_.Exception) 
        if ($pauseAtEnd -eq $True) {
            read-host "Press ENTER to continue..."
        }
        Exit 3
    }
}

function CreateVirtualDirectory{
[cmdletbinding()]
param(
[Parameter(Mandatory=$false)]
[string]$appName,
[Parameter(Mandatory=$true)]
[string]$siteName,
[Parameter(Mandatory=$true)]
[string]$VirtualDirName,
[Parameter(Mandatory=$true)]
[string]$VirtualDirPath
)  
     
    if($appName -eq "")
    {  $fullAppSite= "IIS:\Sites\$siteName";
       if (Test-Path ($fullAppSite))
       {
          
            LogWrite -logstring "Web Site  $fullAppSite already exists"  
            LogWrite -logstring "Creating Virtual Directory $VirtualDirName..under $fullAppSite pointing to  $VirtualDirPath"
            New-WebVirtualDirectory -site $siteName  -name $VirtualDirName   -physicalpath $VirtualDirPath
            $virtualDir= $fullAppSite+"\"+$VirtualDirName
            Set-ItemProperty $virtualDir -Name userName -Value $UserName
            Set-ItemProperty $virtualDir -Name password -Value $password
       }
       else
       {
         LogWrite -logstring "Web Site  $fullAppSite not exists.. Can't create Virtual Directory.."  
       }
    }
    else
    {
        $fullAppSite= "IIS:\Sites\$siteName\$appName";
        if (Test-Path ($fullAppSite))
       {
            LogWrite -logstring "Web Application  $fullAppSite already exists"  
            LogWrite -logstring "Creating Virtual Directory $VirtualDirName.. under $fullAppSite  pointing to  $VirtualDirPath "
            New-WebVirtualDirectory -site $siteName  -Application $appName   -name $VirtualDirName   -physicalpath $VirtualDirPath -Force
             $virtualDir= $fullAppSite+"\"+$VirtualDirName
            Set-ItemProperty $virtualDir -Name userName -Value $UserName
            Set-ItemProperty $virtualDir -Name password -Value $password
       }
       else
       {
         LogWrite -logstring "Web Application  $fullAppSite not exists.. Can't create Virtual Directory.."  
       }
    }
}

# Web Application Pool

# Usage  : Create WEB Application pool. It Checks the Application already exits or not. If it's not exists,will create one
# Syntax : CreateApplicationPool -appName "MedicareGW" -siteName "BCBSRI-TEST" -applFolderName "D\Coreapps\MedicareGW"


function CreateApplicationPool{
[cmdletbinding()]
param(
[Parameter(Mandatory=$true)]
[string]$appPoolName,
[Parameter(Mandatory=$true)]            
[string]$UserName,
[Parameter(Mandatory=$true)]            
[string]$password
)
    LogWrite -logstring "Creating  Application Pool $($appPoolName)..." 
    try 
    {
        $fullAppPoolName = "IIS:\AppPools\{0}" -f $appPoolName
        if(Test-Path IIS:\AppPools\$AppPoolName)
        {
          LogWrite -logstring "$appPoolName is already exists." 
        }
        else
        {
            $appPool=New-WebAppPool -name $appPoolName  
            LogWrite -logstring "$appPoolName is created." 
        }
        setApplicationPoolProerties -appPoolName $appPoolName -UserName $UserName -password  $password
    }
    catch 
    {
        LogWrite -logstring "ERROR:  Unable to create App Pool Name $fullAppPoolName.  Exception:  " + $_.Exception  
        if ($pauseAtEnd -eq $True) 
        {
            read-host "Press ENTER to continue..."
        }
	    Exit 3
    }
}

# setApplicationPoolProerties

# Usage  :  
# Syntax :  

function setApplicationPoolProerties{
[cmdletbinding()]
param(
[Parameter(Mandatory=$true)]
[string]$appPoolName,
[Parameter(Mandatory=$true)]            
[string]$UserName,
[Parameter(Mandatory=$true)]            
[string]$password
)
    $appPool= get-item iis:\apppools\$appPoolName;
    LogWrite -logstring "Setting up the LDAP credentails in App pool  $appPoolName"
    $appPool.processModel.username = $UserName
    $appPool.processModel.password = $password
    $appPool.processModel.identityType = 3
    $appPool.processModel.loadUserProfile = $true
    $appPool | set-item

    LogWrite -logstring "Setting  App pool idletimeout"
    Set-ItemProperty -Path IIS:\AppPools\$appPoolName -Name processModel.idleTimeout -value ( [TimeSpan]::FromMinutes(60))
     if($appPoolName.Contains("Claims"))
    { 
        LogWrite -logstring "Enabling 32bit"
        Set-ItemProperty -Path IIS:\AppPools\$appPoolName -Name  "enable32BitAppOnWin64"  -Value "true"
    }

    LogWrite -logstring "Setting up the App pool recycling timing"
    Set-ItemProperty -Path IIS:\AppPools\$appPoolName -Name Recycling.periodicRestart.time -Value "00:00:00"
    Set-ItemProperty -Path IIS:\AppPools\$appPoolName -Name recycling.periodicRestart.schedule -Value @{value = '03:00:00'}
    
}

#function AssignCertificates{
#cd IIS:\SslBindings
#get-item cert:\LocalMachine\MY\7ABF581E134280162AFFFC81E62011787B3B19B5 | new-item 0.0.0.0!443
#}

####################################### IIS SETTINGS FUNCTIONS END ###################################################


####################################### GATEWAY APP CONFIG FUNCTIONS ###################################################


# Usage  :  It will create all the necessary steps to configure all the apps
# Syntax :  CreateApplication -SitePath "D:\CoreApps" -siteName "BCBSRI-TEST" -CMSfeedsPath "D:\CMSFEEDS\" -isIntegrated "true" -ProductName "ClAIMS" -clientName "Bcri" -environmentName "TEST";

function CreateApplication
{
[cmdletbinding()]            
param(            
[Parameter(Mandatory=$true)]            
[string]$SitePath,
[Parameter(Mandatory=$true)]            
[string]$siteName,
[Parameter(Mandatory=$false)]            
[string]$CMSfeedsPath, 
[Parameter(Mandatory=$true)] 
[ValidateSet("Claims","Enrollment","EnrollmentPDP","ADMINPORTAL","ClaimsServices","CoreServices")]             
[string]$ProductName,
[Parameter(Mandatory=$true)]            
[string]$UserName,
[Parameter(Mandatory=$true)]            
[string]$password,
[Parameter(Mandatory=$true)]            
[string]$hostName
)
   

    CreateApplicationFolder -folderName $SitePath
    $applicationName= $ProductName 

    $fullSiteName = "IIS:\Sites\{0}" -f $siteName
    
    if (!(Test-Path $fullSiteName))
    {
         #if($isIntegrated -eq -$false){
         # $SitePath=$SitePath+"\"+$ProductName;}
      #  CreateWebSite -siteName $siteName -environmentName $environmentName -sitePath $SitePath -userName $UserName -Password $password -appName $ProductName -hostName $hostName
    }

    LogWrite -logstring "Configuration needed for Integrated mode.."
    
    if ($ProductName.ToUpper().Trim() -eq  "ADMINPORTAL")
    {  
          ### Adding Account Applications for Admin portal product
            $applicationName="Accounts"
            $applicationPath= $SitePath+"\"+$applicationName;
            
            CreateApplicationFolder -folderName $applicationPath 
            
            $applicationPoolName= $siteName+"-"+$applicationName           
             
            LogWrite -logstring "applicationPoolName: $applicationPoolName"
            CreateApplicationPool -appPoolName $applicationPoolName -userName $UserName -Password $password
            Start-Sleep -s 2
            
            LogWrite -logstring "Creating Application..."        
            CreateWebApplication -appName $applicationName -siteName $siteName -applicationPath $applicationPath -UserName $UserName -Password $password;
            ### Creating Administration Application.
            $applicationName="Administration"
    }
        
    $applicationPath= $SitePath+"\"+$applicationName;
    CreateApplicationFolder -folderName $applicationPath 
    $applicationPoolName= $siteName+"-"+$applicationName
    CreateApplicationPool -appPoolName  $applicationPoolName -userName $UserName -Password $password
    Start-Sleep -s 2
    LogWrite -logstring "Creating Application..."        
    CreateWebApplication -appName $applicationName -siteName $siteName -applicationPath $applicationPath -UserName $UserName -Password $password;
    Grant-FolderFullRights -FolderName $SitePath  -UserName $Username  

     
    if($ProductName.ToUpper().Trim().StartsWith("CLAIMS"))
     {

      $udcPath=$cmsVirDirPath+"UserDocuments"
         CreateClaimsUserDocFolders -sitePath $SitePath
         $claimsudcpath=$SitePath+"\Claimsuserdocuments"
         CreateVirtualDirectory -siteName  $siteName -appName $applicationName -VirtualDirName "UserDocuments" -VirtualDirPath $claimsudcpath
    }
    if($ProductName.ToUpper().Trim().StartsWith("ENROLLMENT"))
    {
        
        if($CMSfeedsPath -eq "")
        {
            LogWrite -logstring "CMS feeds Path parameter is required."
        }
        else
        {
            $isPDPinstance=$false
            if($ProductName.EndsWith("PDP"))
            {

                $isPDPinstance=$true
            }

           
            ## creating CMS feeds folder and virtual directory for the folder
            CreateGatewayFeedsFolder -CmsFeedsFolder $CMSfeedsPath  -isPDPinstance $isPDPinstance
            Grant-FolderFullRights -FolderName $CMSfeedsPath  -UserName $Username  


            #Grant-FolderFullRights -FolderName $CMSfeedsPath  -UserName $Username  

            ## creating User documents folder and virtual directory for the folder
            # CreateApplicationFolder -folderName $SitePath+"\UserDocuments";
            if($CMSfeedsPath.EndsWith("\"))
            {
                $cmsVirDirPath = "{0}" -f $CMSfeedsPath
            }
            else
            { 
                $cmsVirDirPath = "{0}\" -f $CMSfeedsPath
            }
            
            $udcPath=$cmsVirDirPath+"UserDocuments"
            $feedpath=$cmsVirDirPath+"Feeds"
           
            if($isPDPinstance -eq "true")
            {
                $udcPath= $udcPath+"_PDP"
                $feedpath= $feedpath+"_PDP"
            }
            CreateVirtualDirectory -siteName  $siteName -appName $applicationName -VirtualDirName "UserDocuments" -VirtualDirPath $udcPath

            CreateVirtualDirectory -siteName  $siteName -appName $applicationName -VirtualDirName "Feeds" -VirtualDirPath $feedpath
        }
    }
    # Write-Host "Permission for cmsFeeds"
    # Grant-FolderFullRights -FolderName $CmsFdsFolder  -UserName  $Username  
}

# Usage  :  It will create all the necessary CMS FEEDS folder structure
# Syntax :  CreateGatewayFeedsFolder -CmsFeedsFolder "D:\cmsfeeds" -clientName "BSBSRI" -environMentName "Test";

function CreateClaimsUserDocFolders
{
[cmdletbinding()]            
param(            
[Parameter(Mandatory=$true)]            
[string]$sitePath
)  
   
    CreateApplicationFolder -folderName $sitePath  
    LogWrite -logstring "Creating Claims UserDocuments folders"; 
  
   
    $rootFolder= $sitePath+"\ClaimsUserDocuments"
    CreateApplicationFolder -folderName $rootFolder
    CreateApplicationFolder -folderName $rootFolder\CallCenter

    CreateApplicationFolder -folderName $rootFolder\ExcelDownloads
    CreateApplicationFolder -folderName $rootFolder\Letters
    CreateApplicationFolder -folderName $rootFolder\Documents
    CreateApplicationFolder -folderName $rootFolder\Temp
    CreateApplicationFolder -folderName $rootFolder\IKASERVICESLOG

    CreateApplicationFolder -folderName $rootFolder\LetterPDFFiles 

    CreateApplicationFolder -folderName $rootFolder\LetterPDFFiles\Archive
    
    CreateApplicationFolder -folderName $rootFolder\LetterPDFFiles\Archive\Incoming
    CreateApplicationFolder -folderName $rootFolder\LetterPDFFiles\Archive\Intermediate
    CreateApplicationFolder -folderName $rootFolder\LetterPDFFiles\Archive\Intermediate\Incoming
    CreateApplicationFolder -folderName $rootFolder\LetterPDFFiles\Archive\Outgoing 

    CreateApplicationFolder -folderName $rootFolder\LetterPDFFiles\ControlM_Archive\Incoming
    CreateApplicationFolder -folderName $rootFolder\LetterPDFFiles\ControlM_Archive\Intermediate
    CreateApplicationFolder -folderName $rootFolder\LetterPDFFiles\ControlM_Archive\Intermediate\Incoming
    CreateApplicationFolder -folderName $rootFolder\LetterPDFFiles\ControlM_Archive\Intermediate\Manual 
    CreateApplicationFolder -folderName $rootFolder\LetterPDFFiles\ControlM_Archive\Intermediate\Outgoing 
    CreateApplicationFolder -folderName $rootFolder\LetterPDFFiles\Outgoing
    CreateApplicationFolder -folderName $rootFolder\Reports 
    
    LogWrite -logstring "Claims UserDocuments folders are created"; 
}

# Usage  :  It will create all the necessary CMS FEEDS folder structure
# Syntax :  CreateGatewayFeedsFolder -CmsFeedsFolder "D:\cmsfeeds" -clientName "BSBSRI" -environMentName "Test";

function CreateGatewayFeedsFolder
{
[cmdletbinding()]            
param(            
[Parameter(Mandatory=$true)]            
[string]$CmsFeedsFolder,
[Parameter(Mandatory=$true)]            
[boolean]$isPDPinstance
)     

    CreateApplicationFolder -folderName $CmsFeedsFolder  
    
   
    $udcPath= $CmsFeedsFolder+"\UserDocuments"
    $feedpath= $CmsFeedsFolder+"\Feeds"
    if($isPDPinstance -eq "true")
    {
        $udcPath= $udcPath+"_PDP"
        $feedpath= $feedpath+"_PDP"
    }

    CreateApplicationFolder -folderName $udcPath
 
    CreateApplicationFolder -folderName $udcPath\CMSFiles

    CreateApplicationFolder -folderName $udcPath\CMSFiles\Archive

    CreateApplicationFolder -folderName $udcPath\CMSFiles\Incoming
    
    CreateApplicationFolder -folderName $udcPath\CMSFiles\Outgoing
    
    CreateApplicationFolder -folderName $udcPath\Current
    
    CreateApplicationFolder -folderName $udcPath\Current\Enrollment
    
    CreateApplicationFolder -folderName $udcPath\Current\Enrollment\FileUpload
    
    CreateApplicationFolder -folderName $udcPath\Current\Enrollment\PlanDocs
    
    CreateApplicationFolder -folderName $udcPath\Current\Enrollment\PlanFiles
    
    CreateApplicationFolder -folderName $udcPath\Current\Enrollment\ResponseFiles
    
    CreateApplicationFolder -folderName $udcPath\Current\GWDocuments
    
    CreateApplicationFolder -folderName $udcPath\FileGeneration_Download_Files
    
    CreateApplicationFolder -folderName $udcPath\Letters

    CreateApplicationFolder -folderName $feedpath

    CreateApplicationFolder -folderName $feedpath\SqlLogs

    CreateApplicationFolder -folderName $feedpath\UnixEndLine

    CreateApplicationFolder -folderName $feedpath\Archive

    CreateApplicationFolder -folderName $feedpath\Archive\Incoming

    CreateApplicationFolder -folderName $feedpath\Archive\Outgoing

    CreateApplicationFolder -folderName $feedpath\Production

    CreateApplicationFolder -folderName $feedpath\Production\Incoming

    CreateApplicationFolder -folderName $feedpath\Production\Incoming\ErrorLog
    
    CreateApplicationFolder -folderName $feedpath\Production\Incoming\UnixEndLine

    CreateApplicationFolder -folderName $feedpath\Production\Incoming\LetterFiles

    CreateApplicationFolder -folderName $feedpath\Production\Incoming\NonProcessedFiles

    CreateApplicationFolder -folderName $feedpath\Production\Incoming\PlanFiles
    
    CreateApplicationFolder -folderName $feedpath\Production\Outgoing

    CreateApplicationFolder -folderName $feedpath\Production\Outgoing\MembershipData
    
    LogWrite -logstring "Gateway feed folders are created"; 
 
   
 }
 ####################################### GATEWAY APP CONFIG FUNCTIONS ###################################################

 # Usage  :  It will create all the necessary steps to configure all the apps
# Syntax :  CreateCoreApplications -rootDrive "D:" -siteName "BCBSRI" -isIntegrated ="false" -HasClaims "true" -HasGateway "true" -clientName "BCRI" -environmentName "TEST"

function CreateCoreApplications
{
[cmdletbinding()]
param(
[Parameter(Mandatory=$true)]            
[string]$UserName,
[Parameter(Mandatory=$true)]            
[string]$password,
[Parameter(Mandatory=$true)]
[string]$rootDrive,
[Parameter(Mandatory=$true)]            
[string]$clientName,
[Parameter(Mandatory=$true)]
[string]$environmentName,
[Parameter(Mandatory=$true)]
[string]$hostName,
[Parameter(Mandatory=$true)]          
[ValidateSet("true", "false")]
[bool]$hasAdminportal,
[Parameter(Mandatory=$true)]          
[ValidateSet("true", "false")]
[bool]$hasClaims,
[Parameter(Mandatory=$true)]
[ValidateSet("true", "false")]
[bool]$hasEnrollment,
[Parameter(Mandatory=$true)]
[ValidateSet("true", "false")]
[bool]$hasEnrollmentPDP,
[Parameter(Mandatory=$false)]          
[ValidateSet("true", "false")]
[bool]$hasClaimsService

) 
    Set-LogFileName ".\IISAppConfig$(gc env:computername)$env:username.txt"
    LogWrite -logstring "************************************** STARTED**********************************"; 
    # if (!(Test-Path $rootDrive))
    #{
      # Write-Error "Drive is not found"
       #return;
    #}
    ##FOR TESTING########
    #$rootDrive= $rootDrive +"\AZtemp"
    #CreateApplicationFolder -folderName $rootDrive
    ##FOR TESTING
      Logwrite -logstring "Script run by: " $env:UserName
    Logwrite -logstring "Cert Installation Started"
    # CertInstallation -environmentName $environmentName
    $ssoCerts="false"
    if($hasAdminportal -eq "true")
    {
      $ssoCerts="true"
    }
    CertInstallation -environmentName $environmentName -ssoCertneeded $ssoCerts
    $CMSfeedsPath=$rootDrive +"\EnrollmentFiles"

    $SitePath =$rootDrive +"\CoreApps"
    CreateApplicationFolder -folderName $SitePath  
    
    $SitePath= $SitePath +"\"+$clientname
    CreateApplicationFolder -folderName $SitePath
    
    $SitePath= $SitePath +"\"+$environMentName
    CreateApplicationFolder -folderName $SitePath
    
    $siteName= $clientName+"-"+$environMentName

    #$confirmation = Read-Host "Are you ok to Proceed ?[Y/N]"
    $fullSiteName = "IIS:\Sites\{0}" -f $siteName
    
    if (!(Test-Path $fullSiteName))
    {
        AdduserTolocalAdmin -userName $UserName
        CreateWebSite -siteName $siteName -environmentName $environmentName -sitePath $SitePath -userName $UserName -Password $password -appName "" -hostName $hostName
    }

    if($hasAdminportal -eq "true")
    {
      
        $ProductName= "Adminportal"
        Logwrite -logstring "******** $ProductName Configuration Started ****************"
        CreateApplication -username $UserName -password $password -SitePath $SitePath -siteName $siteName -ProductName  $ProductName  -hostName $hostName
        Logwrite -logstring "******** $ProductName Configuration Ended ****************"
    }
    if($hasAdminportal -eq "true")
    {
      
        $ProductName= "CoreServices"
        Logwrite -logstring "******** $ProductName Configuration Started ****************"
        CreateApplication -username $UserName -password $password -SitePath $SitePath -siteName $siteName -ProductName  $ProductName  -hostName $hostName
        Logwrite -logstring "******** $ProductName Configuration Ended ****************"
    }

    if($hasClaims -eq "true")
    { 
        $ProductName= "Claims"
        Logwrite -logstring "******** $ProductName Configuration Started ****************"
        CreateApplication -username $UserName -password $password -SitePath $SitePath -siteName $siteName -ProductName  $ProductName  -hostName $hostName
        Logwrite -logstring "******** $ProductName Configuration Ended ****************"
    }

    if($hasEnrollment -eq "true")
    {   
        $ProductName= "Enrollment"
        Logwrite -logstring "******** $ProductName Configuration Started ****************"
        CreateApplication -username $UserName -password $password -SitePath $SitePath -siteName $siteName -ProductName $ProductName  -CMSfeedsPath $CMSfeedsPath -hostName $hostName
        Logwrite -logstring "******** $ProductName Configuration Ended ****************"
    }
   
   
    if($hasEnrollmentPDP -eq "true")
    {
        $ProductName= "EnrollmentPDP"
        Logwrite -logstring "******** $ProductName Configuration Started ****************"
        CreateApplication -username $UserName -password $password -SitePath $SitePath -siteName $siteName  -ProductName $ProductName -CMSfeedsPath $CMSfeedsPath -hostName $hostName
        Logwrite -logstring "******** $ProductName Configuration Ended ****************"
    }

    if($HasClaimsService -eq "true")
    {
        $ProductName= "ClaimsServices"
        Logwrite -logstring "******** $ProductName Configuration Started ****************"
        CreateApplication -username $UserName -password $password -SitePath $SitePath -siteName $siteName  -ProductName $ProductName -hostName $hostName
        Logwrite -logstring "******** $ProductName Configuration Ended ****************"
    }

    Start-WebSite -Name $siteName
    LogWrite -logstring "************************************** ENDED **********************************"; 
   
}

function CreateBEQSite
{
[cmdletbinding()]
param(
[Parameter(Mandatory=$true)]
[string]$rootDrive,
[Parameter(Mandatory=$true)]
[string]$environMentName,
[Parameter(Mandatory=$true)]
[string]$hostName
)
    $SitePath =$rootDrive +"\Services"
    CreateApplicationFolder -folderName $SitePath  
    $SitePath= $SitePath +"\"+$clientname
    CreateApplicationFolder -folderName $SitePath
    
    $SitePath= $SitePath +"\"+$environMentName
    CreateApplicationFolder -folderName $SitePath
    $siteName= "BEQ-"+$environMentName
    $ProductName="GovtWorks"
    $confirmation = Read-Host "Are you ok to Proceed ?[Y/N]"
    if ($confirmation -ne 'y'){ return;}

    CreateWebSite -siteName $siteName -environmentName $environmentName -sitePath $SitePath -userName  -Password $password -appName $ProductName -hostName $hostName

    
}