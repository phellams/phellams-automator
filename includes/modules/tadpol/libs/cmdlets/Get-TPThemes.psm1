
using module ..\tadpol_lib.psm1

Function Get-TPThemes {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $false,
            #ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )] [string[]]$type
    )
 
    BEGIN {
        if($null -eq $type -or $type -eq '') { $type = 'all' }
    }
 
    PROCESS {

        switch ($type ){
            'bars' { 
                [console]::write("-----[$(csole -s "Theme Type" -c "yellow")] | <Bars>`n")
                (New-Object tadpol).themeBars()  | Format-Table theme,open,close,completed,incomplete,pointer,themepath,example -autosize -Wrap
                    }
            'loaders' { 
                [console]::write("-----[$(csole -s "Theme Type" -c "yellow")] | <Loaders>`n")
                (New-Object tadpol).themeloaders() | 
                    select-object @{ Name="Theme"; Expression={"$(csole -s "$($_.Theme)" -c "yellow")"}},levels,ThemePath |
                    Format-Table -autosize -Wrap
            }
            'all' { 
                
                [console]::write("-----[$(csole -s "Theme Type" -c "yellow")] | <Bars>`n")
                (New-Object tadpol).themeBars()  | Format-Table theme,open,close,completed,incomplete,pointer,themepath,example -autosize -Wrap
                
                [console]::write("-----[$(csole -t "Theme Type" -c "yellow")] | <Loaders>`n")
                (New-Object tadpol).themeloaders() | 
                    select-object @{ Name="Theme"; Expression={"$(csole -s "$($_.Theme)" -c "yellow")"}},levels,ThemePath |
                    Format-Table -autosize -Wrap
            }
        }     

    }

    END {

    }
}
Export-ModuleMember -Function Get-TPThemes