<#
        .SYNOPSIS
            Move or delete files older than 30 days from predefined folders.


        .DESCRIPTION
            Part I 
             Documents pre-move size of affected folders
             Moves files older than 30 days to archive folders
             Documents post-move size of affected folders

            Part II 
             Documents pre-delete size of affected folders
             Deletes files older than 30 days from affected folders
             Documents post-delete size of affected folders

        
        .NOTES
            Author: Steve Swanstrom - Advantasure CloudOps
            Created: 16 JUN 2023
             Version 1.0 (16 JUN 2023):
                -Initial creation
             Version 1.1 (23 JUN 2023):
                -Bug fixes
             Version 1.2 (18 JUL 2023):
                -Added documentation code

        #>


############################################################
# Part I - Move files from Prod folders to Archive folders #
############################################################

Echo "Part I - File archiving" | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
Echo "" | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append

# Document Folder Sizes before moving files to Archive folder

Echo "Folder Sizes BEFORE file movement" | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
Echo "" | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append

$Folders1 = @("T:\Shares\DataExchangeSFTP_Prod\Anthem_Prod\FromTessellate", "T:\Shares\DataExchangeSFTP_Prod\BCBSKS_Prod\FromTessellate", "T:\Shares\DataExchangeSFTP_Prod\BCBSM_HenryFord_Prod\FromDDDS", "T:\Shares\DataExchangeSFTP_Prod\BCBSM_IHA_Prod\FromDDDS", "T:\Shares\DataExchangeSFTP_Prod\BCBSM_IPC_Prod\FromTessellate", "T:\Shares\DataExchangeSFTP_Prod\BCBSM_Prod\FromDDDS", "T:\Shares\DataExchangeSFTP_Prod\BCBSNE_Prod\FromTessellate", "T:\Shares\DataExchangeSFTP_Prod\CIOX_Prod\FromDDDS", "T:\Shares\DataExchangeSFTP_Prod\HCSC_Prod\FromTessellate", "T:\Shares\DataExchangeSFTP_Prod\Premera_Prod\FromTessellate", "T:\Shares\DataExchangeSFTP_Prod\TSA_Prod\FromDDDS")

ForEach ($Folder1 in $Folders1) {
$Folder1 | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
"{0:N2} GB" -f ((Get-ChildItem $Folder1 -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1GB) | out-file C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
}

# Move files from Prod folders to Archive folders in the Folders1 array

robocopy T:\Shares\DataExchangeSFTP_Prod\Anthem_Prod\FromTessellate T:\Shares\DataExchangeArchive_Prod\Anthem\FromTessllate /mov /minage:30 /s /r:3 /w:10 /log:C:\Admin\SD-568971\Logs\Anthem_Prod.txt
robocopy T:\Shares\DataExchangeSFTP_Prod\BCBSKS_Prod\FromTessellate T:\Shares\DataExchangeArchive_Prod\BCBSKS\FromTessellate /mov /minage:30 /s /r:3 /w:10 /log:c:\C:\Admin\SD-568971\Logs\BCBSKS_Prod.txt
robocopy T:\Shares\DataExchangeSFTP_Prod\BCBSM_HenryFord_Prod\FromDDDS T:\Shares\DataExchangeArchive_Prod\BCBSM-HenryFord\FromDDDS /mov /minage:30 /s /r:3 /w:10 /log:C:\Admin\SD-568971\Logs\BCBSM_HenryFord_Prod.txt
robocopy T:\Shares\DataExchangeSFTP_Prod\BCBSM_IHA_Prod\FromDDDS T:\Shares\DataExchangeArchive_Prod\BCBSM-IHA\FromDDDS /mov /minage:30 /s /r:3 /w:10 /log:C:\Admin\SD-568971\Logs\BCBSM_IHA_Prod.txt
robocopy T:\Shares\DataExchangeSFTP_Prod\BCBSM_IPC_Prod\FromTessellate T:\Shares\DataExchangeArchive_Prod\BCBSM-IPC\FromTessellate /mov /minage:30 /s /r:3 /w:10 /log:C:\Admin\SD-568971\Logs\BCBSM_IPC_Prod.txt
robocopy T:\Shares\DataExchangeSFTP_Prod\BCBSM_Prod\FromDDDS T:\Shares\DataExchangeArchive_Prod\BCBSM\FromDDDS /mov /minage:30 /s /r:3 /w:10 /log:C:\Admin\SD-568971\Logs\BCBSM_Prod.txt
robocopy T:\Shares\DataExchangeSFTP_Prod\BCBSNE_Prod\FromTessellate T:\Shares\DataExchangeArchive_Prod\BCBSNE\FromTessellate /mov /minage:30 /s /r:3 /w:10 /log:C:\Admin\SD-568971\Logs\BCBSNE_Prod.txt
robocopy T:\Shares\DataExchangeSFTP_Prod\CIOX_Prod\FromDDDS T:\Shares\DataExchangeArchive_Prod\CIOX\FromDDDS /mov /minage:30 /s /r:3 /w:10 /log:C:\Admin\SD-568971\Logs\CIOX_Prod.txt
robocopy T:\Shares\DataExchangeSFTP_Prod\HCSC_Prod\FromTessellate T:\Shares\DataExchangeArchive_Prod\HCSC\FromTessellate /mov /minage:30 /s /r:3 /w:10 /log:C:\Admin\SD-568971\Logs\HCSC_Prod.txt
robocopy T:\Shares\DataExchangeSFTP_Prod\Premera_Prod\FromTessellate T:\Shares\DataExchangeArchive_Prod\Premera\FromTessellate /mov /minage:30 /s /r:3 /w:10 /log:C:\Admin\SD-568971\Logs\Premera_Prod.txt
robocopy T:\Shares\DataExchangeSFTP_Prod\TSA_Prod\FromDDDS T:\Shares\DataExchangeArchive_Prod\TripleS\FromDDDS /mov /minage:30 /s /r:3 /w:10 /log:C:\Admin\SD-568971\Logs\TSA_Prod.txt

# Document Prod Folder Sizes after moving files to Archive folders

Echo "" | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
Echo "Folder Sizes AFTER file movement" | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
Echo "" | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append

ForEach ($Folder1 in $Folders1) {
$Folder1 | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
"{0:N2} GB" -f ((Get-ChildItem $Folder1 -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1GB) | out-file C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
}

####################################################################
# Part II - Delete files older than 30 days from given folder list #
####################################################################

Echo "" | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
Echo "Part II - File deletions" | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
Echo "" | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append

# Document Folder Sizes before deleting files

Echo "" | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
Echo "Folder Sizes BEFORE deleting files" | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
Echo "" | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append

$Folders2 = @("T:\Shares\DataExchangeSFTP_Prod\Anthem_Prod\Raw Data\InboundProcess\Dest", "T:\Shares\DataExchangeSFTP_Prod\BCBSKS_Prod\Raw Data\InboundProcess\Dest", "T:\Shares\DataExchangeSFTP_Prod\BCBSM_Prod\Raw Data\InboundProcess\Dest", "T:\Shares\DataExchangeSFTP_Prod\BCBSNE_Prod\Raw Data\InboundProcess\Dest", "T:\Shares\DataExchangeSFTP_Prod\Global_Prod\Raw Data\InboundProcess\Dest", "T:\Shares\DataExchangeSFTP_Prod\HCSC_Prod\Raw Data\InboundProcess\Dest", "T:\Shares\DataExchangeSFTP_Prod\Premera_Prod\Raw Data\InboundProcess\Dest", "T:\Shares\DataExchangeSFTP_Prod\TSA_Prod\Raw Data\InboundProcess\Dest", "T:\Shares\DataProcessing_Prod\DataPipeline\BCBSKS_Prod\Raw Data\InboundProcess\Dest", "T:\Shares\DataProcessing_Prod\DataPipeline\NBND_Prod\Raw Data\InboundProcess\Dest","T:\Shares\DataProcessing_Prod\DataPipeline\VBA_Prod\Raw Data\InboundProcess\Dest", "T:\Shares\DataProcessing_Prod\DataPipeline\WAHP_Prod\Raw Data\InboundProcess\Dest")

ForEach ($Folder2 in $Folders2) {
$Folder2 | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
"{0:N2} GB" -f ((Get-ChildItem $Folder2 -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1GB) | out-file C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
}

# Delete files older than 30 days from each folder in the Folders2 array

ForEach ($Folder2 in $Folders2) {

   Get-ChildItem $Folder2 -Recurse -Force -ea 0 |
   ? {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-30)} |
      ForEach-Object {
      $_ | del -Force
      $_.FullName | Out-File C:\Admin\SD-568971\Logs\Deletions.txt -Append
   }
}

# Document Folder Sizes after deleting files

Echo "" | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
Echo "Folder Sizes AFTER deleting files" | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
Echo "" | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append

ForEach ($Folder2 in $Folders2) {
$Folder2 | Out-File -FilePath C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
"{0:N2} GB" -f ((Get-ChildItem $Folder2 -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1GB) | out-file C:\Admin\SD-568971\Logs\Test-Everything-Log.txt -Append
}

#Delete empty folders and subfolders
#Get-ChildItem $Folder -Recurse -Force -ea 0 |
#? {$_.PsIsContainer -eq $True} |
#? {$_.getfiles().count -eq 0} |
#ForEach-Object {
#    $_ | del -Force
#    $_.FullName | Out-File C:\log\deletedlog.txt -Append
#}