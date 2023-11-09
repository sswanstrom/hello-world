Configuration AppFabricPS {
	Import-DscResource -ModuleName PsDesiredStateConfiguration
	Import-DscResource -ModuleName xSmbShare

    Node 'localhost' {
		# .net 3.5 and IIS server are pre-requisites for AppFabric
		$winFeatures = @("NET-Framework-Core","Web-Server")

		ForEach ($Feature in $winFeatures) {
			WindowsFeature $Feature {
				Name				= $Feature
				Ensure				= 'Present'
			}
		}
		
		File AppFabricConfig_Folder {
		  Type = 'Directory'
		  DestinationPath = 'D:\AppFabric configuration'
		  Ensure = "Present"
		}
		
		# ADFS (e.g. LAS_STG_ADFS) user needs Read/Write access
		# srv-scmadmin needs Read/Write access
		xSmbShare CarrierShare {
            Name    = "AppFabric configuration"
            Path    = "D:\AppFabric configuration"
            Ensure  = "Present"
			FullAccess = @("srv-scmadmin@ikasystems.com", "arodrigues@ikasystems.com")
            DependsOn = "[File]AppFabricConfig_Folder"
        }
		
		Script AppFabric_Install
		{
			GetScript = {Return "AppFabric_Install" }
			TestScript = {$false}
			SetScript = { 
				Start-Process -FilePath 'D:\devops\DSC\installers\WindowsServerAppFabricSetup_x64.exe' -ArgumentList '/i hostingservices",hostingadmin",""cacheclient","cachingService","CacheAdmin /l c:\temp\appfabric.log' -Wait -NoNewWindow | Write-verbose
			}
		}
    }
}