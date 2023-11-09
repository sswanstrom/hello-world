Import-CSV JHpwresets.csv | foreach {
 
$User = $_.samAccountName
$NewPW = $_.NewPassword
$UserMail = $_.Email


write-host $User
set-adaccountpassword -identity $User -newpassword (convertto-securestring -asplaintext $NewPW -force) -reset

Send-MailMessage -To $usermail -From “noreply@advantasure.com” -Subject “SD-485752” -Body $NewPW -smtpserver "mpwikarelay1.ikaservices.com"
}

# Set the new password
$NewPassword = ConvertTo-SecureString -AsPlainText $_.NewPassword -Force
# Import users from CSV
Import-Csv "C:\ScriptsADUsers.csv" | ForEach-Object {
$samAccountName = $_."samAccountName"
 
#Un-comment the below line if your CSV file includes password for all users
#$NewPassword = ConvertTo-SecureString -AsPlainText $_."Password"  -Force
 
# Reset user password.
Set-ADAccountPassword -Identity $samAccountName -NewPassword $NewPassword -Reset
 
# Force user to reset password at next logon.
# Remove this line if not needed for you
Set-AdUser -Identity $samAccountName -ChangePasswordAtLogon $true
Write-Host " AD Password has been reset for: "$samAccountName
}

MoKznv98rquhHBZ7 Boucher
PT5EsE9QQgraTSzF Bussell
P3hkTzwt7kDkfD9D Cooper
MMVE2jOrAHqDRcEg Blair
79GJygdM4INKbA34 Peyton
uetvl0TCSmkglVgI Chun
vZFc3mKYrquhHBZ7 DeArmon
cLvYnwma7kDkfD9D Donovan
tgonKU4k9YviCgre Foley
KAzrMsrcMoKznv98 Matthews
rquhHBZ74INKbA34 Moussa
XhanxG5c9YviCgre Villanueva
37hHJmY2AHqDRcEg Craig
AHqDRcEgV6JCck6L Mahmud - Disabled
LhcO6r647kDkfD9D Richards
9YviCgreQgraTSzF Hasaj
4INKbA34MoKznv98 Islam
6VJwToBhrquhHBZ7 Boozer
yV3LnWqDQgraTSzF 
uhHNdpu4MoKznv98
SmkglVgIrquhHBZ7
V6JCck6LMoKznv98
VJwToBhKrquhHBZ7
znv99GJySmkglVgI
QgraTSzF4IN>bA34 DA_CYBER_1
XSKrC%25V6JCck6L DA_CYBER_2
Qauw3zgw#YviCgre DA_CYBER_3
Ncd@7YJfSmkglVgI DA_CYBER_4
ZvbZkscLV6JCc&6L DA_CYBER_5
7kDkfD9DAHqDRcEg
