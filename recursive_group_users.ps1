$groups = get-content WSR01_Groups.txt

ForEach ($group in $groups) {

$groupmem = get-adgroupmember -identity $group -recursive 

ForEach ($Member in $groupmem){

    $ADUser = $Member | Get-ADUser -Properties SamAccountName
    [PSCustomObject]@{
	    Group = $group
            User = $Member.Name
            UserID = $ADUser.SamAccountName
           
} | export-csv WSR01_Admins.csv -append
}
}