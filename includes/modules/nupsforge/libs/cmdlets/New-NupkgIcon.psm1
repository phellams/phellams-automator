<#
.SYNOPSIS

    A function that copies the default icon file for nuget and choco packages.

.DESCRIPTION

    A function that copies the default icon file for nuget and choco packages.

.PARAMETER type

    The type of package to copy the icon for.

.PARAMETER outpath

    The path to the icon file.

.EXAMPLE

    New-nupkgicon -type "nuget" -outpath "C:\MyPackage\icon.png"

    This will copy the default icon file for nuget packages to the path "C:\MyPackage\icon.png".
#>

function  New-nupkgicon {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [validateSet('choco','nuget')]
        [string]$type,
        [Parameter(Mandatory = $true)]
        [string]$outpath
    )
    process{
        Write-QuickLog -Message "Copying default @{pt:{type=$type}} icon file" -Name $global:LOGTASTIC_MOD_NAME -Type "info"
        [string]$defaulticon = $null
        switch($type){
            'choco' {$defaulticon = $global:_nupsforge.rootpath + "\libs\resources\icons\dist\png\icon-choco.png"}
            'nuget' {$defaulticon = $global:_nupsforge.rootpath + "\libs\resources\icons\dist\png\icon-nuget.png"}
        }
        try{
            Write-QuickLog -Message "Copying @{pt:{icon=$defaulticon}} to @{pt:{path=$outpath}}" -Name $global:LOGTASTIC_MOD_NAME -Type "action"
            Copy-Item -Path $defaulticon -Destination "$outpath\icon.png" -Force
            Write-QuickLog -Message "Copied" -Name $global:LOGTASTIC_MOD_NAME -Type "success"
        } catch [system.exception] {
            Write-QuickLog -Message "Failed to copy icon file" -Name $global:LOGTASTIC_MOD_NAME -Type "error"
        }
    }

}

$cmdlet_config = @{
    function = @('New-NupkgIcon')
    alias    = @()
}

Export-ModuleMember @cmdlet_config