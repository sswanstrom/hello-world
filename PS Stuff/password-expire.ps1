param ([string]$accname)

$domains = @("IKASYSTEMS.com", "IKASTG.com", "IKASERVICES.com", "IKACLAIM.com", "IKACLAIM50.com", "IKACLAIMS40.com", "IKACLAIMS45.com", "IKAPROD55.com", "IKAPROD60.com", "IKAPROD65.com","IKAPROD76.com", "IKAPROD87.com", "IKAPROD90.com", "IKAPROD98.com", "IKAPROD110.com", "IKAPROD120.com", "IKAPROD130.com", "IPERF194.com", "ENTCORE.com", "SERVICES.ENTCORE.com")

ForEach($domain in $domains)
{
write-host $domain
set-aduser $accname -passwordneverexpires:$false
get-aduser $accname -properties passwordneverexpires
}