@{

    RootModule             = "csverify.psm1"
    ModuleVersion     = '0.3.3.0'
    CompatiblePSEditions   = @()
    GUID                   = 'c7e7262e-8c66-4c0d-9454-9927449c2927'
    Author                 = 'Garvey k. Snow'
    CompanyName            = 'sgkens'
    Copyright              = '2023 Garvey k. Snow. All rights reserved.'
    Description            = 'Conventional Commit Message Generator'
    PowerShellVersion      = '7.0'
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
        'New-CheckSum',
        'Read-CheckSum',
        'New-VerificationFile',
        'Test-Verification'
    )
    CmdletsToExport        = @()
    VariablesToExport      = @()
    AliasesToExport        = @()
    DscResourcesToExport   = @()
    ModuleList             = @()
    FileList               = @()
    PrivateData            = @{
        PSData = @{
            Tags                       = @('automation', 'checksum', 'hash', 'module', 'powershell', 'powershellcore', 'tool', 'utility', 'utility-module')
            LicenseUrl                 = 'https://choosealicense.com/licenses/mit'
            ProjectUrl                 = 'https://gitlab.com/phellams/csverify'
            IconUrl                    = 'https://raw.githubusercontent.com/sgkens/resources/main/modules/CommitFusion/dist/v2/commitfusion-icon-x128.png'
            ReleaseNotes               = 'https://gitlab.com/phellams/csverify/-/blob/main/Releases'
            # Prerelease                 = 'beta'
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
            Docsurl                    = 'https://gitlab.com/phellams/csverify'
            MailingListUrl             = 'https://gitlab.com/phellams/csverify/issues'
            projectSourceUrl           = 'https://gitlab.com/phellams/csverify'
            bugTrackerUrl              = 'https://gitlab.com/phellams/csverify/issues'
            Summary                    = 'Conventional Commit Message Generators.'
        }
    }
    HelpInfoURI            = 'https://github.com/sgkens/commitfusion/blob/main/README.md'
    DefaultCommandPrefix   = ''
}

