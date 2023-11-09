$DscWorkingFolder = $PSScriptRoot

Configuration Configure_IIS_Enrollment {
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
		
		if ($Node.MultiTenant -eq "true") {
			$UserDocClientPath = $Node.FileServerUNC + '\EnrollmentFiles\' + $Node.Client + '\UserDocuments'
			$FeedsClientPath = $Node.FileServerUNC + '\EnrollmentFiles\' + $Node.Client + '\Feeds'
		} else {
			$UserDocClientPath = $Node.FileServerUNC + '\EnrollmentFiles\UserDocuments'
			$FeedsClientPath = $Node.FileServerUNC + '\EnrollmentFiles\Feeds'
		}

		xWebAppPool EnrollmentAppPool
        {
			Name					= $SiteName + '-Enrollment' 
            Ensure          		= 'Present'
            State           		= 'Started'
			autoStart       		= $false
			loadUserProfile			= $true
            identityType    		= 'SpecificUser'
            credential      		= $LDAP_Credential
			idleTimeout				= (New-TimeSpan -Minutes 60).ToString()
			restartTimeLimit		= '00:00:00'
			restartSchedule			= '03:00:00'
        }
		
		xWebApplication EnrollmentApplication
		{
			 Ensure          		= 'Present'
			 Name            		= 'Enrollment'
			 Website				= $SiteName
			 PhysicalPath			= $DscWorkingFolder
			 WebAppPool				= $SiteName + '-Enrollment' 
			 DependsOn 				= @('[xWebAppPool]EnrollmentAppPool')
		}
		
		Script EnrollmentApplication_PhysicalPath
		{
			TestScript = { return $false }
			
			SetScript = {
				$Client = $using:Node.Client
                $EnvType = $using:Node.EnvType
                $SiteName = $using:SiteName
                $FileServerUNC = $using:Node.FileServerUNC
				$EnrollmentAppPhysicalPath = $FileServerUNC + '\CoreApps\' + $Client + '\' + $EnvType + '\Enrollment'
				
				Set-webconfigurationproperty "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/Enrollment']/virtualDirectory[@path='/']" -Name PhysicalPath -Value $EnrollmentAppPhysicalPath
			}
			
			GetScript = { }
			DependsOn 				= @('[xWebApplication]EnrollmentApplication')
		}
		
		# Set IIS Site credentials
		Script EnrollmentApplicationCreds
		{
			TestScript = { return $false }
			
			SetScript = {
				$SiteName = $using:SiteName
				Set-WebConfiguration "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/Enrollment']/virtualDirectory[@path='/']" -Value @{userName=$using:ldap_username;password=$using:ldap_password}
			}
			
			GetScript = { }
			DependsOn 				= @('[xWebApplication]EnrollmentApplication')
		}
		
		#########################################################################################
		
		# Not yet idempotent (See https://github.com/PowerShell/xWebAdministration/issues/331)
		# Dummy path since the "xWebsite" resource does not allow us to use a UNC path
		# The PhysicalPath is updated to a UNC path later, using the Script resource
		xWebVirtualDirectory UserDocuments
		{
			Ensure          		= 'Present'
			Name            		= 'UserDocuments'
			Website					= $SiteName
			WebApplication			= 'Enrollment'
			PhysicalPath			= $DscWorkingFolder
			DependsOn 				= '[xWebApplication]EnrollmentApplication'
		}
		
		Script UserDocuments_PhysicalPath
		{
			TestScript = { return $false }
			
			SetScript = {
				$SiteName = $using:SiteName
				$UserDocClientPath = $using:UserDocClientPath
				
				set-webconfigurationproperty "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/Enrollment']/VirtualDirectory[@path='/UserDocuments']" -Name PhysicalPath -Value $UserDocClientPath
			}
			
			GetScript = { }
			DependsOn 				= @('[xWebVirtualDirectory]UserDocuments')
		}
		
		Script SetVirtDirCreds_UserDocuments
		{
			TestScript = { return $false }
			
			SetScript = {
				$SiteName = $using:SiteName
				Set-WebConfiguration "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/Enrollment']/VirtualDirectory[@path='/UserDocuments']" -Value @{userName=$using:ldap_username;password=$using:ldap_password}
			}
			
			GetScript = { }
			DependsOn 				= @('[xWebVirtualDirectory]UserDocuments')
		}
		
		#########################################################################################
		
		# Not yet idempotent (See https://github.com/PowerShell/xWebAdministration/issues/331)
		# Dummy path since the "xWebsite" resource does not allow us to use a UNC path
		# The PhysicalPath is updated to a UNC path later, using the Script resource
		xWebVirtualDirectory Feeds
		{
			Ensure          		= 'Present'
			Name            		= 'Feeds'
			Website					= $SiteName
			WebApplication			= 'Enrollment'
			PhysicalPath			= $DscWorkingFolder
			DependsOn 				= '[xWebApplication]EnrollmentApplication'
		}
		
		Script Feeds_PhysicalPath
		{
			TestScript = { return $false }
			
			SetScript = {
				$SiteName = $using:SiteName
				$FeedsClientPath = $using:FeedsClientPath
				
				set-webconfigurationproperty "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/Enrollment']/VirtualDirectory[@path='/Feeds']" -Name PhysicalPath -Value $FeedsClientPath
			}
			
			GetScript = { }
			DependsOn 				= @('[xWebVirtualDirectory]Feeds')
		}
		
		Script SetVirtDirCreds_Feeds
		{
			TestScript = { return $false }
			
			SetScript = {
				$SiteName = $using:SiteName
				
				Set-WebConfiguration "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/Enrollment']/VirtualDirectory[@path='/Feeds']" -Value @{userName=$using:ldap_username;password=$using:ldap_password}
			}
			
			GetScript = { }
			DependsOn 				= @('[xWebVirtualDirectory]Feeds')
		}
	}
}

$LDAP_Credential = Get-Credential -UserName $Node.LDAPUser -Message "Enter credentials for LDAP User"
Configure_IIS_Enrollment -LDAP_Credential $LDAP_Credential -ConfigurationData DSCData.psd1

Start-DscConfiguration Configure_IIS_Enrollment -Wait -Force -Verbose
