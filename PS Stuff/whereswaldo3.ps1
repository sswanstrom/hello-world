param ([string]$accname)

get-aduser -identity $accname -server ikasystems.com | select Name,SamAccountName,Enabled 
