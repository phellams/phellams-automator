# Define Modules
# By default in linux modules are installed in /usr/.local/share/powershell/Modules

# Set Powershell Gallary and phellams gallary as trusted
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

# Install Pester
Get-Command 'Invoke-Pester' ? (install-module Pester -RequiredVersion 5.8.0 -Confirm:$false)
Get-Command 'Invoke-ScriptAnalyzer' ? (install-module PSScriptAnalyzer -Confirm:$false)
Get-Command 'ConvertFrom-Yaml' ? (install-module powershell-yaml -Confirm:$false)

import-module -Name Pester -RequiredVersion 5.8.0
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
$resolvedVersions["kernel"] = try {
    $k = (uname -rov 2>$null | Out-String).Trim()
    if ($k -like "* *") {
        $k = $k.Split(" ")[0]
    }
    $k
} catch { "Unknown" }

# Read version from VERSION file, with fallback to Get-ConventionalCommitVersion
$versionPath = Join-Path $home ".config/powershell/VERSION"
if (-not (Test-Path $versionPath -ErrorAction SilentlyContinue)) {
    $versionPath = Join-Path $PSScriptRoot "VERSION"
}
$resolvedVersions["automator"] = if (Test-Path $versionPath) {
    try { Get-NormalizedVersion ((Get-Content -Path $versionPath -Raw 2>$null).Trim()) } catch { "Unknown" }
} else {
    try { Get-NormalizedVersion (Get-ConventionalCommitVersion 2>$null).Version } catch { "Unknown" }
}

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
    @{ Key = "composer";           Type = "Binary"; Command = { composer --version 2>$null } }
    @{ Key = "jq";                 Type = "Binary"; Command = { jq --version 2>$null } }
    @{ Key = "yq";                 Type = "Binary"; Command = { yq --version 2>$null | ForEach-Object { $_.Split(' ')[-1] } } }
    @{ Key = "inkscape";           Type = "Binary"; Command = { inkscape --version 2>$null | ForEach-Object { $_.split(" ")[1] } } }
    @{ Key = "magick";             Type = "Binary"; Command = {
        $cmd = if (Get-Command convert -ErrorAction SilentlyContinue) { "convert" } else { "magick" }
        & $cmd --version 2>$null | select-string -pattern "Version:" | ForEach-Object { $_.Line.split(" ")[2] }
    } }
    @{ Key = "photino";            Type = "Binary"; Command = {
        $pkgDir = Get-ChildItem -Path (Join-Path $home ".nuget/packages") 2>$null | Where-Object { $_.Name -ieq "photino.net" }
        if ($pkgDir) {
            Get-ChildItem -Path $pkgDir.FullName 2>$null | Select-Object -First 1 | ForEach-Object { $_.Name }
        }
    } }
    
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
# Removed magick override to allow actual version to display

# Load Template
$templatePath = Join-Path $home ".config/powershell/acsiilogo-template.txt"
if (-not (Test-Path $templatePath -ErrorAction SilentlyContinue)) {
    # Fallback to local script directory for testing/flexibility
    $templatePath = Join-Path $PSScriptRoot "acsiilogo-template.txt"
}

# Read template lines
$templateLines = try { [System.IO.File]::ReadAllLines($templatePath) } catch { @() }
$mascotLines = $templateLines | Select-Object -First 14
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
function Get-BoxWidths($list, $minW1_name = 14, $minW1_ver = 10, $minW2_name = 13, $minW2_ver = 10, $minW3_name = 13, $minW3_ver = 10) {
    $w1_name = $minW1_name
    $w1_ver  = $minW1_ver
    $w2_name = $minW2_name
    $w2_ver  = $minW2_ver
    $w3_name = $minW3_name
    $w3_ver  = $minW3_ver
    
    for ($i = 0; $i -lt $list.Count; $i++) {
        $item = $list[$i]
        if (-not $item) { continue }
        $name = $item[0]
        $ver  = $item[1]
        
        $col = $i % 3
        if ($col -eq 0) {
            if ($name.Length -gt $w1_name) { $w1_name = $name.Length }
            if ($ver.Length -gt $w1_ver) { $w1_ver = $ver.Length }
        } elseif ($col -eq 1) {
            if ($name.Length -gt $w2_name) { $w2_name = $name.Length }
            if ($ver.Length -gt $w2_ver) { $w2_ver = $ver.Length }
        } else {
            if ($name.Length -gt $w3_name) { $w3_name = $name.Length }
            if ($ver.Length -gt $w3_ver) { $w3_ver = $ver.Length }
        }
    }
    
    return [ordered]@{
        w1_name = $w1_name
        w1_ver  = $w1_ver
        w2_name = $w2_name
        w2_ver  = $w2_ver
        w3_name = $w3_name
        w3_ver  = $w3_ver
    }
}

function Get-FormattedRow([string[]]$c1, [string[]]$c2, [string[]]$c3, $w1_name, $w1_ver, $w2_name, $w2_ver, $w3_name, $w3_ver) {
    $c1Name = if ($c1) { $c1[0] } else { "" }
    $c1Ver  = if ($c1) { $c1[1] } else { "" }
    $c2Name = if ($c2) { $c2[0] } else { "" }
    $c2Ver  = if ($c2) { $c2[1] } else { "" }
    $c3Name = if ($c3) { $c3[0] } else { "" }
    $c3Ver  = if ($c3) { $c3[1] } else { "" }
    
    $c1NamePadded = $c1Name.PadRight($w1_name)
    $c1VerPadded  = $c1Ver.PadLeft($w1_ver)
    $c2NamePadded = $c2Name.PadRight($w2_name)
    $c2VerPadded  = $c2Ver.PadLeft($w2_ver)
    $c3NamePadded = $c3Name.PadRight($w3_name)
    $c3VerPadded  = $c3Ver.PadLeft($w3_ver)
    
    return "│ $c1NamePadded$c1VerPadded │ $c2NamePadded$c2VerPadded │ $c3NamePadded$c3VerPadded │"
}

$infoW = 26
$infoValues = @(
    $resolvedVersions["automator"],
    $resolvedVersions["base-distro-release"],
    $resolvedVersions["kernel"]
)
foreach ($val in $infoValues) {
    if ($val -and $val.Length -gt $infoW) {
        $infoW = $val.Length
    }
}

$infoTopDashes = New-Object System.String ('─', ($infoW + 7))
$infoBottomDashes = New-Object System.String ('─', ($infoW + 14))

$infoBox = @(
    "╭─ Info $infoTopDashes╮"
    "│ Automator : $($resolvedVersions["automator"].PadRight($infoW)) │"
    "│ Distro    : $($resolvedVersions["base-distro-release"].PadRight($infoW)) │"
    "│ Kernel    : $($resolvedVersions["kernel"].PadRight($infoW)) │"
    "╰$infoBottomDashes╯"
)

for ($i = 9; $i -lt 14; $i++) {
    $mascotPart = $mascotLines[$i].PadRight(36)
    $boxPart = $infoBox[$i - 9]
    $plainLines.Add("$mascotPart$boxPart")
}

# Line 14: Spacer with vertical line connection
$plainLines.Add("      ┋")

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
    @("composer", $resolvedVersions["composer"]),
    @("jq", $resolvedVersions["jq"]),
    @("yq", $resolvedVersions["yq"]),
    @("inkscape", $resolvedVersions["inkscape"]),
    @("magick", $resolvedVersions["magick"]),
    @("photino", $resolvedVersions["photino"])
)

$binWidths = Get-BoxWidths $binariesList
$bin_w1_name = $binWidths.w1_name
$bin_w1_ver  = $binWidths.w1_ver
$bin_w2_name = $binWidths.w2_name
$bin_w2_ver  = $binWidths.w2_ver
$bin_w3_name = $binWidths.w3_name
$bin_w3_ver  = $binWidths.w3_ver

$bin_total_w = $bin_w1_name + $bin_w1_ver + $bin_w2_name + $bin_w2_ver + $bin_w3_name + $bin_w3_ver + 10
$binTopDashes = New-Object System.String ('─', ($bin_total_w - 13))
$binBottomDashes = New-Object System.String ('─', ($bin_total_w - 2))

$plainLines.Add("      ┋─────╭─ Binaries $binTopDashes╮")
for ($r = 0; $r -lt 7; $r++) {
    $idx1 = $r * 3
    $idx2 = $idx1 + 1
    $idx3 = $idx1 + 2
    
    $c1 = if ($idx1 -lt $binariesList.Count) { $binariesList[$idx1] } else { $null }
    $c2 = if ($idx2 -lt $binariesList.Count) { $binariesList[$idx2] } else { $null }
    $c3 = if ($idx3 -lt $binariesList.Count) { $binariesList[$idx3] } else { $null }
    
    $plainLines.Add("      ┋     " + (Get-FormattedRow $c1 $c2 $c3 $bin_w1_name $bin_w1_ver $bin_w2_name $bin_w2_ver $bin_w3_name $bin_w3_ver))
}
$plainLines.Add("      ┋     ╰$binBottomDashes╯")

# Line 24: Spacer
$plainLines.Add("      ┋")

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

$modWidths = Get-BoxWidths $modulesList
$mod_w1_name = $modWidths.w1_name
$mod_w1_ver  = $modWidths.w1_ver
$mod_w2_name = $modWidths.w2_name
$mod_w2_ver  = $modWidths.w2_ver
$mod_w3_name = $modWidths.w3_name
$mod_w3_ver  = $modWidths.w3_ver

$mod_total_w = $mod_w1_name + $mod_w1_ver + $mod_w2_name + $mod_w2_ver + $mod_w3_name + $mod_w3_ver + 10
$modTopDashes = New-Object System.String ('─', ($mod_total_w - 12))
$modBottomDashes = New-Object System.String ('─', ($mod_total_w - 2))

$plainLines.Add("      ┋─────╭─ Modules $modTopDashes╮")
for ($r = 0; $r -lt 5; $r++) {
    $idx1 = $r * 3
    $idx2 = $idx1 + 1
    $idx3 = $idx1 + 2
    
    $c1 = if ($idx1 -lt $modulesList.Count) { $modulesList[$idx1] } else { $null }
    $c2 = if ($idx2 -lt $modulesList.Count) { $modulesList[$idx2] } else { $null }
    $c3 = if ($idx3 -lt $modulesList.Count) { $modulesList[$idx3] } else { $null }
    
    $plainLines.Add("      ┋     " + (Get-FormattedRow $c1 $c2 $c3 $mod_w1_name $mod_w1_ver $mod_w2_name $mod_w2_ver $mod_w3_name $mod_w3_ver))
}
$plainLines.Add("      ┋     ╰$modBottomDashes╯")

# Spacer and Footer lines
$plainLines.Add("      ┋")
if ($templateLines.Count -ge 45) {
    for ($i = 42; $i -lt 45; $i++) {
        $plainLines.Add($templateLines[$i])
    }
} else {
    $plainLines.Add("  ┌───┴───┐")
    $plainLines.Add("  ▙ Shell ▟")
    $plainLines.Add(" ─── ─ ••• ─ ─ ─────────────────────")
}

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
    
    $hasColoredVInfo = $false
    $hasColoredV1 = $false
    $hasColoredV2 = $false
    $hasColoredV3 = $false
    
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
                if ($x -eq 36 -or $x -eq (36 + $infoW + 15)) {
                    # Keep border gradient
                }
                # Name area (index 38 to 49)
                elseif ($x -ge 38 -and $x -le 49) {
                    $isOverridden = $true
                    $overrideColor = Get-NameColorChar -idx ($x - 38) -length 12
                }
                # Version area (index 50 to 50 + $infoW - 1)
                elseif ($x -ge 50 -and $x -le (50 + $infoW - 1)) {
                    $isOverridden = $true
                    if ($c -eq ' ') {
                        [void]$sb.Append($c)
                        continue
                    } elseif ($c -eq 'v' -and -not $hasColoredVInfo) {
                        $hasColoredVInfo = $true
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
        elseif ($y -ge 15 -and $c -ne ' ' -and $plainLines[$y] -like "*│*") {
            $isBinRow = ($y -ge 16 -and $y -le 22)
            
            $w1_n = if ($isBinRow) { $bin_w1_name } else { $mod_w1_name }
            $w1_v = if ($isBinRow) { $bin_w1_ver } else { $mod_w1_ver }
            $w2_n = if ($isBinRow) { $bin_w2_name } else { $mod_w2_name }
            $w2_v = if ($isBinRow) { $bin_w2_ver } else { $mod_w2_ver }
            $w3_n = if ($isBinRow) { $bin_w3_name } else { $mod_w3_name }
            $w3_v = if ($isBinRow) { $bin_w3_ver } else { $mod_w3_ver }
            
            $del1 = 2 + $w1_n + $w1_v + 1
            $del2 = $del1 + $w2_n + $w2_v + 3
            $del3 = $del2 + $w3_n + $w3_v + 3
            
            $xo = $x - 12
            
            # Delimiters
            if ($xo -eq 0 -or $xo -eq $del1 -or $xo -eq $del2 -or $xo -eq $del3) {
                # Keep border gradient
            }
            # Column 1 Name
            elseif ($xo -ge 2 -and $xo -le (2 + $w1_n - 1)) {
                $isOverridden = $true
                $overrideColor = Get-NameColorChar -idx ($xo - 2) -length $w1_n
            }
            # Column 1 Version
            elseif ($xo -ge (2 + $w1_n) -and $xo -le (2 + $w1_n + $w1_v - 1)) {
                $isOverridden = $true
                if ($c -eq ' ') {
                    [void]$sb.Append($c)
                    continue
                } elseif ($c -eq 'v' -and -not $hasColoredV1) {
                    $hasColoredV1 = $true
                    [void]$sb.Append("$esc[95mv$esc[0m")
                    continue
                } else {
                    [void]$sb.Append("$esc[3;90m$c$esc[0m")
                    continue
                }
            }
            # Column 2 Name
            elseif ($xo -ge ($del1 + 2) -and $xo -le ($del1 + 2 + $w2_n - 1)) {
                $isOverridden = $true
                $overrideColor = Get-NameColorChar -idx ($xo - ($del1 + 2)) -length $w2_n
            }
            # Column 2 Version
            elseif ($xo -ge ($del1 + 2 + $w2_n) -and $xo -le ($del1 + 2 + $w2_n + $w2_v - 1)) {
                $isOverridden = $true
                if ($c -eq ' ') {
                    [void]$sb.Append($c)
                    continue
                } elseif ($c -eq 'v' -and -not $hasColoredV2) {
                    $hasColoredV2 = $true
                    [void]$sb.Append("$esc[95mv$esc[0m")
                    continue
                } else {
                    [void]$sb.Append("$esc[3;90m$c$esc[0m")
                    continue
                }
            }
            # Column 3 Name
            elseif ($xo -ge ($del2 + 2) -and $xo -le ($del2 + 2 + $w3_n - 1)) {
                $isOverridden = $true
                $overrideColor = Get-NameColorChar -idx ($xo - ($del2 + 2)) -length $w3_n
            }
            # Column 3 Version
            elseif ($xo -ge ($del2 + 2 + $w3_n) -and $xo -le ($del2 + 2 + $w3_n + $w3_v - 1)) {
                $isOverridden = $true
                if ($c -eq ' ') {
                    [void]$sb.Append($c)
                    continue
                } elseif ($c -eq 'v' -and -not $hasColoredV3) {
                    $hasColoredV3 = $true
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
