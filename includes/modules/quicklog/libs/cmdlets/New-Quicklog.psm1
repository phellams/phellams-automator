using module ../lib.psm1
<#
.SYNOPSIS
Returns and instance of the Quicklog class.

.DESCRIPTION
Returns and instance of the Quicklog class, providing access to the Quicklog methods.

.PARAMETER Name
Name of the log file. (Optional)

.PARAMETER Unicode
Specifies char for the log name. (Optional)

.EXAMPLE
$qlm = New-Quicklog-Name "Log1" -unicode $null
$qlm.enablelogdate()
$qlm.enablelogicon()
$qlm.WriteMessage("This is an information message", "info", $false)
$qlm.WriteMessage("This is an information message", "info", $true) # submessage

This example writes an information message to the log file with the name "Log1".

.INPUTS
None.

.OUTPUTS
returns an instance of the Quicklog class. [object]

.NOTES
- 

.LINK
Quicklog (Module): https://github.com/sgkens/Quicklog/blob/main/libs/cmdlets/New-Quicklog.psm1
#>
Function New-Quicklog() {
  [alias("qln")]
  [CmdletBinding()]
  [OutPutType([object])]
  param()
  process{
    return (New-Object -TypeName quicklog)
  }
}

Export-ModuleMember -Function New-Quicklog -Alias qlni