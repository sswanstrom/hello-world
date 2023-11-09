####################################################################################################
#
# NAME: copyADMuser.ps1
#
# AUTHOR:	Steven Swanstrom (steven.swanstrom@advantasure.com)
# MODIFIED:	v1.0	Steven Swnastrom (steven.swanstrom@advantasure.com)
#
# COMMENT:	Copies ADM user account in all on-premesis domains
#
# VERSION HISTORY:
# 1.0	05/03/2020	Original version
# 
#
# USAGE: copyADMuser.ps1 Firstname Lastname sourceSAMaccount
#
# (Note: Run from an elevated (Run as Administrator) PowerShell prompt)
####################################################################################################

Param(
	[Parameter(Position=0, Mandatory=$true)][string]$sourceADMuser, 
	[Parameter(Position=1, Mandatory=$true)][string]$TicketNum
	[Parameter(Position=2, Mandatory=$true)][string]$FirstName
	[Parameter(Position=3, Mandatory=$true)][string]$LastName
	[Parameter(Position=4, Mandatory=$true)][string]$Password
	[Parameter(Position=5, Mandatory=$true)][string]$TicketNum
)

#Variables

$ErrorActionPreference = 'SilentlyContinue' 

$Domains = @("IKASYSTEMS.com", "IKASTG.com", "IKASERVICES.com", "IKACLAIM.com", "IKACLAIM50.com", "IKACLAIMS40.com", "IKACLAIMS45.com", "IKAPROD55.com", "IKAPROD60.com", "IKAPROD65.com","IKAPROD76.com", "IKAPROD87.com", "IKAPROD90.com", "IKAPROD98.com", "IKAPROD110.com", "IKAPROD120.com", "IKAPROD130.com", "IPERF194.com", "ENTCORE.com", "SERVICES.ENTCORE.com")
$Date = Get-Date -Format MM/dd/yyyy
$Description = $TicketNum + " - Created " + $Date
$AdmSam = "adm" + $SamAccountName

#Loads ActiveDirectory Module
$modulecheck = Get-Module ActiveDirectory
If(!$modulecheck){
	Import-Module ActiveDirectory
}

+------------+
| What to do |
+------------+

get sourceaccount properties ($sourceaccount = get-aduser $sourceADMuser -properties *)

create targetuser ($userInstance = Get-ADUser -Identity "saraDavis"
New-ADUser -SAMAccountName "ellenAdams" -Instance $userInstance -DisplayName "EllenAdams"

$newaccount = new-aduser
modify targetuser from source
additional targetuser modifications 


#Disable computer accounts and moves to Disabled Computers OU
$computer = (($SamAccountName -replace '[^a-zA-Z-]','')[0..9] -join "") + "*"
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
