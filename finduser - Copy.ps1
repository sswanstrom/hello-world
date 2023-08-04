param ([string]$accname)
$domains = get-content sungarddomainlist.txt

foreach($domain in $domains) {
write-host $domain
get-aduser -identity $accname -server $domain -properties * | select Name,SAMaccountName,Enabled 

}