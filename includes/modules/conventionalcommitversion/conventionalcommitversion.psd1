@{
    RootModule        = 'conventionalcommitversion.psm1'
    ModuleVersion     = '0.1.0'
    Description       = 'Generates a SemVer version number from git history using Conventional Commits, returned as a PSCustomObject.'
    GUID              = '61d24b42-2b1e-4000-bc8e-cb9275fde621'
    CompanyName       = 'phellams'
    Author            = 'Garvey K. Snow'
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