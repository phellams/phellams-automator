# <img width="46" src="https://raw.githubusercontent.com/phellams/phellams-general-resources/main/logos/phwriter/dist/png/phwriter-logo-128x128.png" alt="Phellams Logo" /> **PHWriter**

<a href="https://gitlab.com/phellams/phwriter/-/blob/main/readme.md"><img src="https://img.shields.io/badge/License-_mit-License?style=flat-square&labelColor=%23383838&color=%237A5ACF23CD5C5C" alt="MIT License" /></a>
<a href="https://gitlab.com/phellams/phwriter/-/pipelines"><img src="https://img.shields.io/gitlab/pipeline-status/phellams%2Fphwriter?style=flat-square&logo=Gitlab&logoColor=%233478BD&labelColor=%232D2D34" alt="Build Status"></a>
<a href="https://codecov.io/gh/phellams/phwriter"><img src="https://img.shields.io/codecov/c/gitlab/phellams/phwriter?style=flat-square&logo=codecov&logoColor=%23E6746B&logoSize=auto&labelColor=%234A7A82" alt="Build Status"></a>
<a href="https://gitlab.com/phellams/phwriter/-/issues"><img src="https://img.shields.io/gitlab/issues/open/phellams%2Fphwriter?style=flat-square&logo=gitlab&logoColor=red&labelColor=%23ffffff&color=%236B8D29" alt="gitlab issues"></a>

## Overview

PHWriter(_**Powershell Help Writer**_) is a PowerShell module designed to generate beautifully formatted, colored help text for your PowerShell cmdlets, mimicking the style and readability of Linux man pages. It allows you to define your cmdlet's parameters and their descriptions in a structured way, providing a consistent and professional look for your command-line help.
Features

 - **Customizable Layout**: Control indentation and spacing between parameter elements.
 - Colored Output: Enhance readability with distinct colors for different help sections and parameter components.
 - **ASCII Art Logo**: Includes a simple, elegant ASCII art banner for visual appeal, or you can provide your own ascii art.
 - **Inline/Newline Descriptions**: Choose whether parameter descriptions appear on the same line or a new line.
 - **Automatic Alignment**: Dynamically calculates padding to ensure perfect alignment of parameter types and descriptions.
 - **Production Ready**: Comes with a module manifest (.psd1) for proper PowerShell module management.

## Installation

Phellams modules are available from [**PowerShell Gallery**](https://www.powershellgallery.com/packages/phwriter) and [**Chocolatey**](https://chocolatey.org/packages/phwriter). you can access the raw assets via [**Gitlab Generic Assets**](https://gitlab.com/phellams/phwriter/-/packages?orderBy=name&sort=desc&search[]=phwriter) or nuget repository via [**Gitlab Packages**](https://gitlab.com/phellams/phwriter/-/packages/?orderBy=name&sort=desc&search[]=phwriter&type=NuGet).

|▓▓▓▓▒▒▒▒░░░|▓▓▓▓▒▒▒▒░░░|▓▓▓▓▒▒▒▒░░░|
|-|-|-|
|📦 PSGallery | <a href="https://www.powershellgallery.com/packages/phwriter"> <img src="https://img.shields.io/powershellgallery/v/phwriter?label=version&style=flat-square&logoColor=blue&labelColor=23CD5C5C&color=%231E3D59" alt="powershellgallery"></a> | <img src="https://img.shields.io/powershellgallery/dt/phwriter?style=flat-square&logoColor=blue&label=downloads&labelColor=23CD5C5C&color=%231E3D59" alt="powershellgallery-downloads"> |
|📦 Chocolatey | <a href="https://community.chocolatey.org/packages/phwriter/"><img src="https://img.shields.io/chocolatey/v/phwriter?label=version&include_prereleases&style=flat-square&logoColor=blue&labelColor=23CD5C5C&color=%231E3D59" alt="chocolatey"/></a> | <img src="https://img.shields.io/chocolatey/dt/phwriter?style=flat-square&logoColor=blue&label=downloads&include_prereleases&labelColor=23CD5C5C&color=%231E3D59" alt="chocolatey-downloads"> |

### Additinonal Installation Options:
 
|▓▓▓▓▒▒▒▒░░░|▓▓▓▓▒▒▒▒░░░|▓▓▓▓▒▒▒▒░░░|
|-|-|-|
|💼 Releases/Tags | <a href="https://gitlab.com/phellams/phwriter/-/releases"> <img src="https://img.shields.io/gitlab/v/release/phellams%2Fphwriter?include_prereleases&style=flat-square&logoColor=%2300B2A9&labelColor=%23CD5C5C&color=%231E3D59" alt="gitlab-release"></a> | <a href="https://gitlab.com/phellams/phwriter/-/tags"> <img src="https://img.shields.io/gitlab/v/tag/phellams%2Fphwriter?include_prereleases&style=flat-square&logoColor=%&labelColor=%23CD5C5C&color=%231E3D59" alt="gitlab tags"></a> |

#### 📦 GitLab Packages

Using `nuget`: See the [**packages**](https://gitlab.com/phellams/phwriter/-/packages?orderBy=name&sort=asc&search[]=phwriter&type=NuGet) page for installation instructions.

> For instructions on adding `nuget` **sources** packages from *GitLab* see [**Releases**](https://github.com/sgkens/phwriter/releases) artifacts or via the [**Packages**](https://gitlab.com/phellams/phwriter/-/packages?orderBy=name&sort=asc&search[]=phwriter&type=NuGet) page.

#### 🧺 Generic Asset

The latest release artifacts can be downloaded from the [**Generic Assets Artifacts**](https://gitlab.com/phellams/phwriter/-/packages?orderBy=type&sort=desc&type=Generic) page.

#### 💾 Git Clone

```bash
# Clone the repository
git clone https://gitlab.com/phellams/phwriter.git
cd phwriter
import-module .\
```

## Quick Start

```powershell
# Import module from module directory
Import-Module -name Phwriter
```


## Usage

The primary cmdlet provided by this module is `New-PHWriter`. Generates formatted help text based on an array of hashtables defining your cmdlet's parameters.

#### 🏮 New-PHWriter

🔹 Output help text

```powershell
New-PHWriter -Help
```
🔹 Generate New Help
```powershell
New-PHWriter -Name <String> `
             -CommandInfo <Hashtable> `
             -ParamTable <HashTable[]> `
             -Version <String> `
             -Examples <String[]> `
             -Padding <Int> `
             -Indent <Int> `
             -CustomLogo <String>
             -Help <Switch>

```

### **Parameters List**

 - **Name**: The name of the module to display in the header. Default: "P H W R I T E R"
 - **CommandInfo**: A hashtable containing the name and description of the cmdlet to display version information. Default: Current command name props: 'ModuleName', 'Cmdlet', 'Description'
 - **ParamTable**: An array of hashtables defining the parameters and their descriptions. Default: Empty array
 - **Examples**: An array of examples for the cmdlet. Default: Empty array
 - **Version**: The version of the module to display in the header. Default: "1.0.0"
 - **Padding**: The number of spaces between the parameter alias/name, type, and description. Default: 4
 - **Indent**: The number of spaces to indent the help text. Default: 2
 - **CustomLogo**: The logo to display at the top of the help text. Default: "P H W R I T E R"
 - **Help**: Display help for the cmdlet

#### 🏮 Write-PHAsciiLogo

Outputs the header logo for the module

```powershell
Write-PHAsciiLogo -Name <String> # Has a Max char length
```

## **Examples:**

You can call `New-PHWriter` to generate help text for your cmdlet with the following parameters either by using **params**, **params** via `hashtable`

### 🟡 Option 1 By Variables
```powershell
# Define the parameters for your custom cmdlet's help
[hashtable] $MyCommandDiscription = @{
    cmdlet = "New-PHWriter";
    synopsis = "New-PHWriter [-HelpTable <Hashtable[]>] [-Padding <Int>] [-Indent <Int>]";
    description = "This cmdlet generates formatted help text for PowerShell cmdlets with custom layouts and coloring, mimicking the style of the 'help' command. It supports custom layouts, coloring, and inline/newline descriptions. "; 
}

$myCmdletParams = @(
    @{
        Name        = "SourcePath"
        Param       = "s|Source"
        Type        = "string"
        required   = $true
        Description = "Specifies the source path for the operation. Wildcards are supported."
        Inline      = $false # Description on a new line
    },
    @{
        Name        = "DestinationPath"
        Param       = "d|Destination"
        Type        = "string"
        required   = $true
        Description = "Specifies the destination path where files will be copied."
        Inline      = $false  # Description on the same line
    },
    @{
        Name        = "Recurse"
        Param       = "r|Recurse"
        Type        = "switch"
        required   = $false
        Description = "Indicates that the operation should process subdirectories recursively."
        Inline      = $false
    },
    @{
        Name        = "Confirmation"
        Param       = "c|Confirm"
        Type        = "switch"
        required   = $false
        Description = "Prompts you for confirmation before running the cmdlet. (CommonParameter)"
        Inline      = $false
    }
)

$myCmdletexamples = @(
    "New-PHWriter -SourcePath 'C:\Source' -DestinationPath 'C:\Destination' -Recurse",
    "New-PHWriter -SourcePath 'C:\Source\*' -DestinationPath 'C:\Destination' -Confirm",
    "New-PHWriter -SourcePath 'C:\Source' -DestinationPath 'C:\Destination' -Recurse -Confirm",
    "New-PHWriter -SourcePath 'C:\Source\*' -DestinationPath 'C:\Destination' -Recurse -Confirm"
)
```
🟢 Call `PHWriter` with params

```powershell

New-PHWriter -Name "PHWRITER" `
             -ParamTable $myCmdletParams `
             -CommandInfo $MyCommandDiscription `
             -Examples $myCmdletexamples `
             -Version "1.2.1" `
             -Padding 6 `
             -Indent 2
```

### 🟡 Option 2 By Object Hashtable

```powershell
$phwriter_object = @{
    Name =  "PHWRITER"
    Version =  "1.2.1"
    Padding =  6
    Indent =  2
    CommandInfo = @{
        cmdlet = "New-PHWriter";
        synopsis = "New-PHWriter [-HelpTable <Hashtable[]>] [-Padding <Int>] [-Indent <Int>]";
        description = "This cmdlet generates formatted help text for PowerShell cmdlets with custom layouts and coloring, mimicking the style of the 'help' command. It supports custom layouts, coloring, and inline/newline descriptions. "; 
    }
    ParamTable         = @(
        @{
            Name        = "SourcePath"
            Param       = "s|Source"
            Type        = "string"
            required   = $true
            Description = "Specifies the source path for the operation. Wildcards are supported."
            Inline      = $false # Description on a new line
        },
        @{
            Name        = "DestinationPath"
            Param       = "d|Destination"
            Type        = "string"
            required   = $true
            Description = "Specifies the destination path where files will be copied."
            Inline      = $false  # Description on the same line
        },
        @{
            Name        = "Recurse"
            Param       = "r|Recurse"
            Type        = "switch"
            required   = $false
            Description = "Indicates that the operation should process subdirectories recursively."
            Inline      = $false
        },
        @{
            Name        = "Confirmation"
            Param       = "c|Confirm"
            Type        = "switch"
            required   = $false
            Description = "Prompts you for confirmation before running the cmdlet. (CommonParameter)"
            Inline      = $false
        }
    )
    Examples           = @(
        "New-PHWriter -SourcePath 'C:\Source' -DestinationPath 'C:\Destination' -Recurse",
        "New-PHWriter -SourcePath 'C:\Source\*' -DestinationPath 'C:\Destination' -Confirm",
        "New-PHWriter -SourcePath 'C:\Source' -DestinationPath 'C:\Destination' -Recurse -Confirm",
        "New-PHWriter -SourcePath 'C:\Source\*' -DestinationPath 'C:\Destination' -Recurse -Confirm"
    )
}
```

🟢 Call `PHWriter` with hashtable params

```powershell
New-PHWriter @phwriter_objects
```

**Generate the formatted help output with custom padding and indent:**

```powershell
New-PHWriter -HelpTable $myCmdletParams -Padding 6 -Indent 2
```

**Output**

```text
╔═======════════════════════════════════════════════════════════======═╗
╟░░░░░░░░░░░░░░░░░░░░░░░░░░░░P H W R I T E R░░░░░░░░░░░░░░░░░░░░░░░░░░░╢                                                               
╚═======════════════════════════════════════════════════════════======═╝

   MODULE  PHWRITER   CMDLET New-PHWriter      v1.2.1

    CMDLET SYNOPSIS
       New-PHWriter [-HelpTable <Hashtable[]>] [-Padding <Int>] [-Indent <Int>]

    DESCRIPTION
       This cmdlet generates formatted help text for PowerShell cmdlets with custom layouts and
       coloring, mimicking the style of the 'help' command. It supports custom layouts, coloring, and
       inline/newline descriptions.


    PARAMETERS

     -s|Source            [string]       (Req)  SourcePath
                                          Specifies the source path for the operation. Wildcards are supported.
     -d|Destination       [string]       (Req)  DestinationPath
                                          Specifies the destination path where files will be copied.
     -r|Recurse           [switch]        Recurse
                                          Indicates that the operation should process subdirectories recursively.
     -c|Confirm           [switch]        Confirmation
                                          Prompts you for confirmation before running the cmdlet. (CommonParameter)
   EXAMPLES

     New-PHWriter -SourcePath 'C:\Source' -DestinationPath 'C:\Destination' -Recurse

     New-PHWriter -SourcePath 'C:\Source\*' -DestinationPath 'C:\Destination' -Confirm

     New-PHWriter -SourcePath 'C:\Source' -DestinationPath 'C:\Destination' -Recurse -Confirm

     New-PHWriter -SourcePath 'C:\Source\*' -DestinationPath 'C:\Destination' -Recurse -Confirm
```
<!-- ROADMAP -->
## Roadmap

🟡 **Task List**

- [ ] Add parameter validation as mandatory is not use, `modulename -help` needs to be called
- [ ] Add Advance Parameter Section in output, make it *optional*

## Contributing

Feel free to contribute!  Fork the repo and submit a **merge request** with your improvements.  Or, open an **issue** with the `enhancement` tag to discuss your ideas.

1. Fork the Project from `git clone https://gitlab.com/phellams/phwriter.git`
2. Create your Feature Branch check out the branch dev `git switch dev`.
   1. `git switch -c feature/AmazingFeature`
   2. or 
   3. `git checkout -b feature/AmazingFeature`
3. Commit your Changes `git commit -m 'Add some AmazingFeature'`
4. Push to the Branch `git push origin feature/AmazingFeature`
5. [Open a Merge Request](https://gitlab.com/phellams/phwriter/-/merge_requests/new)

## 📑 License

This project is licensed under the MIT License - see the LICENSE file for details.


[license-badge]: https://img.shields.io/badge/License-MIT-Blue?style=for-the-badge&labelColor=%232D2D34&color=%2317202a