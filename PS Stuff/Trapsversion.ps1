$filename = "\Program Files\Palo Alto Networks\Traps\CyveraService.exe" 
 
$obj = New-Object System.Collections.ArrayList 
 
$computernames = Get-Content Computerlist.txt 
foreach ($server in $computernames) 
{ 
$filepath = Test-Path "\\$server\c$\$filename" 
 
if ($filepath -eq "True") { 
$file = Get-Item "\\$server\c$\$filename" 
 
     
        $obj += New-Object psObject -Property @{'Computer'=$server;'FileVersion'=$file.VersionInfo|Select FileVersion;'LastAccessTime'=$file.LastWriteTime} 
        } 
     } 
     
$obj | select computer, FileVersion | Export-Csv -Path 'Traps_Results.csv' -NoTypeInformation 