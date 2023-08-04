$Folder = "F:\CarrierHome\SCAN Prod Int\Claims\UserDocuments\IKASERVICELOG"

#Delete files older than 6 months
Get-ChildItem $Folder -Recurse -Force -ea 0 |
? {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-30)} |
ForEach-Object {
   $_ | del -Force
   $_.FullName | Out-File c:\users\da_cyber_8\desktop\deletedlog.txt -Append
}

#Delete empty folders and subfolders
#Get-ChildItem $Folder -Recurse -Force -ea 0 |
#? {$_.PsIsContainer -eq $True} |
#? {$_.getfiles().count -eq 0} |
#ForEach-Object {
#    $_ | del -Force
#    $_.FullName | Out-File C:\log\deletedlog.txt -Append
#}