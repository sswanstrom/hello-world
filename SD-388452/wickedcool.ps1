####################################################################################################
#
# NAME:	wickedcool.ps1
#
# AUTHOR:	Steven Swanstrom (steven.swanstrom@advantasure.com)
#
# COMMENT:	Disables AD accounts for domains in Sungard
#
# VERSION HISTORY:
# 1.0	11 Mar 2021	Initial version
# 
#
####################################################################################################

Param(
	[Parameter(Position=0, Mandatory=$true)][string]$SamAccountName, 
	[Parameter(Position=1, Mandatory=$true)][string]$TicketNum
)

#Variables
$ErrorActionPreference = 'SilentlyContinue' 
$Domains = @("IKASYSTEMS.com", "IKASTG.com", "IKASERVICES.com", "IKACLAIM.com", "IKACLAIM50.com", "IKACLAIMS40.com", "IKACLAIMS45.com", "IKAPROD55.com", "IKAPROD60.com", "IKAPROD65.com","IKAPROD76.com", "IKAPROD87.com", "IKAPROD90.com", "IKAPROD98.com", "IKAPROD110.com", "IKAPROD120.com", "IKAPROD130.com", "IPERF194.com", "ENTCORE.com", "SERVICES.ENTCORE.com")
$Date = Get-Date -Format "dd MMM yyyy"
$Description = SD-388452 + " - Created " + $Date
$AdmSam = "adm" + $SamAccountName

#Loads ActiveDirectory Module
$modulecheck = Get-Module ActiveDirectory
If(!$modulecheck){
	Import-Module ActiveDirectory
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
		}
	
	IF($admuser){
		$admuser | Disable-ADAccount
		$admuser | Set-ADUser -Description $Description
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
