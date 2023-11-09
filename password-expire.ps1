param ([string]$accname)

Get-ADUser -filter 'SAMAccountName -like $accname' -server entcorecloud.com -Properties msDS-UserPasswordExpiryTimeComputed, PasswordLastSet, CannotChangePassword | format-table Name, @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}, PasswordLastSet -autosize
