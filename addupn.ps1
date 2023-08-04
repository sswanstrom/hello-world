Import-CSV -path c:\users\da_cyber_8\Desktop\testaccounts.csv 

$eiosusers = get-aduser -filter {userprincipalname -like ' '} -searchbase 'cn=EIOS Helpdesk,ou=helpdesk team,ou=admin,ou=activeusers,dc=services,dc=entcore,dc=com -properties userprincipalname 

$eiosusers | foreach {

-userprincipalname ($_.samaccountname + "@services.entcore.com")

}

