Install-Module AzureAD

Connect-AzureAD

Get-AzureADUser -Filter "userPrincipalName eq 'srehman@ikasystems.onmicrosoft.com'" | Format-Table DisplayName, UserPrincipalName, AccountEnabled -AutoSize

Get-AzureADUser -Filter "userPrincipalName eq 'srehman@ikasystems.onmicrosoft.com'" | Get-AzureADUserMembership | Format-Table DisplayName, ObjectType -AutoSize
Get-AzureADUser -Filter "userPrincipalName eq 'srehman@ikasystems.onmicrosoft.com'" | Set-AzureADUser -AccountEnabled $false
$MemberId = Get-AzureADUser -Filter "userPrincipalName eq 'srehman@ikasystems.onmicrosoft.com'"
$MemberId | Get-AzureADUserMembership | ForEach-Object {$_.ObjectId | Remove-AzureADGroupMember -MemberId $MemberId.ObjectId}
Remove-Variable MemberId
Get-AzureADUser -Filter "userPrincipalName eq 'srehman@ikasystems.onmicrosoft.com'" | Format-Table DisplayName, UserPrincipalName, AccountEnabled -AutoSize

------------------------------

Get-AzureADUser -Filter "userPrincipalName eq 'srehman@ikasystems.onmicrosoft.com'" | Format-Table DisplayName, UserPrincipalName, AccountEnabled -AutoSize

Get-ADComputer -Filter 'Name -like "srehman*"' -server IKASYSTEMS.com -Properties OperatingSystem, Description | Format-Table Name, DNSHostName, OperatingSystem, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKASYSTEMS.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKASERVICES.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD55.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD60.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD65.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD76.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD87.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD90.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD98.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD110.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD120.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD130.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IPERF194.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIM.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIMS40.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIMS45.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIM50.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKASTG.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server ENTCORE.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server SERVICES.ENTCORE.COM -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IKASYSTEMS.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IKASERVICES.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IKAPROD55.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IKAPROD60.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IKAPROD65.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IKAPROD76.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IKAPROD87.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IKAPROD90.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IKAPROD98.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IKAPROD110.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IKAPROD120.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IKAPROD130.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IPERF194.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IKACLAIM.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IKACLAIMS40.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IKACLAIMS45.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IKACLAIM50.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server IKASTG.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server ENTCORE.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server SERVICES.ENTCORE.COM -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server VISIANTCLOUD.COM -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server VISIANTCLOUD.COM -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server ENTCORECLOUD.COM -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server ENTCORECLOUD.COM -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

------------------------------

Get-ADComputer -Filter 'Name -like "srehman*"' -server IKASYSTEMS.com | Disable-ADAccount
Get-ADComputer -Filter 'Name -like "srehman*"' -server IKASYSTEMS.com | Set-ADComputer -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADComputer -Filter 'Name -like "srehman*"' -server IKASYSTEMS.com -Properties OperatingSystem, Description | Format-Table Name, DNSHostName, OperatingSystem, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKASYSTEMS.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKASYSTEMS.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IKASYSTEMS.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKASYSTEMS.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKASYSTEMS.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKASERVICES.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKASERVICES.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IKASERVICES.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKASERVICES.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKASERVICES.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD55.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD55.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IKAPROD55.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD55.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD55.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD60.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD60.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IKAPROD60.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD60.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD60.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD65.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD65.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IKAPROD65.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD65.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD65.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD76.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD76.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IKAPROD76.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD76.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD76.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD87.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD87.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IKAPROD87.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD87.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD87.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD90.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD90.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IKAPROD90.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD90.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD90.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD98.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD98.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IKAPROD98.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD98.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD98.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD110.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD110.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IKAPROD110.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD110.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD110.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD120.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD120.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IKAPROD120.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD120.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD120.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD130.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD130.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IKAPROD130.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD130.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKAPROD130.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IPERF194.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IPERF194.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IPERF194.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IPERF194.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IPERF194.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIM.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIM.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IKACLAIM.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIM.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIM.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIMS40.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIMS40.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IKACLAIMS40.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIMS40.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIMS40.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIMS45.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIMS45.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IKACLAIMS45.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIMS45.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIMS45.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIM50.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIM50.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IKACLAIM50.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIM50.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKACLAIM50.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKASTG.com | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKASTG.com -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server IKASTG.com -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKASTG.com | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server IKASTG.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server ENTCORE.COM | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server ENTCORE.COM -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server ENTCORE.COM -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server ENTCORE.COM | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server ENTCORE.com -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server SERVICES.ENTCORE.COM | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server SERVICES.ENTCORE.COM -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server SERVICES.ENTCORE.COM -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server SERVICES.ENTCORE.COM | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server SERVICES.ENTCORE.COM -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

------------------------------

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server VISIANTCLOUD.COM | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server VISIANTCLOUD.COM -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server VISIANTCLOUD.COM -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server VISIANTCLOUD.COM | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server VISIANTCLOUD.COM -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server VISIANTCLOUD.COM | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server VISIANTCLOUD.COM -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server VISIANTCLOUD.COM -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server VISIANTCLOUD.COM | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server VISIANTCLOUD.COM -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "srehman"' -server ENTCORECLOUD.COM | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server ENTCORECLOUD.COM -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server ENTCORECLOUD.COM -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server ENTCORECLOUD.COM | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "srehman"' -server ENTCORECLOUD.COM -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize

Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server ENTCORECLOUD.COM | Disable-ADAccount
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server ENTCORECLOUD.COM -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -server ENTCORECLOUD.COM -Confirm:$false}
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server ENTCORECLOUD.COM | Set-ADUser -Description "HRO-8946 - Disabled 07/25/2019"
Get-ADUser -Filter 'SamAccountName -like "admsrehman"' -server ENTCORECLOUD.COM -Properties Description | Format-Table Name, UserPrincipalName, Description, Enabled -AutoSize



