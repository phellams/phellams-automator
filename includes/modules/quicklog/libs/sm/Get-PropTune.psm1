<#  -------------------------------------------------------------------------------------------------------
/** ******************************************************************************************************* 
#!   NAME--------: proptune
##   AUTHER------: sgkens | davilion
#!   VERSION-----: 0.1
#?   DESCRIPTION-: Wrapper function for ConvertFrom-StringData parses `n \\ , and returns hastable              
*?   DEPENDANCIES:              
##   BUILD ENV---: BUILD: Powershellcore 7.3.1
*?   LICENCE-----: MIT
*********************************************************************************************************#>
function Get-PropTune( ) {
    [CmdletBinding()]
    [OutputType([hashtable])]
    [Alias('pt')]
    param(
        [parameter(Mandatory = $true, Position = 0)]
        [string]$StringData
    )
    Begin{
        $stringdata= $stringdata -replace "\\", "/"
        $formatted_stringdata = $stringdata -replace ','," `n "
    }
    process{
        $hashedtdata = [ordered]@{}
        $hashedtdata = ConvertFrom-StringData -StringData $formatted_stringdata
        return $hashedtdata
    }
}