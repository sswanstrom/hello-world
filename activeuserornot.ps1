$users = get-content SD-458752.txt

foreach($user in $users) {

get-aduser -identity $user | select Name,SamAccountName,Enabled 

}