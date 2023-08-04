Import-CSV svcaccounts.csv | foreach {
 
$AccName = $_.SAMaccountName
$Domain = $_.Domain

get-aduser -server $Domain -identity $AccName -properties * | select SAMaccountName,Enabled,EmailAddress,LastLogonDate | out-file .\svcaccounts.txt -append

}