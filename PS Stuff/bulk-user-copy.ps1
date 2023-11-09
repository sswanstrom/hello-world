import-csv -path c:\users\da_cyber_8\desktop\users.csv | foreach {

$givenName = $_.name.split()[0]
$surname = $_.name.split()[1]

new-aduser -name $_.name -enabled $true -givenName -surname $surname -accountpassword (convertto-securestring -asplaintext $newpass -force) -changepasswordatlogon $false -samaccountname $_.samaccountname –userprincipalname ($_.samaccountname+”@ad.contoso.com”) -city $_.city -department $_.department
















param ([string]$accname)
$serverlist = get-content domains.txt

ForEach($domain in $serverlist)
{
write-host $domain
get-aduser -identity $accname -server $domain | select Name,SamAccountName,Enabled 
}