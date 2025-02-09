<#
.SYNOPSIS
Cmdlet Write-QuickLogProgress writes a progress bar to the console.

.DESCRIPTION
Cmdlet Write-QuickLogProgress writes a progress bar to the console.

.PARAMETER Barcount [int]
The Length(number of characters) of the progress bar

.PARAMETER Percent [int]
The percentage of the progress bar

.PARAMETER Total [string]
The total Extra information of the progress bar

.PARAMETER Name [string]
The name of the progress bar

.PARAMETER Status [string]
The status of the progress bar

.PARAMETER Submessage [switch]
Sets the output as a submessage

.PARAMETER Bandwidth [string]
The bandwidth of the progress bar

.PARAMETER Transferred [string]
The transferred of the progress bar

.PARAMETER Eta [string]
The eta of the progress bar

.PARAMETER NoDateTime [switch]
Disables the date in the progress bar

.PARAMETER NoLogIcon [switch]
Disables the log icon in the progress bar

.EXAMPLE
Write-QuicklogProgress -Barcount 50 -Percent 50 -Total "50%" -Name "Log1" -Status "Running" -Submessage -Bandwidth "50%" -Transferred "50%" -Eta "00:00:00"

.EXAMPLE
Write-QuicklogProgress -Barcount 50 -Percent 50 -Total "50%" -Name "Log1" -Status "Running" -Submessage -Bandwidth "50%" -Transferred "50%" -Eta "00:00:00" -NoDateTime

.EXAMPLE
Write-QuicklogProgress -Barcount 50 -Percent 50 -Total "50%" -Name "Log1" -Status "Running" -Submessage -Bandwidth "50%" -Transferred "50%" -Eta "00:00:00" -NoLogIcon

.NOTES
- 

.LINK
Quicklog (Module): https://github.com/sgkens/Quicklog/blob/main/libs/cmdlets/Write-QuicklogProgress.psm1
#>
Function Write-QuicklogProgress() {
    [CmdletBinding()]
    [OutPutType([void])]
    [Alias("qlwp")]
    param(
      [Parameter(Mandatory = $true, Position = 0)]
      [int]$Barcount,
      [Parameter(Mandatory = $true, Position = 1)]
      [int]$Percent,
      [Parameter(Mandatory = $true)]
      [string]$Total,
      [Parameter(Mandatory = $false)]
      [string]$Name,
      [Parameter(Mandatory = $false)]
      [string]$Status,
      [Parameter(Mandatory = $false)]
      [switch]$Submessage,
      [Parameter(Mandatory = $false)]
      [String]$Bandwidth,
      [Parameter(Mandatory = $false)]
      [string]$Transferred,
      [Parameter(Mandatory = $false)]
      [string]$Eta,
      [Parameter(Mandatory = $false)]
      [switch]$NoDateTime,
      [Parameter(Mandatory = $false)]
      [switch]$NoLogIcon

    )
    process{
        # Fetch the logtastic instance
        $qlmi = $global:_quicklog.instance

        # disable exectime
        $qlmi.DisableExectime()

        if($submessage){$submessage = $true} else {$submessage = $false}

        # Set the log name
        if($null -eq $name -or $name.length -eq 0 ) { $name = "logt" }
        $qlmi.name = $name # Default lt
        
        # Set the unicode char
        if($icon -eq $true) { $qlmi.unicode = $icon }
        else{ $qlmi.icon = "default-icon" }

        # Set the log type
        if($NoDateTime -eq $true){ $qlmi.disablelogdate() }
        else { $qlmi.enablelogdate() }

        # Set the log type
        if($NoLogIcon -eq $true){ $qlmi.disablelogicon() }
        else{ $qlmi.enablelogicon() }

        $Props = [PSCustomObject]@{
          barcount    = [int]$barcount
          percent     = [int]$percent
          status      = [String]$status
          submessage  = [Bool]$submessage
          total       = [String]$total
          bandwidth   = [String]$bandwidth
          transferred = [String]$transferred
          eta         = [String]$eta
        }

        # Write the message
        $qlmi.GenerateProgress($Props)
        $qlmi.WriteProgress()
    }
}
Export-ModuleMember -Function Write-QuicklogProgress -Alias qlwp
