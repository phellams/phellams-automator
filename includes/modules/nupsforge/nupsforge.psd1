@{

    # Script module or binary module file associated with this manifest.
    RootModule        = 'nupsforge.psm1'

    # Version number of this module.
    ModuleVersion     = '0.7.2.0'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID              = '66c5e2d6-3737-44d7-a0e8-344983d18b36'

    # Author of this module
    Author            = 'Garvey k. Snow'

    # Company or vendor of this module
    CompanyName       = 'phellams'

    # Copyright statement for this module
    Copyright         = '2025 Garvey k. Snow All rights reserved.'

    # Description of the functionality provided by this module
    Description       = "NuPSForge is a PowerShell module that aids in the creation of .nupkg files for psgal, choco, GitLab packages, and GitHub packages. These are intended for PowerShell modules and scripts, which can be deployed to NuGet repositories. See https://github.com/sgkens/NuPSForge for more information."

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '7.0'

    # Name of the PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # ClrVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    #
    # RequiredModules   = @(
    #     @{
    #         ModuleName = "quicklog"; 
    #         ModuleVersion = "0.2.1" 
    #     },
    #      @{
    #         ModuleName = "tadpol"; 
    #         ModuleVersion = "0.1.8" 
    #     }
    # )

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    #NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
     FunctionsToExport = @(
        'New-NupkgPackage', 
        'New-NuspecPackageFile', 
        'New-ChocoPackage', 
        'New-ChocoNuspecFile',
        'New-NupkgIcon'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport   = @()

    # Variables to export from this module
    VariablesToExport  = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport   = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList    = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags             = 'automation', 'nupsec', 'nupkg', 'nuget', 'nuget-create', 'package-create', 'package-create-nupkg', 'powershell', 'powershell-core', 'module'

            # A URL to the license for this module.
            LicenseUrl       = 'https://choosealicense.com/licenses/mit'

            # A URL to the main website for this project.
            ProjectUrl       = 'https://github.com/sgkens/nupsforge'

            # A URL to an icon representing this module.
            IconUrl          = 'https://raw.githubusercontent.com/sgkens/resources/main/modules/nupsforge/nupsforge-logo-x128.png'

            # ReleaseNotes of this module
            ReleaseNotes     = 'https://github.com/sgkens/nupsforge/releases'

            # Prerelease string of this module
            # Prerelease = 'alpha1'

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()

            # DocsURL
            Docsurl          = 'https://pages.gitlab.io/sgkens/NuPSForge'

            # MailingListUrl
            MailingListUrl   = 'https://github.com/sgkens/nupsforge/issues'
        
            # projectSourceUrl
            projectSourceUrl = 'https://gitlab.snowlab.tk/powershell/NuPSForge'

            # bugTrackerUrl 
            bugTrackerUrl    = 'https://github.com/sgkens/nupsforge/issues'

            # Summary
            Summary          = 'NuPSForge is a powershell module to help with the creation of .nupkg for powershell modules and scripts, for deployment to nuget package repositories'

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo url of this module
    # HelpInfourl = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}

