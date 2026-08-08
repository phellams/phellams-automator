<#
.SYNOPSIS
    Tokenizes ASCII art into contiguous glyph regions and renders it with
    ANSI truecolor gradients.

.DESCRIPTION
    Pipeline:
      1. ConvertTo-AsciiTokens  - pads lines, builds a char grid, and runs a
         4-connected BFS flood fill over non-whitespace cells to find
         "tokens" (contiguous shapes/regions). O(width * height), so it's
         effectively instant even for large art.
      2. Write-GradientAscii    - walks the token object and paints each
         cell using 24-bit ANSI color codes, interpolated across whichever
         axis you choose (Horizontal / Vertical / PerToken).

    
  • Visual Quality & Dimension: Your concept operates in a 2D Grid space (X,Y), allowing true vertical and       
  horizontal gradients across multi-line shapes. The current  New-AsciiGradient  is 1D (linear) and processes    
  text line-by-line.
  • Performance: The current  New-AsciiGradient  loops through the 256-color palette (Euclidean distance         
  matching) for every single character (O(N × 240)), causing noticeable rendering latency.  New-AsciiHeaderArt   
  writes 24-bit TrueColor directly to the stream (O(Width × Height)), which compiles instantly.                  
  • Topological Shading: The 4/8-connectivity BFS flood fill is highly unique—it identifies disconnected text    
  elements (tokens) so you can color each shape individually ( PerToken  mode).
  
  However, the current module implementation remains superior for maximum compatibility because it uses 8-bit    
  xterm-256 color sequences ( \e[38;5;COLORm ), which are supported on older legacy shells, whereas TrueColor (  
  \e[38;2;R;G;Bm ) requires modern terminal hosts.

.EXAMPLE
    $art = @(
        "(\ "
        "\'\ "
        " \'\     __________  "
        " / '|   ()_________)"
        " \ '/    \ ~~~~~~~~ \"
        "   \       \ ~~~~~~   \"
        "   ==).      \__________\"
        "  (__)       ()__________)"
    )
    $tokens = ConvertTo-AsciiTokens -Lines $art
    Write-GradientAscii -TokenObject $tokens -Mode PerToken -StartColor 0,180,255 -EndColor 255,60,180
#>

function ConvertTo-AsciiTokens {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$Lines,

        # 4-connectivity treats diagonal-only touching chars as separate
        # tokens; 8-connectivity merges them. Use 8 for "loose" line art
        # like slashes/backslashes that only touch at corners.
        [ValidateSet(4, 8)]
        [int]$Connectivity = 8
    )

    $width  = ($Lines | Measure-Object -Property Length -Maximum).Maximum
    if (-not $width) { $width = 0 }
    $padded = @($Lines | ForEach-Object { $_.PadRight($width) })
    $height = $padded.Count

    $grid = New-Object 'char[][]' $height
    for ($y = 0; $y -lt $height; $y++) { $grid[$y] = $padded[$y].ToCharArray() }

    $visited = New-Object 'bool[,]' $height, $width
    $tokenId = 0
    $tokens  = [System.Collections.Generic.List[object]]::new()

    $dirs4 = @(@(0,1), @(0,-1), @(1,0), @(-1,0))
    $dirs8 = $dirs4 + @(@(1,1), @(1,-1), @(-1,1), @(-1,-1))
    $dirs  = if ($Connectivity -eq 8) { $dirs8 } else { $dirs4 }

    for ($y = 0; $y -lt $height; $y++) {
        for ($x = 0; $x -lt $width; $x++) {
            if ($visited[$y, $x]) { continue }
            $ch = $grid[$y][$x]
            if ($ch -eq ' ' -or $ch -eq "`t") { $visited[$y, $x] = $true; continue }

            # BFS flood fill - each cell is visited exactly once total
            $queue = [System.Collections.Generic.Queue[object]]::new()
            $queue.Enqueue(@($y, $x))
            $visited[$y, $x] = $true
            $cells   = [System.Collections.Generic.List[object]]::new()
            $charSet = [System.Collections.Generic.HashSet[char]]::new()
            $minX = $maxX = $x
            $minY = $maxY = $y

            while ($queue.Count -gt 0) {
                $cy, $cx = $queue.Dequeue()
                $cells.Add(@($cy, $cx))
                [void]$charSet.Add($grid[$cy][$cx])
                if ($cx -lt $minX) { $minX = $cx }
                if ($cx -gt $maxX) { $maxX = $cx }
                if ($cy -lt $minY) { $minY = $cy }
                if ($cy -gt $maxY) { $maxY = $cy }

                foreach ($d in $dirs) {
                    $ny = $cy + $d[0]; $nx = $cx + $d[1]
                    if ($ny -ge 0 -and $ny -lt $height -and $nx -ge 0 -and $nx -lt $width -and -not $visited[$ny, $nx]) {
                        $g = $grid[$ny][$nx]
                        if ($g -ne ' ' -and $g -ne "`t") {
                            $visited[$ny, $nx] = $true
                            $queue.Enqueue(@($ny, $nx))
                        }
                    }
                }
            }

            $tokens.Add([pscustomobject]@{
                Id          = $tokenId++
                Cells       = $cells
                BoundingBox = [pscustomobject]@{ X = $minX; Y = $minY; W = ($maxX - $minX + 1); H = ($maxY - $minY + 1) }
                CharCount   = $cells.Count
                CharSet     = -join $charSet
            })
        }
    }

    [pscustomobject]@{
        Width  = $width
        Height = $height
        Lines  = $padded
        Tokens = $tokens
    }
}

function Get-GradientColor {
    param([double]$T, [int[]]$Start, [int[]]$End)
    $r = [int]($Start[0] + ($End[0] - $Start[0]) * $T)
    $g = [int]($Start[1] + ($End[1] - $Start[1]) * $T)
    $b = [int]($Start[2] + ($End[2] - $Start[2]) * $T)
    "$r;$g;$b"
}

function ConvertTo-Xterm256Color {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateRange(0, 255)]
        [int]$Red,

        [Parameter(Mandatory)]
        [ValidateRange(0, 255)]
        [int]$Green,

        [Parameter(Mandatory)]
        [ValidateRange(0, 255)]
        [int]$Blue
    )

    $levels = @(0, 95, 135, 175, 215, 255)
    $components = @($Red, $Green, $Blue)
    $indexes = [int[]]::new(3)

    for ($component = 0; $component -lt $components.Count; $component++) {
        $minimumDistance = [int]::MaxValue
        for ($level = 0; $level -lt $levels.Count; $level++) {
            $distance = [Math]::Abs($components[$component] - $levels[$level])
            if ($distance -lt $minimumDistance) {
                $minimumDistance = $distance
                $indexes[$component] = $level
            }
        }
    }

    $cubeRed = $levels[$indexes[0]]
    $cubeGreen = $levels[$indexes[1]]
    $cubeBlue = $levels[$indexes[2]]
    $cubeDistance =
        [Math]::Pow($Red - $cubeRed, 2) +
        [Math]::Pow($Green - $cubeGreen, 2) +
        [Math]::Pow($Blue - $cubeBlue, 2)
    $cubeIndex = 16 + (36 * $indexes[0]) + (6 * $indexes[1]) + $indexes[2]

    # Compare the 6x6x6 color cube with the xterm grayscale ramp.
    $average = ($Red + $Green + $Blue) / 3
    $grayIndex = [Math]::Round(($average - 8) / 10, [MidpointRounding]::AwayFromZero)
    $grayIndex = [Math]::Max(0, [Math]::Min(23, $grayIndex))
    $grayValue = 8 + (10 * $grayIndex)
    $grayDistance =
        [Math]::Pow($Red - $grayValue, 2) +
        [Math]::Pow($Green - $grayValue, 2) +
        [Math]::Pow($Blue - $grayValue, 2)

    if ($grayDistance -lt $cubeDistance) {
        return 232 + $grayIndex
    }

    return $cubeIndex
}

function Get-AnsiForegroundSgr {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('^\d{1,3};\d{1,3};\d{1,3}$')]
        [string]$Rgb,

        [ValidateSet('Auto', 'TrueColor', 'Indexed256')]
        [string]$ColorMode = 'Auto'
    )

    if ($ColorMode -eq 'Auto') {
        $ColorMode = if ([string]::IsNullOrEmpty($env:GITLAB_CI)) {
            'TrueColor'
        } else {
            'Indexed256'
        }
    }

    if ($ColorMode -eq 'TrueColor') {
        return "38;2;$Rgb"
    }

    $rgbComponents = $Rgb.Split(';')
    $colorParameters = @{
        Red = [int]$rgbComponents[0]
        Green = [int]$rgbComponents[1]
        Blue = [int]$rgbComponents[2]
    }
    $colorIndex = ConvertTo-Xterm256Color @colorParameters
    return "38;5;$colorIndex"
}

function Write-GradientAscii {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $TokenObject,
        [int[]]$StartColor = @(0, 150, 255),
        [int[]]$EndColor   = @(255, 0, 150),
        [ValidateSet('Horizontal', 'Vertical', 'PerToken')]
        [string]$Mode = 'Horizontal',
        [ValidateSet('Auto', 'TrueColor', 'Indexed256')]
        [string]$ColorMode = 'Auto'
    )

    $esc = [char]27
    $resolvedColorMode = if ($ColorMode -eq 'Auto' -and -not [string]::IsNullOrEmpty($env:GITLAB_CI)) {
        'Indexed256'
    } elseif ($ColorMode -eq 'Auto') {
        'TrueColor'
    } else {
        $ColorMode
    }
    $colorMap = New-Object 'string[,]' $TokenObject.Height, $TokenObject.Width

    switch ($Mode) {
        'Horizontal' {
            foreach ($token in $TokenObject.Tokens) {
                foreach ($cell in $token.Cells) {
                    $y, $x = $cell
                    $t = if ($TokenObject.Width -gt 1) { $x / ($TokenObject.Width - 1) } else { 0 }
                    $colorMap[$y, $x] = Get-GradientColor -T $t -Start $StartColor -End $EndColor
                }
            }
        }
        'Vertical' {
            foreach ($token in $TokenObject.Tokens) {
                foreach ($cell in $token.Cells) {
                    $y, $x = $cell
                    $t = if ($TokenObject.Height -gt 1) { $y / ($TokenObject.Height - 1) } else { 0 }
                    $colorMap[$y, $x] = Get-GradientColor -T $t -Start $StartColor -End $EndColor
                }
            }
        }
        'PerToken' {
            $maxId = [Math]::Max(1, ($TokenObject.Tokens.Count - 1))
            foreach ($token in $TokenObject.Tokens) {
                $tColor = Get-GradientColor -T ($token.Id / $maxId) -Start $StartColor -End $EndColor
                foreach ($cell in $token.Cells) {
                    $y, $x = $cell
                    $colorMap[$y, $x] = $tColor
                }
            }
        }
    }

    for ($y = 0; $y -lt $TokenObject.Height; $y++) {
        $sb = [System.Text.StringBuilder]::new()
        for ($x = 0; $x -lt $TokenObject.Width; $x++) {
            $c = $TokenObject.Lines[$y][$x]
            if ($colorMap[$y, $x]) {
                $foregroundSgr = Get-AnsiForegroundSgr -Rgb $colorMap[$y, $x] -ColorMode $resolvedColorMode
                [void]$sb.Append(('{0}[{1}m{2}{0}[0m' -f $esc, $foregroundSgr, $c))
            } else {
                [void]$sb.Append($c)
            }
        }
        Write-Host $sb.ToString()
    }
}

# --- Demo using the boat art you pasted -----------------------------------
# if ($MyInvocation.InvocationName -notmatch '^\.$') {
#     $boat = @(
#         "(\ "
#         "\'\ "
#         " \'\     __________  "
#         " / '|   ()_________)"
#         " \ '/    \ ~~~~~~~~ \"
#         "   \       \ ~~~~~~   \"
#         "   ==).      \__________\"
#         "  (__)       ()__________)"
#     )

#     $tokens = ConvertTo-AsciiTokens -Lines $boat -Connectivity 8
#     Write-Host "Found $($tokens.Tokens.Count) tokens:"
#     $tokens.Tokens | Format-Table Id, CharCount, CharSet, BoundingBox -AutoSize
#     Write-Host ""
#     Write-Host "-- Horizontal gradient --"
#     Write-GradientAscii -TokenObject $tokens -Mode Horizontal -StartColor 0,180,255 -EndColor 255,60,180
#     Write-Host ""
#     Write-Host "-- PerToken gradient (each shape its own color band) --"
#     Write-GradientAscii -TokenObject $tokens -Mode PerToken -StartColor 255,200,0 -EndColor 0,255,140
# }
