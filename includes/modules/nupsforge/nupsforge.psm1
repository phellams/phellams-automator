<#
* Root module for NuPSForge
#>
using module libs\cmdlets\New-NuspecPackageFile.psm1
using module libs\cmdlets\New-ChocoNuspecFile.psm1
using module libs\cmdlets\New-ChocoPackage.psm1
using module libs\cmdlets\New-NupkgPackage.psm1

$global:LOGTASTIC_MOD_NAME = 'forge'
$global:_nupsforge = @{
    rootpath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
}
<#
* Exported Functions Object -> array 
#>
$ExportedFunctions = @{
    function = @(
        'New-NuspecPackageFile',
        'New-NupkgPackage',
        'New-ChocoPackage',
        'New-ChocoNuspecFile'
    )
}
<#
* Exported Functions
#>
Export-ModuleMember @ExportedFunctions