$DscWorkingFolder = $PSScriptRoot

Configuration Configure_IIS_ClaimsServices {
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [System.Management.Automation.PSCredential]
        $LDAP_Credential
    )
	
    Import-DscResource -Module PSDesiredStateConfiguration
	Import-DscResource -Module xWebAdministration -ModuleVersion 2.6.0.0
	
	Node localhost {
		$ldap_username = $LDAP_Credential.username
		$ldap_password = $LDAP_Credential.GetNetworkCredential().password
		
		$SiteName = $Node.Client + '-' + $Node.EnvType

		xWebAppPool ClaimsServicesAppPool
        {
            Name            		= $SiteName + '-ClaimsServices'
            Ensure          		= 'Present'
            State           		= 'Started'
			autoStart       		= $false
			loadUserProfile			= $true
            identityType    		= 'SpecificUser'
            credential      		= $LDAP_Credential
			enable32BitAppOnWin64	= $true
			idleTimeout				= (New-TimeSpan -Minutes 60).ToString()
			restartTimeLimit		= '00:00:00'
			restartSchedule			= '03:00:00'
        }
		
		xWebApplication ClaimsServicesApplication
		{
			 Ensure          		= 'Present'
			 Name            		= 'ClaimsServices'
			 Website				= $SiteName
			 PhysicalPath			= $DscWorkingFolder
			 WebAppPool				= $SiteName + '-ClaimsServices'
			 DependsOn 				= @('[xWebAppPool]ClaimsServicesAppPool')
		}
		
		Script ClaimsServicesApplication_PhysicalPath
		{
			TestScript = { return $false }
			
			SetScript = {
                $Client = $using:Node.Client
                $EnvType = $using:Node.EnvType
                $SiteName = $using:SiteName
                $FileServerUNC = $using:Node.FileServerUNC
				$ClaimsServicesAppPhysicalPath = $FileServerUNC + '\CoreApps\' + $Client + '\' + $EnvType + '\ClaimsServices'
				
				Set-webconfigurationproperty "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/ClaimsServices']/virtualDirectory[@path='/']" -Name PhysicalPath -Value $ClaimsServicesAppPhysicalPath
			}
			
			GetScript = { }
			DependsOn 				= @('[xWebApplication]ClaimsServicesApplication')
		}
		
		# Set IIS Site credentials
		Script ClaimsServicesApplicationCreds
		{
			TestScript = { return $false }
			
			SetScript = {
				$SiteName = $using:SiteName
				Set-WebConfiguration "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/ClaimsServices']/virtualDirectory[@path='/']" -Value @{userName=$using:ldap_username;password=$using:ldap_password}
			}
			
			GetScript = { }
			DependsOn 				= '[xWebApplication]ClaimsServicesApplication'
		}
	}
}

$LDAP_Credential = Get-Credential -UserName $Node.LDAPUser -Message "Enter credentials for LDAP User"
Configure_IIS_ClaimsServices -LDAP_Credential $LDAP_Credential -ConfigurationData DSCData.psd1

Start-DscConfiguration Configure_IIS_ClaimsServices -Wait -Force -Verbose
