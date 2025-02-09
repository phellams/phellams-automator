@{

    # Script module or binary module file associated with this manifest.
    RootModule        = 'quicklog.psm1'

    # Version number of this module.
    ModuleVersion     = '1.0.1.0'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID              = '9d70e476-0214-4644-aaf6-cb4fadc1116c'

    # Author of this module
    Author            = 'Garvey Snow'

    # Company or vendor of this module
    CompanyName       = 'phellams'

    # Copyright statement for this module
    Copyright         = '2023 @ Garvey k. Snow. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'LogTastic is a PowerShell Module that outputs styled log message to the console.'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.1' #TODO Sit CI/CD to testing powershell but failed test does not break the build

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
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules     = @(
        'libs\sm\Get-Elapsed.psm1',
        'libs\sm\Get-PropTune.psm1',
        'libs\sm\Get-ColorTune.psm1'
    )

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(  
        'Write-Quicklog',
        'Write-QuicklogProgress',
        'New-Quicklog',
        'Get-QuicklogTypes'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport   = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport   = @(
        'qlqt', # alias for Write-QuicklogProgress
        'qlwp' # alias for Get-QuicklogTypes
        'qln' # alias for Get-QuicklogTypes
        'qlm' # alias for New-Quicklog
    )

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags             = 'message', 'log, logging, module, freeware, powershell-core, cross-platform, progressbars, console', 'unicode', 'emoji', 'icons', 'icons-in-console', 'icons-in-powershell'

            # A URL to the license for this module.
            LicenseUrl       = "https://choosealicense.com/licenses/mit"

            # A URL to the main website for this project.
            ProjectUrl       = 'https://github.com/sgkens/logtastic'
        
            # A URL to an icon representing this module.
            IconUrl          = 'https://raw.githubusercontent.com/sgkens/resources/main/modules/quicklog/dist/v2/logtastic-logo-x128.png'

            # ReleaseNotes of this module
            ReleaseNotes     = 'https://github.com/sgkens/quicklog/-/blob/main/Releases'

            # Prerelease string of this module
            Prerelease       = 'preview3'

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()
            # DocsURL
            Docsurl          = 'https://pages.gitlab.io/sgkens/quicklog'

            # MailingListUrl
            MailingListUrl   = 'https://github.com/sgkens/quicklog/issues'
    
            # projectSourceUrl
            projectSourceUrl = 'https://github.com/sgkens/quicklog'

            # bugTrackerUrl 
            bugTrackerUrl    = 'https://github.com/sgkens/quicklog/issues'

            # Summary
            Summary          = 'LogTastic is a PowerShell Module that outputs styled log message to the console.'



        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}

