param ([string]$domain,[string]$group)

get-adgroupmember -server $domain -identity $group | select name, SAMaccountname