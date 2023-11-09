$DscWorkingFolder = $PSScriptRoot

Configuration Install_SqlClient {
	Import-DscResource -ModuleName PsDesiredStateConfiguration
	
	Node localhost {
		Package ODBCDriver {
			Ensure		=	"Present"
			Name		=	"Microsoft ODBC Driver 13 for SQL Server"
			Path		=	"$DscWorkingFolder\SupportingFiles\Tools\MSSQLServer\msodbcsql.msi"
			Arguments	=	"/passive IACCEPTMSODBCSQLLICENSETERMS=YES"
			ProductID	=	"7E425BFB-1DEB-499F-8F3F-3522A6E98754"
		}
		
		Package SQLClient {
			Ensure		=	"Present"
			Name		=	"Microsoft Command Line Utilities 13 for SQL Server"
			Path		=	"$DscWorkingFolder\SupportingFiles\Tools\MSSQLServer\MsSqlCmdLnUtils.msi"
			Arguments	=	"/passive IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES"
			ProductID	=	"48C4C5F8-2821-465B-BBF6-6F45EE3B1584"
		}
	}
}

Install_SqlClient

Start-DscConfiguration Install_SqlClient -Wait -Force -Verbose
