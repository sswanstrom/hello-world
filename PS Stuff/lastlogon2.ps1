$domainlist = get-content sungarddomainlist.txt
$accountlist = get-content accountlist.txt

ForEach($domain in $domainlist)
{
ForEach($accountname in $accountlist)
   {
   get-aduser -identity $accountname -server $domain -properties samaccountname, name, lastlogon | select name, samaccountname, @{Name='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}} 
   }
}