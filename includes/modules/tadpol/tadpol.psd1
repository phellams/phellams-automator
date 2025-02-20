@{
    RootModule             = 'tadpol.psm1'
    ModuleVersion     = '0.1.8.0'
    CompatiblePSEditions   = @()
    GUID                   = '773c2cff-ed15-4d62-af36-a4b69c3af4df'
    Author                 = 'Garvey k Snow'
    CompanyName            = 'phellams'
    Copyright              = '2025 Garvey k. Snow. All rights reserved.'
    Description            = 'Tadpol is a powershell module that geneates custom progress bars and loaders from a theme.json config file'
    PowerShellVersion      = '7.3.4'
    PowerShellHostName     = ''
    PowerShellHostVersion  = ''
    DotNetFrameworkVersion = ''
    ClrVersion             = ''
    ProcessorArchitecture  = ''
    RequiredModules        = @()
    RequiredAssemblies     = @()
    ScriptsToProcess       = @()
    TypesToProcess         = @()
    FormatsToProcess       = @()
    NestedModules          = @()
    FunctionsToExport      = @('get-tpthemes', 'write-tpprogress', 'new-tpobject', 'write-tploader', 'Clear-Prelines')
    CmdletsToExport        = @( )
    VariablesToExport      = ''
    AliasesToExport        = ''
    DscResourcesToExport   = @()
    ModuleList             = @()
    FileList               = @()
    PrivateData            = @{

        PSData = @{
            Tags                       = 'ProgressBar, Generate, progress, CustomProgress', 'status'
            LicenseUri                 = 'https://choosealicense.com/licenses/mit'
            ProjectUri                 = 'https://gitlab.snowlab.tk/powershell/tadpol.git'
            IconUri                    = 'https://gitlab.snowlab.tk/powershell/tadpol/-/blob/main/logo.svg'
            ReleaseNotes               = 'https://github.com/powershell/tadpol/-/blob/main/Releases.md'
            Prerelease                 = 'preview1'
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()

        }

    }
    HelpInfoURI            = ''
    DefaultCommandPrefix   = ''
}
