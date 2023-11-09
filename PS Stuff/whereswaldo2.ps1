param ([string]$accname)
$serverlist = get-content domains.txt

ForEach($domain in $serverlist)
{
write-host $domain
get-aduser -identity $accname -server $domain | select Name,SamAccountName,Enabled 
}