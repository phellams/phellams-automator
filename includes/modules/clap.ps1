#Requires -Version 5.1

<#
.SYNOPSIS
    Clap - ANSI-aware string concatenation and padding utility.
 
.DESCRIPTION
    Clap exists for one job: gluing together ANSI/SGR-encoded strings without
    the visible width getting thrown off by invisible escape sequences. Plain
    PadLeft/PadRight count escape codes as characters, which breaks table
    columns, headers, and TUI frames the moment color is involved. Clap
    strips escape sequences only for measurement, pads/truncates against the
    *visible* length, and builds the final line in a single StringBuilder
    pass so redraws are atomic (no partial-width flicker / "tearing").
 
    Two ways to call it:
      - Strings mode: positional array of strings + parallel Width/Align/PadChar arrays
      - Cells mode:   array of hashtables, one per column, for table-row building
 
.EXPORTS
    Clap                    Main entry point (alias: New-ClapString)
    Pad-AnsiString           Single-string ANSI-aware pad/truncate
    Get-ClapVisibleLength    Visible (non-escape) character count
    Set-ClapAnsiPattern      Override the escape-sequence regex if needed
 
.EXAMPLE
    # Plain padding, two columns, ANSI-colored
    $name   = "$($psa.Green)Garvey$($psa.Reset)"
    $status = "$($psa.Red)OFFLINE$($psa.Reset)"
    Clap -Strings $name,$status -Width 20,10 -Align Left,Right
 
.EXAMPLE
    # Table row via Cells mode (clearer when columns vary in spec)
    Clap -Cells @(
        @{ Text = "$($psa.Cyan)Name$($psa.Reset)";   Width = 20; Align = 'Left'  },
        @{ Text = "$($psa.Yellow)Role$($psa.Reset)"; Width = 12; Align = 'Left'  },
        @{ Text = "$($psa.Green)OK$($psa.Reset)";    Width = 6;  Align = 'Right' }
    ) -Separator ' | '
 
.EXAMPLE
    # Truncate overflowing cell content with an ellipsis, ANSI codes preserved
    Clap -Cells @(
        @{ Text = "$($psa.Red)A very long status message here$($psa.Reset)"; Width = 15; Truncate = $true }
    )
 
.EXAMPLE
    # Build a header line, then write it in one shot (atomic / tear-free)
    $line = Clap -Strings "$($psa.Bg.Blue)$($psa.White) RAVENUI $($psa.Reset)" -Width 80 -Align Center -PadChar '═'
    Write-Host $line
#>
 
# Matches standard CSI SGR sequences: ESC [ ... letter (covers color/style codes)
$script:ClapAnsiPattern = [regex]'\x1B\[[0-9;]*[a-zA-Z]'
 
function Set-ClapAnsiPattern {
    <#
    .SYNOPSIS
        Override the regex Clap uses to detect/strip escape sequences.
        Useful if you're emitting OSC sequences or non-standard codes.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [regex]$Pattern
    )
    $script:ClapAnsiPattern = $Pattern
}
 
function Get-ClapVisibleLength {
    <#
    .SYNOPSIS
        Returns the visible character count of a string, ignoring ANSI escape sequences.
    #>
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [AllowEmptyString()]
        [AllowNull()]
        [string]$Text
    )
    process {
        if ([string]::IsNullOrEmpty($Text)) { return 0 }
        ($script:ClapAnsiPattern.Replace($Text, '')).Length
    }
}
 
function Clap-TruncateAnsi {
    # Internal helper: walk the string char-by-char, copying escape sequences
    # verbatim (they don't count toward MaxVisible) and stopping once the
    # visible-character budget is spent.
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string]$Text,
        [Parameter(Mandatory)]
        [int]$MaxVisible
    )
 
    if ($MaxVisible -le 0) { return '' }
 
    $sb = [System.Text.StringBuilder]::new()
    $visibleCount = 0
    $i = 0
    $len = $Text.Length
 
    while ($i -lt $len -and $visibleCount -lt $MaxVisible) {
        if ($Text[$i] -eq [char]0x1B) {
            $m = $script:ClapAnsiPattern.Match($Text, $i)
            if ($m.Success -and $m.Index -eq $i) {
                [void]$sb.Append($m.Value)
                $i += $m.Length
                continue
            }
        }
        [void]$sb.Append($Text[$i])
        $visibleCount++
        $i++
    }
 
    $sb.ToString()
}
 
function Pad-AnsiString {
    <#
    .SYNOPSIS
        Pads or truncates a single (possibly ANSI-encoded) string to a target
        visible width, without the escape sequences throwing off the math.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string]$Text,
 
        [Parameter(Mandatory, Position = 1)]
        [int]$Width,
 
        [ValidateSet('Left', 'Right', 'Center')]
        [string]$Align = 'Left',
 
        [char]$PadChar = ' ',
 
        [switch]$Truncate,
 
        [string]$TruncateSuffix = '…'
    )
 
    $visibleLen = Get-ClapVisibleLength -Text $Text
 
    if ($visibleLen -gt $Width) {
        if ($Truncate) {
            $suffixLen = Get-ClapVisibleLength -Text $TruncateSuffix
            $budget = $Width - $suffixLen
            $Text = (Clap-TruncateAnsi -Text $Text -MaxVisible $budget) + $TruncateSuffix
            $visibleLen = Get-ClapVisibleLength -Text $Text
        }
        else {
            # Overflow with no truncation requested: return as-is, uncut.
            return $Text
        }
    }
 
    $deficit = $Width - $visibleLen
    if ($deficit -le 0) { return $Text }
 
    switch ($Align) {
        'Left'   { return $Text + ([string]::new($PadChar, $deficit)) }
        'Right'  { return ([string]::new($PadChar, $deficit)) + $Text }
        'Center' {
            $leftLen  = [Math]::Floor($deficit / 2)
            $rightLen = $deficit - $leftLen
            return ([string]::new($PadChar, $leftLen)) + $Text + ([string]::new($PadChar, $rightLen))
        }
    }
}
 
function Clap {
    <#
    .SYNOPSIS
        Concatenate ANSI/formatted strings with correct visible-width padding,
        in a single pass, for tear-free TUI lines, table rows, and headers.
 
    .PARAMETER Strings
        Plain mode: array of text segments to join.
 
    .PARAMETER Width
        Parallel array of target widths per segment (Strings mode). If shorter
        than Strings, the last value repeats. Omit to skip padding entirely.
 
    .PARAMETER Align
        Parallel array of 'Left' | 'Right' | 'Center' per segment.
 
    .PARAMETER PadChar
        Parallel array of pad characters per segment. Defaults to space.
 
    .PARAMETER Cells
        Table mode: array of hashtables, each with optional keys
        Text / Width / Align / PadChar / Truncate. Width defaults to the
        segment's own visible length (no padding) if omitted.
 
    .PARAMETER Separator
        String inserted between segments/cells. Defaults to empty.
 
    .PARAMETER Truncate
        Global default for truncation when a segment overflows its width.
        Per-cell 'Truncate' key (Cells mode) overrides this.
 
    .PARAMETER TruncateSuffix
        Suffix appended when truncating. Defaults to '…'.
 
    .PARAMETER Raw
        Bypass ANSI-aware padding entirely; just concatenate as-is. Useful
        when segments are already pre-padded and you just need fast joining.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Strings')]
    [OutputType([string])]
    [Alias('New-ClapString')]
    param(
        [Parameter(ParameterSetName = 'Strings', Mandatory, Position = 0, ValueFromPipeline)]
        [string[]]$Strings,
 
        [Parameter(ParameterSetName = 'Strings')]
        [int[]]$Width,
 
        [Parameter(ParameterSetName = 'Strings')]
        [string[]]$Align,
 
        [Parameter(ParameterSetName = 'Strings')]
        [char[]]$PadChar,
 
        [Parameter(ParameterSetName = 'Cells', Mandatory, Position = 0)]
        [hashtable[]]$Cells,
 
        [string]$Separator = '',
 
        [switch]$Truncate,
 
        [string]$TruncateSuffix = '…',
 
        [switch]$Raw
    )
 
    begin {
        $collected = [System.Collections.Generic.List[string]]::new()
    }
 
    process {
        if ($PSCmdlet.ParameterSetName -eq 'Strings' -and $Strings) {
            foreach ($s in $Strings) { $collected.Add($s) }
        }
    }
 
    end {
        $sb = [System.Text.StringBuilder]::new()
 
        if ($PSCmdlet.ParameterSetName -eq 'Cells') {
            for ($idx = 0; $idx -lt $Cells.Count; $idx++) {
                $cell = $Cells[$idx]
                $text = [string]$cell.Text
                $w    = if ($cell.ContainsKey('Width'))   { [int]$cell.Width }    else { Get-ClapVisibleLength $text }
                $al   = if ($cell.ContainsKey('Align'))    { [string]$cell.Align } else { 'Left' }
                $pc   = if ($cell.ContainsKey('PadChar'))  { [char]$cell.PadChar } else { ' ' }
                $tr   = if ($cell.ContainsKey('Truncate')) { [bool]$cell.Truncate } else { $Truncate.IsPresent }
 
                $piece = if ($Raw) {
                    $text
                }
                else {
                    Pad-AnsiString -Text $text -Width $w -Align $al -PadChar $pc -Truncate:$tr -TruncateSuffix $TruncateSuffix
                }
 
                [void]$sb.Append($piece)
                if ($idx -lt $Cells.Count - 1) { [void]$sb.Append($Separator) }
            }
        }
        else {
            for ($idx = 0; $idx -lt $collected.Count; $idx++) {
                $text = $collected[$idx]
 
                if ($Raw -or -not $Width -or $Width.Count -eq 0) {
                    [void]$sb.Append($text)
                }
                else {
                    $w  = $Width[[Math]::Min($idx, $Width.Count - 1)]
                    $al = if ($Align   -and $Align.Count   -gt 0) { $Align[[Math]::Min($idx, $Align.Count - 1)] }   else { 'Left' }
                    $pc = if ($PadChar -and $PadChar.Count -gt 0) { $PadChar[[Math]::Min($idx, $PadChar.Count - 1)] } else { ' ' }
 
                    [void]$sb.Append((Pad-AnsiString -Text $text -Width $w -Align $al -PadChar $pc -Truncate:$Truncate -TruncateSuffix $TruncateSuffix))
                }
 
                if ($idx -lt $collected.Count - 1) { [void]$sb.Append($Separator) }
            }
        }
 
        $sb.ToString()
    }
}
 
# Uncomment if dropping this into a module file instead of dot-sourcing directly:
# Export-ModuleMember -Function Clap, 'Pad-AnsiString', 'Get-ClapVisibleLength', 'Set-ClapAnsiPattern' -Alias 'New-ClapString'