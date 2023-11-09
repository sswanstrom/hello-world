$domains = get-content domainlist.txt

foreach($domain in $domains) {

get-adcomputer -filter {operatingsystem -like '*windows server*'} -properties operatingsystem -server $domain | select -expandproperty Name | out-file .\$domain.txt

}