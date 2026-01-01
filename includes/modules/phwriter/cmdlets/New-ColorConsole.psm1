<#
.SYNOPSIS
  Colorize a string using ANSI escape sequences.

.DESCRIPTION
  The New-Color function takes a string and a color, and returns the string with the specified color.

.PARAMETER string
  The input string to be colorized.

.PARAMETER color
  The color to be applied to the string.

.PARAMETER bgcolor
  The background color to be applied to the string.

.PARAMETER format
  The format to be applied to the string, supports `bold`, `italic`, underline`, `Strikethrough`, `invert`, and `conceal`.

.PARAMETER debug
  for testing only.

.EXAMPLE
  New-Color -string "Hello World" -color Red
  New-Color -string "Hello World" -color Red -bgcolor Yellow

.OUTPUTS
  The colorized string.

.NOTES
  The available colors are: foreground and background
  * Blue
  * Yellow
  * Green
  * Red
  * White
  * Black
  * Cyan
  * Magenta
  * Gray
  * Darkgray
  * Darkblue
  * Darkyellow
  * Darkgreen
  * Darkred
  * Darkcyan
  * Darkmagenta

.LINK
  https://en.wikipedia.org/wiki/ANSI_escape_code
#>

Function New-ColorConsole() {
  [CmdletBinding()]
  [Alias('csole')]
  [OutputType([string])]
  param(
    [parameter(mandatory = $true, Position = 0)]
    [string]$string,
    [parameter(mandatory = $false, Position = 1)]
    [ValidateSet(
      "blue",
      "yellow",
      "green",
      "red",
      "white",
      "black",
      "cyan",
      "magenta",
      "gray",
      "darkgray",
      "darkblue",
      "darkyellow",
      "darkgreen",
      "darkred",
      "darkcyan",
      "darkmagenta", ignorecase = $true)]
    $color = "white",
    [parameter(mandatory = $false, Position = 2)]
    [ValidateSet(
      "blue",
      "yellow",
      "green",
      "red",
      "white",
      "black",
      "cyan",
      "magenta",
      "gray",
      "darkgray",
      "darkblue",
      "darkyellow",
      "darkgreen",
      "darkred",
      "darkcyan",
      "darkmagenta", ignorecase = $true)]
    $bgcolor = "",
    [parameter(mandatory = $false, Position = 3)]
    [ValidateSet(
      "bold",
      "italic",
      "underline",
      "strikethrough",
      "invert",
      "conceal", ignorecase = $true)]
    $format = "",
    [parameter(mandatory = $false)]
    [switch]$debugger = $false
  )
  Begin {
    # --- Handle Formatting ---
    $formatCodeParts = @()
    if ($Format) {
      $formatMap = @{
        'Bold'          = '1'
        'Italic'        = '3'
        'Underline'     = '4'
        'Strikethrough' = '9'
        'Invert'        = '7'
        'Conceal'       = '8'
      }
      foreach ($f in $Format) {
        if ($formatMap.ContainsKey($f)) {
          $formatCodeParts += "`e[$($formatMap[$f])m"
        }
      }
    }
    # Define the escape sequence for color formatting
    $escapeSequence = [char]27
    # Define color codes
    $colorReset = "${escapeSequence}[0m"   # Reset color
    $colorRed = "${escapeSequence}[31m"    # Red
    $colorGreen = "${escapeSequence}[32m"  # Green
    $colorYellow = "${escapeSequence}[33m" # Yellow
    $colorBlue = "${escapeSequence}[34m"   # Blue
    $colorMagenta = "${escapeSequence}[35m" # Magenta
    $colorCyan = "${escapeSequence}[36m"   # Cyan
    $colorWhite = "${escapeSequence}[37m"  # White
    $colorDarkGray = "${escapeSequence}[90m" # Dark Gray
    $colorDarkRed = "${escapeSequence}[91m" # Dark Red
    $colorDarkGreen = "${escapeSequence}[92m" # Dark Green
    $colorDarkYellow = "${escapeSequence}[93m" # Dark Yellow
    $colorDarkBlue = "${escapeSequence}[94m" # Dark Blue
    $colorDarkMagenta = "${escapeSequence}[95m" # Dark Magenta
    $colorDarkCyan = "${escapeSequence}[96m" # Dark Cyanaaf
    $colorBlack = "${escapeSequence}[97m" # Black

    # define background color codes
    $colorBgReset = "${escapeSequence}[49m"   # Reset color
    $colorBgRed = "${escapeSequence}[41m"    # Red
    $colorBgGreen = "${escapeSequence}[42m"  # Green
    $colorBgYellow = "${escapeSequence}[43m" # Yellow
    $colorBgBlue = "${escapeSequence}[44m"   # Blue
    $colorBgMagenta = "${escapeSequence}[45m" # Magenta
    $colorBgCyan = "${escapeSequence}[46m"   # Cyan
    $colorBgWhite = "${escapeSequence}[47m"  # White
    $colorBgDarkGray = "${escapeSequence}[100m" # Dark Gray
    $colorBgDarkRed = "${escapeSequence}[101m" # Dark Red
    $colorBgDarkGreen = "${escapeSequence}[102m" # Dark Green
    $colorBgDarkYellow = "${escapeSequence}[103m" # Dark Yellow
    $colorBgDarkBlue = "${escapeSequence}[104m" # Dark Blue
    $colorBgDarkMagenta = "${escapeSequence}[105m" # Dark Magenta
    $colorBgDarkCyan = "${escapeSequence}[106m" # Dark Cyan
    $colorBgBlack = "${escapeSequence}[107m" # Black
  }
  process {

    if ($PSVersionTable.PSVersion.Major -eq 5 -or $debugger -eq $true) {
      #! Note the below return needs to be change to $string = "$color$string$colorReset" etc
      switch ($color) {
        "red" { return "$formatCodeParts$colorRed$string$colorReset" }
        "yellow" { return "$formatCodeParts$colorYellow$string$colorReset" }
        "green" { return "$formatCodeParts$colorGreen$string$colorReset" }
        "blue" { return "$formatCodeParts$colorBlue$string$colorReset" }
        "white" { return "$formatCodeParts$colorWhite$string$colorReset" }
        "black" { return "$formatCodeParts$colorBlack$string$colorReset" }
        "cyan" { return "$formatCodeParts$colorCyan$string$colorReset" }
        "magenta" { return "$formatCodeParts$colorMagenta$string$colorReset" }
        "gray" { return "$formatCodeParts$colorDarkGray$string$colorReset" }
        "darkgray" { return "$formatCodeParts$colorDarkGray$string$colorReset" }
        "darkblue" { return "$formatCodeParts$colorDarkBlue$string$colorReset" }
        "darkyellow" { return "$formatCodeParts$colorDarkYellow$string$colorReset" }
        "darkgreen" { return "$formatCodeParts$colorDarkGreen$string$colorReset" }
        "darkred" { return "$formatCodeParts$colorDarkRed$string$colorReset" }
        "darkcyan" { return "$formatCodeParts$colorDarkCyan$string$colorReset" }
        "darkmagenta" { return "$formatCodeParts$colorDarkMagenta$string$colorReset" }
        default { return "$formatCodeParts$string" }
      } #! Add switch here for background color if needed
      if ($bgcolor) {
        switch ($bgcolor) {
          "red" { return "$colorBgRed$string$colorBgReset" }
          "yellow" { return "$colorBgYellow$string$colorBgReset" }
          "green" { return "$colorBgGreen$string$colorBgReset" }
          "blue" { return "$colorBgBlue$string$colorBgReset" }
          "white" { return "$colorBgWhite$string$colorBgReset" }
          "black" { return "$colorBgBlack$string$colorBgReset" }
          "cyan" { return "$colorBgCyan$string$colorBgReset" }
          "magenta" { return "$colorBgMagenta$string$colorBgReset" }
          "gray" { return "$colorBgDarkGray$string$colorBgReset" }
          "darkgray" { return "$colorBgDarkGray$string$colorBgReset" }
          "darkblue" { return "$colorBgDarkBlue$string$colorBgReset" }
          "darkyellow" { return "$colorBgDarkYellow$string$colorBgReset" }
          "darkgreen" { return "$colorBgDarkGreen$string$colorBgReset" }
          "darkred" { return "$colorBgDarkRed$string$colorBgReset" }
          "darkcyan" { return "$colorBgDarkCyan$string$colorBgReset" }
          "darkmagenta" { return "$colorBgDarkMagenta$string$colorBgReset" }
          default { return "$string" }
        }
      }
    }
    else {
      # PowerShell 7.0 and above
      # Use ANSI escape sequences to colorize the string
      # https://en.wikipedia.org/wiki/ANSI_escape_code
      # forground color
      switch ($color) {
        "blue" { $string = "$formatCodeParts`e[94m$string`e[0m" } 
        "yellow" { $string = "$formatCodeParts`e[93m$string`e[0m" } 
        "green" { $string = "$formatCodeParts`e[92m$string`e[0m" } 
        "red" { $string = "$formatCodeParts`e[91m$string`e[0m" }  
        "white" { $string = "$formatCodeParts`e[97m$string`e[0m" } 
        "black" { $string = "$formatCodeParts`e[30m$string`e[0m" } 
        "cyan" { $string = "$formatCodeParts`e[96m$string`e[0m" } 
        "magenta" { $string = "$formatCodeParts`e[95m$string`e[0m" }
        "gray" { $string = "$formatCodeParts`e[90m$string`e[0m" }
        "darkgray" { $string = "$formatCodeParts`e[30m$string`e[0m" }
        "darkblue" { $string = "$formatCodeParts`e[34m$string`e[0m" }
        "darkyellow" { $string = "$formatCodeParts`e[33m$string`e[0m" }
        "darkgreen" { $string = "$formatCodeParts`e[32m$string`e[0m" }
        "darkred" { $string = "$formatCodeParts`e[31m$string`e[0m" }
        "darkcyan" { $string = "$formatCodeParts`e[36m$string`e[0m" }
        "darkmagenta" { $string = "$formatCodeParts`e[35m$string`e[0m" }
        default { $string = "$formatCodeParts$string" }
      }
      # background color
      if ($bgcolor) {
        switch ($bgcolor) {
          "blue" { $string = "`e[104m$string`e[0m" }
          "yellow" { $string = "`e[103m$string`e[0m" }
          "green" { $string = "`e[102m$string`e[0m" }
          "red" { $string = "`e[101m$string`e[0m" }
          "cyan" { $string = "`e[106m$string`e[0m" }
          "magenta" { $string = "`e[105m$string`e[0m" }
          "gray" { $string = "`e[100m$string`e[0m" }
          "white" { $string = "`e[107m$string`e[0m" }
          "black" { $string = "`e[40m$string`e[0m" }
          "darkgray" { $string = "`e[40m$string`e[0m" }
          "darkblue" { $string = "`e[44m$string`e[0m" }
          "darkyellow" { $string = "`e[43m$string`e[0m" }
          "darkgreen" { $string = "`e[42m$string`e[0m" }
          "darkred" { $string = "`e[41m$string`e[0m" }
          "darkcyan" { $string = "`e[46m$string`e[0m" }
          "darkmagenta" { $string = "`e[45m$string`e[0m" }
          default { $string = "$formatCodeParts$string" } # Default is to reset the background color
        }
      }
    }
    return $string
  }
}

$cmdletconfig = @{
  function = @('New-ColorConsole')
  alias    = @('csole')
}

Export-ModuleMember @cmdletconfig