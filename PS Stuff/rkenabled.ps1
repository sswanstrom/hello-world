$domainlist = get-content domains.txt

ForEach($domain in $domainlist)

   {
   write-host $domain
   get-aduser -identity admrkuniewicz -server $domain -properties samaccountname, name, lastlogon | select name, samaccountname, enabled
   }
