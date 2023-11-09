$DscWorkingFolder = $PSScriptRoot

Configuration Configure_IIS_AdminPortal {
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

		xWebAppPool AccountsAppPool
        {
          
            Name            		= $SiteName + '-Accounts'
            Ensure          		= 'Present'
            State           		= 'Started'
			autoStart       		= $false
			loadUserProfile			= $true
            identityType    		= 'SpecificUser'
            credential      		= $LDAP_Credential
			enable32BitAppOnWin64	= $false
			idleTimeout				= (New-TimeSpan -Minutes 60).ToString()
			restartTimeLimit		= '00:00:00'
			restartSchedule			= '03:00:00'
        }
		
		xWebApplication AccountsApplication
		{
			 Ensure          		= 'Present'
			 Name            		= 'Accounts'
			 Website				= $SiteName
			 PhysicalPath			= $DscWorkingFolder
			 WebAppPool				= $SiteName + '-Accounts'
			 DependsOn 				= @('[xWebAppPool]AccountsAppPool')
		}
		
		Script AccountsApplication_PhysicalPath
		{
			TestScript = { return $false }
			
			SetScript = {
				$SiteName = $using:SiteName
                $Client = $using:Node.Client
                $EnvType = $using:Node.EnvType
                $FileServerUNC = $using:Node.FileServerUNC
				$AccountsAppPhysicalPath = $FileServerUNC + '\CoreApps\' + $Client + '\' + $EnvType + '\Accounts'
				
				Set-webconfigurationproperty "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/Accounts']/virtualDirectory[@path='/']" -Name PhysicalPath -Value $AccountsAppPhysicalPath
			}
			
			GetScript = { }
			DependsOn 				= @('[xWebApplication]AccountsApplication')
		}
		
		# Set IIS Site credentials
		Script AccountsApplicationCreds
		{
			TestScript = { return $false }
			
			SetScript = {
				$SiteName = $using:SiteName
				Set-WebConfiguration "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/Accounts']/virtualDirectory[@path='/']" -Value @{userName=$using:ldap_username;password=$using:ldap_password}
			}
			
			GetScript = { }
			DependsOn 				= '[xWebApplication]AccountsApplication'
		}
		
		xWebAppPool AdministrationAppPool
        {
          
            Name            		= $SiteName + '-Administration'
            Ensure          		= 'Present'
            State           		= 'Started'
			autoStart       		= $false
			loadUserProfile			= $true
            identityType    		= 'SpecificUser'
            credential      		= $LDAP_Credential
			enable32BitAppOnWin64	= $false
			idleTimeout				= (New-TimeSpan -Minutes 60).ToString()
			restartTimeLimit		= '00:00:00'
			restartSchedule			= '03:00:00'
        }
		
		xWebApplication AdministrationApplication
		{
			 Ensure          		= 'Present'
			 Name            		= 'Administration'
			 Website				= $SiteName
			 PhysicalPath			= $DscWorkingFolder
			 WebAppPool				= $SiteName + '-Administration'
			 DependsOn 				= @('[xWebAppPool]AdministrationAppPool')
		}
		
		Script AdministrationApplication_PhysicalPath
		{
			TestScript = { return $false }
			
			SetScript = {
                $SiteName = $using:SiteName
                $Client = $using:Node.Client
                $EnvType = $using:Node.EnvType
                $FileServerUNC = $using:Node.FileServerUNC
				$AdministrationAppPhysicalPath = $FileServerUNC + '\CoreApps\' + $Client + '\' + $EnvType + '\Administration'
				
				Set-webconfigurationproperty "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/Administration']/virtualDirectory[@path='/']" -Name PhysicalPath -Value $AdministrationAppPhysicalPath
			}
			
			GetScript = { }
			DependsOn 				= @('[xWebApplication]AdministrationApplication')
		}
		
		# Set IIS Site credentials
		Script AdministrationApplicationCreds
		{
			TestScript = { return $false }
			
			SetScript = {
				$SiteName = $using:SiteName
				Set-WebConfiguration "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/Administration']/virtualDirectory[@path='/']" -Value @{userName=$using:ldap_username;password=$using:ldap_password}
			}
			
			GetScript = { }
			DependsOn 				= @('[xWebApplication]AdministrationApplication')
		}
		
		xWebAppPool CoreServicesAppPool
        {
          
            Name            		= $SiteName + '-CoreServices'
            Ensure          		= 'Present'
            State           		= 'Started'
			autoStart       		= $false
			loadUserProfile			= $true
            identityType    		= 'SpecificUser'
            credential      		= $LDAP_Credential
			enable32BitAppOnWin64	= $false
			idleTimeout				= (New-TimeSpan -Minutes 60).ToString()
			restartTimeLimit		= '00:00:00'
			restartSchedule			= '03:00:00'
        }
		
		xWebApplication CoreServicesApplication
		{
			 Ensure          		= 'Present'
			 Name            		= 'CoreServices'
			 Website				= $SiteName
			 PhysicalPath			= $DscWorkingFolder
			 WebAppPool				= $SiteName + '-CoreServices'
			 DependsOn 				= @('[xWebAppPool]CoreServicesAppPool')
		}
		
		Script CoreServicesApplication_PhysicalPath
		{
			TestScript = { return $false }
			
			SetScript = {
                $SiteName = $using:SiteName
                $Client = $using:Node.Client
                $EnvType = $using:Node.EnvType
                $FileServerUNC = $using:Node.FileServerUNC
				$CoreServicesPhysicalPath = $FileServerUNC + '\CoreApps\' + $Client + '\' + $EnvType + '\CoreServices'
				
				Set-webconfigurationproperty "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/CoreServices']/virtualDirectory[@path='/']" -Name PhysicalPath -Value $CoreServicesPhysicalPath
			}
			
			GetScript = { }
			DependsOn 				= @('[xWebApplication]CoreServicesApplication')
		}
		
		# Set IIS Site credentials
		Script CoreServicesApplicationCreds
		{
			TestScript = { return $false }
			
			SetScript = {
				$SiteName = $using:SiteName
				Set-WebConfiguration "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/CoreServices']/virtualDirectory[@path='/']" -Value @{userName=$using:ldap_username;password=$using:ldap_password}
			}
			
			GetScript = { }
			DependsOn 				= '[xWebApplication]CoreServicesApplication'
		}
	}
}

$LDAP_Credential = Get-Credential -UserName $Node.LDAPUser -Message "Enter credentials for LDAP User"
Configure_IIS_AdminPortal -LDAP_Credential $LDAP_Credential -ConfigurationData DSCData.psd1

Start-DscConfiguration Configure_IIS_AdminPortal -Wait -Force -Verbose
