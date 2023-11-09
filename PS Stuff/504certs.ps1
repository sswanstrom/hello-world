Import-Module -Name WebAdministration

Get-ChildItem -computer iprd2b504.ikaprod90.com -Path IIS:SSLBindings | ForEach-Object -Process `
{
    if ($_.Sites)
    {
        $certificate = Get-ChildItem -Path CERT:LocalMachine/My |
            Where-Object -Property Thumbprint -EQ -Value $_.Thumbprint

        [PsCustomObject]@{
            Sites                        = $_.Sites.Value
            CertificateFriendlyName      = $certificate.FriendlyName
            CertificateDnsNameList       = $certificate.DnsNameList
            CertificateNotAfter          = $certificate.NotAfter
            CertificateIssuer            = $certificate.Issuer
        }
    }
}