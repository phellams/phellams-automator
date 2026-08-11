BeforeAll {
    . ([System.IO.Path]::Combine($PSScriptRoot, '..', 'includes', 'modules', 'asciitokenizer.ps1'))
}

Describe 'Get-AnsiForegroundSgr' {
    It 'preserves 24-bit RGB output in TrueColor mode' {
        Get-AnsiForegroundSgr -Rgb '101;165;191' -ColorMode TrueColor |
            Should -Be '38;2;101;165;191'
    }

    It 'converts RGB output to a valid xterm-256 foreground code' {
        $sgr = Get-AnsiForegroundSgr -Rgb '101;165;191' -ColorMode Indexed256

        $sgr | Should -Match '^38;5;\d{1,3}$'
        [int]($sgr.Split(';')[-1]) | Should -BeIn (0..255)
    }

    It 'selects xterm-256 output automatically in GitLab CI' {
        $previousGitLabCi = $env:GITLAB_CI
        try {
            $env:GITLAB_CI = 'true'

            Get-AnsiForegroundSgr -Rgb '101;165;191' -ColorMode Auto |
                Should -Match '^38;5;\d{1,3}$'
        }
        finally {
            $env:GITLAB_CI = $previousGitLabCi
        }
    }

    It 'selects TrueColor output automatically outside GitLab CI' {
        $previousGitLabCi = $env:GITLAB_CI
        try {
            Remove-Item Env:GITLAB_CI -ErrorAction SilentlyContinue

            Get-AnsiForegroundSgr -Rgb '101;165;191' -ColorMode Auto |
                Should -Be '38;2;101;165;191'
        }
        finally {
            $env:GITLAB_CI = $previousGitLabCi
        }
    }
}

Describe 'Write-GradientAscii' {
    It 'does not emit TrueColor sequences when GitLab CI mode is active' {
        $tokens = ConvertTo-AsciiTokens -Lines @('ABC')
        $output = Write-GradientAscii -TokenObject $tokens -ColorMode Indexed256 6>&1
        $rendered = $output.ToString()

        $rendered | Should -Match "$([char]27)\[38;5;\d{1,3}m"
        $rendered | Should -Not -Match "$([char]27)\[38;2;"
    }
}
