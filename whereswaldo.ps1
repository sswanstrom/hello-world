param ([string]$accname)
$serverlist = get-content domains.txt

$result = ForEach($domain in $serverlist)
{
write-host $domain
get-aduser -identity $accname -server $domain | select Name,SamAccountName,Enabled 
$result | out-file awaan.txt -append
}