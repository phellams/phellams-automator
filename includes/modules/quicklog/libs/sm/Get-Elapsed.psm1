function Get-Elapsed() {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [String] $From,
        [Parameter(Mandatory = $true, Position = 1)]
        [String] $To,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [Switch] $Formattedstring = $false,
        [Parameter(Mandatory = $false)]
        [Switch] $AsObject = $false
    )

    $timespan = New-TimeSpan -Start $From -End $To

    $timespan_f = [pscustomobject]@{}
    # Add members by default, including milliseconds
    $timespan_f | Add-Member -MemberType NoteProperty -Name 'milliseconds' -Value "$([math]::Round($timespan.TotalMilliseconds, 0))"
    $timespan_f | Add-Member -MemberType NoteProperty -Name 'seconds' -Value "$([math]::Round($timespan.TotalSeconds, 0))"
    $timespan_f | Add-Member -MemberType NoteProperty -Name 'minutes' -Value "$([math]::Round($timespan.TotalMinutes, 0))"
    $timespan_f | Add-Member -MemberType NoteProperty -Name 'hours' -Value "$([math]::Round($timespan.TotalHours, 0))"
    $timespan_f | Add-Member -MemberType NoteProperty -Name 'days' -Value "$([math]::Round($timespan.TotalDays, 0))"

    if ($AsObject) {
        return $timespan_f
    }

    if ($Formattedstring) {
        [string]$timeblock = ""  # Initialize the string

        if ($timespan.TotalMilliseconds -lt 1000) {
            $timeblock += "$($timespan_f.milliseconds)ms"
        } elseif ($timespan.TotalSeconds -lt 60) {
            $timeblock += "$($timespan_f.seconds)s"
        } elseif ($timespan.TotalMinutes -lt 60) {
            $timeblock += "$($timespan_f.minutes)m"
        } elseif ($timespan.TotalHours -lt 24) {
            $timeblock += "$($timespan_f.hours)h"
        } else {
            $timeblock += "$($timespan_f.days)d"
        }

        return $timeblock
    } else {
        return $timespan_f
    }
}
