$users = get-content SD-278831.txt

foreach ($User in $users)
	{
	get-aduser -server ikasystems.com -identity $user -properties lastlogondate | select Name,SAMaccountname,lastlogondate | out-file lastlog.txt -append
	}
