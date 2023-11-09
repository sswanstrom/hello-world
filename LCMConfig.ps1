[DSCLocalConfigurationManager()]

configuration LCMConfig
{
     param(
        [string[]]$NodeName
	    )

    Node localhost
	{
        Settings
        {
            RefreshMode = 'Push'
            RebootNodeIfNeeded = $true
        }
    }
}

LCMConfig -NodeName localhost
Set-DscLocalConfigurationManager .\LCMConfig -Verbose