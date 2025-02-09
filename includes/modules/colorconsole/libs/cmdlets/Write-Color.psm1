Function Write-Color() {
    [CmdletBinding()]
    [Alias('wsole')]
    [OutputType([void])]
    param(
        [parameter(mandatory = $true, Position = 0)]
        [string]$string,
        [parameter(mandatory = $false, Position = 1)]
        [ValidateSet(
            "blue",
            "yellow",
            "green",
            "red",
            "white",
            "black",
            "cyan",
            "magenta",
            "gray",
            "darkgray",
            "darkblue",
            "darkyellow",
            "darkgreen",
            "darkred",
            "darkcyan",
            "darkmagenta", ignorecase = $true)]
        $color = "white",
        [parameter(mandatory = $false)]
        [ValidateSet(
            "blue",
            "yellow",
            "green",
            "red",
            "white",
            "black",
            "cyan",
            "magenta",
            "gray",
            "darkgray",
            "darkblue",
            "darkyellow",
            "darkgreen",
            "darkred",
            "darkcyan",
            "darkmagenta", ignorecase = $true)]
        $bgcolor = "black"
    )
    Begin{
        if($null -eq $bgcolor){
            $coloredText = New-ColorConsole -string $string -color $color
        }else{
            $coloredText = New-ColorConsole -string $string -color $color -bgcolor $bgcolor
        }
    }
    Process{
        if($nl){
            [Console]::Write("$($coloredText)`n")
        }else{
            [Console]::Write($coloredText)
        }
    }
}