<#
.SYNOPSIS
    A function that creates a new .nuspec manifest file for a Chocolatey package.

.DESCRIPTION
    The New-ChocoNuspecFile function generates a .nuspec manifest file for a Chocolatey package. 
    It takes in parameters such as the module name, version, path, author, description, project URL, license, tags, company, 
    dependencies, license acceptance, and release notes. It then generates a .nuspec file with these details, 
    including the files and dependencies of the package. 

.PARAMETER ModuleName
    The name of the Chocolatey package.

.PARAMETER ModuleVersion
    The version of the Chocolatey package.

.PARAMETER path
    The path where the .nuspec file will be created.

.PARAMETER Author
    The author of the Chocolatey package.

.PARAMETER Description
    A description of the Chocolatey package.

.PARAMETER ProjectUrl
    The URL of the project associated with the Chocolatey package.

.PARAMETER License
    The license under which the Chocolatey package is released.

.PARAMETER Tags
    Tags associated with the Chocolatey package.

.PARAMETER company
    The company that owns the Chocolatey package.

.PARAMETER dependencies
    Any dependencies that the Chocolatey package has.

.PARAMETER LicenseAcceptance
    A switch that indicates whether license acceptance is required.

.PARAMETER releasenotes
    Any release notes associated with the Chocolatey package.

.EXAMPLE
    New-ChocoNuspecFile -ModuleName "MyPackage" -ModuleVersion "1.0.0" -path "C:\MyPackage" -Author "John Doe" -Description "This is my package" -ProjectUrl "http://example.com" -License "MIT" -Tags "Choco,Package" -company "MyCompany" -dependencies @("Dep1", "Dep2") -LicenseAcceptance -releasenotes "First release"

    This will create a .nuspec file for the package "MyPackage" version "1.0.0" in the directory "C:\MyPackage". The author is "John Doe", the description is "This is my package", the project URL is "http://example.com", the license is "MIT", the tags are "Choco" and "Package", the company is "MyCompany", the dependencies are "Dep1" and "Dep2", license acceptance is required, and the release notes are "First release".
#>

function New-ChocoNuspecFile {
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
        [parameter(Mandatory = $false)]
        [string[]]$Owners,
        [Parameter(Mandatory = $true)]
        [string]$Description,
        [Parameter(Mandatory = $true)]
        [string]$Projecturl,
        [Parameter(Mandatory = $false)]
        [string]$projectSourceUrl,
        [Parameter(Mandatory = $false)]
        [string]$MailingListUrl,
        [Parameter(Mandatory = $false)]
        [string]$bugTrackerUrl,
        [Parameter(Mandatory = $false)]
        [string]$DocsUrl,
        [Parameter(Mandatory = $false)]
        [string]$IconUrl,
        [Parameter(Mandatory = $false)]
        [string]$LicenseUrl,
        [Parameter(Mandatory = $false)]
        [string]$Tags,
        [Parameter(Mandatory = $false)]
        [string]$Company,
        [Parameter(Mandatory = $false)]
        [array]$Dependencies,
        [Parameter(Mandatory = $false)]
        [string]$Releasenotes,
        [Parameter(Mandatory = $false)]
        [switch]$LicenseAcceptance,
        [Parameter(Mandatory = $false)]
        [string]$Summary,
        [Parameter(Mandatory = $false)]
        [string]$PreRelease
    )
    $logo = Get-Content -Path "$($global:_nupsforge.rootpath)\libs\icon-choco.txt" -raw
    $logo
    Write-QuickLog -Message "Generating @{pt:{module=$ModuleName}} @{pt:{package=$ModuleName.$ModuleVersion.nupkg}}" -Name $global:LOGTASTIC_MOD_NAME -Type "action"
    try {
        # Set Defaults
        # Set PreRelease
        if (!$PreRelease -or $PreRelease.Length -eq 0) { $ModuleVersion = $ModuleVersion }
        else { $ModuleVersion = "$ModuleVersion-$PreRelease" }
        # Set Acceptance
        if($licenseAcceptance){$Acceptance='true'}else{$Acceptance='false'}
        # Set Owners
        if(!$owners){$Owners=$author}
        # XML Here-String .nuspec file template for powershell modules 
        # for a nuget package.
        [xml]$nuspec = @"
<?xml version="1.0"?>
<package>
  <metadata>
    <title>$ModuleName</title>
    <id>$ModuleName</id>
    <version>$ModuleVersion</version>
    <authors>$Author</authors>
    <owners>$Author</owners>
    <description>
    <![CDATA[
    $Description
    ]]>
    </description>
    <summary>$Summary</summary>
    <projectUrl>$Projecturl</projectUrl>
    <iconUrl>$iconurl</iconUrl>
    <projectSourceUrl>$projectSourceurl</projectSourceUrl>
    <docsUrl>$docsurl</docsUrl>
    <mailingListUrl>$mailingListurl</mailingListUrl>
    <bugTrackerUrl>$bugTrackerurl</bugTrackerUrl>
    <licenseUrl>$Licenseurl</licenseUrl>
    <tags>$Tags</tags>
    <requireLicenseAcceptance>$Acceptance</requireLicenseAcceptance>
    <releaseNotes>
    <![CDATA[
    $releasenotes
    ]]>
    </releaseNotes>
    <copyright>Copyright ©$((get-date | select-object year).year) $company</copyright>
    <dependencies>
    </dependencies>
  </metadata>
  <files>
  </files>
</package>
"@
        Write-QuickLog -Message "Done" -Name $global:LOGTASTIC_MOD_NAME -Type "success" -submessage
    }
    catch [System.Exception] {
        Write-QuickLog -Message "[NuspecPackageFile] Template Create Failed Error: @{pt:{Error=$($_.Exception.Message)}} " -Name $global:LOGTASTIC_MOD_NAME -Type "error"
    }
    Write-QuickLog -Message "Creating File Manifest" -Name $global:LOGTASTIC_MOD_NAME -Type "Info"
    Write-QuickLog -Message "Adding files to manifest to @{pt:{xmlNodePath=nuspec.package.files.file}}" -Name $global:LOGTASTIC_MOD_NAME -Type "action" -Submessage
    #! check for readme.txt and icon.png 
    # Update and add all files to the manifest
    try {
        Write-QuickLog -Message "Getting Directory Properties" -Name $global:LOGTASTIC_MOD_NAME -Type "Info" -Submessage
        $DirectoryProperty = Get-itemProperty -Path $path
    }
    catch [System.Exception] {
        Write-QuickLog -Message "Get-ItemProperty Failed Error: @{pt:{Error=$($_.Exception.Message)}} " -Name $global:LOGTASTIC_MOD_NAME -Type "error"
        return
    }

    Get-Childitem -path $DirectoryProperty.FullName -Recurse | foreach-object {
        if ($_.PSIsContainer -eq $false) {
            
            # https://learn.microsoft.com/en-us/nuget/reference/errors-and-warnings/nu5019
            if($isLinux){
                $RelativePath = "$($_.fullname.Replace($DirectoryProperty.FullName, '').TrimStart('/'))"
            }
            if($isWindows){
                $RelativePath = "$($_.fullname.Replace($DirectoryProperty.FullName, '').TrimStart('\'))"
            }

            if ($_.length -eq 0) {
                Write-QuickLog -Message "File @{pt:{path=$RelativePath}} is empty, skipping." -Name $global:LOGTASTIC_MOD_NAME -Type "info" -Submessage
                return
            }
            
            try {

                # replace souce path with empty string to get relative path 
                if($_.name -match "(I|i)con.png") {
                    Write-QuickLog -Message "{cs:blue:required} @{pt:{path=$RelativePath}}" -Name $global:LOGTASTIC_MOD_NAME -Type "complete" -Submessage
                    # add readme.txt and icon.png to the root of the package as default requirements
                    $fileElement = $nuspec.CreateElement("file")
                    $fileElement.SetAttribute("target", $RelativePath)
                    $fileElement.SetAttribute("src", $RelativePath)
                } 
                if($_.name -match "(readme|README).md") {
                    Write-QuickLog -Message "{cs:blue:required} @{pt:{path=$RelativePath}}" -Name $global:LOGTASTIC_MOD_NAME -Type "complete" -Submessage
                    # add readme.txt and icon.png to the root of the package as default requirements
                    $fileElement = $nuspec.CreateElement("file")
                    $fileElement.SetAttribute("target", $RelativePath)
                    $fileElement.SetAttribute("src", $RelativePath)       
                }
                
                Write-QuickLog -Message "@{pt:{path=$RelativePath}}" -Name $global:LOGTASTIC_MOD_NAME -Type "complete" -Submessage
                # Add files to the manifest in root pat22h
                $fileElement = $nuspec.CreateElement("file")
                $fileElement.SetAttribute("target", $RelativePath)
                $fileElement.SetAttribute("src", $RelativePath)
                
                # Append the new <file> element to the <files> node
                $nuspec.SelectSingleNode("//files").AppendChild($fileElement) | Out-Null
            }
            catch [System.Exception] {
                Write-QuickLog -Message "Get-ItemProperty Failed Error: $($_.Exception.Message) " -Name $global:LOGTASTIC_MOD_NAME -Type "error"
                break;
            }
        }
    }
    Write-QuickLog -Message "Finished." -Name $global:LOGTASTIC_MOD_NAME -Type "complete" -Submessage
    
    # Add dependancies to the manifest
    # xmlnode nuspec.package.metadata.dependencies.dependency
    if ($dependencies.Count -ne 0) {
        try {
            Write-QuickLog -Message "Adding dependancies to manifest @{pt:{xmlNodePath=nuspec.package.metadata.dependencies}}" -Name $global:LOGTASTIC_MOD_NAME -Type "action"
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
    $nuspec.package.metadata.SetAttribute("xmlns", "http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd")
    # If true, this value prompts the user to accept the license when installing the package. 
    #nuspec.package.metadata.requireLicenseAcceptance = $requireLicenseAcceptance
 
    # output the nuspec file
    $savepath = [System.IO.Path]::Combine($DirectoryProperty.fullname, "$modulename.nuspec")
    try {
        Write-QuickLog -Message "Exporting .nuspec @{pt:{File=$savepath}}" -Name $global:LOGTASTIC_MOD_NAME -Type "action"
        $nuspec.Save($savepath)
        Write-QuickLog -Message "Exported" -Name $global:LOGTASTIC_MOD_NAME -Type "complete"
    }
    catch [system.exception] {
        Write-QuickLog -Message "Error: @{pt:{Error=$($_.Exception.Message)}}" -Name $global:LOGTASTIC_MOD_NAME -Type "Error" -Submessage
    }
    
}
Export-modulemember -function New-ChocoNuspecFile