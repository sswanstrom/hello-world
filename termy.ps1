####################################################################################################
#
# NAME:	term.ps1
#
# AUTHOR:	Jonathan Tsoi (jonathan.tsoi@advantasure.com)
# MODIFIED:	v1.1	Jonathan Tsoi (jonathan.tsoi@advantasure.com)
#
# COMMENT:	Terminates AD accounts for domains in Sungard and Azure Portal
#
# VERSION HISTORY:
# 1.0	08/02/2019	Initial release
# 1.1	08/07/2019	Modified $computer variable to take into account long usernames.
#					Updated Disable AzureAD section to check for adm accounts
#
####################################################################################################

Param(
	[Parameter(Position=0, Mandatory=$true)][string]$SamAccountName, 
	[Parameter(Position=1, Mandatory=$true)][string]$TicketNum
)

#Variables
$ErrorActionPreference = 'SilentlyContinue' 
$Domains = @("IKASYSTEMS.com", "IKASTG.com", "IKASERVICES.com", "IKACLAIM.com", "IKACLAIM50.com", "IKACLAIMS40.com", "IKACLAIMS45.com", "IKAPROD55.com", "IKAPROD60.com", "IKAPROD65.com","IKAPROD76.com", "IKAPROD87.com", "IKAPROD90.com", "IKAPROD98.com", "IKAPROD110.com", "IKAPROD120.com", "IKAPROD130.com", "IPERF194.com", "ENTCORE.com", "SERVICES.ENTCORE.com")
$Date = Get-Date -Format MM/dd/yyyy
$Description = $TicketNum + " - Disabled " + $Date
$AdmSam = "adm" + $SamAccountName

#Loads ActiveDirectory Module
$modulecheck = Get-Module ActiveDirectory
If(!$modulecheck){
	Import-Module ActiveDirectory
}

#Connects to AzureAD
$AzureADCheck = Get-AzureADTenantDetail
If(!$AzureADCheck){
	$message = Connect-AzureAD -ErrorAction Stop
}

#Disable AzureAD account and removes from groups
$userPrincipalName = $SamAccountName + "@ikasystems.onmicrosoft.com"
$MemberId = Get-AzureADUser -ObjectId $userPrincipalName
IF (!$MemberId){
	Write-Host $userPrincipalName does not exist in the Azure Portal
}
ELSE{
	$MemberId | Set-AzureADUser -AccountEnabled $false
	$MemberId | Get-AzureADUserMembership | ForEach-Object {$_.ObjectId | Remove-AzureADGroupMember -MemberId $MemberId.ObjectId}
	
	Get-AzureADUser -ObjectId $userPrincipalName | Format-Table DisplayName, UserPrincipalName, AccountEnabled -AutoSize
}

$AdmUserPrincipalName = $AdmSam + "@ikasystems.onmicrosoft.com"
$AdmMemberId = Get-AzureADUser -ObjectId $AdmUserPrincipalName
IF (!$AdmMemberId){
	Write-Host $AdmUserPrincipalName does not exist in the Azure Portal
}
ELSE{
	$AdmMemberId | Set-AzureADUser -AccountEnabled $false
	$AdmMemberId | Get-AzureADUserMembership | ForEach-Object {$_.ObjectId | Remove-AzureADGroupMember -MemberId $AdmMemberId.ObjectId}
	
	Get-AzureADUser -ObjectId $AdmUserPrincipalName | Format-Table DisplayName, UserPrincipalName, AccountEnabled -AutoSize
}

#Disable computer accounts and moves to Disabled Computers OU
$computer = (($SamAccountName -replace '[^a-zA-Z-]','')[0..10] -join "") + "*"
$ikacomp = Get-ADComputer -Filter 'Name -like $computer' -server IKASYSTEMS.com
IF (!$ikacomp){
	Write-Host There are no computer accounts that begins with $computer.Replace('*','') in the IKASYSTEMS.com domain.
}
ELSE{
	$ikacomp | Disable-ADAccount
	$ikacomp | Set-ADComputer -Description $Description
	$ikacomp | Move-ADObject -TargetPath "OU=Disabled Computers,DC=ikaSystems,DC=com"
	
	Get-ADComputer -Filter 'Name -like $computer' -server IKASYSTEMS.com -Properties OperatingSystem, Description | Format-Table Name, DNSHostName, OperatingSystem, Description, Enabled -AutoSize
}

#Disables the account, Sets Description with the ticket number and date disabled, Moves it to the "Disabled Users" OU, Adds to DisabledUsers group and sets as the Primary Group, Remove user from all groups
ForEach ($domain in $Domains){
	$DN = 'OU=Disabled Users,DC=' + $domain.Replace('.',',DC=')
	$primaryGroup = Get-ADGroup -Identity DisabledUsers -properties primaryGroupToken -Server $domain
	$user = Get-ADUser -Filter 'SamAccountName -like $SamAccountName' -server $domain
	$admuser = Get-ADUser -Filter 'SamAccountName -like $AdmSam' -server $domain
	
	IF($user){	
		$user | Disable-ADAccount
		$user | Set-ADUser -Description $Description
		Add-ADGroupMember -Identity $primaryGroup -Members $user -server $domain
		$user | Set-ADUser -Replace @{primaryGroupID=$primaryGroup.primaryGroupToken}
		$user | Move-ADObject -TargetPath $DN
		Get-ADUser -Filter 'SamAccountName -like $SamAccountName' -server $domain -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server $domain -Confirm:$false}
	}
	
	IF($admuser){
		$admuser | Disable-ADAccount
		$admuser | Set-ADUser -Description $Description
		Add-ADGroupMember -Identity $primaryGroup -Members $admuser -server $domain 
		$admuser | Set-ADUser -Replace @{primaryGroupID=$primaryGroup.primaryGroupToken}
		$admuser | Move-ADObject -TargetPath $DN
		Get-ADUser -Filter 'SamAccountName -like $AdmSam' -server $domain -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server $domain -Confirm:$false}
	}
}

$results = @(ForEach ($domain in $Domains){
	$user = Get-ADUser -Filter 'SamAccountName -like $SamAccountName' -server $domain -Properties Description
	IF(!$user){	
		Write-Host $SamAccountName does not exist in $domain
	}
	ELSE{
		$user
	}
})

$results += @(ForEach ($domain in $Domains){
	$user = Get-ADUser -Filter 'SamAccountName -like $AdmSam' -server $domain -Properties Description
	IF(!$user){
		Write-Host $AdmSam does not exist in $domain
	}
	ELSE{
		$user
	}
})

$results | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
