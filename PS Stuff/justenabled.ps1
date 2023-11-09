$domains = get-content domainlist.txt

foreach($domain in $domains) {

get-aduser -filter "enabled -eq 'true'" -properties * | select displayName,samAccountName,Enabled | export-csv .\Enabled\$domain-Enabled.csv

}