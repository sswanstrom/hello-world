$DscWorkingFolder = $PSScriptRoot

Configuration OracleClient {
	Import-DscResource -ModuleName PsDesiredStateConfiguration

	Node $AllNodes.Where{$_.Role -contains "OracleClient"}.NodeName {
		Script Install_OracleClient_32
		{
			GetScript = {Return "Install_OracleClient_32" }
			TestScript = {$false}
			SetScript = { 
				Start-Process -FilePath '$using:DscWorkingFolder\SupportingFiles\installers\win32_11gR2_client\client\setup.exe' -ArgumentList '-silent -noconfig -ignorePrereq -ignoreSysPrereqs -nowait -force -responseFile $using:DscWorkingFolder\SupportingFiles\ResponseFiles\OracleInstantClient_32.rsp' -Wait -NoNewWindow | Write-verbose
			}
		}
		
		Script Install_OracleClient_64
		{
			GetScript = {Return "Install_OracleClient_64" }
			TestScript = {$false}
			SetScript = { 
				Start-Process -FilePath '$using:DscWorkingFolder\SupportingFiles\installers\win64_11gR2_client\client\setup.exe' -ArgumentList '-silent -noconfig -ignorePrereq -ignoreSysPrereqs -nowait -force -responseFile $using:DscWorkingFolder\SupportingFiles\ResponseFiles\OracleInstantClient_64.rsp' -Wait -NoNewWindow | Write-verbose
			}
		}
	}
}

OracleClient -ConfigurationData EnvData.psd1
