$ThumbPrint = '9f64b2b6186b78acaca4b61c80a7d4c6d510f3c5'  
# $cn = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name
$cn2 = get-content servlist-rq.txt

ForEach ($srvname in $cn2) {

Invoke-Command -ScriptBlock{  
    Get-ChildItem -path Cert:\LocalMachine\My -Recurse |  
        # Where-Object $_.Thumbprint -eq $Using.$ThumbPrint |  
        Where-Object Thumbprint -eq $Using.$ThumbPrint |
            Select-Object @{n='Computer';e={$ENV:ComputerName}}, Thumbprint, Friendlyname  
}  



$ThumbPrint = '9f64b2b6186b78acaca4b61c80a7d4c6d510f3c5'  
$cn2 = get-content servlist-rq1.txt

ForEach ($srvname in $cn2) {

Invoke-Command -ScriptBlock{  

Get-ChildItem -path Cert:\LocalMachine\My -Recurse |  Where-Object Thumbprint -eq $ThumbPrint | Write-host $srvname
}
}