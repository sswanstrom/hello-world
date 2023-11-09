@{ 
	# Node specific data 
	AllNodes =
	@(
		@{ 
			NodeName = '*'
			PSDscAllowPlainTextPassword = $True
			ServicesEndpoint = 'http://localhost/Services/'
			TimeZone = 'Pacific Standard Time'
		},
		
		@{ 
			NodeName = 'AUTH'
		},
		
		@{ 
			NodeName = 'UTIL'
		},
		
		@{ 
			NodeName					=	'IIS'
			SiteName					=	'Lasso-Test'
			SiteHostName				=	'LASTWIIS01'
			
		},
		
		@{ 
			NodeName = 'SQL'
		},
	);
}