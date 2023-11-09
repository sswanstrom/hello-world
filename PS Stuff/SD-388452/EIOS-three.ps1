Import-CSV EIOS-three.csv | foreach {
 
$GivenName = $_.name.split()[0] 
$Surname = $_.name.split()[1]
$Date = Get-Date -Format "dd MMM yyyy"
$Description = "SD-399975 - Created " + $Date
$FullName = $GivenName + " " + $Surname

   new-aduser -name $_.Name -enabled $true –GivenName $GivenName –Surname $Surname `
    -accountpassword (convertto-securestring $_.Password -asplaintext -force) -changepasswordatlogon $false `
    -samaccountname $_.samAccountName -email $_.Email -description $Description `
    -displayname ($_.surname + ' ' + $_.givenname) 

   set-aduser -identity $_.samAccountName -userprincipalname $_.NewUPN

$user = get-aduser -identity $_.samAccountName
   move-adobject -identity $user.distinguishedname -targetpath "OU=Helpdesk Team,OU=Admin,OU=ActiveUsers,DC=services,DC=entcore,dc=com"
   add-adgroupmember -identity "CN=EIOS Helpdesk,OU=Helpdesk Team,OU=Admin,OU=ActiveUsers,DC=services,DC=entcore,dc=com" -members $_.samAccountName

}