Configuration AppFabric {
	Import-DscResource -ModuleName PsDesiredStateConfiguration
    Import-DscResource -ModuleName AppFabricDsc
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
		
		Script Unblock_File
		{
			GetScript = {Return "Unblock_File" }
			TestScript = {$false}
			SetScript = { 
				Unblock-File -Path D:\devops\DSC\installers\WindowsServerAppFabricSetup_x64.exe
			}
		}
		
		
        AFInstall AppFabric_Install
        {
            Ensure						= 'Present'
            Path						= "D:\devops\DSC\installers\WindowsServerAppFabricSetup_x64.exe"
            Features					= "hostingservices","hostingadmin","cachingservice","cacheclient","cacheadmin"
            EnableUpdate				= $false
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
    }
}