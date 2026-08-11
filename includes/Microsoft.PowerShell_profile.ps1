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
    $minimalLogo = $minimalLogo.Replace('[pwsh-version]', $PSVersionTable.PSVersion.ToString())
    [Console]::WriteLine($minimalLogo.TrimEnd())
}
