$DscWorkingFolder = $PSScriptRoot

Configuration Web_Gateway {
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [System.Management.Automation.PSCredential]
        $ADFS_Credential
    )
	
    Import-DscResource -Module PSDesiredStateConfiguration
	Import-DscResource -Module xWebAdministration
	
	Node localhost {
		$adfs_username = $ADFS_Credential.username
		$adfs_password = $ADFS_Credential.GetNetworkCredential().password

		xWebAppPool GatewayAppPool
        {
          
            Name            		= $Node.GatewayAppPoolName
            Ensure          		= 'Present'
            State           		= 'Started'
			autoStart       		= $false
			startMode				= 'AlwaysRunning'
            identityType    		= 'SpecificUser'
            credential      		= $ADFS_Credential
			idleTimeout				= (New-TimeSpan -Minutes 180).ToString()
			idleTimeoutAction		= 'Terminate'
			#disallowRotationOnConfigChange
        }
		
		if ($Node.IISHostName -ne $Node.UTILHostName) {
			File CarrierPath_Gateway {
				Type = "Directory"
				Ensure = "Present"
				Recurse = $true
				Force = $true
				SourcePath = "$DscWorkingFolder\SupportingFiles\FrontEnd\gateway"
				DestinationPath = $Node.GatewayAppPhysicalPath_UNC
			}
			
			xWebApplication GatewayApplication
			{
				 Ensure          		= 'Present'
				 Name            		= 'MedicareGW'
				 Website				= $Node.SiteName
				 PhysicalPath			= $Node.GatewayAppPhysicalPath_UNC
				 WebAppPool				= $Node.GatewayAppPoolName
				 DependsOn 				= @('[xWebAppPool]GatewayAppPool', '[File]CarrierPath_Gateway')
			}
			
			# Not yet idempotent (See https://github.com/PowerShell/xWebAdministration/issues/331)
			xWebVirtualDirectory UserDocuments
			{
				Ensure          		= 'Present'
				Name            		= 'UserDocuments'
				Website					= $Node.SiteName
				WebApplication			= 'MedicareGW'
				PhysicalPath			= $DscWorkingFolder
			}
			
			# Not yet idempotent (See https://github.com/PowerShell/xWebAdministration/issues/331)
			xWebVirtualDirectory Feeds
			{
				Ensure          		= 'Present'
				Name            		= 'Feeds'
				Website					= $Node.SiteName
				WebApplication			= 'MedicareGW'
				PhysicalPath			= $DscWorkingFolder
				
			}
			
			Script UserDocuments_SitePhysicalPath
			{
				TestScript = { return $false }
				
				SetScript = {
					$SiteName = $using:Node.SiteName
					$UserDocClientPath_UNC = $using:Node.UserDocClientPath_UNC
					
					set-webconfigurationproperty "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/MedicareGW']/VirtualDirectory[@path='/UserDocuments']" -Name PhysicalPath -Value $UserDocClientPath_UNC
				}
				
				GetScript = { }
			}
			
			Script Feeds_SitePhysicalPath
			{
				TestScript = { return $false }
				
				SetScript = {
					$SiteName = $using:Node.SiteName
					$FeedsClientPath_UNC = $using:Node.FeedsClientPath_UNC
					
					set-webconfigurationproperty "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/MedicareGW']/VirtualDirectory[@path='/Feeds']" -Name PhysicalPath -Value $FeedsClientPath_UNC
				}
				
				GetScript = { }
			}
		} else {
			File CarrierPath_Gateway {
				Type = "Directory"
				Ensure = "Present"
				Recurse = $true
				Force = $true
				SourcePath = "$DscWorkingFolder\SupportingFiles\FrontEnd\gateway"
				DestinationPath = $Node.GatewayAppPhysicalPath_Local
			}
			
			xWebApplication GatewayApplication
			{
				 Ensure          		= 'Present'
				 Name            		= 'MedicareGW'
				 Website				= $Node.SiteName
				 PhysicalPath			= $Node.GatewayAppPhysicalPath_local
				 WebAppPool				= $Node.GatewayAppPoolName
				 DependsOn 				= @('[xWebAppPool]GatewayAppPool', '[File]CarrierPath_Gateway')
			}
			
			# Not yet idempotent (See https://github.com/PowerShell/xWebAdministration/issues/331)
			xWebVirtualDirectory UserDocuments
			{
				Ensure          		= 'Present'
				Name            		= 'UserDocuments'
				Website					= $Node.SiteName
				WebApplication			= 'MedicareGW'
				PhysicalPath			= $Node.UserDocClientPath_local
			}
			
			# Not yet idempotent (See https://github.com/PowerShell/xWebAdministration/issues/331)
			xWebVirtualDirectory Feeds
			{
				Ensure          		= 'Present'
				Name            		= 'Feeds'
				Website					= $Node.SiteName
				WebApplication			= 'MedicareGW'
				PhysicalPath			= $Node.FeedsClientPath_local
			}
		}
		
		# Set IIS Site credentials
		Script GatewayApplicationCreds
		{
			TestScript = { return $false }
			
			SetScript = {
				$SiteName = $using:Node.SiteName
				Set-WebConfiguration "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/MedicareGW']/virtualDirectory[@path='/']" -Value @{userName=$using:adfs_username;password=$using:adfs_password}
			}
			
			GetScript = { }
			DependsOn 				= '[xWebApplication]GatewayApplication'
		}
		
		Script SetVirtDirCreds_UserDocuments
		{
			TestScript = { return $false }
			
			SetScript = {
				$SiteName = $using:Node.SiteName
				Set-WebConfiguration "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/MedicareGW']/VirtualDirectory[@path='/UserDocuments']" -Value @{userName=$using:adfs_username;password=$using:adfs_password}
			}
			
			GetScript = { }
			DependsOn 				= @('[xWebVirtualDirectory]UserDocuments', '[xWebVirtualDirectory]Feeds')
		}
		
		Script SetVirtDirCreds_Feeds
		{
			TestScript = { return $false }
			
			SetScript = {
				$SiteName = $using:Node.SiteName
				
				Set-WebConfiguration "/system.applicationHost/sites/site[@name='$SiteName']/application[@path='/MedicareGW']/VirtualDirectory[@path='/Feeds']" -Value @{userName=$using:adfs_username;password=$using:adfs_password}
			}
			
			GetScript = { }
			DependsOn 				= @('[xWebVirtualDirectory]UserDocuments', '[xWebVirtualDirectory]Feeds')
		}
		

		
		#https://jermdavis.wordpress.com/2015/09/28/config-variables-in-powershell-dsc-can-confuse/
		#https://davewyatt.wordpress.com/2014/10/30/automatic-variables-in-desired-state-configuration/
		Script SetWebConfig
		{
			TestScript = { return $false
			}
			
			SetScript = {
				$iis = $using:Node.IISHostName
			
				Import-Module "$using:DscWorkingFolder\SupportingFiles\PowerShellModules\EPS\0.5.0\EPS.psm1"
				$epsHash = @{
					Client								=	$using:Node.Client;
					IISDNSName							=	$using:Node.IISDNSName
					sitePhysicalPath_UNC				=	$using:Node.sitePhysicalPath_UNC;
					IntegratedEnv						=	$using:Node.IntegratedEnv;
					
					smtpFrom = $using:Node.smtpFrom;
					smtpNetworkHost = $using:Node.smtpNetworkHost;
					smtpNetworkPort = $using:Node.smtpNetworkPort;
					
					ADAMServer							=	$using:Node.ADAMServer;
					adamPort							=	$using:Node.adamPort;
					adamName							=	$using:Node.adamName;
					adamDesc							=	$using:Node.adamDesc;
					adamPartition						=	$using:Node.adamPartition;
					adamAdminUser						=	$using:Node.adamAdminUser;
					adamPassword						=	$using:Node.adamPassword;
					
					wsFederationrequireHttps			=	if ($using:Node.EnvType -in ("DEV","QA")) {"false"} else {"true"}
					wsFederationProtocol				=	if ($using:Node.EnvType -in ("DEV","QA")) {"http"} else {"https"}
					wsFederationHomeRealm				=	$using:Node.wsFederationHomeRealm;
					wsFederationRealm					=	$using:Node.wsFederationRealm;
					adfsDNS								=	$using:Node.adfsDNS;
					
					adminPortalUrl						=	$using:Node.adminPortalUrl;
					audienceUris						=	$using:Node.audienceUris;
					unAuthorizedAdminPortalAccessUrl	=	$using:Node.unAuthorizedAdminPortalAccessUrl;
					
					AppFabric_CacheServer				=	$using:Node.AppFabric_CacheServer;
					AppFabric_CachePort					=	$using:Node.AppFabric_CachePort;
					AppFabric_CacheName					=	$using:Node.AppFabric_CacheName;
					
					cleanupUrl							=	$using:Node.cleanupUrl;
					CRM_URL								=	$using:Node.crmUrl;
					
					dbserver							=	$using:Node.dbserver;
					GWMasterDBName						=	$using:Node.GWMasterDBName;
					GWMasterDBUserID					=	$using:Node.GWMasterDBUserID;
					GWMasterDBPassword					=	$using:Node.GWMasterDBPassword;
					sqlJobRunnerDBName					=	$using:Node.sqlJobRunnerDBName;
					sqlJobRunnerUser					=	$using:Node.sqlJobRunnerUser;
					sqlJobRunnerPassword				=	$using:Node.sqlJobRunnerPassword;
					
					iamClaimsUrl						=	$using:Node.iamClaimsUrl;
					iamClaimsUrlForChangePassword		=	$using:Node.iamClaimsUrlForChangePassword;
					iamClaimsUrlForChangeQA				=	$using:Node.iamClaimsUrlForChangeQA;
					iamCMSBEQService					=	$using:Node.iamCMSBEQService;
					iamDomainUrl						=	$using:Node.iamDomainUrl;
					iamGWLUrl							=	$using:Node.iamGWLUrl; 
					iamHomeUrl							=	$using:Node.iamHomeUrl;
					iamProfessionalListIkaServiceUrl	=	$using:Node.iamProfessionalListIkaServiceUrl;
					iamProfessionalListIkaService		=	$using:Node.iamProfessionalListIkaService;
					iamUserNotAuthorizedPageUrl			=	$using:Node.iamUserNotAuthorizedPageUrl;
					
					samlLogoutURL						=	$using:Node.samlLogoutURL
					
					#TRUSTED_ISSUERS_CERT_HOST = $thumbObj.Thumbprint;
				}
				
				if ($Node.IISHostName -ne $Node.UTILHostName) {
					$GatewayAppPhysicalPath = $using:Node.GatewayAppPhysicalPath_UNC
				} else {
					$GatewayAppPhysicalPath = $using:Node.GatewayAppPhysicalPath_local
				}
		
				Invoke-EpsTemplate -Path "$using:DscWorkingFolder\SupportingFiles\templates\web.config.gateway.nonintegrated.template" -Binding $epsHash > "$GatewayAppPhysicalPath\Web.config"
			}
			
			GetScript = { }
			DependsOn 				= @('[xWebVirtualDirectory]UserDocuments', '[xWebVirtualDirectory]Feeds')
		}
		
	}
}

$ADFS_Credential = Get-Credential -UserName $Node.ADFSUser -Message "Enter credentials for ADFS User"
Web_Gateway -ADFS_Credential $ADFS_Credential -ConfigurationData EnvData.psd1
