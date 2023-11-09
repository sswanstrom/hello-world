Install-Module -Name DSCR_Font -Force

$DscWorkingFolder = $PSScriptRoot

Configuration Install_OCRFont
{
    Import-DscResource -ModuleName DSCR_Font
    cFont Add_OCRFont
    {
        Ensure			= "Present"
        FontFile		= "$DscWorkingFolder\SupportingFiles\Tools\Font\OCRAEXT.TTF"
    }
}

Install_OCRFont

Start-DscConfiguration Install_OCRFont -Wait -Force -Verbose