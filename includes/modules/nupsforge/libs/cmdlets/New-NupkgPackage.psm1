using module ..\shelldock\New-ShellDock.psm1

<#
.SYNOPSIS
    A function that creates a new .nupkg package from a .nuspec file.

.DESCRIPTION
    The New-NupkgPackage function generates a .nupkg package from a .nuspec file. 
    It takes in parameters such as the path of the .nuspec file and the output path for the .nupkg package. 
    It checks for the existence of a single .nuspec file in the specified path, reads its content, 
    and uses the NuGet package manager to create a .nupkg package. 

.PARAMETER Path
    The path where the .nuspec file is located.

.PARAMETER OutPath
    The path where the .nupkg package will be created.

.EXAMPLE
    New-NupkgPackage -Path "C:\MyModule\MyModule.nuspec" -OutPath "C:\MyModule\Output"

    This will create a .nupkg package from the .nuspec file located at "C:\MyModule\MyModule.nuspec" and output it to "C:\MyModule\Output".
#>

Function New-NupkgPackage() {
    #create nupkg package from nuspec file
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$OutPath,
        [Parameter(Mandatory = $false)]
        [string]$prerelease
    )
    begin{
        $rootpath = (Get-itemProperty -Path $Path).FullName
        $exportPath = (Get-itemProperty -Path $OutPath).FullName 
    }
    process{
        try{
            # Check for nuspec file in root dir or check for more than one nuspec file in root dir
            if ((Get-ChildItem $Path -Filter "*.nuspec").count -eq 0 ) { throw [System.Exception] "No nuspec file found in $rootpath"; }
            elseif ((Get-ChildItem $Path -Filter "*.nuspec").count -gt 1 ) { throw [System.Exception] "More than one nuspec file found in $rootpath"; }
            
            if (!([xml]$nuspecfile = Get-Content -Path "$rootpath\*.nuspec")) {
                throw [System.Exception]::new("Failed to read nuspec file $rootpath\*.nuspec", "nuget.ex not function PATH System variable"); 

                break;
            }
            Write-QuickLog -Message "[{ct:magenta:nuget}]|-@{pt:{run=pack}} @{pt:{Package=$($nuspecfile.package.metadata.id)}} @{pt:{Version=$($nuspecfile.package.metadata.version)}}" `
                            -Name $global:LOGTASTIC_MOD_NAME `
                            -Type "action"
            Write-QuickLog -Message "Creating {ct:magenta:nupkg} package from {ct:magenta:nuspec} file" -Name $global:LOGTASTIC_MOD_NAME -Type "action" -Submessage      
            Write-QuickLog -Message "Checking {ct:yellow:nuget} Package Manager" -Name $global:LOGTASTIC_MOD_NAME -Type "info" -Submessage


            $nuget = Get-Command -Name nuget -ErrorAction SilentlyContinue
            if ($nuget.source.length -eq 0) { 
                throw [System.Exception]::new("Nuget package manager not found @{pt:{DownloadFrom=https://www.nuget.org/downloads}}", "nuget.ex not function PATH System variable"); 
            }
            Write-QuickLog -Message "Done" -Name $global:LOGTASTIC_MOD_NAME -Type "complete" -Submessage
        }
        catch [System.Exception] {
            Write-QuickLog -Message "$($_.Exception.Message)" -Name $global:LOGTASTIC_MOD_NAME -Type "Error" -submessage
        }
        Write-QuickLog -Message "[{ct:green:PackPackage}]" -Name $global:LOGTASTIC_MOD_NAME -Type "action" -submessage
        $PackageName = "$($nuspecfile.package.metadata.id).$($nuspecfile.package.metadata.version)-$prerelease.nupkg"
        New-ShellDock -Ql -ScriptBlock {
            nuget pack -build $args.rootpath -OutputDirectory $args.exportPath
        } -Arguments (
            [PSObject]@{
                rootpath = $rootpath; 
                exportPath = $exportPath 
            }
        )
        
        # - TotalProcessorTime : 00:00:00.6250000
        # - id : 26036
        Write-QuickLog -Message "response -OutputDirectory $exportPath" -Name $global:LOGTASTIC_MOD_NAME -Type "Success" -Submessage
        Write-QuickLog -Message "Nupkg Package created" -Name $global:LOGTASTIC_MOD_NAME -Type "Success"
        Write-QuickLog -Message "@{pt:{package=$exportPath`\$PackageName}}" -Name $global:LOGTASTIC_MOD_NAME -Type "Complete" -Submessage
        Write-QuickLog -Message "Complete" -Name $global:LOGTASTIC_MOD_NAME -Type "Complete"
    }
}
Export-ModuleMember -Function New-NupkgPackage
