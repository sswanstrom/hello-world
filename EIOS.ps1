                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                Import-CSV -path c:\users\admsswanstrom\Desktop\SD-388452\EIOS.csv | foreach {
 
$GivenName = $_.name.split()[0] 
$Surname = $_.name.split()[1]
$Date = Get-Date -Format "dd MMM yyyy"
$Description = "SD-388452 - Created " + $Date
$FullName = $GivenName + " " + $Surname

   new-aduser -name $_.Name -enabled $true –GivenName $GivenName –Surname $Surname `
    -accountpassword (convertto-securestring $_.Password -asplaintext -force) -changepasswordatlogon $false `
    -samaccountname $_.samAccountName -email $_.Email -description $Description `
    -displayname ($_.surname + ' ' + $_.givenname) 

   set-aduser -identity $_.samAccountName -userprincipalname $_.NewUPN

$user = get-aduser -identity $_.samAccountName
   move-adobject -identity $user.distinguishedname -targetpath "OU=Helpdesk Team,OU=Account Operators,OU=Accounts,DC=entcorecloud,dc=com"
   add-adgroupmember -identity "CN=EIOS Helpdesk,ou=Helpdesk Team,ou=Account Operators,ou=Accounts,dc=entcorecloud,dc=com" -members $_.samAccountName

}