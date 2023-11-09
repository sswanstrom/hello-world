@{
    AllNodes = @(
	
        @{
            NodeName							= "localhost"
			
			PSDscAllowPlainTextPassword			= $true
			PSDscAllowDomainUser 				= $true
			
			SystemTimeZone						= "Eastern Standard Time"
			smtpFrom							= "pwd@ikasystems.com"
			smtpNetworkHost						= "10.10.3.25"
			smtpNetworkPort						= "25"
			
			Client								= "PREM"
			EnvType								= "QA"
			MultiTenant							= "false"
			Sandbox								= "NO"
			IntegratedEnv						= "1"	# 0 = for non-integrated, 1 for Integrated
			
			ADFSExists							= "true"
			
			# Users
			LDAPUser							= "entcorecloud\PREM_QA_APP"
			#ADFSUser							= "entcorecloud\HNNY_QA_AFS"
			SQLShrdUser							= "entcorecloud\SHRD_QA_SQL01"
			
			# Certificate information
			WildcardName						= "*.qa.Advantasure.com"
			WildcardCertLocn					= "SupportingFiles\certs\qa\star_qa.advantasure.com.pfx"
			SSOCertLocn						    = "SupportingFiles\certs\qa\sso.qa.advantasure.com.pfx"
			
			# UTIL Server
			FileServerDrive						= "F:"
			FileServerUNC						= "\\ZQWDVQAUTL03C"
			
			# IIS site
			IISDNSName							= "premera.qa.advantasure.com"

			# Active Directory Federation Services
			#ADFS								= "healthnow-adfs.qa.advantasure.com"
        }
    )
}