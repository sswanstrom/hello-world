$DscWorkingFolder = $PSScriptRoot

Configuration Configure_IIS_Claims {
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

		xWebAppPool ClaimsAppPool
        {
			Name					= $SiteName + '-Claims'
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
		
		xWebApplication ClaimsApplication
		{
			 Ensure          		= 'Present'
			 Name            		= 'Claims'
			 Website				= $SiteName
			 PhysicalPath			= $DscWorkingFolder
			 WebAppPool				= $SiteName + '-Claims'
			 DependsOn 				= @('[xWebAppPool]ClaimsAppPool')
		}
		
		Script ClaimsApplication_PhysicalPath
		{
			TestScript = { return $false }
			
			SetScript = {
                $Client = $using:Node.Client
                $EnvType = $using:Node.EnvType
                $SiteName = $using:SiteName
                $FileServerUNC = $using:Node.FileServerUNC
				$ClaimsAppPhysicalPath = $FileServerUNC + '\CoreApps\' + $Client + '\' + $EnvType + '\Claims'
				
				Set-webconfigurationproperty "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/Claims']/virtualDirectory[@path='/']" -Name PhysicalPath -Value $ClaimsAppPhysicalPath
			}
			
			GetScript = { }
			DependsOn 				= @('[xWebApplication]ClaimsApplication')
		}
		
		# Set IIS Site credentials
		Script ClaimsApplicationCreds
		{
			TestScript = { return $false }
			
			SetScript = {
				$SiteName = $using:SiteName
				Set-WebConfiguration "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/Claims']/virtualDirectory[@path='/']" -Value @{userName=$using:ldap_username;password=$using:ldap_password}
			}
			
			GetScript = { }
			DependsOn 				= '[xWebApplication]ClaimsApplication'
		}
	}
}

$LDAP_Credential = Get-Credential -UserName $Node.LDAPUser -Message "Enter credentials for LDAP User"
Configure_IIS_Claims -LDAP_Credential $LDAP_Credential -ConfigurationData DSCData.psd1

Start-DscConfiguration Configure_IIS_Claims -Wait -Force -Verbose
