$DscWorkingFolder = $PSScriptRoot

Configuration Import_Certificates {
    param
    (
	[Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [System.Management.Automation.PSCredential]
        $Wildcard_Credential,
		
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [System.Management.Automation.PSCredential]
        $ADFS_Credential
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
	Import-DscResource -ModuleName CertificateDsc
		
	Node localhost
	{
		$afds_username = $ADFS_Credential.username
		$adfs_password = $ADFS_Credential.GetNetworkCredential().password

        $IntegratedEnv = $Node.IntegratedEnv

        $WildcardCertLocn = $DscWorkingFolder + '\' + $Node.WildcardCertLocn
        $Wildcard_password = $Wildcard_Credential.GetNetworkCredential().password
		$certificateObject = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
		$certificateObject.Import($WildcardCertLocn, $Wildcard_password, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::DefaultKeySet)
		$WildcardThumbprint =  $certificateObject.Thumbprint

        $SSOCertLocn = $DscWorkingFolder + '\' + $Node.SSOCertLocn
        $SSO_password = $SSO_Credential.GetNetworkCredential().password
		$certificateObject = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
		$certificateObject.Import($SSOCertLocn, $SSO_password, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::DefaultKeySet)
		$SSOThumbprint =  $certificateObject.Thumbprint

		PfxImport ImportWildcard_Personal
        {
			Thumbprint	= $WildcardThumbprint
			Path		= $DscWorkingFolder + '\' + $Node.WildcardCertLocn
            Location	= 'LocalMachine'
            Store		= 'My'
			Credential	= $Wildcard_Credential
        }
		
		PfxImport ImportWildcard_Trusted-Root-Certification-Authorities
        {
			Thumbprint	= $WildcardThumbprint
			Path		= $DscWorkingFolder + '\' + $Node.WildcardCertLocn
            Location	= 'LocalMachine'
            Store		= 'Root'
			Credential	= $Wildcard_Credential
        }

        if ($IntegratedEnv -eq 1) {
			PfxImport ImportSSO_Personal
			{
				Thumbprint = $SSOThumbprint
				Path		= $DscWorkingFolder + '\' + $Node.SSOCertLocn
				Location   = 'LocalMachine'
				Store      = 'My'
				Credential = $SSO_Credential
			}
			
			PfxImport ImportSSO_Trusted-Root-Certification-Authorities
			{
				Thumbprint = $SSOThumbprint
				Path		= $DscWorkingFolder + '\' + $Node.SSOCertLocn
				Location   = 'LocalMachine'
				Store      = 'Root'
				Credential = $SSO_Credential
			}
			
			# Add permissions to SSO certificate for user
			Script SetPermissions_SSOCert
			{
				TestScript = { return $false }
				
				SetScript = {
					$keyName=(((Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Thumbprint -like $using:SSOThumbprint}).PrivateKey).CspKeyContainerInfo).UniqueKeyContainerName
					$keyPath = "C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys\"
					$fullPath=$keyPath+$keyName
					$acl=Get-Acl -Path $fullPath
					
					$permission=$using:afds_username,"FullControl","Allow"
					$accessRule=new-object System.Security.AccessControl.FileSystemAccessRule $permission
					$acl.AddAccessRule($accessRule)
					Set-Acl $fullPath $acl
					
					$permission="Network Service","FullControl","Allow"
					$accessRule=new-object System.Security.AccessControl.FileSystemAccessRule $permission
					$acl.AddAccessRule($accessRule)
					Set-Acl $fullPath $acl
					
					$permission="IIS_IUSRS","FullControl","Allow"
					$accessRule=new-object System.Security.AccessControl.FileSystemAccessRule $permission
					$acl.AddAccessRule($accessRule)
					Set-Acl $fullPath $acl
				}
				
				GetScript = { }
				DependsOn 				= '[PfxImport]ImportSSO_Personal'
			}
		}
	
	}
}

$Wildcard_Credential = Get-Credential -UserName "devops\devops" -Message "Enter password for Wildcard Certificate.  Username is not used, so anything goes"
$SSO_Credential = Get-Credential -UserName "devops\devops" -Message "Enter password for SSO Certificate. Username is not used, so anything goes"
$ADFS_Credential = Get-Credential -UserName $Node.ADFSUser -Message "Enter credentials for ADFS User"
Import_Certificates -Wildcard_Credential $Wildcard_Credential -ADFS_Credential $ADFS_Credential -ConfigurationData DSCData.psd1

Start-DscConfiguration Import_Certificates -Wait -Force -Verbose