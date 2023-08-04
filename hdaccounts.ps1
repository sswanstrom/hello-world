param ([string]$accname,[string]$newpass)

$domains = @("ENTCORE.com", "SERVICES.ENTCORE.com")
$Date = Get-Date -Format "dd MMM yyyy"
$Description = SD-388452 + " - Created " + $Date

Import-CSV -path c:\users\da_cyber_8\Desktop\testaccounts.csv | foreach {
 
$givenName = $_.name.split()[0] 
$surname = $_.name.split()[1]
 
new-aduser -server iperf94.com -name $name -enabled $true –givenName $givenName –surname $surname -accountpassword (convertto-securestring $_.password -asplaintext Kdp89w6sgWdUJ -force) -changepasswordatlogon $false -samaccountname $_.samaccountname 

}






Import-CSV -path c:\users\da_cyber_8\Desktop\
 set variables for GivenName,Surname,DisplayName,Description,EmailAddress
create account
apply variables
apply password