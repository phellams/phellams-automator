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

$global:__shelldock = @{                                                                         
    rootpath    = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
    utility =  @{
        logname   = "[$(csole -s '+' -c darkmagenta)] $(csole -s ShellDock -c yellow) $(csole -s '→' -c cyan )"
        sublog    = "$(" " * 4) $(csole -s '•' -c darkmagenta) "
    }
    kvtinc                 = {
        <#
            Hashtable function
            ------------------
            Key Value in color with value type
            Returns a string representation of a key value pair wrapped in ASCII color codes denoting the key and valuetype.
        #>
        param([string]$keyName, [string]$KeyValue, [string]$valueType)
        [string]$kvtStringRep = ''
        $kvtStringRep += "$(csole -s '{' -c magenta) "
        $kvtStringRep += "key-($(csole -s $keyName -c cyan)) : "
        $kvtStringRep += "value-(type-($(csole -s $valueType -c yellow))[$(csole -s $KeyValue -c gray)]) "
        $kvtStringRep += "$(csole -s '}' -c magenta)"   
        return $kvtStringRep
    }
    kvinc                  = {
        <#
            Hashtable function
            ------------------
            Key Value in color
            Returns a string representation of a key value pair wrapped in ASCII color codes
        #>
        param([string]$keyName, [string]$KeyValue)
        return "$(csole -s '{' -c magenta) $(csole -s $keyName -c cyan) : $(csole -s $KeyValue -c gray) $(csole -s '}' -c magenta)"
    }
    kvoinc                 = {
        <#
            Hashtable function
            ------------------
            Key Value object in color
            Returns a string representation of a key value pair ordered array 
            from pscustomobject wrapped in ASCII color codes
            PSCustomObject is used to retain ordering.
        #>
        param([PSCustomObject]$object)
        [string]$kvaToStringRep = ""
        $kvaToStringRep += "$(csole -s '{' -c magenta) "
        
        foreach ($key in $object.psobject.properties.where({ $_.MemberType -eq 'NoteProperty' })) {
            $kvaToStringRep += "$(csole -s $key.name -c cyan) : $(csole -s $key.value -c gray); "
        }
        
        $kvaToStringRep += "$(csole -s '}' -c magenta)"
        return $kvaToStringRep
    }
}


$cmdlet_config = @{
    function = @(
        "New-ShellDock"
    )
    alias = @(
        "shelldock"
    )
}

Export-ModuleMember @cmdlet_config