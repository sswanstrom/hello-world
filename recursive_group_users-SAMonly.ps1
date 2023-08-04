$groups = get-content c02_groups.txt

ForEach ($group in $groups) {

$groupmem = get-adgroupmember -identity $group -recursive 

ForEach ($Member in $groupmem){

    Get-ADUser $Member | select SamAccountName | out-file admins.txt -append

           
}
}