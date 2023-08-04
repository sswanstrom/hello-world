$servers = gc serverlist.txt
$date = get-date -format "dd MMM yyyy"
$time = get-date -format hhmm
$a = "<style>"
$a = $a + "BODY{backgrouund-color:white;}"
$a = $a + "TABLE{border-width: 2px;border-style: solid;border-color: black;border-collapse: separate;width:800px}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:lightblue}"
$a = $a + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:White}"
$a = $a + "</style>"

ForEach ($server in $servers) {

gwmi Win32_LogicalDisk -computername $server -Filter "DriveType=3" | select Name, FileSystem,FreeSpace,BlockSize,Size | `
% {$_.BlockSize=(($_.FreeSpace)/($_.Size))*100;$_.FreeSpace=($_.FreeSpace/1GB);$_.Size=($_.Size/1GB);$_} | `
Format-Table Name, 
@{n='Free (GB)';e={'{0:N2}'-f $_.FreeSpace}}, `
@{n='Capacity (GB)';e={'{0:N3}'-f $_.Size}}, ` 
@{n='Percent Free';e={'{0,6:P0}'-f ($_.FreeSpace/$_.Size)}} -AutoSize | ConvertTo-Html -head $a | Out-File -append "C:\Users\admsswanstrom\Desktop\diskspace\Freespace$date-$time.htm"

}