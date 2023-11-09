$servers = get-content C:\Users\a648522\Desktop\SessionHosts.txt
$outfile = "C:\Users\a648522\Desktop\SessionHostDiskSpace.txt"

ForEach ($server in $servers) {

# Set execution policy
# set-executionpolicy -executionpolicy unrestricted

# Add server name to outfile
$server | out-file $outfile -append 

gwmi Win32_LogicalDisk -computer $server -Filter "DriveType=3" | select Name, FileSystem,FreeSpace,BlockSize,Size | `
% {$_.BlockSize=(($_.FreeSpace)/($_.Size))*100;$_.FreeSpace=($_.FreeSpace/1GB);$_.Size=($_.Size/1GB);$_} | `
Format-Table Name, 
@{n='Free (GB)';e={'{0:N2}'-f $_.FreeSpace}}, `
@{n='Capacity (GB)';e={'{0:N3}'-f $_.Size}}, ` 
@{n='Percent Free';e={'{0:N2}'-f ($_.FreeSpace/$_.Size*100)+"%"}} -AutoSize | out-file $outfile -append

}