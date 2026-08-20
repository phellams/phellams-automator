Describe 'PowerShell profile banner' {
    BeforeAll {
        $repositoryRoot = [System.IO.Path]::GetFullPath(
            [System.IO.Path]::Combine($PSScriptRoot, '..')
        )
        $profilePath = [System.IO.Path]::Combine(
            $repositoryRoot,
            'includes',
            'Microsoft.PowerShell_profile.ps1'
        )
        $minimalLogoPath = [System.IO.Path]::Combine(
            $repositoryRoot,
            'includes',
            'asciilogo-minimal.txt'
        )
        $aboutScriptPath = [System.IO.Path]::Combine(
            $repositoryRoot,
            'scripts',
            'Get-About.ps1'
        )
    }

    It 'uses a compact banner with separate binary and module lines' {
        $minimalLogoLines = [System.IO.File]::ReadAllLines($minimalLogoPath)

        $minimalLogoLines.Count | Should -Be 3
        $minimalLogoLines | Should -Not -Contain ''
        $minimalLogoLines[1] | Should -Match '\[binary-versions\]'
        $minimalLogoLines[2] | Should -Match '\[module-versions\]'
    }

    It 'loads the detailed report from the scripts directory' {
        $profileContent = [System.IO.File]::ReadAllText($profilePath)

        $profileContent | Should -Match "'scripts',\s*'Get-About\.ps1'"
        $profileContent | Should -Not -Match 'ConvertTo-AsciiTokens'
    }

    It 'defines Get-About and its About alias' {
        $aboutScriptContent = [System.IO.File]::ReadAllText($aboutScriptPath)

        $aboutScriptContent | Should -Match 'function\s+Get-About'
        $aboutScriptContent | Should -Match 'Set-Alias\s+-Name\s+About\s+-Value\s+Get-About'
        $aboutScriptContent | Should -Match 'Key = "hugo"'
        $aboutScriptContent | Should -Match 'Key = "sass"'
    }
}
