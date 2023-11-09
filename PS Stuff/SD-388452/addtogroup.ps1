Import-CSV -path c:\users\da_cyber_8\Desktop\helpdeskaccounts-ikasystems.csv | foreach {
 
add-adgroupmember -identity "cn=EIOS Helpdesk,ou=helpdesk team,ou=admin,ou=activeusers,dc=services,dc=entcore,dc=com" -members $_.samaccountname

}

