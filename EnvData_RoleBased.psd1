@{
    AllNodes = @(
	
        @{
            NodeName					= "*"
			PSDscAllowPlainTextPassword	= $true
			PSDscAllowDomainUser 		= $true
			EnvType						= "PROD"
			Client						= "Lasso"
			SSOCertLocn					= "D:\devops\DSC\Certs\ssop.pfx"
			SSOThumbprint				= "<thumbprint>"
			WildcardName				= "ikaenterprise.com"
			WildcardCertLocn			= "D:\devops\DSC\Certs_Jeremy\star.ikaenterprise\star.ikaenterprise.pfx"
			WildcardThumbprint			= "<thumbprint>"
			ADFSUser					= "ikasystems\srv-scmadmin"
        },

        @{
            NodeName					= "SDWACDRV01V"
            Role						= "WEB", "UTIL", "WEB-Gateway", "OracleClient"
			SiteName					= "Lasso-PROD"
			SiteIP						= "172.16.84.27"
			SitePort					= "80"
			SiteSSLPort					= "443"
			SitePhysicalPath			= "D:\Carrier\Lasso-PD"
			SiteAppPoolName				= "Lasso-PROD"
			IISHostName					= "lasso.ikaenterprise.com"
			GatewayAppPoolName			= "Lasso-PROD-MedicareGW"
			GatewayAppPhysicalPath		= "C:\Carrier\Lasso-PROD\MedicareGW"
			UserDocRootPath				= "C:\CarrierHome"
			UserDocClientPath			= "C:\CarrierHome\Lasso"
			FeedsRootPath				= "C:\Feeds"
			FeedsClientPath				= "C:\Feeds\Lasso_Feeds"
        }
    )
}