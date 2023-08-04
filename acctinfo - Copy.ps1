param ([string]$accname)
$serverlist = get-content domainlist.txt

ForEach($domain in $serverlist)
{
write-host $domain
Get-ADUser -filter 'SAMAccountName -like $accname' -server $domain | ft SAMAccountName, Name -autosize
}