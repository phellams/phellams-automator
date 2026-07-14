<#
.SYNOPSIS
    Generates a custom SVG badge for CI/CD status tracking.
.DESCRIPTION
    This script generates a static SVG badge matching the Shields.io flat or for-the-badge visual style.
    It calculates text widths dynamically and outputs the SVG to a specified file.
.PARAMETER Label
    The label text displayed on the left side of the badge. Default is 'runtime'.
.PARAMETER Message
    The message text displayed on the right side of the badge. Default is 'unknown'.
.PARAMETER LabelColor
    The CSS color or hex code for the label background. Default is '#555'.
.PARAMETER MessageColor
    The CSS color or hex code for the message background. Default is '#007acc'.
.PARAMETER OutputPath
    The file path where the generated SVG will be saved. Default is 'runtime-badge.svg'.
.PARAMETER Style
    The design style of the badge. Valid values are 'flat' and 'for-the-badge'. Default is 'flat'.
.PARAMETER IncludeIcon
    Switch to include the custom pipeline icon on the left side of the label.
.EXAMPLE
    .\Generate-Badge.ps1 -Label "runtime" -Message "4m 12s" -Style "for-the-badge" -IncludeIcon -OutputPath "badge.svg"
.NOTES
    Adheres to phellams-aa strict module styling and utilizes .NET file writing for performance.
#>

param (
    [string]$Label = "runtime",
    [string]$Message = "unknown",
    [string]$LabelColor = "#555",
    [string]$MessageColor = "#007acc",
    [string]$OutputPath = "runtime-badge.svg",
    [ValidateSet("flat", "for-the-badge")]
    [string]$Style = "flat",
    [switch]$IncludeIcon
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Helper function to estimate character width to prevent SVG screen tearing.
function Get-TextWidth {
    param (
        [string]$Text,
        [string]$Style
    )
    if ([string]::IsNullOrEmpty($Text)) { return 0 }
    if ($Style -eq "for-the-badge") {
        # Bold uppercase with letter-spacing (9.5px per character average + 20px padding)
        return [Math]::Ceiling($Text.Length * 9.5 + 20)
    } else {
        # Flat style (6.25px per character average + 12px padding)
        return [Math]::Ceiling($Text.Length * 6.25 + 12)
    }
}

# Define layout variables based on style
$IconSize = 0
$IconX = 0
$IconY = 0
$IconOffset = 0

if ($IncludeIcon) {
    if ($Style -eq "for-the-badge") {
        $IconSize = 18
        $IconX = 8
        $IconY = 5
        $IconOffset = 26 # width (18) + spacing (8)
    } else {
        $IconSize = 14
        $IconX = 6
        $IconY = 3
        $IconOffset = 18 # width (14) + spacing (4)
    }
}

# Calculate badge component dimensions
$LabelTextWidth = Get-TextWidth -Text $Label -Style $Style
$MessageTextWidth = Get-TextWidth -Text $Message -Style $Style

$LabelWidth = $LabelTextWidth + $IconOffset
$MessageWidth = $MessageTextWidth
$TotalWidth = $LabelWidth + $MessageWidth

# Calculate text positioning
if ($IncludeIcon) {
    $LabelX = ($LabelWidth + $IconOffset) / 2
} else {
    $LabelX = $LabelWidth / 2
}
$MessageX = $LabelWidth + ($MessageWidth / 2)

# Scale text parameters by 10 for SVG textLength/positioning compatibility
$LabelXScaled = [int]($LabelX * 10)
$MessageXScaled = [int]($MessageX * 10)

$LabelLengthScaled = [int](($LabelTextWidth - 12) * 10)
$MessageLengthScaled = [int](($MessageTextWidth - 12) * 10)
if ($Style -eq "for-the-badge") {
    $LabelLengthScaled = [int](($LabelTextWidth - 20) * 10)
    $MessageLengthScaled = [int](($MessageTextWidth - 20) * 10)
}

# Define SVG components
$IconSvg = ""
if ($IncludeIcon) {
    $IconSvg = @"
  <svg x="$($IconX)" y="$($IconY)" width="$($IconSize)" height="$($IconSize)" viewBox="0 0 48 48">
    <path fill="#fff" d="M40,30a2,2,0,0,0-2,2v1H22a2,2,0,0,1,0-4h4A12,12,0,0,0,26,5H10V4A2,2,0,0,0,6,4V16a2,2,0,0,0,4,0V15H26a2,2,0,0,1,0,4H22a12,12,0,0,0,0,24H38v1a2,2,0,0,0,4,0V32A2,2,0,0,0,40,30Z"/>
  </svg>
"@
}

$Svg = ""
if ($Style -eq "for-the-badge") {
    # Render 'for-the-badge' style (square corners, uppercase, bold, letter-spaced)
    $Svg = @"
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="$($TotalWidth)" height="28" role="img" aria-label="$($Label): $($Message)">
  <g shape-rendering="crispEdges">
    <rect width="$($LabelWidth)" height="28" fill="$($LabelColor)"/>
    <rect x="$($LabelWidth)" width="$($MessageWidth)" height="28" fill="$($MessageColor)"/>
  </g>
$($IconSvg)
  <g fill="#fff" text-anchor="middle" font-family="Verdana,Geneva,DejaVu Sans,sans-serif" text-rendering="geometricPrecision" font-size="100" font-weight="bold">
    <text x="$($LabelXScaled)" y="180" transform="scale(.1)" fill="#fff" letter-spacing="15" textLength="$($LabelLengthScaled)">$($Label.ToUpper())</text>
    <text x="$($MessageXScaled)" y="180" transform="scale(.1)" fill="#fff" letter-spacing="15" textLength="$($MessageLengthScaled)">$($Message.ToUpper())</text>
  </g>
</svg>
"@
} else {
    # Render 'flat' style (rounded corners, normal text)
    $Svg = @"
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="$($TotalWidth)" height="20" role="img" aria-label="$($Label): $($Message)">
  <linearGradient id="s" x2="0" y2="100%">
    <stop offset="0" stop-color="#bbb" stop-opacity=".1"/>
    <stop offset="1" stop-opacity=".1"/>
  </linearGradient>
  <clipPath id="r">
    <rect width="$($TotalWidth)" height="20" rx="3" fill="#fff"/>
  </clipPath>
  <g clip-path="url(#r)">
    <rect width="$($LabelWidth)" height="20" fill="$($LabelColor)"/>
    <rect x="$($LabelWidth)" width="$($MessageWidth)" height="20" fill="$($MessageColor)"/>
    <rect width="$($TotalWidth)" height="20" fill="url(#s)"/>
  </g>
$($IconSvg)
  <g fill="#fff" text-anchor="middle" font-family="Verdana,Geneva,DejaVu Sans,sans-serif" text-rendering="geometricPrecision" font-size="110">
    <text aria-hidden="true" x="$($LabelXScaled)" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)" textLength="$($LabelLengthScaled)">$($Label)</text>
    <text x="$($LabelXScaled)" y="140" transform="scale(.1)" fill="#fff" textLength="$($LabelLengthScaled)">$($Label)</text>
    <text aria-hidden="true" x="$($MessageXScaled)" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)" textLength="$($MessageLengthScaled)">$($Message)</text>
    <text x="$($MessageXScaled)" y="140" transform="scale(.1)" fill="#fff" textLength="$($MessageLengthScaled)">$($Message)</text>
  </g>
</svg>
"@
}

# Write output file using .NET for maximum performance and cross-platform compatibility
$ResolvedPath = [System.IO.Path]::GetFullPath($OutputPath)
[System.IO.File]::WriteAllText($ResolvedPath, $Svg)
Write-Output "Successfully wrote ($Style) badge to $ResolvedPath"
