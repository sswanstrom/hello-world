configuration Add_LocalAdmin 
{
	Import-DscResource -Module PSDesiredStateConfiguration
    Import-DscResource -Module xComputerManagement 
   
    Node localhost
    {
        Group AddToAdmin{
            GroupName='Administrators'
            Ensure= 'Present'
            MembersToInclude=$Node.LDAPUser
 
        }
    #End Configuration Block    
    } 
}
 
Add_LocalAdmin -ConfigurationData DSCData.psd1
 
Start-DscConfiguration Add_LocalAdmin -Wait -Force -Verbose