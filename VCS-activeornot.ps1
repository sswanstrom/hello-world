$domains = get-content dclist3.txt

foreach($domain in $domains) {

get-aduser -filter * | select Name,SamAccountName,Enabled | out-file $domain.txt

}