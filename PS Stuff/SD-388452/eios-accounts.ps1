Import-CSV -path c:\users\da_cyber_8\Desktop\helpdeskaccounts.csv | foreach {
 
$GivenName = $_.name.split()[0] 
$Surname = $_.name.split()[1]
$Date = Get-Date -Format "dd MMM yyyy"
$Description = "SD-388452 - Created " + $Date

new-aduser -name $_.Name -enabled $true �GivenName $GivenName �Surname $Surname -accountpassword (convertto-securestring $_.Password -asplaintext -force) -changepasswordatlogon $false -samaccountname $_.samAccountName -email $_.Email -description $Description -displayname ($_.Gurname + ' ' + $_.GivenName) 


$FullName = $GivenName + " " + $Surname
$DistinguishedName = "CN=" + $FullName 


}