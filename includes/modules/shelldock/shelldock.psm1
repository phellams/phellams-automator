using module libs\cmdlets\New-ShellDock.psm1

<#
     _____ __         ________             __  
    / ___// /_  ___  / / / __ \____  _____/ /__
    \__ \/ __ \/ _ \/ / / / / / __ \/ ___/ //_/
&  ___/ / / / /  __/ / / /_/ / /_/ / /__/ ,<
* /____/_/ /_/\___/_/_/_____/\____/\___/_/|_| Powerhell RunSpace Wrapper
----------------------------------------o #>

# -- Depandencies
# • quicklog
# • tadpol
# • colorconsole

$logobjects = @{
    logname   = "[$(csole -s '+' -c darkmagenta)] $(csole -s 'ShellDock' -c yellow) $(csole -s '→' -c cyan )"
    sublog    = "$(" " * 4) $(csole -s '•' -c darkmagenta) "
}


$global:_shelldock = @{                                                                         
    rootpath    = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
    kvstring    = {
        param([string]$key, [string]$value)
        return "$(csole -s '{' -c magenta) $(csole -s $key -c cyan) : $(csole -s $value -c gray) $(csole -s '}' -c magenta)"
    }
    ui = $logobjects
}


$cmdlet_config = @{
    function = @(
        "New-ShellDock"
    )
    alias = @(
        "sdock"
    )
}

Export-ModuleMember @cmdlet_config