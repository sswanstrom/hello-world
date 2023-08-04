param ([string]$accname)
$users = get-content userlist.txt

foreach($user in $users) {
write-host $domain
get-aduser -identity $accname -server $domain -properties * | select Name,SAMaccountName,Enabled 

}