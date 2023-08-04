$Folder = "\\10.120.20.147\C$\inetpub\mailroot\Badmail"

#Delete files older than 6 months
Get-ChildItem $Folder -Recurse -Force -ea 0 |
? {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-37)} |
ForEach-Object {
   $_ | del -Force
   $_.FullName | Out-File c:\users\admsswanstrom\desktop\deletedlog2.txt -Append
}

#Delete empty folders and subfolders
#Get-ChildItem $Folder -Recurse -Force -ea 0 |
#? {$_.PsIsContainer -eq $True} |
#? {$_.getfiles().count -eq 0} |
#ForEach-Object {
#    $_ | del -Force
#    $_.FullName | Out-File C:\log\deletedlog.txt -Append
#}