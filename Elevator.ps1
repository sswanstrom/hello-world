# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)

# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
   {
   # We are running "as Administrator" - so change the title and background color to indicate this
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   $Host.UI.RawUI.BackgroundColor = "DarkBlue"
   clear-host
   }
else
   {
   # We are not running "as Administrator" - so relaunch as administrator
   
   # Create a new process object that starts PowerShell
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   
   # Specify the current script path and name as a parameter
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   
   # Indicate that the process should be elevated
   $newProcess.Verb = "runas";
   
   # Start the new process
   [System.Diagnostics.Process]::Start($newProcess);
   
   # Exit from the current, unelevated, process
   exit
   }

# Run your code that needs to be elevated here
Write-Host -NoNewLine "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

$thisComputer = $env:COMPUTERNAME
$smtpServer = "smtp.ikasystems.com"
$smtpFrom = "PRousey@ikasystems.com"
$smtpTo = "prousey@ikasystems.com";
$messageSubject = $thisComputer + " Update/Reboot Report"
$Message = New-Object System.Net.Mail.mailmessage $smtpFrom, $smtpTo
$Message.Subject = $messageSubject

#Define update criteria.

$Criteria = "IsInstalled=0 and Type='Software'"

#Search for relevant updates.

$Searcher = New-Object -ComObject Microsoft.Update.Searcher

$SearchResult = $Searcher.Search($Criteria).Updates

#Download updates.

$Session = New-Object -ComObject Microsoft.Update.Session

$Downloader = $Session.CreateUpdateDownloader()

$Downloader.Updates = $SearchResult

$Downloader.Download()


#Install updates.

$Installer = New-Object -ComObject Microsoft.Update.Installer

$Installer.Updates = $SearchResult

$Result = $Installer.Install()

#Reboot if required by updates.

If ($Result.rebootRequired) 
	{ 
		$timeStamp = get-date -Format hh:mm
		$todaysDate = get-date -format D
		$RebootResult = "The server: " + $thisComputer + " has installed its updates and requires a reboot. It began rebooting at:" + $timeStamp + " on " + $todaysDate
		$Message.Body = $RebootResult
		$smtp = new-Object Net.Mail.SmtpClient($smtpServer)
		$smtp.Send($message)
		shutdown.exe /t 0 /r 
	}
If (!$Result.rebootRequired)
	{
		$timeStamp = get-date -Format hh:mm
		$todaysDate = get-date -format D
		$RebootResult = "The server: " + $thisComputer + " has installed its updates and did not require a reboot. It finished installing its updates at:" + $timeStamp + " on " + $todaysDate
		$smtp = new-Object Net.Mail.SmtpClient($smtpServer)
		$smtp.Send($message)
     }