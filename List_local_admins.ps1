$servers= get-content 'CBCservers.txt'
$output = 'cbc_local_admin_output.csv' 
$results = @()

foreach($server in $servers)
{
$admins = @()
$group =[ADSI]"WinNT://$server/Administrators" 
$members = @($group.psbase.Invoke("Members"))
$members | foreach {
 $obj = new-object psobject -Property @{
 Server = $Server
 Admin = $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
 }
 $admins += $obj
 } 
$results += $admins
}
$results| Export-csv $Output -NoTypeInformation
