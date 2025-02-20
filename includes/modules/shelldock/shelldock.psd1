@{

    RootModule             = 'shelldock.psm1'
    ModuleVersion          = '0.1.1'
    GUID                   = '241e284e-8123-41d5-81df-0473d9a632a4'
    Author                 = 'sgkens'
    CompanyName            = 'phallams'
    Copyright              = '2025 sgkens. All rights reserved.'
    Description            = 'Shelldock is a simple powershell module, create and excucte a code block/script inside a local runspace with animated output'
    PowerShellVersion      = '7.4.0'
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
    FunctionsToExport      = @(
        'New-ShellDock'
        )
    CmdletsToExport        = @()
    VariablesToExport      = @()
    AliasesToExport        = @(
        'sdock'
    )
    DscResourcesToExport   = @()
    ModuleList             = @()
    FileList               = @()
    PrivateData            = @{

        PSData = @{
            Tags                       = 'automation', 'runspace'
            LicenseUri                 = 'https://choosealicense.com/licenses/mit'
            ProjectUri                 = 'https://gitlab.lab.davilion.online/powershell/shelldock.git'
            IconUri                    = 'https://gitlab.lab.davilion.online/powershell/shelldock/-/blob/main/logo.svg'
            ReleaseNotes               = 'https://gitlab.lab.davilion.online/powershell/shelldock/-/blob/main/Releases.md'
            Prerelease                 = 'alpha1'
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }

    }

    HelpInfoURI            = ''
    DefaultCommandPrefix   = ''

}
