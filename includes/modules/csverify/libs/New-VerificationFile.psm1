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
   
    [console]::write("-─◉ generating new verification file $($global:_csverify.prop.invoke($rootpath))`n")
    
    $rootpath = $(Get-ItemProperty $rootpath).FullName
    $outPath = $(Get-ItemProperty $OutputPath).FullName
   
    New-CheckSum -Path $rootpath | Out-File -FilePath "$outPath\verification.txt" -Encoding utf8
    
    [console]::write("  └─◉ $(Get-ColorTune -Text "verification file created" -color green) $($global:_csverify.prop.invoke("$outPath\verification.txt"))`n")
    
    Read-CheckSum -File "$outPath\verification.txt"
}
Export-ModuleMember -Function New-VerificationFile