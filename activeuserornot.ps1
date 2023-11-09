$users = get-content userlist2.txt

foreach($user in $users) {

get-aduser -identity $user | select Name,SamAccountName,Enabled | out-file activeornot.txt -append

}