Configuration Set_TimeZone {
    Import-DscResource -ModuleName PSDesiredStateConfiguration
	Import-DscResource -ModuleName ComputerManagementDsc
	
	Node localhost
	{
		TimeZone SetTimeZone
		{
			IsSingleInstance = 'Yes'
			TimeZone = 'Eastern Standard Time'
		}
	}
}

Set_TimeZone -ConfigurationData DSCData.psd1
Start-DscConfiguration Set_TimeZone -Wait -Force -Verbose

