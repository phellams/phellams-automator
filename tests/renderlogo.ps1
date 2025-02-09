using module G:\devspace\projects\powershell\_repos\colorconsole\libs\cmdlets\New-ColorConsole.psm1 

# Alter logo
# ----------
$logo = Get-Content -Path .\resources\acsiilogo.txt -Raw
$logo = $logo -replace "X", "$(csole -s "○" -c green)" 
$logo = $logo -replace "•", "$(csole -s "•" -c blue)"
$logo = $logo -replace "○", "$(csole -s "○" -c magenta)"
$logo = $logo -replace "\.\.", "$(csole -s ".." -c darkcyan)"
$logo = $logo -replace "\[--]", "$(csole -s "[--]" -c magenta)"

# Alter info area
# ---------------
$logo = $logo -replace "INFO", "$(csole -s "INFO" -c yellow)"
$logo = $logo -replace "BINARIES", "$(csole -s "BINARIES" -c magenta)"
$logo = $logo -replace "MODULES", "$(csole -s "MODULES" -c magenta)"
$logo = $logo -replace "SCRIPTS", "$(csole -s "SCRIPTS" -c magenta)"

# template Biniary Versions
# -------------------------
$logo = $logo -replace "pwsh", "$(csole -s "pwsh" -c green)"

#  - Get Versions
$Distro_release = lsb_release --all | select-string -pattern "Description"
$pwsh_version = $PSVersionTable.PSVersion.ToString()
$dotnet_version = (dotnet --info | Select-String -Pattern "version") -replace "Version:","" -replace " ",""
$nuget_version = (nuget help | Select-Object -First 1) -replace "NuGet Version:","" -replace " ",""

# - Update Versions
$logo = $logo -replace "[pwsh-version]", "$(csole -s $pwsh_version -c Yellow)"
$logo = $logo -replace "[dotnet-version]", "$(csole -s $dotnet_version -c magenta)"
$logo = $logo -replace "[nuget-version]", "$(csole -s $nuget_version -c magenta)"
$logo = $logo -replace "[base-distro-release]", "$(csole -s $Distro_release -c magenta)"

$logo 