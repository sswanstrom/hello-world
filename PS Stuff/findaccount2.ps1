$names = get-content names.txt
<# $erroractionpreference= 'silentlycontinue'
#>
foreach($name in $names)
{
get-aduser -server ikasystems.com $name | select Name,SamAccountName,Enabled
}