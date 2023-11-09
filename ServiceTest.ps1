configuration ServiceTest
{
	param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [System.Management.Automation.PSCredential]
        $LDAP_Credential
    )
	
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node localhost
    {
		$ldap_username = $LDAP_Credential.username
		$ldap_password = $LDAP_Credential.GetNetworkCredential().password
		
        Service ServiceExample
        {
            Name        = "ClaimsSch_LTR_RPT_CORR_For_HNNY-QA"
			Description = "Generate Letters, Reports and Correspondence for HNNY-QA"
            StartupType = "Automatic"
            State       = "Running"
			Credential  = $LDAP_Credential
			Path		= "\\ZQWDVQAUTL03C\CoreApps\HNNY\QA\Utilities\Correspondence\ikaSystems.ClaimsSystems.Services.ClaimsScheduler.exe"
        }
    }
}

$LDAP_Credential = Get-Credential -UserName $Node.LDAPUser -Message "Enter credentials for LDAP User"
ServiceTest -LDAP_Credential $LDAP_Credential -ConfigurationData DSCData.psd1

Start-DscConfiguration ServiceTest -Wait -Force -Verbose