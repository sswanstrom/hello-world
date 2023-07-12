$Users = Get-Content listofusers.txt

ForEach ($User in $Users) {

Get-ADUser -identity $User -server domainname.com | select Name,SamAccountName,Enabled | out-file filename.txt
}