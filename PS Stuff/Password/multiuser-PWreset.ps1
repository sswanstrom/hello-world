Import-CSV -path .\PWchangeAccounts.csv | foreach {
 
$User = $._AccountName
$NewPass = $._Password

write-host "Changing password to " $User
set-adaccountpassword -identity $User -newpassword (convertto-securestring -asplaintext $NewPass -force) -reset

}
