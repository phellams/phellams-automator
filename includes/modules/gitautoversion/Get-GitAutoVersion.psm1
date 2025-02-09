using namespace System.Text.RegularExpressions
<#
.SYNOPSIS

Generates and return SemVer Version number and return it as a Pscustomobject

.DESCRIPTION

Generates and return SemVer Version number and return it as a Pscustomobject

.PARAMETER Branch

branch name to use for versioning, your release branch

.EXAMPLE

Get-GitAutoVersion | Select Version

(Get-GitAutoVersion).Version

.INPUTS
None

.OUTPUTS [PsCustomObject]

#>
Function Get-GitAutoVersion {
    [CmdletBinding()]
    [OutputType([Pscustomobject])]
    [Alias('cfav')]
    param ()
    begin {
        if(!$branch){ $branch = "main" }
    }
    process {
        [int]$major =  0
        [int]$minor =  1
        [int]$patch =  0

        try {
            # Check for git installation
            if ($null -eq (Get-Command git -ErrorAction SilentlyContinue)) {
                throw "Git is not installed, please install git and try again"
            }
            else {

                $gitCommits = git log --pretty=format:"%s%n%b"

                for($l=$gitcommits.count -1; $l -gt 0; $l--) {
                    if ([regex]::Matches($gitCommits[$l], "Build: major", [RegexOptions]::IgnoreCase)) {
                        $major++
                        $patch = 0
                        $minor = 0
                    }
                    if ([regex]::Matches($gitCommits[$l], "Build: minor", [RegexOptions]::IgnoreCase)) {
                        $minor++
                        $patch = 0
                    }
                    if ([regex]::Matches($gitCommits[$l], "Build: patch", [RegexOptions]::IgnoreCase)) {
                        $patch++
                    }
                }
                return [PSCustomObject]@{ 
                    Version="$major.$minor.$patch";
                    ParsedLines = "$($gitCommits.count.tostring())" 
                }
            }
        }
        catch [System.Exception] {
            Write-Host "An error occurred while creating AutoVersion Number: $($_.Exception.Message)"
            # You can handle the exception here or rethrow it if needed
        }
    }
}

$cmdlet_config = @{
    function = @('Get-GitAutoVersion')
    alias    = @('cfav')
}

Export-ModuleMember @cmdlet_config
