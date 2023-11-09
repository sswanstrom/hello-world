Import-CSV -path c:\users\admsswanstrom\Desktop\SD-388452\helpdeskaccounts.csv | foreach {
 
$GivenName = $_.name.split()[0] 
$Surname = $_.name.split()[1]
$Date = Get-Date -Format "dd MMM yyyy"
$Description = "SD-388452 - Created " + $Date

new-aduser -name $_.Name -enabled $true –GivenName $GivenName –Surname $Surname -accountpassword (convertto-securestring $_.Password -asplaintext -force) -changepasswordatlogon $false -samaccountname $_.samAccountName -email $_.Email -description $Description -displayname ($_.Gurname + ' ' + $_.GivenName) 


$FullName = $GivenName + " " + $Surname
$DistinguishedName = "CN=" + $FullName 


}


Import-Module ActiveDirectory

$accountName = Read-Host "Enter the SamAccountName of the terminated user: "

# find the user object using the SamAccountName entered

# Get-ADUser takes a DistinghuishedName, a GUID, a SID or SamAccountName as Identity parameter
$user = Get-ADUser -Identity $accountName
if ($user) {
    # Move-ADObject takes a DistinghuishedName or GUID as Identity parameter
    Move-ADObject -Identity $user.DistinguishedName -TargetPath "OU=DisabledAccounts,DC=nfii,DC=com"

    # you can also pipe the object through:
    # $user | Move-ADObject -TargetPath "OU=DisabledAccounts,DC=nfii,DC=com"
}
else {
    Write-Warning "User with SamAccountName '$accountName' not found."
}