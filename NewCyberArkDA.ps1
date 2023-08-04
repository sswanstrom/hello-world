Import-CSV -path c:\users\admsswanstrom\Desktop\SD-440328\NewCyberArkDA.csv | foreach {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               Import-CSV EIOS-three.csv | foreach {
 
$Date = Get-Date -Format "dd MMM yyyy"
$Description = "SD-440328 - Created " + $Date

   new-aduser -name $_.Name -enabled $true `
    -accountpassword (convertto-securestring $_.Password -asplaintext -force) -changepasswordatlogon $false `
    -samaccountname $_.samAccountName -description $Description `
    -displayname $_.DisplayName 

   set-aduser -identity $_.samAccountName -userprincipalname $_.NewUPN

$user = get-aduser -identity $_.samAccountName
   move-adobject -identity $user.distinguishedname -targetpath "OU=Domain Admins,OU=Accounts,DC=entcorecloud,dc=com"
   add-adgroupmember -identity "OU=Domain Admins,OU=Accounts,DC=entcorecloud,DC=com" -members $_.samAccountName

}