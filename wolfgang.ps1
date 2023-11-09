$cred = Get-Credential
$c = 0
$servers = Get-ADComputer -Filter "OperatingSystem -like 'Windows Server*'"
$servers | foreach{
 $p = ($c++/$servers.count) * 100
 Write-Progress -Activity "Checking $_" -Status "$p % completed" -PercentComplete $p;
 if(Test-Connection -ComputerName $_.DNSHostName -Count 2 -Quiet){
    Invoke-Command -ComputerName $_.DNSHostName -Credential $cred `
    {dir Cert:\LocalMachine\my | ? NotAfter -lt (Get-Date).AddDays(14)}
  }
}