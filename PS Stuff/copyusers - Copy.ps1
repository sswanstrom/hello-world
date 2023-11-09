

$templateUser = Get-ADUser ctemplate -Properties *
$newUser = Get-ADUser 'Adam Bertram' -Properties *

foreach ($property in $newUser.PSObject.Properties) {
    $matchingTemplateUserProperty = $templateUser.PSObject.Properties | Where-Object { $_.Name -eq $property.Name }
    if ($matchingTemplateUserProperty.Value -ne $property.Value) {
        Write-Host "The [$($property.Name) attribute is different]"
    }
} 



get-aduser -server ikastg.com admrmai -properties *


I know this is an old thread, but I needed help today and Internet search came with this answer.

Anyways, the "Copy AD User" functionality is built into New-ADUser cmdlet with "-Instance <ADUser>" parameter.

Here is copy/paste from New-ADUser cmdlet help.

    -Instance <ADUser>
        Specifies an instance of a user object to use as a template for a new user object.
        
        You can use an instance of an existing user object as a template or you can construct a new user object for template use.  You can construct a new user object using the Windows PowerShell command line or by using a script. The following examples show how to use these two methods to create user object templates.
        
        Method 1: Use an existing user object as a template for a new object. To retrieve an instance of an existing user object, use a cmdlet such as Get-ADUser. Then provide this object to the Instance parameter of the New-ADUser cmdlet to create a new user object. You can override property values of the new object by setting the appropriate parameters. 
        
          $userInstance = Get-ADUser -Identity "saraDavis" 
          New-ADUser -SAMAccountName "ellenAdams"  -Instance $userInstance -DisplayName "EllenAdams"
        
        Method 2: Create a new ADUser object and set the property values by using the Windows PowerShell command line interface. Then pass this object to the Instance parameter of the New-ADUser cmdlet to create the new Active Directory user object. 
        
          $userInstance = new-object Microsoft.ActiveDirectory.Management.ADUser
          $userInstance.DisplayName = "Ellen Adams"
          New-ADUser -SAMAccountName "ellenAdams"  -Instance $userInstance
        
        Note: Specified attributes are not validated, so attempting to set attributes that do not exist or cannot be set will raise an error.