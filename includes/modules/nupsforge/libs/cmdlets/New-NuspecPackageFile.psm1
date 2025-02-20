<#
.SYNOPSIS
    A function that creates a new .nuspec manifest file for a PowerShell module/package.

.DESCRIPTION
    The New-NuspecPackageFile function generates a .nuspec manifest file for a PowerShell module or package. 
    It takes in parameters such as the module name, version, path, author, description, project Url, license, tags, company, 
    dependencies, license acceptance, and release notes. It then generates a .nuspec file with these details, 
    including the files and dependencies of the module/package. 

.PARAMETER ModuleName
    The name of the PowerShell module.

.PARAMETER ModuleVersion
    The version of the PowerShell module.

.PARAMETER path
    The path where the .nuspec file will be created.

.PARAMETER Author
    The author of the PowerShell module.

.PARAMETER Description
    A description of the PowerShell module.

.PARAMETER ProjectUrl
    The Url of the project associated with the PowerShell module.

.PARAMETER License
    The license under which the PowerShell module is released.

.PARAMETER Tags
    Tags associated with the PowerShell module.

.PARAMETER company
    The company that owns the PowerShell module.

.PARAMETER dependencies
    Any dependencies that the PowerShell module has.

.PARAMETER LicenseAcceptance
    A switch that indicates whether license acceptance is required.

.PARAMETER releasenotes
    Any release notes associated with the PowerShell module.

.EXAMPLE
    New-NuspecPackageFile -ModuleName "MyModule" -ModuleVersion "1.0.0" -path "C:\MyModule" -Author "John Doe" -Description "This is my module" -ProjectUrl "http://example.com" -License "MIT" -Tags "PS,Module" -company "MyCompany" -dependencies @("Dep1", "Dep2") -LicenseAcceptance -releasenotes "First release"

    This will create a .nuspec file for the module "MyModule" version "1.0.0" in the directory "C:\MyModule". The author is "John Doe", the description is "This is my module", the project Url is "http://example.com", the license is "MIT", the tags are "PS" and "Module", the company is "MyCompany", the dependencies are "Dep1" and "Dep2", license acceptance is required, and the release notes are "First release".
#>
function New-NuspecPackageFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ModuleName,
        [Parameter(Mandatory = $true)]
        [string]$ModuleVersion,
        [Parameter(Mandatory = $true)]
        [string]$path,
        [Parameter(Mandatory = $true)]
        [string]$Author,
        [Parameter(Mandatory = $true)]
        [string]$Description,
        [Parameter(Mandatory = $true)]
        [string]$ProjectUrl,
        [Parameter(Mandatory = $true)]
        [string]$License,
        [Parameter(Mandatory = $true)]
        [string]$Tags,
        [Parameter(Mandatory = $true)]
        [string]$company,
        [Parameter(Mandatory = $false)]
        [array]$dependencies,
        [Parameter(Mandatory = $false)]
        [switch]$LicenseAcceptance,
        [Parameter(Mandatory = $false)]
        [string]$releasenotes,
        [Parameter(Mandatory = $false)]
        [string]$PreRelease
    )
    $logo = Get-Content -Path "$($global:_nupsforge.rootpath)\libs\icon-nuget.txt" -raw
    $logo
    Write-QuickLog -Message "Getting Metadata @{pt:{module=$ModuleName}} @{pt:{package=$ModuleName`.$ModuleVersion.nupkg}}" -Name $global:LOGTASTIC_MOD_NAME -Type "action"
    try {
        # Set Defaults
        # Set PreRelease
        if (!$PreRelease -or $PreRelease.Length -eq 0) { $ModuleVersion = $ModuleVersion }
        else { $ModuleVersion = "$ModuleVersion-$PreRelease"}
        # Set Acceptance
        if($LicenseAcceptance){ $Acceptance = "true" } else { $Acceptance = "false" }
        # XML Here-String .nuspec file template for powershell modules 
        # for a nuget package.
        [xml]$nuspec = @"
<?xml version="1.0"?>
<package>
  <metadata>
    <!-- Identifier that must be unique within the hosting gallery -->
    <id>$ModuleName</id>
    <!-- Package version number that is used when resolving dependencies -->
    <version>$ModuleVersion</version>
    <!-- Authors contain text that appears directly on the gallery -->
    <authors>$Author</authors>
    <!-- Owners are typically nuget.org identities that allow gallery users to easily find other packages by the same owners.  a-->
    <owners>$Author</owners>
    <!-- The description can be used in package manager UI. Note that thenuget.org gallery uses information you add in the portal. -->
    <description>$Description.</description>
    <!-- Project Url provides a link for the gallery -->
    <!--readme reference-->
    <readme>readme.md</readme>
    <projectUrl>$ProjectUrl</projectUrl>
    <!-- License information is displayed on the gallery -->
    <license type="expression">$License</license>
    <!-- Tags appear in the gallery and can be used for tag searches -->
    <tags>$Tags</tags>
    <!-- Icon is used in Visual Studio's package manager UI -->
    <icon>icon.png</icon>
    <!-- If true, this value prompts the user to accept the license wheninstalling the package. -->   
    <requireLicenseAcceptance>$Acceptance</requireLicenseAcceptance>
    <!-- Any details about this particular release -->
    <releaseNotes>$releasenotes</releaseNotes>
    <!-- Copyright information -->
    <copyright>Copyright ©$((get-date | select-object year).year) $company / $Author</copyright>
    <!-- Dependencies are automatically installed when the package is installed -->
    <dependencies>
    </dependencies>
  </metadata>
  <!-- Files included in the manifiest and relative path -->
  <files>
  </files>
</package>
"@
        Write-QuickLog -Message "Done" -Name $global:LOGTASTIC_MOD_NAME -Type "success" -submessage
    }
    catch [System.Exception] {
        Write-QuickLog -Message "[NuspecPackageFile] Template Create Failed Error: @{pt:{Error=$($_.Exception.Message)}} " -Name $global:LOGTASTIC_MOD_NAME -Type "error"
    }
    Write-QuickLog -Message "Generating File Manifest" -Name $global:LOGTASTIC_MOD_NAME -Type "Info"
    Write-QuickLog -Message "Adding files @{pt:{xmlNodePath=nuspec.package.files.file}}" -Name $global:LOGTASTIC_MOD_NAME -Type "action" -Submessage
    #! check for readme.txt and icon.png 
    # Update and add all files to the manifest
    try {
        Write-QuickLog -Message "Getting file properties" -Name $global:LOGTASTIC_MOD_NAME -Type "Info" -Submessage
        $DirectoryProperty = Get-itemProperty -Path $path
    }
    catch [System.Exception] {
        Write-QuickLog -Message "Get-ItemProperty Failed Error: @{pt:{Error=$($_.Exception.Message)}} " -Name $global:LOGTASTIC_MOD_NAME -Type "error"
        return
    }

    Get-Childitem -path $DirectoryProperty.FullName -Recurse | foreach-object {
        if ($_.PSIsContainer -eq $false) {
            
            # https://learn.microsoft.com/en-us/nuget/reference/errors-and-warnings/nu5019
            $RelativePath = $_.fullname.Replace($DirectoryProperty.FullName, "").TrimStart("\")
            try {
                # replace souce path with empty string to get relative path 
                if ($_.name -match "(i|I)(con).png") {
                    Write-QuickLog -Message "{ct:blue:required} @{pt:{path=$RelativePath}}" -Name $global:LOGTASTIC_MOD_NAME -Type "complete" -Submessage
                    # add readme.txt and icon.png to the root of the package as default requirements
                    $fileElement = $nuspec.CreateElement("file")
                    $fileElement.SetAttribute("target", $RelativePath)
                    $fileElement.SetAttribute("src", $RelativePath)
                }
                elseif ($_.name -match "(r|R)(eadme|EADNE).md") {
                    Write-QuickLog -Message "{ct:blue:required} @{pt:{path=$RelativePath}}" -Name $global:LOGTASTIC_MOD_NAME -Type "complete" -Submessage
                    # add readme.txt and icon.png to the root of the package as default requirements
                    $fileElement = $nuspec.CreateElement("file")
                    $fileElement.SetAttribute("target", $RelativePath)
                    $fileElement.SetAttribute("src", $RelativePath)                  
                }
                else {
                    Write-QuickLog -Message "@{pt:{path=$RelativePath}}" -Name $global:LOGTASTIC_MOD_NAME -Type "complete" -Submessage
                    # Add files to the manifest in root path
                    $fileElement = $nuspec.CreateElement("file")
                    $fileElement.SetAttribute("target", $RelativePath)
                    $fileElement.SetAttribute("src", $RelativePath)
                }
                # Append the new <file> element to the <files> node
                $nuspec.SelectSingleNode("//files").AppendChild($fileElement) | Out-Null
            }
            catch [System.Exception] {
                Write-QuickLog -Message "Get-ItemProperty Failed Error: $($_.Exception.Message) " -Name $global:LOGTASTIC_MOD_NAME -Type "error"
                #break;
            }
        }
    }
    Write-QuickLog -Message "Finished." -Name $global:LOGTASTIC_MOD_NAME -Type "complete" -Submessage
    
    # Add dependancies to the manifest
    # xmlnode nuspec.package.metadata.dependencies.dependency
    if ($dependencies.Count -ne 0) {
        try {
            Write-QuickLog -Message "Adding dependancies to manifest @{pt:{xmlNodePath=nuspec.package.metadata.dependencies.dependency}}" -Name $global:LOGTASTIC_MOD_NAME -Type "action"
            foreach ($dependency in $dependencies) {
                Write-QuickLog -Message "Dependency > @{pt:{Name=$($dependency.id)}} @{pt:{Version=$($dependency.version)}}" -Name $global:LOGTASTIC_MOD_NAME -Type "Action" -Submessage
                $dependencyElement = $nuspec.CreateElement("dependency")
                $dependencyElement.SetAttribute("id", $dependency.id)
                $dependencyElement.SetAttribute("version", $dependency.version)
                $nuspec.SelectSingleNode("//dependencies").AppendChild($dependencyElement) | Out-Null
            }
            Write-QuickLog -Message "Done." -Name $global:LOGTASTIC_MOD_NAME -Type "success" -Submessage
        }
        catch [system.exception] {
            Write-QuickLog -Message "Error: @{pt:{Error=$($_.Exception.Message)}}" -Name $global:LOGTASTIC_MOD_NAME -Type "Error" -Submessage
        }
    }

    # Add Xmlns schema to the root element
    # http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd
    # http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd
    $nuspec.package.metadata.SetAttribute("xmlns", "http://schemas.microsoft.com/packaging/2010/06/nuspec.xsd")
    # If true, this value prompts the user to accept the license when installing the package. 
    #nuspec.package.metadata.requireLicenseAcceptance = $requireLicenseAcceptance
 
    # output the nuspec file
    try {
        Write-QuickLog -Message "Exporting .nuspec @{pt:{File=$outpath\$modulename.nuspec)}}" -Name $global:LOGTASTIC_MOD_NAME -Type "action"
        $nuspec.Save("$path\$ModuleName`.nuspec")
        Write-QuickLog -Message "Exported" -Name $global:LOGTASTIC_MOD_NAME -Type "Complete"
        Write-QuickLog -Message "@{pt:{Path=$outpath\$modulename.nuspec}}" -Name $global:LOGTASTIC_MOD_NAME -Type "info" -Submessage
    }
    catch [system.exception] {
        Write-QuickLog -Message "Error: @{pt:{Error=$($_.Exception.Message)}}" -Name $global:LOGTASTIC_MOD_NAME -Type "Error" -Submessage
    }
    
}
Export-modulemember -function New-NuspecPackageFile