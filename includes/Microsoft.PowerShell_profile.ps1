# Load the opt-in detailed environment report.
$aboutScriptPath = [System.IO.Path]::Combine(
    $HOME,
    '.config',
    'powershell',
    'scripts',
    'Get-About.ps1'
)
if (-not [System.IO.File]::Exists($aboutScriptPath)) {
    $aboutScriptPath = [System.IO.Path]::Combine(
        [System.IO.Path]::GetDirectoryName($PSScriptRoot),
        'scripts',
        'Get-About.ps1'
    )
}
. $aboutScriptPath

# Resolve the same registry used by Get-About without rendering the full
# report. The registry is local to the function and must be requested explicitly.
$resolvedVersions = try { Get-About -ReturnVersions } catch { [ordered]@{} }

# Keep startup and CI logs compact. The detailed ASCII report is available via
# Get-About (or its About alias).
$minimalLogoPath = [System.IO.Path]::Combine(
    $HOME,
    '.config',
    'powershell',
    'asciilogo-minimal.txt'
)
if (-not [System.IO.File]::Exists($minimalLogoPath)) {
    $minimalLogoPath = [System.IO.Path]::Combine($PSScriptRoot, 'asciilogo-minimal.txt')
}

$automatorVersion = 'Unknown'
$versionPath = [System.IO.Path]::Combine($HOME, '.config', 'powershell', 'VERSION')
if (-not [System.IO.File]::Exists($versionPath)) {
    $versionPath = [System.IO.Path]::Combine(
        [System.IO.Path]::GetDirectoryName($PSScriptRoot),
        'VERSION'
    )
}
if ([System.IO.File]::Exists($versionPath)) {
    $automatorVersion = [System.IO.File]::ReadAllText($versionPath).Trim()
}

if ([System.IO.File]::Exists($minimalLogoPath)) {
    $minimalLogo = [System.IO.File]::ReadAllText($minimalLogoPath)
    $minimalLogo = $minimalLogo.Replace('[automator-version]', $automatorVersion)

    # The product title uses xterm-256 light blue (117) with bold emphasis.
    # ColorConsole provides the named cyan/darkgray styles used below.
    $esc = [char]27
    $title = "${esc}[1;38;5;117mPHELLAMS AUTOMATOR${esc}[0m"
    $minimalLogo = $minimalLogo.Replace('PHELLAMS AUTOMATOR', $title)

    # Get-About resolves these values once when the profile dot-sources it.
    # Strip the detailed report's leading v for compact binary/module entries.
    $profileBinaries = [ordered]@{
        pwsh = 'pwsh'; dotnet8 = 'dotnet8'; dotnet10 = 'dotnet10'; nuget = 'nuget'
        codecov = 'codecov'; coveralls = 'coveralls'; git = 'git'; ruby = 'ruby'
        rubygems = 'rubygems'; go = 'go'; rust = 'rust'; elixir = 'elixir'
        erlang = 'erlang'; node = 'node'; npm = 'npm'; pnpm = 'pnpm'; yarn = 'yarn'
        bun = 'bun'; hugo = 'hugo'; sass = 'sass'; dart = 'dart'; php = 'php'
        composer = 'composer'; jq = 'jq'; yq = 'yq'; inkscape = 'inkscape'
        magick = 'magick'; photino = 'photino'
    }

    $binaryValues = [System.Collections.Generic.List[string]]::new()
    foreach ($binaryKey in $profileBinaries.Keys) {
        $binaryVersion = if ($resolvedVersions.Contains($binaryKey)) { $resolvedVersions[$binaryKey] } else { 'Unknown' }
        if ([string]::IsNullOrWhiteSpace($binaryVersion)) { $binaryVersion = 'Unknown' }
        $binaryVersion = $binaryVersion -replace '^v', ''
        $binaryName = try {
            New-ColorConsole -string $profileBinaries[$binaryKey] -color cyan
        } catch {
            $profileBinaries[$binaryKey]
        }
        $binaryValue = try {
            New-ColorConsole -string $binaryVersion -color darkgray
        } catch {
            $binaryVersion
        }
        [void]$binaryValues.Add("$binaryName $binaryValue")
    }

    $profileModules = [ordered]@{
        Pester = 'pester'; PSScriptAnalyzer = 'psscriptanalyzer'; 'PowerShell-Yaml' = 'powershell-yaml'
        ColorConsole = 'colorconsole'; Quicklog = 'quicklog'; Nupsforge = 'nupsforge'
        Psmpacker = 'psmpacker'; Csverify = 'csverify'; ShellDock = 'shelldock'; TadPol = 'tadpol'
        PHWriter = 'phwriter'; CCVersion = 'conventionalcommitversion'; GitAutoVersion = 'gitautoversion'
    }

    $moduleValues = [System.Collections.Generic.List[string]]::new()
    foreach ($moduleName in $profileModules.Keys) {
        $moduleKey = $profileModules[$moduleName]
        $moduleVersion = if ($resolvedVersions.Contains($moduleKey)) { $resolvedVersions[$moduleKey] } else { 'Unknown' }
        if ([string]::IsNullOrWhiteSpace($moduleVersion)) { $moduleVersion = 'Unknown' }
        $moduleVersion = $moduleVersion -replace '^v', ''
        $moduleTitle = try {
            New-ColorConsole -string $moduleName -color cyan
        } catch {
            $moduleName
        }
        $moduleValue = try {
            New-ColorConsole -string $moduleVersion -color darkgray
        } catch {
            $moduleVersion
        }
        [void]$moduleValues.Add("$moduleTitle $moduleValue")
    }

    $minimalLogo = $minimalLogo.Replace('[binary-versions]', ($binaryValues -join ', '))
    $minimalLogo = $minimalLogo.Replace('[module-versions]', ($moduleValues -join ', '))
    [Console]::WriteLine($minimalLogo.TrimEnd())
}
