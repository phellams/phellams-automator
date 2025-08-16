<#
.SYNOPSIS
    A function that creates a new Chocolatey package from a .nuspec file.

.DESCRIPTION
    The New-ChocoPackage function generates a Chocolatey package from a .nuspec file. 
    It takes in parameters such as the path of the .nuspec file and the output path for the Chocolatey package. 
    It checks for the existence of a single .nuspec file in the specified path, reads its content, 
    and uses the Compress-Archive cmdlet to create a Chocolatey package. 

.PARAMETER Path
    The path where the .nuspec file is located.

.PARAMETER OutPath
    The path where the Chocolatey package will be created.

.EXAMPLE
    New-ChocoPackage -Path "C:\MyPackage\MyPackage.nuspec" -OutPath "C:\MyPackage\Output"

    This will create a Chocolatey package from the .nuspec file located at "C:\MyPackage\MyPackage.nuspec" and output it to "C:\MyPackage\Output".
#>

Function New-ChocoPackage() {
    #create nupkg package from nuspec file
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$OutPath
    )
    begin{
        $rootpath = (Get-itemProperty -Path $Path).FullName
        $exportPath = (Get-itemProperty -Path $OutPath).FullName 
    }
    process {
        try{
            # Check for nuspec file in root dir or check for more than one nuspec file in root dir
            if ((Get-ChildItem $Path -Filter "*.nuspec").count -eq 0 ) { 
                throw [System.Exception] "No nuspec file found in $rootpath"; 
            }
            elseif ((Get-ChildItem $Path -Filter "*.nuspec").count -gt 1 ) { 
                throw [System.Exception] "More than one nuspec file found in $rootpath"; 
            }
            
            if (!([xml]$nuspecfile = Get-Content -Path "$rootpath\*.nuspec")) {
                throw [System.Exception]::new("Failed to read nuspec file $rootpath\*.nuspec", "nuget.ex not function PATH System variable"); 
                break;
            }
            Write-QuickLog -Message "[{ct:magenta:nuget}]|-@{pt:{run=pack}} @{pt:{Package=$($nuspecfile.package.metadata.id)}} @{pt:{Version=$($nuspecfile.package.metadata.version)}}" `
                            -Name $global:LOGTASTIC_MOD_NAME `
                            -Type "action"
            Write-QuickLog -Message "creating {ct:magenta:nupkg} package from {ct:magenta:nuspec} file" -Name $global:LOGTASTIC_MOD_NAME -Type "action" -Submessage      
            Write-QuickLog -Message "checking {ct:yellow:nuget} Package Manager" -Name $global:LOGTASTIC_MOD_NAME -Type "info" -Submessage
        }
        catch [System.Exception] {
            Write-QuickLog -Message "$($_.Exception.Message)" -Name $global:LOGTASTIC_MOD_NAME -Type "Error" -submessage
        }
        Write-QuickLog -Message "[{ct:green:Choco-Package-Creator}]" -Name $global:LOGTASTIC_MOD_NAME -Type "action" -submessage
        $PackageName = "$($nuspecfile.package.metadata.id).$($nuspecfile.package.metadata.version).nupkg"
        New-ShellDock -LogName $global:LOGTASTIC_MOD_NAME -Name 'nuget-choco-nupkg-packager' -ScriptBlock {
            Set-Location -path "$($args.rootpath)"
            choco pack --outputdirectory "$($args.exportPath)"
        } -Arguments (
            [PSObject]@{
                rootpath = $rootpath; 
                exportpath = $exportpath;
            }
        )

        # - TotalProcessorTime : 00:00:00.6250000
        # - id : 26036
        Write-QuickLog -Message "response -OutputDirectory $exportPath" -Name $global:LOGTASTIC_MOD_NAME -Type "Success" -Submessage
        Write-QuickLog -Message "nupkg package created" -Name $global:LOGTASTIC_MOD_NAME -Type "Success"
        Write-QuickLog -Message "@{pt:{package=$exportPath`\$PackageName}}" -Name $global:LOGTASTIC_MOD_NAME -Type "Complete" -Submessage
        Write-QuickLog -Message "complete" -Name $global:LOGTASTIC_MOD_NAME -Type "Complete"

        [console]::("------------------------------------------- `n")
        [console]::("Chocolatey PackageName: $PackageName `n")
        [console]::("File Cound: $($nuspecfile.package.files.Count) `n")
        [console]::("Version: $($nuspecfile.package.version) `n")
        [console]::("-------------------------------------------")
    }
}
Export-ModuleMember -Function New-ChocoPackage
