# Define Modules
# By default in linux modules are installed in /usr/.local/share/powershell/Modules
import-module -Name Pester -RequiredVersion 5.7.1
import-module -Name PSScriptAnalyzer
import-module -Name powershell-yaml
import-module -Name colorconsole
import-module -name tadpol
import-module -name shelldock
import-module -Name gitautoversion # pending replacement: https://gitlab.com/phellams/phellams-utils\helpers\semver\Get-ConventionalCommitVersion.ps1
import-module -Name conventionalcommitversion
import-module -Name csverify
import-module -name quicklog
import-module -name psmpacker
import-module -Name nupsforge
import-module -name phwriter

# Load Clap and AsciiTokenizer
$clapPath = Join-Path $home ".local/share/powershell/Modules/clap.ps1"
if (-not (Test-Path $clapPath -ErrorAction SilentlyContinue)) {
    $clapPath = Join-Path $PSScriptRoot "modules/clap.ps1"
}
. $clapPath

$tokenizerPath = Join-Path $home ".local/share/powershell/Modules/asciitokenizer.ps1"
if (-not (Test-Path $tokenizerPath -ErrorAction SilentlyContinue)) {
    $tokenizerPath = Join-Path $PSScriptRoot "modules/asciitokenizer.ps1"
}
. $tokenizerPath

# Function to extract module versions
function gmv($name) {
    $moduleInfo = Get-Module -Name $name
    if ($null -eq $moduleInfo) { return "Unknown" }
    
    [string]$version_prerelease = ""
    if ($moduleInfo.PrivateData.PSData.Prerelease) {
        $version_prerelease = "-$($moduleInfo.PrivateData.PSData.Prerelease)"
    }
    $v = "$($moduleInfo.Version.Major).$($moduleInfo.Version.Minor).$($moduleInfo.Version.Build)$version_prerelease"
    return "v$($v.Trim())"
}

# Regex to normalize version strings to match v0.0.0, v0.0, including .rc, .beta-rc1, .bata-rc1 etc.
function Get-NormalizedVersion([string]$rawVersion) {
    if ([string]::IsNullOrEmpty($rawVersion)) { return "Unknown" }
    $clean = $rawVersion.Trim()
    
    # Matches vX.Y.Z or vX.Y with pre-releases/RCs (such as -rc1, .rc, .beta-rc1, .bata-rc1 etc.)
    if ($clean -match '(?i)(?:go|v)?(\d+\.\d+(?:\.\d+)*(?:[-.][a-zA-Z0-9]+)*)') {
        $v = $Matches[1]
        if ($v -notmatch '^v') {
            $v = "v$v"
        }
        return $v
    }
    return "v$clean"
}

# Resolve Versions Object
$resolvedVersions = [ordered]@{}

# Special / OS Infos
$resolvedVersions["base-distro-release"] = try { (lsb_release --all 2>$null | select-string -pattern "Description" | Out-String).Trim() -replace "Description:\s*", "" } catch { "Unknown" }
$resolvedVersions["kernel"] = try { (uname -rov 2>$null | Out-String).Trim() } catch { "Unknown" }
$resolvedVersions["automator"] = try { Get-NormalizedVersion (Get-CoventionalCommitVersion 2>$null).Version } catch { "Unknown" }

# List of Version Specs to resolve
$versionSpecs = @(
    # Binaries
    @{ Key = "pwsh";               Type = "Binary"; Command = { $PSVersionTable.PSVersion.ToString() } }
    @{ Key = "dotnet";             Type = "Binary"; Command = { dotnet --version 2>$null } }
    @{ Key = "nuget";              Type = "Binary"; Command = { nuget help 2>$null | select-string -pattern "NuGet Version:" | Out-String | ForEach-Object { $_ -replace "NuGet Version:", "" } } }
    @{ Key = "codecov";            Type = "Binary"; Command = { codecov --version 2>$null } }
    @{ Key = "coveralls";          Type = "Binary"; Command = { coveralls --version 2>$null } }
    @{ Key = "git";                Type = "Binary"; Command = { git --version 2>$null | ForEach-Object { $_.split(" ")[2] } } }
    @{ Key = "ruby";               Type = "Binary"; Command = { ruby --version 2>$null } }
    @{ Key = "rubygems";           Type = "Binary"; Command = { gem --version 2>$null } }
    @{ Key = "go";                 Type = "Binary"; Command = { go version 2>$null | ForEach-Object { $_.split(" ")[2] } } }
    @{ Key = "rust";               Type = "Binary"; Command = { rustc --version 2>$null | ForEach-Object { $_.split(" ")[1] } } }
    @{ Key = "elixir";             Type = "Binary"; Command = { elixir --version 2>$null | select-string -pattern "Elixir" | ForEach-Object { if ($_ -match "Elixir\s+([\d\.]+)") { $Matches[1] } } } }
    @{ Key = "node";               Type = "Binary"; Command = { node --version 2>$null } }
    @{ Key = "npm";                Type = "Binary"; Command = { npm --version 2>$null } }
    @{ Key = "bun";                Type = "Binary"; Command = { bun --version 2>$null } }
    @{ Key = "php";                Type = "Binary"; Command = { php -v 2>$null | select -First 1 | ForEach-Object { $_.split(" ")[1] } } }
    @{ Key = "jq";                 Type = "Binary"; Command = { jq --version 2>$null } }
    @{ Key = "yq";                 Type = "Binary"; Command = { yq --version 2>$null | ForEach-Object { $_.Split(' ')[-1] } } }
    @{ Key = "inkscape";           Type = "Binary"; Command = { inkscape --version 2>$null | ForEach-Object { $_.split(" ")[1] } } }
    @{ Key = "magick";             Type = "Binary"; Command = { magick --version 2>$null | select-string -pattern "Version:" | ForEach-Object { $_.split(" ")[2] } } }
    @{ Key = "photino";            Type = "Binary"; Command = { Get-ChildItem -Path (Join-Path $home ".nuget/packages/photino.net") 2>$null | Select-Object -First 1 | ForEach-Object { $_.Name } } }
    
    # Modules
    @{ Key = "colorconsole";       Type = "Module"; Name = "colorconsole" }
    @{ Key = "gitautoversion";     Type = "Module"; Name = "gitautoversion" }
    @{ Key = "conventionalcommitversion"; Type = "Module"; Name = "conventionalcommitversion" }
    @{ Key = "pester";             Type = "Module"; Name = "Pester" }
    @{ Key = "psscriptanalyzer";   Type = "Module"; Name = "PSScriptAnalyzer" }
    @{ Key = "powershell-yaml";    Type = "Module"; Name = "powershell-yaml" }
    @{ Key = "nupsforge";          Type = "Module"; Name = "nupsforge" }
    @{ Key = "phwriter";           Type = "Module"; Name = "phwriter" }
    @{ Key = "quicklog";           Type = "Module"; Name = "quicklog" }
    @{ Key = "psmpacker";          Type = "Module"; Name = "psmpacker" }
    @{ Key = "csverify";           Type = "Module"; Name = "csverify" }
    @{ Key = "shelldock";          Type = "Module"; Name = "shelldock" }
    @{ Key = "tadpol";             Type = "Module"; Name = "tadpol" }
)

# Resolve specs dynamically
foreach ($spec in $versionSpecs) {
    [string]$val = "Unknown"
    if ($spec.Type -eq "Binary") {
        try {
            $raw = & $spec.Command
            if ($raw) {
                $val = Get-NormalizedVersion ($raw.ToString().Trim())
            }
        } catch {}
    } else {
        try {
            $raw = gmv $spec.Name
            $val = Get-NormalizedVersion $raw
        } catch {}
    }
    $resolvedVersions[$spec.Key] = $val
}

# Load Template
$templatePath = Join-Path $home ".config/powershell/acsiilogo-template.txt"
if (-not (Test-Path $templatePath -ErrorAction SilentlyContinue)) {
    # Fallback to local script directory for testing/flexibility
    $templatePath = Join-Path $PSScriptRoot "acsiilogo-template.txt"
}

# Read mascot template (only the first 14 lines)
$mascotLines = try { [System.IO.File]::ReadAllLines($templatePath) | Select-Object -First 14 } catch { @() }
if ($mascotLines.Count -lt 14) {
    # Fallback to keep it running if file is missing/incomplete
    $mascotLines = @(" ") * 14
}

$plainLines = [System.Collections.Generic.List[string]]::new()

# Build lines 0 to 8: Mascot + Spacer + Header
for ($i = 0; $i -lt 9; $i++) {
    $plainLines.Add($mascotLines[$i].PadRight(80))
}

# Build lines 9 to 13: Mascot + Spacer + Info Box (Box 1)
$infoBox = @(
    "╭─ Info ─────────────────────────────────╮"
    "│ Automator : $($resolvedVersions["automator"].PadRight(26)) │"
    "│ Distro    : $($resolvedVersions["base-distro-release"].PadRight(26)) │"
    "│ Kernel    : $($resolvedVersions["kernel"].PadRight(26)) │"
    "╰────────────────────────────────────────╯"
)

for ($i = 9; $i -lt 14; $i++) {
    $mascotPart = $mascotLines[$i].PadRight(36)
    $boxPart = $infoBox[$i - 9]
    $plainLines.Add("$mascotPart$boxPart")
}

# Line 14: Spacer
$plainLines.Add(" ".PadRight(80))

# Build Box 2: Binaries Box (3 columns, 7 rows of content)
$binariesList = @(
    @("pwsh", $resolvedVersions["pwsh"]),
    @("dotnet", $resolvedVersions["dotnet"]),
    @("nuget", $resolvedVersions["nuget"]),
    @("codecov", $resolvedVersions["codecov"]),
    @("coveralls", $resolvedVersions["coveralls"]),
    @("git", $resolvedVersions["git"]),
    @("Ruby", $resolvedVersions["ruby"]),
    @("RubyGems", $resolvedVersions["rubygems"]),
    @("Go", $resolvedVersions["go"]),
    @("Rust", $resolvedVersions["rust"]),
    @("Elixir", $resolvedVersions["elixir"]),
    @("Bun", $resolvedVersions["bun"]),
    @("Node", $resolvedVersions["node"]),
    @("NPM", $resolvedVersions["npm"]),
    @("php", $resolvedVersions["php"]),
    @("jq", $resolvedVersions["jq"]),
    @("yq", $resolvedVersions["yq"]),
    @("inkscape", $resolvedVersions["inkscape"]),
    @("magick", $resolvedVersions["magick"]),
    @("photino", $resolvedVersions["photino"])
)

function Get-PlainRow([string[]]$c1, [string[]]$c2, [string[]]$c3) {
    $c1Name = if ($c1) { $c1[0] } else { "" }
    $c1Ver  = if ($c1) { $c1[1] } else { "" }
    $c2Name = if ($c2) { $c2[0] } else { "" }
    $c2Ver  = if ($c2) { $c2[1] } else { "" }
    $c3Name = if ($c3) { $c3[0] } else { "" }
    $c3Ver  = if ($c3) { $c3[1] } else { "" }
    
    $c1NamePadded = $c1Name.PadRight(14)
    $c1VerPadded  = $c1Ver.PadLeft(10)
    $c2NamePadded = $c2Name.PadRight(13)
    $c2VerPadded  = $c2Ver.PadLeft(10)
    $c3NamePadded = $c3Name.PadRight(13)
    $c3VerPadded  = $c3Ver.PadLeft(10)
    
    return "│ $c1NamePadded$c1VerPadded │ $c2NamePadded$c2VerPadded │ $c3NamePadded$c3VerPadded │"
}

$plainLines.Add("╭─ Binaries ─────────────────────────────────────────────────────────────────────────╮")
for ($r = 0; $r -lt 7; $r++) {
    $idx1 = $r * 3
    $idx2 = $idx1 + 1
    $idx3 = $idx1 + 2
    
    $c1 = if ($idx1 -lt $binariesList.Count) { $binariesList[$idx1] } else { $null }
    $c2 = if ($idx2 -lt $binariesList.Count) { $binariesList[$idx2] } else { $null }
    $c3 = if ($idx3 -lt $binariesList.Count) { $binariesList[$idx3] } else { $null }
    
    $plainLines.Add((Get-PlainRow $c1 $c2 $c3))
}
$plainLines.Add("╰────────────────────────────────────────────────────────────────────────────────────╯")

# Line 24: Spacer
$plainLines.Add(" ".PadRight(80))

# Build Box 3: Modules Box (3 columns, 5 rows of content)
$modulesList = @(
    @("PSScriptAnalyzer", $resolvedVersions["psscriptanalyzer"]),
    @("Pester", $resolvedVersions["pester"]),
    @("PowerShell-Yaml", $resolvedVersions["powershell-yaml"]),
    @("ColorConsole", $resolvedVersions["colorconsole"]),
    @("Quicklog", $resolvedVersions["quicklog"]),
    @("Nupsforge", $resolvedVersions["nupsforge"]),
    @("Psmpacker", $resolvedVersions["psmpacker"]),
    @("Csverify", $resolvedVersions["csverify"]),
    @("ShellDock", $resolvedVersions["shelldock"]),
    @("TadPol", $resolvedVersions["tadpol"]),
    @("PHWriter", $resolvedVersions["phwriter"]),
    @("CCVersion", $resolvedVersions["conventionalcommitversion"]),
    @("GitAutoVersion", $resolvedVersions["gitautoversion"])
)

$plainLines.Add("╭─ Modules ──────────────────────────────────────────────────────────────────────────╮")
for ($r = 0; $r -lt 5; $r++) {
    $idx1 = $r * 3
    $idx2 = $idx1 + 1
    $idx3 = $idx1 + 2
    
    $c1 = if ($idx1 -lt $modulesList.Count) { $modulesList[$idx1] } else { $null }
    $c2 = if ($idx2 -lt $modulesList.Count) { $modulesList[$idx2] } else { $null }
    $c3 = if ($idx3 -lt $modulesList.Count) { $modulesList[$idx3] } else { $null }
    
    $plainLines.Add((Get-PlainRow $c1 $c2 $c3))
}
$plainLines.Add("╰────────────────────────────────────────────────────────────────────────────────────╯")

# Run Tokenizer on the plain text lines to get the vertical border gradient
$tokens = ConvertTo-AsciiTokens -Lines $plainLines.ToArray() -Connectivity 8

# Generate Color Map for the vertical gradient (Cyan ➔ Magenta)
$esc = [char]27
$colorMap = New-Object 'string[,]' $tokens.Height, $tokens.Width
for ($y = 0; $y -lt $tokens.Height; $y++) {
    $t = if ($tokens.Height -gt 1) { $y / ($tokens.Height - 1) } else { 0 }
    $rowColor = Get-GradientColor -T $t -Start @(0, 180, 255) -End @(255, 60, 180)
    for ($x = 0; $x -lt $tokens.Width; $x++) {
        $colorMap[$y, $x] = $rowColor
    }
}

# Helper to format name gradient (lightblue ➔ orange)
function Get-NameColorChar([int]$idx, [int]$length) {
    $t = if ($length -gt 1) { $idx / ($length - 1) } else { 0 }
    return Get-GradientColor -T $t -Start @(50, 180, 255) -End @(255, 120, 0)
}

# Render Character Grid with Custom Coloring Overrides
for ($y = 0; $y -lt $tokens.Height; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    $line = $tokens.Lines[$y]
    
    for ($x = 0; $x -lt $tokens.Width; $x++) {
        $c = $line[$x]
        
        # Override logic
        $isOverridden = $false
        $overrideColor = ""
        
        # 1. Info Box area next to Mascot (Lines 9 to 13, $x >= 36)
        if ($y -ge 9 -and $y -le 13 -and $x -ge 36) {
            # Skip border rows
            if ($y -eq 9 -or $y -eq 13) {
                # Keep border gradient
            } else {
                # Border vertical lines
                if ($x -eq 36 -or $x -eq 77) {
                    # Keep border gradient
                }
                # Name area (index 38 to 49)
                elseif ($x -ge 38 -and $x -le 49) {
                    $isOverridden = $true
                    $overrideColor = Get-NameColorChar -idx ($x - 38) -length 12
                }
                # Version area (index 50 to 75)
                elseif ($x -ge 50 -and $x -le 75) {
                    $isOverridden = $true
                    if ($c -eq ' ') {
                        [void]$sb.Append($c)
                        continue
                    } elseif ($c -eq 'v') {
                        [void]$sb.Append("$esc[95mv$esc[0m")
                        continue
                    } else {
                        [void]$sb.Append("$esc[3;90m$c$esc[0m")
                        continue
                    }
                }
            }
        }
        # 2. Content rows of Binaries and Modules (Lines 15 onwards)
        elseif ($y -ge 15 -and $c -ne ' ' -and $plainLines[$y] -notmatch '^[╭╰]') {
            # Delimiters
            if ($x -eq 0 -or $x -eq 27 -or $x -eq 53 -or $x -eq 79) {
                # Keep border gradient
            }
            # Column 1 Name
            elseif ($x -ge 2 -and $x -le 15) {
                $isOverridden = $true
                $overrideColor = Get-NameColorChar -idx ($x - 2) -length 14
            }
            # Column 1 Version
            elseif ($x -ge 16 -and $x -le 25) {
                $isOverridden = $true
                if ($c -eq ' ') {
                    [void]$sb.Append($c)
                    continue
                } elseif ($c -eq 'v') {
                    [void]$sb.Append("$esc[95mv$esc[0m")
                    continue
                } else {
                    [void]$sb.Append("$esc[3;90m$c$esc[0m")
                    continue
                }
            }
            # Column 2 Name
            elseif ($x -ge 29 -and $x -le 41) {
                $isOverridden = $true
                $overrideColor = Get-NameColorChar -idx ($x - 29) -length 13
            }
            # Column 2 Version
            elseif ($x -ge 42 -and $x -le 51) {
                $isOverridden = $true
                if ($c -eq ' ') {
                    [void]$sb.Append($c)
                    continue
                } elseif ($c -eq 'v') {
                    [void]$sb.Append("$esc[95mv$esc[0m")
                    continue
                } else {
                    [void]$sb.Append("$esc[3;90m$c$esc[0m")
                    continue
                }
            }
            # Column 3 Name
            elseif ($x -ge 55 -and $x -le 67) {
                $isOverridden = $true
                $overrideColor = Get-NameColorChar -idx ($x - 55) -length 13
            }
            # Column 3 Version
            elseif ($x -ge 68 -and $x -le 77) {
                $isOverridden = $true
                if ($c -eq ' ') {
                    [void]$sb.Append($c)
                    continue
                } elseif ($c -eq 'v') {
                    [void]$sb.Append("$esc[95mv$esc[0m")
                    continue
                } else {
                    [void]$sb.Append("$esc[3;90m$c$esc[0m")
                    continue
                }
            }
        }
        
        if ($isOverridden) {
            if ($overrideColor) {
                [void]$sb.Append("$esc[38;2;$($overrideColor)m$c$esc[0m")
            }
        } elseif ($colorMap[$y, $x] -and $c -ne ' ') {
            [void]$sb.Append("$esc[38;2;$($colorMap[$y,$x])m$c$esc[0m")
        } else {
            [void]$sb.Append($c)
        }
    }
    Write-Host $sb.ToString()
}
