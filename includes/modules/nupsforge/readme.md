# <img width="25" src="https://raw.githubusercontent.com/sgkens/resources/main/modules/nupsforge/dist/v1/nupsforge-logo-x128.png"/>  **NuPSForge** 

<!--license-->
<a href="https://github.com/sgkens/nupsforge/">
  <img src="https://img.shields.io/badge/MIT-License-blue?style=&logo=unlicense&color=%23004481"></a>
<!--Code Factor-->
<a href="https://www.codefactor.io/repository/github/sgkens/nupsforge/">
  <img src="https://www.codefactor.io/repository/github/sgkens/nupsforge/badge"></a>
<!--coverage-->
<a href="https://coveralls.io/github/sgkens/nupsforge">
  <img src="https://img.shields.io/coverallsCoverage/github/sgkens/nupsforge?branch=main"></a>


NuPSForge help with the creation of `.nupkg` for powershell modules and scripts, for deployment to a nuget repositories, such as the **Powershell Gallary**,**Chocolatey**, **proget**, and **Gitlab|Github** Packages Repositories.

|BUILD|RELEASES|
|-|-|
|<a href="https://gitlab.lab.davilion.online/powershell/commitfusion/-/pipelines"><img src="https://gitlab.lab.davilion.online/powershell/commitfusion/badges/main/pipeline.svg"></a>|<a href="https://gitlab.lab.davilion.online/powershell/ccommits/-/releases"><img src="https://gitlab.lab.davilion.online/powershell/commitfusion/-/badges/release.svg"></a>|
|<a href="https://gitlab.lab.davilion.online/powershell/commitfusion/-/pipelines"><img src="https://gitlab.lab.davilion.online/powershell/commitfusion/badges/main/pipeline.svg"></a>|

## 🟪 Cmdlets/Functions

#### 🔹**New-ChocoNuspecFile**

Generating a **.nuspec** from a *ModuleManifest* file `Test-ModuleManifest -Path "Path"`, `New-ChocoNuspecFile` outputs `$modulename.companyname.nuspec`

> NOTE!

Extra properties are added to the `.nuspec` file. Such as `projectSourceUrl`, `docsUrl`, `bugTrackerUrl`, `LicenseUrl`, `IconUrl`, `mailingListUrl`, `bugTrackerUrl`, `licenseUrl`, `projectSourceUrl`, `projectUrl`, `iconUrl`.

With `.psd1` manifest file they can be added to `$ModuleManifest.PrivateData.PSData` if pulling from manifest.

```powershell
$NuSpecParamsChoco = @{
  path             = .\dist\$ModuleName
  ModuleName       = $ModuleName
  ModuleVersion    = $ModuleManifest.Version -replace "\.\d+$", "" # remove the extra .0 as semver has 0.0.0 and powershell 0.0.0.0
  Author           = $ModuleManifest.Author
  Description      = $ModuleManifest.Description
  ProjectUrl       = $ModuleManifest.PrivateData.PSData.ProjectUrl
  IconUrl          = $ModuleManifest.PrivateData.PSData.IconUrl
  docsUrl          = $ModuleManifest.PrivateData.PSData.docsUrl
  projectSourceUrl = $ModuleManifest.PrivateData.PSData.projectSourceUrl
  MailingListUrl   = $ModuleManifest.PrivateData.PSData.MailingListUrl
  bugTrackerUrl    = $ModuleManifest.PrivateData.PSData.BugTrackerUrl
  LicenseUrl       = $ModuleManifest.PrivateData.PSData.LicenseUrl
  ReleaseNotes     = $ModuleManifest.PrivateData.PSData.ReleaseNotes
  License          = "MIT"
  company          = $ModuleManifest.CompanyName
  Tags             = $ModuleManifest.Tags
  dependencies     = $ModuleManifest.ExternalModuleDependencies
  LicenseAcceptance = $false
}
New-ChocoNuspecFile @NuSpecParamsChoco

# or ----------------------

New-ChocoNuspecFile -Path .\dist\$ModuleName `
                    -ModuleName $ModuleName `
                    -ModuleVersion $ModuleManifest.Version -replace "\.\d+$", "" # remove the extra .0 as semver has 0.0.
                    -Author $ModuleManifest.Author `
                    -Description $ModuleManifest.Description `
                    -ProjectUrl $ModuleManifest.PrivateData.PSData.ProjectUrl `
                    -IconUrl $ModuleManifest.PrivateData.PSData.IconUrl `
                    -docsUrl $ModuleManifest.PrivateData.PSData.docsUrl `
                    -projectSourceUrl $ModuleManifest.PrivateData.PSData.projectSourceUrl `
                    -MailingListUrl $ModuleManifest.PrivateData.PSData.MailingListUrl `
                    -bugTrackerUrl $ModuleManifest.PrivateData.PSData.BugTrackerUrl `
                    -LicenseUrl $ModuleManifest.PrivateData.PSData.LicenseUrl `
                    -ReleaseNotes $ModuleManifest.PrivateData.PSData.ReleaseNotes `
                    -License "MIT" `
                    -company $ModuleManifest.CompanyName `
                    -Tags $ModuleManifest.Tags `
                    -dependencies $ModuleManifest.ExternalModuleDependencies `
                    -LicenseAcceptance $false

```

#### 🔹New-NuspecPackageFile

Generating a **.nuspec** from a *ModuleManifest* file `Test-ModuleManifest -Path "Path"`, `New-NuspecPackageFile` outputs `$modulename.companyname.nuspec`

🧪 **Example**:

```powershell
$ModuleManifest = Test-ModuleManifest -Path "Path"
$NuSpecParams = @{
  path             = .\dist\ModuleName
  ModuleName       = $ModuleName
  ModuleVersion    = $ModuleManifest.Version -replace "\.\d+$", "" # remove the extra .0 as semver has 0.0.0 and powershell 0.0.0.0
  Author           = $ModuleManifest.Author
  Description      = "$($ModuleManifest.Description)`n`n$Additional_descriptions"
  ProjectUrl       = $ModuleManifest.PrivateData.PSData.ProjectUri
  License          = "MIT"
  company          = $ModuleManifest.CompanyName
  Tags             = $ModuleManifest.Tags
  dependencies     = $ModuleManifest.ExternalModuleDependencies
  LicenseAcceptance = $false
}

New-NuspecPackageFile -Path "path/to/folder"

# or ----------------------

New-NuspecPackageFile -Path "Path"
                      -ModuleName "ModuleName"
                      -ModuleVersion "ModuleVersion"
                      -Author "Author"
                      -Description "Description"
                      -ProjectUrl "ProjectUrl"
                      -License "License"
                      -Company "company"
                      -Tags "Tags"
                      -Dependencies "dependencies"
                      -LicenseAcceptance $false

```

#### 🔹New-ChocoPackage

Create a **Chocolatey** nuget package from `.nuspec` file `New-ChocoPackage` looks for `rootfoldername.nuspec` file in your root directory.

> NOTE!
> 🖋 `New-ChocoPackage` uses **choco.exe** to create the **package.nupkg**
> 🖋 choco must be installed and be callable from cli
> 🖋 Runs`Choco Pack --outdirectory $outdir`

> *How-to!* \
> Installing *Chocolatey* Package Manager [**How to Install**](https)  [🧷chocolatey.org/install](https://chocolatey.org/install)

🧪 **Example**:

```powershell
New-ChocoPackage -path .\dist\ModuleName  -outpath .\dist\choco
```

#### 🔹New-NupkgPackage

Create an nuget package from `.nuspec` file `New-NupkgPackage` looks for `rootfoldername.nuspec` file in your root directory.

> NOTE!
> 🖋`New-NupkgPackage` uses **nuget.exe** to create the **package.nupkg**
> 🖋 nuget must be installed and be callable from cli
> 🖋 dotnet sdk `dotnet nuget` is also compatable
> 🖋 Runs `nuget -build -pack .`

```powershell
New-NupkgPackage -path .\dist\ModuleName  -outpath .\dist\nuget
```

## 🟪 Installation Methods

### 💾 Source

1. Clone the repository from GitHub `git clone https://github.com/sgkens/nupsforge.git` \
2. Open a *PowerShell* session and navigate to the cloned repository directory. \
3. **Run** the *Module Import* via the command below:

    ```powershell
    # Import the module
    git clone https://github.com/sgkens/nupsforge.git
    cd nupsforge
    Import-Module -Name nupsforge
    Get-Module -Name nupsforge

    # Check imported module functions
    Get-Module -Name nupsforge | Select-Object -expand ExportedFunctions
    Get-Module -Name nupsforge | select-object version
    ```

### 💼 Releases

Download the latest release from the [**Releases**](https://github.com/sgkens/nupsforge/releases) page.

### 📦 Packages

[<img src="https://img.shields.io/powershellgallery/v/csverify?include_prereleases&style=for-the-badge&logo=powershell"/>](https://www.powershellgallery.com/packages/nupsforge) <img src="https://img.shields.io/powershellgallery/dt/csverify?label=Downloads&style=for-the-badge">

```powershell
# Install the module from the psgal
Install-Module -Name davilion.nupsforge -force

# Import module into you powershell session
Import-Module -Name davilion.nupsforge
```

> *Note!*  
> You may need to `Set-ExecutionPolicy` to `RemoteSigned` or `Unrestricted` to install from the PSGallary.

[<img src="https://img.shields.io/chocolatey/v/csverify?style=for-the-badge&logo=chocolatey"/>](https://Chocolatory.org/sgkens/commitfusion) <img src="https://img.shields.io/chocolatey/dt/csverify?label=Downloads&style=for-the-badge">

```powershell
# Install the module from the psgal
choco install davilion.nupsforge

# Import Module into you powershell session
Import-Module -Name nupsforge
```

## 🟧 Requirements

🔹**TadPal** : <https://github.com/sgkens/tadpol> *Installed with Module*
🔹**LogTastic**: <https://github.com/sgkens/logtastic> *Installed with Module*
🔹**Nuget** : Be available in your environtment $PATH|PATH
🔹**Choco** : Be available in your environtment $PATH|PATH
