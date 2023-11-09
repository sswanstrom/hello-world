Import-CSV -path c:\users\da_cyber_8\Desktop\testaccounts.csv | foreach {
 
$GivenName = $_.name.split()[0] 
$Surname = $_.name.split()[1]
$Date = Get-Date -Format "dd MMM yyyy"
$Description = "SD-388452 - Created " + $Date

new-aduser -name $_.Name -enabled $true –GivenName $GivenName –Surname $Surname -accountpassword (convertto-securestring $_.Password -asplaintext -force) -changepasswordatlogon $false -samaccountname $_.samAccountName -email $_.Email -description $Description -displayname ($_.surname + ' ' + $_.givenname) 

set-aduser -identity $samaccountname -userprincipalname $samaccountname"@services.entcore.com"

$FullName = $GivenName + " " + $Surname
$DistinguishedName = "CN=" + $FullName 

move-adobject -identity "cn=$FullName,cn=users,cn=entcore,cn=com" -targetpath "ou=helpdesk team,ou=admin,ou=activeusers,dc=services,dc=entcore,dc=com"
add-adgroupmember -identity "cn=EIOS Helpdesk,ou=helpdesk team,ou=admin,ou=activeusers,dc=services,dc=entcore,dc=com" -members $samaccountname

}