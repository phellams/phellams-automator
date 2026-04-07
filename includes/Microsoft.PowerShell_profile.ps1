# Standalone modules
#using module /root/.config/powershell/Get-CII.psm1

# Define Modules
# By default in linux modules are installed in /usr/.local/share/powershell/Modules
import-module -Name Pester -RequiredVersion 5.7.1
import-module -Name PSScriptAnalyzer
import-module -Name powershell-yaml
import-module -Name colorconsole
import-module -name tadpol
import-module -name shelldock
import-module -Name gitautoversion
import-module -Name csverify
import-module -name quicklog
import-module -name psmpacker
import-module -Name nupsforge
import-module -name phwriter


# # Define functions
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

# Load Template
[string]$logo = [System.IO.File]::ReadAllText("/root/.config/powershell/acsiilogo-template.txt")

# Get Versions
[string]$distro_release = try { (lsb_release --all 2>$null | select-string -pattern "Description" | Out-String).Trim() -replace "Description:", "" } catch { "Unknown" }
[string]$dotnet_version = try { (dotnet --version 2>$null | Out-String).Trim() } catch { "Unknown" }
[string]$nuget_version = try { (nuget help 2>$null | select-string -pattern "NuGet Version:" | Out-String).Trim() -replace "NuGet Version:", "" } catch { "Unknown" }
[string]$Kernel_version = try { (uname -rov 2>$null | Out-String).Trim() } catch { "Unknown" }
[string]$codecov_version = try { (codecov --version 2>$null | Out-String).Trim() } catch { "Unknown" }
[string]$coveralls_version = try { (coveralls --version 2>$null | Out-String).Trim() } catch { "Unknown" }
[string]$git_version = try { (git --version 2>$null | Out-String).Trim().split(" ")[2] } catch { "Unknown" }
[string]$ruby_version = try { (ruby --version 2>$null | Out-String).Trim() } catch { "Unknown" }
[string]$rubygems_version = try { (gem --version 2>$null | Out-String).Trim() } catch { "Unknown" }
[string]$go_version = try { (go version 2>$null | Out-String).Trim().split(" ")[2] } catch { "Unknown" }
[string]$rust_version = try { (rustc --version 2>$null | Out-String).Trim().split(" ")[1] } catch { "Unknown" }
[string]$elixir_version = "Unknown"
try {
    # Elixir --version outputs multiple lines, we need the one with "Elixir"
    $elixir_raw = (elixir --version 2>$null) | Out-String
    if ($elixir_raw -match "Elixir\s+([\d\.]+)") {
        $elixir_version = $Matches[1]
    }
} catch { $elixir_version = "Unknown" }

$pwsh_version = $PSVersionTable.PSVersion.ToString()
[string]$av = "Unknown"
try { $av = (Get-GitAutoversion 2>$null).Version } catch {}

# Apply Version Replacements
$logo = $logo -ireplace "\[pwsh-version\]", "$(csole -s "v$($pwsh_version.Trim())" -c yellow)"
$logo = $logo -ireplace "\[dotnet-version\]", "$(csole -s "v$($dotnet_version.Trim())" -c yellow)"
$logo = $logo -ireplace "\[nuget-version\]", "$(csole -s "v$($nuget_version.Trim())" -c yellow)"
$logo = $logo -ireplace "\[base-distro-release\]", "$(csole -s "$($distro_release.Trim())" -c yellow)"
$logo = $logo -ireplace "\[colorconsole-version\]", "$(csole -s "$(gmv('colorconsole'))" -c yellow)"
$logo = $logo -ireplace "\[gitautoversion-version\]", "$(csole -s "$(gmv('gitautoversion'))" -c yellow)"
$logo = $logo -ireplace "\[kernel-version\]", "$(csole -s "v$($Kernel_version.Trim())" -c yellow)"
$logo = $logo -ireplace "\[pester-version\]", "$(csole -s "$(gmv('Pester'))" -c yellow)"
$logo = $logo -ireplace "\[psscriptanalyzer-version\]", "$(csole -s "$(gmv('PSScriptAnalyzer'))" -c yellow)"
$logo = $logo -ireplace "\[powerShell-yaml-version\]", "$(csole -s "$(gmv('powershell-yaml'))" -c yellow)"
$logo = $logo -ireplace "\[csverify-version\]", "$(csole -s "$(gmv('csverify'))" -c yellow)"
$logo = $logo -ireplace "\[quicklog-version\]", "$(csole -s "$(gmv('quicklog'))" -c yellow)"
$logo = $logo -ireplace "\[psmpacker-version\]", "$(csole -s "$(gmv('psmpacker'))" -c yellow)"
$logo = $logo -ireplace "\[tadpol-version\]", "$(csole -s "$(gmv('tadpol'))" -c yellow)"
$logo = $logo -ireplace "\[shelldock-version\]", "$(csole -s "$(gmv('shelldock'))" -c yellow)"
$logo = $logo -ireplace "\[codecov-version\]", "$(csole -s "v$($codecov_version.Trim())" -c yellow)"
$logo = $logo -ireplace "\[coveralls-version\]", "$(csole -s "v$($coveralls_version.Trim())" -c yellow)"
$logo = $logo -ireplace "\[git-version\]", "$(csole -s "v$($git_version.Trim())" -c yellow)"
$logo = $logo -ireplace "\[nupsforge-version\]", "$(csole -s "$(gmv('nupsforge'))" -c yellow)"
$logo = $logo -ireplace "\[phwriter-version\]", "$(csole -s "$(gmv('phwriter'))" -c yellow)"
$logo = $logo -ireplace "\[ruby-version\]", "$(csole -s "$($ruby_version.Trim())" -c yellow)"
$logo = $logo -ireplace "\[rubygems-version\]", "$(csole -s "$($rubygems_version.Trim())" -c yellow)"
$logo = $logo -ireplace "\[go-version\]", "$(csole -s "$($go_version.Trim())" -c yellow)"
$logo = $logo -ireplace "\[rust-version\]", "$(csole -s "v$($rust_version.Trim())" -c yellow)"
$logo = $logo -ireplace "\[elixir-version\]", "$(csole -s "v$($elixir_version.Trim())" -c yellow)"
$logo = $logo -ireplace "\[automator-version\]", "$(csole -s "$($av.Trim())" -c yellow)"

# Apply Color Replacements
$logo = $logo -replace "X", "$(csole -s "x" -c green)" `
              -replace "■", "$(csole -s "■" -c cyan)" `
              -replace "▣", "$(csole -s "▣" -c magenta)" `
              -replace "\.\.", "$(csole -s ".." -c darkcyan)" `
              -replace "✜", "$(csole -s "✜" -c darkyellow)" `
              -replace "INFO", "$(csole -s "INFO" -c yellow)" `
              -replace "BINARIES", "$(csole -s "BINARIES" -c yellow)" `
              -replace "MODULES", "$(csole -s "MODULES" -c yellow)" `
              -replace "SCRIPTS", "$(csole -s "SCRIPTS" -c yellow)"

# Output final logo
Write-Host $logo
