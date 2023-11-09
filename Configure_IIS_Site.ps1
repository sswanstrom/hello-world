Install-Module xWebAdministration
Install-Module xComputerManagement
Install-Module NetworkingDsc

$DscWorkingFolder = $PSScriptRoot
$ip = (Test-Connection -ComputerName (hostname) -Count 1  | Select IPV4Address).IPV4Address

Configuration Configure_IIS_Site {
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [System.Management.Automation.PSCredential]
        $Wildcard_Credential,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [System.Management.Automation.PSCredential]
        $LDAP_Credential
    )
	
	Import-DscResource -ModuleName PsDesiredStateConfiguration
	Import-DscResource -Module xWebAdministration -ModuleVersion 2.6.0.0
	Import-DscResource -Module xComputerManagement
	Import-DSCResource -ModuleName NetworkingDsc
	
	Node localhost {
		$ldap_username = $LDAP_Credential.username
		$ldap_password = $LDAP_Credential.GetNetworkCredential().password

        $WildcardCertLocn = $DscWorkingFolder + '\' + $Node.WildcardCertLocn
        $Wildcard_password = $Wildcard_Credential.GetNetworkCredential().password
		$certificateObject = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
		$certificateObject.Import($WildcardCertLocn, $Wildcard_password, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::DefaultKeySet)
		$WildcardThumbprint = $certificateObject.Thumbprint
		
		$SitePhysicalPath = $Node.FileServerUNC + '\CoreApps\' + $Node.Client + '\' + $Node.EnvType
		$SiteName = $Node.Client + '-' + $Node.EnvType
		
		Group AddToAdmin{
			GroupName				= 'Administrators'
			Ensure					= 'Present'
			MembersToInclude		= $Node.LDAPUser
        }
		
		HostsFile HostsFileAddEntry
        {
			HostName  = $Node.IISDNSName
			IPAddress = $ip
			Ensure    = 'Present'
        }
		
		# Enable Windows features and roles
		# Might need to provide option to continue running DSC config in case reboot is needed
		$winFeatures = @("Web-Default-Doc","Web-Dir-Browsing","Web-Http-Errors","Web-Static-Content","Web-Http-Logging","Web-Stat-Compression","Web-Filtering","Web-Net-Ext45","Web-Asp-Net45","Web-ISAPI-Ext","Web-ISAPI-Filter","Web-Mgmt-Console","NET-Framework-45-ASPNET","NET-WCF-HTTP-Activation45","Windows-Identity-Foundation","WAS-Process-Model","WAS-Config-APIs")

		ForEach ($Feature in $winFeatures) {
			WindowsFeature $Feature {
				Name                 = $Feature
				Ensure               = 'Present'
			}
		}
		
		# Default Web Site is always stopped
		xWebsite DefaultSite
		{
			Ensure          = 'Present'
			Name            = 'Default Web Site'
			PhysicalPath    = "C:\inetpub\wwwroot"
			State           = 'Stopped'
		}
		
		# Create IIS Site AppPool
		xWebAppPool BaseSiteAppPool
        {
          
            Name            		= $SiteName
            Ensure          		= 'Present'
            State           		= 'Started'
            autoStart       		= $false
            identityType    		= 'SpecificUser'
            credential      		= $LDAP_Credential
            enable32BitAppOnWin64	= $false
			loadUserProfile			= $true
			idleTimeout				= (New-TimeSpan -Minutes 60).ToString()
			restartTimeLimit		= '00:00:00'
			restartSchedule			= '03:00:00'
			DependsOn       		= '[WindowsFeature]Web-Static-Content'
        }
		
		xWebsite BaseSite
		{
			Ensure          = 'Present'
			Name            = $SiteName
			State           = 'Started'
			# Dummy path since the "xWebsite" resource does not allow us to use a UNC path
			# The PhysicalPath is updated to a UNC path later, using the Script resource
			PhysicalPath    = $DscWorkingFolder
			ApplicationPool = $SiteName
			BindingInfo     = @(
					MSFT_xWebBindingInformation {
						Protocol				= 'HTTP'
						IPAddress				= '*'
						Port					= '80'
						HostName				= $Node.IISDNSName
					}
					
					MSFT_xWebBindingInformation {
						Protocol				= 'HTTPS'
						IPAddress				= '*'
						Port					= '443'
						CertificateThumbprint	= '84310060d2013c2eb507304dd87ef5358940f565'
						CertificateStoreName	= 'My'
						HostName				= $Node.IISDNSName
					}
			)
			DependsOn       = '[xWebAppPool]BaseSiteAppPool'
		}
		
		Script BaseSite_SitePhysicalPath
		{
			TestScript = { return $false }
			
			SetScript = {
				$SiteName = $using:SiteName
				$SitePhysicalPath = $using:SitePhysicalPath
				
				Set-ItemProperty IIS:\Sites\$SiteName -name PhysicalPath -value $SitePhysicalPath
			}
			
			GetScript = { }
			DependsOn 				= '[xWebsite]BaseSite'
		}
		
		# Set IIS Site credentials
		Script BaseSiteCreds
		{
			TestScript = { return $false }
			
			SetScript = {
				$SiteName = $using:SiteName
				
				Set-WebConfiguration "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/']/virtualDirectory[@path='/']" -Value @{userName=$using:ldap_username;password=$using:ldap_password}
			}
			
			GetScript = { }
			DependsOn 				= '[xWebsite]BaseSite'
		}
	}
}

$Wildcard_Credential = Get-Credential -UserName "devops\devops" -Message "Enter password for Wildcard Certificate.  Username is not used, so anything goes"
$LDAP_Credential = Get-Credential -UserName $Node.LDAPUser -Message "Enter credentials for LDAP User"
Configure_IIS_Site -Wildcard_Credential $Wildcard_Credential -LDAP_Credential $LDAP_Credential -ConfigurationData DSCData.psd1

Start-DscConfiguration Configure_IIS_Site -Wait -Force -Verbose