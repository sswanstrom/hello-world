@{
    AllNodes = @(
	
        @{
            NodeName							= "*"
			PSDscAllowPlainTextPassword			= $true
			PSDscAllowDomainUser 				= $true
			smtpFrom							= "pwd@ikasystems.com"
			smtpNetworkHost						= "10.10.3.25"
			smtpNetworkPort						= "25"
        },
		
		@{
			NodeName							= "localhost"
			Client								= "Lasso"
			EnvType								= "PROD"
			Sandbox								= "YES"
			IntegratedEnv						= "0"	# 0 = for non-integrated, 1 for Integrated
			
			# Servers in this environment
			IISHostName							= "SDWACDRV01V"
			UTILHostName						= "SDWACDRV01V"
			ADAMServer							= "SDWACDRV01V"
			
			# Certificate information
			SSOCertLocn							= "D:\devops\DSC\SupportingFiles\Certs\ssop.pfx"
			SSOThumbprint						= "0df57671e6704c773ae6fe550575bf1c02231ce3"
			WildcardName						= "ikaenterprise.com"
			WildcardCertLocn					= "D:\devops\DSC\SupportingFiles\Certs\star.ikaenterprise.pfx"
			WildcardThumbprint					= "36b15677be5d3f33b8d759474d04ef20fc1c4e9e"

			# ADAM / ADLDS (for integrated environments only)
			adamPassword						= 'Password$2'
			adamAdminUser						= "srv-scmadmin"
			adamName							= "DevOpsSandbox"
			adamDesc							= "DevOpsSandbox AD LDS instance"
			adamPartition						= "O=DevOpsSandbox-Partition,DC=ikasystems,DC=COM"
			adamPort							= "50201"
			adamSSLPort							= "50202"

			# ADFS  (for integrated environments only) (what should these values be for DEV/QA?)
			adfsDNS								= "SDWACDRV01V"
			ADFSUser							= "ikasystems\srv-scmadmin"
			wsFederationHomeRealm				= "Lasso_Production_STS"
			wsFederationRealm					= "SDWACDRV01V/MedicareGW/"
			
			# AppFabric  (for integrated environments only)
			AppFabric_CacheServer				= "SDWACDRV01V.ikasystems.com"
			AppFabric_CachePort					= "22233"
			AppFabric_CacheName					= "lassocachedata"
			
			# Web (IIS) details
			SiteName							= "Lasso-PROD"
			SiteIP								= "172.16.84.27"
			SitePort							= "80"
			SiteSSLPort							= "443"
			IISDNSName							= "SDWACDRV01V"
			SitePhysicalRootPath				= "C:\Carrier"
			SitePhysicalBackupPath				= "C:\Carrier_Backup"
			SitePhysicalPath_local				= "C:\Carrier\Lasso-PROD"
			SitePhysicalPath_UNC				= "\\SDWACDRV01V\Carrier\Lasso-PROD"
			SiteAppPoolName						= "Lasso-PROD"
			
			# Gateway web
			GatewayAppPoolName					= "Lasso-PROD-MedicareGW"
			GatewayAppPhysicalPath_local		= "C:\Carrier\Lasso-PROD\MedicareGW"
			GatewayAppPhysicalPath_UNC			= "\\SDWACDRV01V\Carrier\Lasso-PROD\MedicareGW"
			UserDocRootPath						= "C:\CarrierHome"
			UserDocClientPath_local				= "C:\CarrierHome\Lasso"
			UserDocClientPath_UNC				= "\\SDWACDRV01V\CarrierHome\Lasso"
			FeedsRootPath						= "C:\Feeds"
			FeedsClientPath_local				= "C:\Feeds\Lasso_Feeds"
			FeedsClientPath_UNC					= "\\SDWACDRV01V\Feeds\Lasso_Feeds"
			ClaimsAppPoolName					= "Lasso-PROD-Claims"
			ClaimsAppPhysicalPath				= "C:\Carrier\Lasso-PROD\Claims"
			
			# Gateway database
			dbserver							= "172.16.84.27"
			GWMasterDBName						= "Medicare01_Lasso"
			GWMasterDBUserID					= "bcbs-sa"
			GWMasterDBPassword					= "P@ssword1"   # Password needs to be secured
			sqlJobRunnerDBName					= "msdb"
			sqlJobRunnerUser					= "sqljobrunner"
			sqlJobRunnerPassword				= "N/A"

			# Admin Portal (for integrated environments only)
			adminPortalUrl						= "https://SDWACDRV01V/Accounts/Accounts/MyAccount.aspx"
			unAuthorizedAdminPortalAccessUrl	= "https://SDWACDRV01V/Accounts/UnauthorizedPortalAccess.aspx"
			
			# Gateway web.config data
			audienceUris						= "https://SDWACDRV01V/MedicareGW/"
			cleanupUrl							= "https://SDWACDRV01V/Accounts/Login.aspx"
			crmUrl								= "https://SDWACDRV01V/SalesPortal/Sales/CRM/"
			iamClaimsUrl						= "https://SDWACDRV01V/Claims"
			iamClaimsUrlForChangePassword		= "https://SDWACDRV01V/Claims/Admin/Connect2ikaClaims.aspx"
			iamClaimsUrlForChangeQA				= "https://SDWACDRV01V/Claims/Admin/Connect2ikaClaims.aspx"
			iamCMSBEQService					= "http://cmswebservice.ikaqa.com/service.asmx"
			iamDomainUrl						= "SDWACDRV01V"
			iamEnrollMemberIkaService			= "https://lassoservice.ikaenterprise.com/IKAService.asmx"
			iamGWLUrl							= "http://cmswebservice.ikaqa.com/service.asmx"
			iamHomeUrl							= "https://SDWACDRV01V"
			iamProfessionalListIkaServiceUrl	= "https://lassoservice.ikaenterprise.com/IKAService.asmx"
			iamProfessionalListIkaService		= "https://lassoservice.ikaenterprise.com/IKAService.asmx"
			iamUserNotAuthorizedPageUrl			= "https://SDWACDRV01V/Accounts/UserNotAuthorizedPage.htm"
			samlLogoutURL						= "https://SDWACDRV01V/Accounts/SAMLLogout.aspx"
			
		}
    )
}