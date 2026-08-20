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

        $minimalLogoLines.Count | Should -BeGreaterThan 0
        $minimalLogoLines | Should -Not -Contain ''
        ($minimalLogoLines -join "`n") | Should -Match '\[binary-versions\]'
        ($minimalLogoLines -join "`n") | Should -Match '\[module-versions\]'
        ($minimalLogoLines -join "`n") | Should -Match '▶ ▶ ▶'
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
        $aboutScriptContent | Should -Match '\[switch\]\$ReturnVersions'
        $aboutScriptContent | Should -Match 'Key = "hugo"'
        $aboutScriptContent | Should -Match 'Key = "sass"'
        $aboutScriptContent | Should -Match '\$binaryContentStart'
        $aboutScriptContent | Should -Match '\$moduleContentStart'
        $aboutScriptContent | Should -Match '\$footerStart'
        $aboutScriptContent | Should -Match '-End @\(255, 128, 0\)'
    }

    It 'requests the shared version registry for the minimal banner' {
        $profileContent = [System.IO.File]::ReadAllText($profilePath)

        $profileContent | Should -Match 'Get-About\s+-ReturnVersions'
        $profileContent | Should -Match 'New-ColorConsole\s+-string.*-color cyan'
        $profileContent | Should -Match 'New-ColorConsole\s+-string.*-color darkgray'
        $profileContent | Should -Match '38;5;117m'
    }
}
