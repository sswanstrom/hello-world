param ([string]$accname)

ForEach($domain in $sungard-domains)
write-host "Changing password to " $accname "in " $domain
<# set-adaccountpassword -server $domain -identity $accname -newpassword (convertto-securestring -asplaintext $newpass -force) -reset #>
write-host "Done!"
write-host " "
