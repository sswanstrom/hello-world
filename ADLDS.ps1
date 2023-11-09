$DscWorkingFolder = $PSScriptRoot

Configuration adlds {
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [System.Management.Automation.PSCredential]
        $ADFS_Credential
    )
	
	Import-DscResource -ModuleName PSDesiredStateConfiguration
		
	Node localhost
	{
		$adfs_username = $ADFS_Credential.username
		$adfs_password = $ADFS_Credential.GetNetworkCredential().password
		
		# Enable Windows features and roles
		$winFeatures = @("ADLDS","RSAT-ADLDS","RSAT-AD-PowerShell")
		ForEach ($Feature in $winFeatures) {
			WindowsFeature $Feature {
				Name                 = $Feature
				Ensure               = 'Present'
			}
		}
		
		Script Configure_ADAM_InstallAnswerFile
		{
			TestScript = { return $false }
			
			SetScript = {
				Import-Module "$using:DscWorkingFolder\SupportingFiles\PowerShellModules\EPS\0.5.0\EPS.psm1"
				$epsHash = @{
					adamName = $using:Node.adamName;
					adamDesc = $using:Node.adamDesc;
					adamPort = $using:Node.adamPort;
					adamSSLPort = $using:Node.adamSSLPort;
					adamPartition = $using:Node.adamPartition;
					adamPath = Join-Path "C:\Program Files\Microsoft ADAM\" -ChildPath $using:Node.adamName;
					adamPathLogs = Join-Path "C:\Program Files\Microsoft ADAM\" -ChildPath $using:Node.adamName;
					svcacc_username = $using:adfs_username;
					svcacc_password = $using:adfs_password;
				}
				Invoke-EpsTemplate -Path "$using:DscWorkingFolder\SupportingFiles\templates\ADAM.txt.template" -Binding $epsHash > "$using:DscWorkingFolder\ADAM.txt"

				# Install using data from input file
				#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
				#Start-Process -FilePath "C:\Windows\ADAM\adaminstall.exe" -ArgumentList "/answer:$using:DscWorkingFolder\ADAM.txt" -Wait -NoNewWindow;
			}
			
			GetScript = { }
		}
		
		Script Configure_ADAMSTR_LDF
		{
			TestScript = { return $false }
			
			SetScript = {
				Import-Module "$using:DscWorkingFolder\SupportingFiles\PowerShellModules\EPS\0.5.0\EPS.psm1"
				$epsHash = @{
					adamPartition = $using:Node.adamPartition;
				}
				Invoke-EpsTemplate -Path "$using:DscWorkingFolder\SupportingFiles\templates\ADAMSTR.ldf.template" -Binding $epsHash > "$using:DscWorkingFolder\ADAMSTR.ldf"
			}
			
			GetScript = { }
		}
		
		Script Configure_AddMembersToRoles_LDF
		{
			TestScript = { return $false }
			
			SetScript = {
                $adamAdminUser = $using:Node.adamAdminUser;
				$adamAdminUserSID = (Get-ADUser -Identity "$adamAdminUser").sid.value
				$adamAdminUserSIDEncoding  = [System.Text.Encoding]::UTF8.GetBytes("<SID=$adamAdminUserSID>")
				$adamAdminUserSIDBitEncoding = [System.Convert]::ToBase64String($adamAdminUserSIDEncoding)
				
				$DomainAdminsGroupSID = (Get-ADGroup -Identity 'Domain Admins').sid.value
				$DomainAdminsGroupSIDEncoding  = [System.Text.Encoding]::UTF8.GetBytes("<SID=$DomainAdminsGroupSID>")
				$DomainAdminsGroupSIDBitEncoding = [System.Convert]::ToBase64String($DomainAdminsGroupSIDEncoding)

				Import-Module "$using:DscWorkingFolder\SupportingFiles\PowerShellModules\EPS\0.5.0\EPS.psm1"
				$epsHash = @{
					adamPartition = $using:Node.adamPartition;
					adamAdminUserSID = $adamAdminUserSID
					adamAdminUserSIDBitEncoding = $adamAdminUserSIDBitEncoding;
					DomainAdminsGroupSIDBitEncoding = $DomainAdminsGroupSIDBitEncoding;
				}
				Invoke-EpsTemplate -Path "$using:DscWorkingFolder\SupportingFiles\templates\AddMembersToRoles.ldf.template" -Binding $epsHash > "$using:DscWorkingFolder\AddMembersToRoles.ldf"
			}
			
			GetScript = { }
		}
		
		Script Configure_ADAM_InstallScript
		{
			TestScript = { return $false }
			
			SetScript = {
				Import-Module "$using:DscWorkingFolder\SupportingFiles\PowerShellModules\EPS\0.5.0\EPS.psm1"
				$epsHash = @{
					Sandbox = $using:Node.Sandbox;
					adamPort = $using:Node.adamPort;
				}
				Invoke-EpsTemplate -Path "$using:DscWorkingFolder\SupportingFiles\templates\ADAM_InstallConfigure.ps1.template" -Binding $epsHash > "$using:DscWorkingFolder\ADAM_InstallConfigure.ps1"
			}
			
			GetScript = { }
		}
	}
}

$ADFS_Credential = Get-Credential -UserName $Node.ADFSUser -Message "Enter credentials for ADFS User"
ADLDS -ADFS_Credential $ADFS_Credential -ConfigurationData EnvData.psd1