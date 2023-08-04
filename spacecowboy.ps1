$servers = gc serverlist.txt
$date = get-date -format "dd MMM yyyy"
$time = get-date -format hhmm
$a = "<style>"
$a = $a + "BODY{background-color:white;}"
$a = $a + "TABLE{border-width: 2px;border-style: solid;border-color: black;border-collapse: separate;width:800px}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:lightblue}"
$a = $a + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:White}"
$a = $a + "</style>"
Foreach ($s in $servers)  
{  
  Get-WmiObject -Class win32_volume -cn $s | 
   Select-Object @{LABEL='Computer';EXPRESSION={$s}}, 
     driveletter, @{LABEL='GBfreespace';EXPRESSION={"{0:N2}" -f ($_.freespace/1GB)}},
       @{LABEL='Capacity';EXPRESSION={"{0:N2}" -f ($_.capacity/1GB)}}, 
        @{LABEL='Percentage';EXPRESSION={"{0:N2}" -f ($_.freespace/$_.capacity*100)+"%"}} | 
     ConvertTo-Html -head $a | Out-File -append "C:\Users\admsswanstrom\Desktop\diskspace\Freespace$date-$time.htm"
}
