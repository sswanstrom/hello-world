﻿
$Lookup = @{
    378389 = [version]'4.5'
    378675 = [version]'4.5.1'
    378758 = [version]'4.5.1'
    379893 = [version]'4.5.2'
    393295 = [version]'4.6'
    393297 = [version]'4.6'
    394254 = [version]'4.6.1'
    394271 = [version]'4.6.1'
    394802 = [version]'4.6.2'
    394806 = [version]'4.6.2'
    460798 = [version]'4.7'
    460805 = [version]'4.7'
    461308 = [version]'4.7.1'
    461310 = [version]'4.7.1'
    461808 = [version]'4.7.2'
    461814 = [version]'4.7.2'
}
foreach ($server in (get-content c:\users\da_cyber_8\desktop\dotnetlist2.txt))
{
write-output $server
Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
    Get-ItemProperty -name Version, Release -EA 0 |
    # For One True framework (latest .NET 4x), change match to PSChildName -eq "Full":
Where-Object { $_.PSChildName -match '^(?!S)\p{L}'} |
    Select-Object @{name = ".NET Framework";expression = {$_.PSChildName}}, 
@{name = "Product"; expression = {$Lookup[$_.Release]}}, 
Version, Release
}