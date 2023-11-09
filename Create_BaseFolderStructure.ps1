$DscWorkingFolder = $PSScriptRoot

Configuration Create_BaseFolderStructure {
	Import-DscResource -ModuleName PsDesiredStateConfiguration
    Import-DscResource -ModuleName xSmbShare
    Import-DscResource -ModuleName cNtfsAccessControl

	Node localhost {
		if ($Node.MultiTenant -eq "true") {
			$EnrollmentFilesBasePath = $Node.FileServerDrive + '\EnrollmentFiles\' + $Node.Client
		} else {
			$EnrollmentFilesBasePath = $Node.FileServerDrive + '\EnrollmentFiles'
		}
		
		switch ($Node.EnvType) {
			"DEV" {$DeploySvcUser = "DEPLOY_DEV_ADM"; break}
			"QA" {$DeploySvcUser = "DEPLOY_QA_ADM"; break}
			"TEST" {$DeploySvcUser = "DEPLOY_TST_ADM"; break}
	        "TESTC" {$DeploySvcUser = "DEPLOY_TST_ADM"; break}
	        "TESTG" {$DeploySvcUser = "DEPLOY_TST_ADM"; break}
	        "TESTH" {$DeploySvcUser = "DEPLOY_TST_ADM"; break}
			"STAGE" {$DeploySvcUser = "DEPLOY_STG_ADM"; break}
			"PROD" {$DeploySvcUser = "DEPLOY_PRD_ADM"; break}
			default {"Not Supported"; break}
		}
		
		File CoreApps {
			Type = 'Directory'
			DestinationPath = $Node.FileServerDrive + '\CoreApps\' + $Node.Client + '\' + $Node.Envtype
			Ensure = "Present"
		}
		
		File Utilities {
			Type = 'Directory'
			DestinationPath = $Node.FileServerDrive + '\CoreApps\' + $Node.Client + '\' + $Node.Envtype + '\Utilities'
			Ensure = "Present"
		}
		
		File default.htm {
			Type = 'File'
			Force = $true
			SourcePath = "$DscWorkingFolder\SupportingFiles\templates\default.htm"
			DestinationPath = $Node.FileServerDrive + '\CoreApps\' + $Node.Client + '\' + $Node.Envtype + '\default.htm'
			Ensure = "Present"
		}
		
		File AppsBackup {
			Type = 'Directory'
			DestinationPath = $Node.FileServerDrive + '\AppsBackup'
			Ensure = "Present"
		}
		
		File EnrollmentFiles {
			Type = 'Directory'
			Recurse = $true
			Force = $true
			SourcePath = "$DscWorkingFolder\SupportingFiles\DirectoryStructure\EnrollmentFiles"
			DestinationPath = $EnrollmentFilesBasePath
			Ensure = "Present"
		}
		
		File ClaimsUserDocuments {
			Type = 'Directory'
			Recurse = $true
			Force = $true
			SourcePath = "$DscWorkingFolder\SupportingFiles\DirectoryStructure\ClaimsUserDocuments"
			DestinationPath = $Node.FileServerDrive + '\CoreApps\' + $Node.Client + '\' + $Node.Envtype + '\ClaimsUserDocuments'
			Ensure = "Present"
		}
		
		File ControlMJobs {
			Type = 'Directory'
			Recurse = $true
			Force = $true
			SourcePath = "$DscWorkingFolder\SupportingFiles\DirectoryStructure\ControlMJobs"
			DestinationPath = $Node.FileServerDrive + '\ControlMJobs'
			Ensure = "Present"
		}
		
		File CoreJobs {
			Type = 'Directory'
			DestinationPath = $Node.FileServerDrive + '\CoreJobs'
			Ensure = "Present"
		}

		xSmbShare CoreAppsShare {
            Name    = "CoreApps"
            Path    = $Node.FileServerDrive + '\CoreApps'
            Ensure  = "Present"
			FullAccess = @($Node.LDAPUser, $DeploySvcUser)
            DependsOn = "[File]CoreApps"
        }
		
		xSmbShare EnrollmentFilesShare {
            Name    = "EnrollmentFiles"
            Path    = $Node.FileServerDrive + '\EnrollmentFiles'
            Ensure  = "Present"
			FullAccess = @($Node.LDAPUser, $Node.SQLShrdUser)
            DependsOn = "[File]EnrollmentFiles"
        }

        cNtfsPermissionEntry CoreAppsPermissionSet1
        {
            Ensure = 'Present'
            Path = 'F:\CoreApps'
            Principal = $Node.LDAPUser
            AccessControlInformation = @(
                cNtfsAccessControlInformation
                {
                    AccessControlType = 'Allow'
                    FileSystemRights = 'ReadAndExecute'
                    Inheritance = 'ThisFolderSubfoldersAndFiles'
                    NoPropagateInherit = $false
                }
            )
            DependsOn = @('[xSmbShare]EnrollmentFilesShare')
        }

        cNtfsPermissionEntry CoreAppsPermissionSet2
        {
            Ensure = 'Present'
            Path = 'F:\CoreApps'
            Principal = $DeploySvcUser
            AccessControlInformation = @(
                cNtfsAccessControlInformation
                {
                    AccessControlType = 'Allow'
                    FileSystemRights = 'ReadAndExecute'
                    Inheritance = 'ThisFolderSubfoldersAndFiles'
                    NoPropagateInherit = $false
                }
            )
            DependsOn = @('[xSmbShare]EnrollmentFilesShare')
        }

        cNtfsPermissionEntry EnrollmentFilesPermissionSet1
        {
            Ensure = 'Present'
            Path = 'F:\EnrollmentFiles'
            Principal = $Node.LDAPUser
            AccessControlInformation = @(
                cNtfsAccessControlInformation
                {
                    AccessControlType = 'Allow'
                    FileSystemRights = 'ReadAndExecute'
                    Inheritance = 'ThisFolderSubfoldersAndFiles'
                    NoPropagateInherit = $false
                }
            )
            DependsOn = @('[xSmbShare]EnrollmentFilesShare')
        }

        cNtfsPermissionEntry EnrollmentFilesPermissionSet2
        {
            Ensure = 'Present'
            Path = 'F:\EnrollmentFiles'
            Principal = $Node.SQLShrdUser
            AccessControlInformation = @(
                cNtfsAccessControlInformation
                {
                    AccessControlType = 'Allow'
                    FileSystemRights = 'ReadAndExecute'
                    Inheritance = 'ThisFolderSubfoldersAndFiles'
                    NoPropagateInherit = $false
                }
            )
            DependsOn = @('[xSmbShare]EnrollmentFilesShare')
        }
	}
}

Create_BaseFolderStructure -ConfigurationData DSCData.psd1

Start-DscConfiguration Create_BaseFolderStructure -Wait -Force -Verbose
