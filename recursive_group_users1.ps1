$groups = get-content AllGroups.txt

ForEach ($group in $groups) {

$groupmem = get-adgroupmember -identity $group -recursive 

ForEach ($Member in $groupmem){

    $ADUser = $Member | Get-ADUser -Properties SamAccountName
    [PSCustomObject]@{
	    Group = $group
            User = $Member.Name
            UserID = $ADUser.SamAccountName
           
} | export-csv AdminUsers.csv -append
}
}