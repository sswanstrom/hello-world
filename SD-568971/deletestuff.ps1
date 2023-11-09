
$Folders = @("T:\DataExchangeSFTP_Prod\Anthem_Prod\Raw Data\InboundProcess\Dest", "T:\DataExchangeSFTP_Prod\BCBSKS_Prod\Raw Data\InboundProcess\Dest", "T:\DataExchangeSFTP_Prod\BCBSM_Prod\Raw Data\InboundProcess\Dest", "T:\DataExchangeSFTP_Prod\BCBSNE_Prod\Raw Data\InboundProcess\Dest", "T:\DataExchangeSFTP_Prod\Global_Prod\Raw Data\InboundProcess\Dest", "T:\DataExchangeSFTP_Prod\HCSC_Prod\Raw Data\InboundProcess\Dest", "T:\DataExchangeSFTP_Prod\Premera_Prod\Raw Data\InboundProcess\Dest", "T:\DataExchangeSFTP_Prod\TSA_Prod\Raw Data\InboundProcess\Dest", "T:\DataProcessing_Prod\DataPipeline\BCBSKS_Prod\Raw Data\InboundProcess\Dest", "T:\DataProcessing_Prod\DataPipeline\NBND_Prod\Raw Data\InboundProcess\Dest","T:\DataProcessing_Prod\DataPipeline\VBA_Prod\Raw Data\InboundProcess\Dest", "T:\DataProcessing_Prod\DataPipeline\WAHP_Prod\Raw Data\InboundProcess\Dest")

ForEach($Folder in $Folders)
{
#Delete files older than 30 days
Get-ChildItem $Folder -Recurse -Force -ea 0 |
? {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-30)} |
ForEach-Object {
   $_ | del -Force
   $_.FullName | Out-File C:\Admin\SD-568971\Logs\Deleted-30Days.txt -Append
               }
}
