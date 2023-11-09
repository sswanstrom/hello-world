Import-Module ActiveDirectory

#$DOM = $ENV:UserDNSDomain
$Dom = (Get-WmiObject Win32_ComputerSystem).Domain

Write-Host "Processing Domain: $Dom"
Write-Host " "

$OutputDir1 = "C:\Temp"
$OutputDir2 = $OutputDir1 + "\" + $DOM + "-Cert-Dumps"

$ErrorActionPreference = "SilentlyContinue"

New-Item -ItemType Directory -Path $OutputDir1
New-Item -ItemType Directory -Path $OutputDir2

#$Servers = Get-ADComputer -Filter {(OperatingSystem -like "*windows*server*") -and (Enabled -eq $True)} -Properties * | select DNSHostName, IPV4Address, Name
$Servers = Get-ADComputer -Filter {(OperatingSystem -like "*windows*server*") -and (Enabled -eq $True)} -Properties * | select *

foreach ($Server in $Servers) {
 
# CN
# DNSHostName
# Name
# IPv4Address
# Enabled = $True

     $DNSHost = $Server.DNSHostName
     $IPv4 = $Server.IPv4Address
     $Name = $Server.Name

     $CurrFile = $OutputDir2 + "\" + $Name + ".txt"

     Write-Host "Processing Server: $Name"
     Write-Host " "

     $CertStore = New-Object System.Security.Cryptography.X509Certificates.X509Store "\\$Name\My","LocalMachine"
     $CertStore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadOnly)

     foreach ($Cert in $CertStore.Certificates) {
     
        Add-Content $CurrFile $Cert
        Add-Content $CurrFile "====================="
        Add-Content $CurrFile " "
     }

     $CertStore.Close()

}