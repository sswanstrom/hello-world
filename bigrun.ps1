Import-CSV bigrunin.csv | foreach {
 
$AccName = $_.SAMaccountName
$Domain = $_.Domain

get-aduser -server $Domain -identity $AccName -properties * | select LastLogonDate | export-csv bigrunout3.csv -append

}