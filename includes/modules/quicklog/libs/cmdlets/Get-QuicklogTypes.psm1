<#
.SYNOPSIS
Return List of logTypes. [object]

.DESCRIPTION
Return List of logTypes. [object]

.PARAMETER none

.EXAMPLE
Get-LogTypes

.INPUTS
None.

.OUTPUTS
Return List of logTypes. [object]

.NOTES
- 

.LINK
Quicklog (Module): https://github.com/sgkens/Quicklog/blob/main/libs/cmdlets/Get-QuicklogLogTypes.psm1
#>

Function Get-QuicklogTypes() { #//TODO change to Get-QuicklogBlocks
    [cmdletbinding()]
    [OutputType([array])]
    [Alias('qlgt')]
    Param()
    process{
        return $global:_quicklog.instance.GetLogTypes() | Format-table id,name,Description,logname,color,icon
    }

}

Export-ModuleMember -Function Get-QuicklogTypes -Alias qlgmi