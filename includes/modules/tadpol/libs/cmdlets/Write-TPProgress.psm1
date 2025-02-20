
using module ..\tadpol_lib.psm1
Function Write-TPProgress {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $false,
            #ValueFromPipeline = $true,
            #ValueFromPipelineByPropertyName = $true,
            Position = 0
        )]
        [long]  $Count,
        [Parameter(
            Mandatory = $false,
            #ValueFromPipeline = $true,
            #ValueFromPipelineByPropertyName = $true,
            Position = 1
        )]
        [long]  $Total,
        [Parameter(
            Mandatory = $false,
            #ValueFromPipeline = $true,
            #ValueFromPipelineByPropertyName = $true,
            Position = 2
        )] [int]$BarLength,
        [Parameter(
            Mandatory = $false,
            #ValueFromPipeline = $true,
            #ValueFromPipelineByPropertyName = $true,
            Position = 3
        )] [string[]]$theme,
        [Parameter(
            Mandatory = $false,
            #ValueFromPipeline = $true,
            #ValueFromPipelineByPropertyName = $true,
            Position = 4
        )] [string]$Status,
        [Parameter(
            Mandatory = $false,
            #ValueFromPipeline = $true,
            #ValueFromPipelineByPropertyName = $true,
            Position = 5
        )]
        [validateset(
            'Black', 
            'DarkGray', 
            'Gray', 
            'DarkRed', 
            'Red', 
            'DarkGreen', 
            'Green', 
            'DarkYellow', 
            'Yellow', 
            'DarkBlue', 
            'Blue', 
            'DarkMagenta', 
            'Magenta',
            'DarkCyan',
            'Cyan',
            'White'
        )] 
        [string]$color
    )
    PROCESS {
        (New-Object tadpol).progress($Count, $Total, $BarLength, $Theme, $Status, $color)
    }
}
Export-ModuleMember -Function Write-TPProgress