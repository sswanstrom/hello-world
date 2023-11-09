$DscWorkingFolder = $PSScriptRoot

Configuration Install_Tools {
	Import-DscResource -ModuleName PsDesiredStateConfiguration
	
	Node localhost {
		Package Install7Zip {
			Ensure		= 'Present'
			Name		= '7-Zip 16.04 (x64 edition)'
			Path		= "$DscWorkingFolder\SupportingFiles\Tools\7Zip\7z1604-x64.msi"
			ProductID	= '23170F69-40C1-2702-1604-000001000000'
			Arguments	= '/q'

		}
		
		Package InstallAdobeReader {
			Ensure		= 'Present'
			Name		= 'Adobe Acrobat Reader DC'
			Path		= "$DscWorkingFolder\SupportingFiles\Tools\Adobe\AcroRdrDC1700920044_en_US.exe"
			ProductID	= 'AC76BA86-7AD7-1033-7B44-AC0F074E4100'
			Arguments	= '/msi EULA_ACCEPT=YES SUPPRESS_APP_LAUNCH=YES ALLUSERS=1 /qn'
		}
	}
}

Install_Tools

Start-DscConfiguration Install_Tools -Wait -Force -Verbose
