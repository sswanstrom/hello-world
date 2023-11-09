#$RealFolders = "T:\Shares\Swanstrom_Test"
$Folders = @("T:\Shares\Harman_Test\DataExchangeSFTP_Prod\Anthem_Prod\Raw Data\InboundProcess\Dest", "T:\Shares\Harman_Test\DataExchangeSFTP_Prod\BCBSNE_Prod\Raw Data\InboundProcess\Dest", "T:\Shares\Harman_Test\DataExchangeSFTP_Prod\HCSC_Prod\Raw Data\InboundProcess\Dest")

ForEach($Folder in $Folders) {
   #Delete files older than 30 days
   Get-ChildItem $Folder -Recurse -Force -ea 0 |
   ? {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-30)} |
      ForEach-Object {
      $_ | del -Force
      $_.FullName | Out-File c:\users\admsswanstrom\desktop\test-delete.txt -Append
   }
}

#$Folder = "F:\CarrierHome\SCAN Prod Int\Claims\UserDocuments\IKASERVICELOG"

#Delete files older than 30 days
#Get-ChildItem $Folder -Recurse -Force -ea 0 |
#? {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-30)} |
#ForEach-Object {
#   $_ | del -Force
#   $_.FullName | Out-File c:\users\da_cyber_8\desktop\deletedlog.txt -Append
#}

#Delete empty folders and subfolders
#Get-ChildItem $Folder -Recurse -Force -ea 0 |
#? {$_.PsIsContainer -eq $True} |
#? {$_.getfiles().count -eq 0} |
#ForEach-Object {
#    $_ | del -Force
#    $_.FullName | Out-File C:\log\deletedlog.txt -Append
#}