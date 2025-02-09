<#
.SYNOPSIS
Returns the instance of the Quicklog class.

.DESCRIPTION
Returns the instance of the Quicklog class, providing access to the LogTastic methods.

.EXAMPLE
$Quicklog = Get-QuicklogModuleInstance
(Get-QuicklogModuleInstance).WriteLog("This is a test message", "info", $false)

This example returns an instance of the Quicklog class.

.INPUTS
None.

.OUTPUTS
none.

.NOTES
- 

.LINK
Quicklog (Module): https://github.com/sgkens/Quicklog/blob/main/libs/cmdlets/Get-QuicklogModuleInstance.psm1
#>
Function Get-QuicklogModuleInstance() {
  [alias("qlmi")]
  [CmdletBinding()]
  [OutPutType([object])]
  param()
  process {
    return $quicklog_instance
  }
}

Export-ModuleMember -Function Get-QuicklogModuleInstance -Alias qlmi
