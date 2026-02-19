using module .\modules\colortune\Get-ColorTune.psm1
using module .\Read-CheckSum.psm1
using module .\New-CheckSum.psm1

Function New-VerificationFile {
    [cmdletbinding()]
    [OutputType("pscustomobject")]
    param(
        [Parameter(Mandatory=$false,position=0)]
        [String]$rootpath,
        [Parameter(Mandatory=$false, position=1)]
        [String]$OutputPath
    )
   
    [console]::write("-─◉ generating new VERIFICATION file $($global:_csverify.prop.invoke($rootpath))`n")
    
    $rootpath = $(Get-ItemProperty $rootpath).FullName
    $outPath = $(Get-ItemProperty $OutputPath).FullName

    # Check if file exists if it does, delete it and create a new one with the same name and path
    if (Test-Path -Path "$OutputPath\VERIFICATION.txt") {
        [console]::write("  └─◉ $(Get-ColorTune -Text "VERIFICATION file already exists" -color yellow) $($global:_csverify.prop.invoke("$OutputPath\VERIFICATION.txt"))`n")
        [console]::write("     └─◉ deleting existing VERIFICATION file...`n")
        Remove-Item -Path "$OutputPath\VERIFICATION.txt" | Out-Null
    }
   
    New-CheckSum -Path $rootpath | Out-File -FilePath "$outPath\VERIFICATION.txt" -Encoding utf8
    
    [console]::write("  └─◉ $(Get-ColorTune -Text "VERIFICATION file created" -color green) $($global:_csverify.prop.invoke("$outPath\VERIFICATION.txt"))`n")
    
    Read-CheckSum -File "$outPath\VERIFICATION.txt"
}
Export-ModuleMember -Function New-VerificationFile