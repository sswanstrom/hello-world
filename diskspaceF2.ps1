$servers = gc serverlist.txt
ForEach ($server in $servers) {

$server | out-file diskspaceF2.txt -append

gwmi Win32_LogicalDisk -computername $server -Filter "DriveType=3" | select Name, FileSystem,FreeSpace,BlockSize,Size | `
% {$_.BlockSize=(($_.FreeSpace)/($_.Size))*100;$_.FreeSpace=($_.FreeSpace/1GB);$_.Size=($_.Size/1GB);$_} | `
Format-Table Name, 
@{n='Free (GB)';e={'{0:N2}'-f $_.FreeSpace}}, `
@{n='Capacity (GB)';e={'{0:N3}'-f $_.Size}}, ` 
@{n='Percent Free';e={'{0,6:P0}'-f ($_.FreeSpace/$_.Size)}} -AutoSize | out-file diskspaceF2.txt -append

}