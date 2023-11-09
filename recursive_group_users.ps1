$groups = get-content c02_admins.txt

ForEach ($group in $groups) {

$groupmem = get-adgroupmember -identity $group -recursive 

ForEach ($Member in $groupmem){

    $ADUser = $Member | Get-ADUser -Properties SamAccountName
    [PSCustomObject]@{
            User = $Member.Name
            UserID = $ADUser.SamAccountName
           
} | export-csv c02_admins.csv -append
}
}