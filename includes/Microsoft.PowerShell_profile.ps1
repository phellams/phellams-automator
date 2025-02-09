# Standalone modules
#using module /root/.config/powershell/Get-CII.psm1

# Define Modules
# By default in linux modules are installed in /usr/.local/share/powershell/Modules
import-module -Name Pester -RequiredVersion 5.5.0
import-module -Name PSScriptAnalyzer
import-module -Name powershell-yaml
import-module -Name colorconsole
import-module -Name gitautoversion
import-module -Name csverify
import-module -name quicklog
import-module -name psmpacker
import-module -Name nupsforge


# Define functions
function gmv($name) {
    [string]$version_prerelease
    $moduleInfo = Get-Module -Name $name
    if ($moduleInfo.PrivateData.PSData.Prerelease) {
        $version_prerelease = "-$($moduleInfo.PrivateData.PSData.Prerelease)"
    }
    $major = $moduleInfo.Version.Major.ToString().trim()
    $minor = $moduleInfo.Version.Minor.ToString().trim()
    $patch = $moduleInfo.Version.Build.ToString().trim()

    return  "v$major.$minor.$patch$version_prerelease"
}


# Alter logo
# ----------
$logo = Get-Content -Path /root/.config/powershell/acsiilogo-template.txt -Raw
$logo = $logo -replace "X", "$(csole -s "x" -c green)" `
              -replace "■", "$(csole -s "■" -c cyan)" `
              -replace "▣", "$(csole -s "▣" -c magenta)" `
              -replace "▣", "$(csole -s "▣" -c magenta)" `
              -replace "\.\.", "$(csole -s ".." -c darkcyan)" `
              -replace "✜", "$(csole -s "✜" -c darkyellow)" `
              -replace "✜", "$(csole -s "✜" -c darkyellow)"

# Alter info area
# ---------------
$logo = $logo -replace "INFO", "$(csole -s "INFO" -c yellow)" `
              -replace "BINARIES", "$(csole -s "BINARIES" -c yellow)" `
              -replace "MODULES", "$(csole -s "MODULES" -c yellow)" `
              -replace "SCRIPTS", "$(csole -s "SCRIPTS" -c yellow)"

# template Biniary Versions
# -------------------------
#$logo = $logo -replace "pwsh", "$(csole -s "pwsh" -c green)"

#  - Get Versions
[string]$distro_release = (lsb_release --all | select-string -pattern "Description") -replace "Description:", ""
[string]$dotnet_version = (dotnet --info | Select-String -Pattern "Version:" | Select-Object -first 1) -replace "Version:", ""
[string]$nuget_version = (nuget help | Select-Object -First 1) -replace "NuGet Version:", ""
[string]$Kernel_version = (uname -rov)

$pwsh_version = $PSVersionTable.PSVersion.ToString()

# - Update Versions
$logo = $logo -replace "\[pwsh-version\]", "$(csole -s "$pwsh_version" -c yellow)" `
              -replace "\[dotnet-version\]", "$(csole -s "$($dotnet_version.Trim())" -c yellow)" `
              -replace "\[nuget-version\]", "$(csole -s "$($nuget_version.Trim())" -c yellow)" `
              -replace "\[base-distro-release\]", "$(csole -s "$($distro_release.Trim())" -c yellow)" `
              -replace "\[colorconsole-version\]", "$(csole -s "$(gmv('colorconsole'))" -c yellow)" `
              -replace "\[gitautoversion-version\]", "$(csole -s "$(gmv('gitautoversion'))" -c yellow)" `
              -replace "\[kernel-version\]", "$(csole -s "$Kernel_version" -c yellow)" `
              -replace "\[pester-version\]", "$(csole -s "$(gmv('Pester'))" -c yellow)" `
              -replace "\[psscriptanalyzer-version\]", "$(csole -s "$(gmv('PSScriptAnalyzer'))" -c yellow)" `
              -replace "\[powershell-yaml-version\]", "$(csole -s "$(gmv('powershell-yaml'))" -c yellow)" `
              -replace "\[csverify-version\]", "$(csole -s "$(gmv('csverify'))" -c yellow)" `
              -replace "\[quicklog-version\]", "$(csole -s "$(gmv('quicklog'))" -c yellow)" `
              -replace "\[psmpacker-version\]", "$(csole -s "$(gmv('psmpacker'))" -c yellow)" `
              -replace "\[nupsforge-version\]", "$(csole -s "$(gmv('nupsforge'))" -c yellow)"

#output final logo
$logo 