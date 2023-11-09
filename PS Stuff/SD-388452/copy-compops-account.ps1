####################################################################################################
#
# NAME:		copy-compops-account.ps1
#
# AUTHOR:	Steven Swanstrom (steven.swanstrom@advantasure.com)
#
# COMMENT:	Creates a CompOps elevated user account in all SunGard Domains and `
#		copies properties from an existing "reference" account
#
# USAGE/SYNTAX:	copy-compops-account.ps1 FirstName Lastname samAccountName Password SDTicket
#		NOTE: samAccountName must be the same as that of user's IKASYSTEMS account
#
# EXAMPLE: 	copy-compops-account.ps1 Robert Johnson RJohnson2 Pas$W0rd!!12 SD-123456
# 
# OUTPUT:	A new ADM account in each SunGard domain that is a copy of the "reference" account
#
#
# VERSION HISTORY:
# 1.0	 Mar 2021	Initial version
# 
#
####################################################################################################
 
Param(
	[Parameter(Position=0, Mandatory=$true)][string]$FirstName,
	[Parameter(Position=1, Mandatory=$true)][string]$LastName,
	[Parameter(Position=2, Mandatory=$true)][string]$samAccountName,
	[Parameter(Position=3, Mandatory=$true)][string]$Password, 
	[Parameter(Position=4, Mandatory=$true)][string]$Ticket
)

$Domains = @("IKASTG.com", "IPERF194.
$GivenName = $FirstName 
$Surname = $LastName
$FullName = $GivenName + " " + $Surname
$Date = Get-Date -Format "dd MMM yyyy"
$Description = $Ticket + " - Created " + $Date
$NewUserProperties = get-aduser -identity admbcline -server $Domain -properties Department,Company,MemberOf

Foreach $Domain in $Domains {

Write-Host $Domain

   New-Aduser -name "ADM " + $FullName -enabled $true –GivenName $FirstName –Surname $LastName ` 
    -accountpassword (convertto-securestring $Password -asplaintext -force) -changepasswordatlogon $false `
    -samaccountname $admAccountName  -description $Description `
    -displayname ('ADM ' + $FirstName + ' ' + $LastName) -userprincipalname ($samAccountName + "@" + $Domain)

$user = get-aduser -identity $samAccountName
   move-adobject -identity $user.distinguishedname -targetpath "OU=Admin,DC=services,DC=entcore,dc=com"
}
