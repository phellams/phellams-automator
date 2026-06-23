@{
    RootModule        = 'conventionalcommitversion.psm1'
    ModuleVersion     = '0.1.0'
    Description       = 'Generates a SemVer version number from git history using Conventional Commits, returned as a PSCustomObject.'
    GUID              = '61d24b42-2b1e-4000-bc8e-cb9275fde621'
    CompanyName       = 'phellams'
    Author            = 'Garvey K. Snow'
    Copyright           = 'MIT License'
    FunctionsToExport = @('Get-ConventionalCommitVersion')
    AliasesToExport   = @('gccv')
    CmdletsToExport   = @()
    VariablesToExport = @()
    PrivateData       = @{
        PSData = @{
            Prerelease      = 'preview1'
            Tags            = @('version', 'git')
            ProjectUri      = 'https://github.com/phellams/phellams-utils'
            IconUri         = 'https://raw.githubusercontent.com/phellams/phellams-utils/main/assets/phellams-utils.png'
            LicenseUri      = 'https://github.com/phellams/phellams-utils/blob/main/LICENSE'
            ReleaseNotes    = ""
            ReleaseNotesUri = 'https://github.com/phellams/phellams-utils/blob/main/CHANGELOG.md'
        }
    }
}