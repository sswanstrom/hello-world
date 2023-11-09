param ([string]$accname)
$serverlist = get-content servers.txt

ForEach($servername in $serverlist)
{
get-hotfix -computername $servername | select-object PSComputername,HotfixID,InstalledOn | Sort-object -property InstalledOn -Descending | Select-object -first 1
}