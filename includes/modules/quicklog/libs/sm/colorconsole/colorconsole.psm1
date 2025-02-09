using module libs\cmdlets\New-ColorConsole.psm1
using module libs\cmdlets\Write-Color.psm1

$global:_colorconsole = @{
    rootpath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
}

# ===============================================================
#  Module Exports
# ===============================================================
$members = @{
    function = @(
        "New-ColorConsole",
        "Write-Color"
    )
    alias = @(
        "csole",
        "wsole"
    )
}

Export-ModuleMember @members