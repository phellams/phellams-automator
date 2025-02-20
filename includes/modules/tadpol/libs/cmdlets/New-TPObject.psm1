using module ..\tadpol_lib.psm1
Function New-TPObject(){
    [CmdletBinding()]
    param()
    process{ 
        <# Return an instance of tadpol #>
        return New-Object tadpol
    }

}
Export-ModuleMember -Function New-TPObject