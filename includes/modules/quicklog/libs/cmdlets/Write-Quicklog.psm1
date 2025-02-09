<#
.SYNOPSIS
Cmdlet function Write-Quicklog interface for Quicklog class.

.DESCRIPTION
Cmdlet function Write-Quicklog is an interface for the Quicklog psm1 lib. It allows you to custom log messages to the console and log file.

.PARAMETER Message
The log message to be written.

.PARAMETER Type
The type of the log message. Valid values are: 'error', 'success', 'info', 'complete', 'action'. Case-insensitive. (Optional)

.PARAMETER Name
The name to be associated with the log. (Optional) eg. [myname-icon-date]

.PARAMETER Unicode
Specifies char for the log name. (Optional) 

.PARAMETER SubMessage
Switch parameter to indicate if the message is a submessage. (Optional)

.PARAMETER NoDatTime
Switch parameter to indicate if the message should include the date and time. (Optional)

.PARAMETER NoLogIcon
Switch parameter to indicate if the message should include the log icon. (Optional)

.EXAMPLE
Write-Quicklog -Message "This is an information message" -Type "info" -Name "Log1"

This example writes an information message to the log file with the name "Log1".

.INPUTS
None.

.OUTPUTS
None. The function does not return any output. writes to console and log file. [Write-Host] is the method used to write to console.

.NOTES
- 

.LINK

#>
Function Write-Quicklog(){
    [alias("qlm")]
    [CmdletBinding()]
    [OutPutType([void])]
    param(
        [Alias('m')]
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Message,
        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateSet('Error', 'Success', 'Info', 'Complete', 'Action','response','request','upload','download','read','write', IgnoreCase = $true)]
        [alias('t')]
        [string]$Type = 'info',
        [Parameter(Mandatory = $false)]
        [alias('n')]
        [string]$Name,
        [Parameter(Mandatory = $false)]
        [alias('ic')]
        [string]$icon,
        [Parameter (ValueFromPipeline = $true, Mandatory = $false)]
        [alias('sm')]
        [switch]$SubMessage = $false,
        [Parameter (ValueFromPipeline = $true, Mandatory = $false)]
        [alias('ndt')]
        [switch]$NoDateTime = $false,
        [Parameter (ValueFromPipeline = $true, Mandatory = $false)]
        [alias('nli')]
        [switch]$NoLogIcon = $false,
        [Parameter (ValueFromPipeline = $true, Mandatory = $false)]
        [alias('et')]
        [switch]$NoExectime,
        [Parameter (ValueFromPipeline = $true, Mandatory = $false)]
        [alias('noe')]
        [switch]$NoEmoji
    )
    process{
        # Fetch the logtastic instance
        $qlmi = $global:_quicklog.instance
        if ($NoEmoji){
            $qlmi.Noemoji = $true
        }else{ $qlmi.Noemoji = $false }

        # Enable or disable exectime
        if ($NoExectime) { $qlmi.DisableExectime() }
        else { $qlmi.EnableExectime() }

        # Set the log name
        if($null -eq $name -or $name.length -eq 0 ) { $name = "Ql" }
        $qlmi.name = $name # Default lt
        
        # Set the unicode char
        if($null -ne $icon -and $icon.length -gt 0 ) { $qlmi.icon = $icon }
        else{ $qlmi.icon = "default-icon" }

        # Set the log type
        if($NoDateTime -eq $true){ $qlmi.disablelogdate() }
        else { $qlmi.enablelogdate() }

        # Set the log type
        if($NoLogIcon -eq $true){ $qlmi.disablelogicon() }
        else{ $qlmi.enablelogicon() }

        # Write the message
        $qlmi.GenerateLog($message, $type, $submessage)
        $qlmi.WriteLog()
    }
}
Export-ModuleMember -Function Write-Quicklog -Alias qlm