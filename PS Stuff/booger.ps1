$Header = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black: border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #6495ED;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@
get-wmiobject -query "select * from win32_logicaldisk where DeviceID ='L:'" 
| convertto-html -Property DeviceID,DriveType,FreeSpace,Size -Head $Header | out-file booger.html