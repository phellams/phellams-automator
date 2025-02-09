@{
    RootModule        = 'Get-GitAutoVersion.psm1'
    ModuleVersion     = '0.1.0.0'
    Description       = 'Get-GitAutoVersion - Generate and return SemVer Version number'
    GUID              = 'c4d8e0b6-7b7b-4d8c-9e8d-8d9d7b7b7b7b'
    CompanyName       = 'phellams'
    Author            = 'Garvey Snow'
    Copyright           = 'MIT License'
    NestedModules     = @('Get-GitAutoVersion.psm1')
    FunctionsToExport = @('Get-GitAutoVersion')
    AliasesToExport   = @('cfav')
    CmdletsToExport   = @()
    VariablesToExport = @()
    PrivateData       = @{
        PSData = @{
            Prerelease      = 'preview1'
            Tags            = @('version', 'git')
            ProjectUri      = 'https://github.com/phellams/gitautoversion'
            IconUri         = 'https://raw.githubusercontent.com/phellams/gitautoversion/main/assets/gitautoversion.png'
            LicenseUri      = 'https://github.com/phellams/gitautoversion/blob/main/LICENSE'
            ReleaseNotes    = ""
            ReleaseNotesUri = 'https://github.com/phellams/gitautoversion/blob/main/CHANGELOG.md'
        }
    }
}