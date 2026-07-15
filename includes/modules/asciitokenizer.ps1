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
    $padded = $Lines | ForEach-Object { $_.PadRight($width) }
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

function Write-GradientAscii {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $TokenObject,
        [int[]]$StartColor = @(0, 150, 255),
        [int[]]$EndColor   = @(255, 0, 150),
        [ValidateSet('Horizontal', 'Vertical', 'PerToken')]
        [string]$Mode = 'Horizontal'
    )

    $esc = [char]27
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
                [void]$sb.Append("$esc[38;2;$($colorMap[$y,$x])m$c$esc[0m")
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