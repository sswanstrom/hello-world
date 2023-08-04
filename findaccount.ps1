$names = get-content names.txt
<# $erroractionpreference= 'silentlycontinue'
#>
foreach($name in $names) {

get-aduser -server ikasystems.com $name -filter * | select Name,SamAccountName,Enabled | out-file exists.txt

}