$Folder = "F:\EnrollmentFiles\Feeds\Archive\Outgoing"

#Delete files older than 215 days
Get-ChildItem $Folder -Recurse -Force -ea 0 |
? {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-215)} |
ForEach-Object {
   $_ | del -Force
   $_.FullName | Out-File c:\users\a648522\desktop\deletedlog.txt -Append
}