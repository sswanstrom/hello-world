$serverlist = get-content servers.txt

ForEach ($server in $serverlist) {

Invoke-Command -ComputerName $server -ScriptBlock{Get-LocalGroupMember -Name 'Administrators'} | select Name
}
