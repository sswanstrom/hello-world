.".\VTAutomationLibrary.ps1" 
.".\ComponentsInstallLibrary.ps1" 
.".\CommonLibrary.ps1"
.".\certInstalLib.ps1"
 
 $environmentName="stage"
 $certpassword="No_certs"
    $certpassword= Switch ($environmentName)
      {
       "dev" { "D3v!_@dvant";break }
       "STAGE" { "St@g3!2019@dvanT";break }
       "prod" { "Pr0d!2019@dvanT";break }
        default {"No_certs"; break}
      }
    if (!($certpassword -eq "No_certs"))
    {
       $certPath= "{0}\certs\{1}\star_{1}.advantasure.com.pfx" -f $(get-location).Path,$environmentName
       write-host $certPath
       Install_Certificate -certPath  $certPath -Certpwd $certpassword
    }