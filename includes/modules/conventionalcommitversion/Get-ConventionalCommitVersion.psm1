using namespace System.Text.RegularExpressions

<# 
.SYNOPSIS
Generates a SemVer version number from git history using Conventional Commits, returned as a PSCustomObject.
.DESCRIPTION
Anchors to the most recent tag (if any) and only scans commits since that tag. Parses
Conventional Commits subject lines (feat:, fix:, feat!:, etc.) and BREAKING CHANGE: footers
to determine the bump level. Falls back to scanning full history if no tags exist yet.
----
 - `BumpType` field added — tells you which rule actually fired, useful for debugging or 
   for printing in a build log ("bumping minor due to feat commit").

 - `perf` defaults into the patch bucket alongside `fix`, matching what most semantic-release 
   configs do out of the box. If you want perf to not bump at all, just pass `-PatchTypes 'fix'`.

 - `refactor`, `chore`, `docs`, `style`, `test`, `ci`, build intentionally don't bump anything — that's 
   standard Conventional Commits behavior, but it does mean if your whole commit history since 
   the last tag is refactor/chore noise, you'll get no version change at all (version stays at 
   the last tag). That's usually correct, but worth knowing it's not "always bump something" anymore.

 - One thing to decide for your workflow: do you want commitlint wired in as a pre-commit/commit-msg 
   hook so malformed messages get rejected before they ever reach this script? Without enforcement, 
   a typo like ` (extra space) or `featt:` will silently fall through to "no bump" rather than 
   erroring — worth considering if you want hard guarantees rather than best-effort parsing.

.EXAMPLE

Get-ConventionalCommitVersion | Select-Object Version

(Get-ConventionalCommitVersion).Version

.OUTPUTS

[PSCustomObject] with Version, LastTag, CommitsScanned, BumpType

.COMMIT LAYOUT

---
feat(scope): subject

BREAKING CHANGE: subject
---

---
fix: subject
---

---
docs: subject

Notes:
 - This is a note
 - This is another note
---
#>

function Get-ConventionalCommitVersion {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        # Conventional Commit types that bump MINOR
        [string[]]$MinorTypes = @('feat'),
        # Conventional Commit types that bump PATCH
        [string[]]$PatchTypes = @('fix', 'perf')
    )
    process {
        try {
            if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
                throw "Git is not installed, please install git and try again"
            }

            # Anchor to the last tag so we don't replay the entire repo history every run.
            $lastTag = git describe --tags --abbrev=0 2>$null
            $hasTag = $LASTEXITCODE -eq 0 -and $lastTag

            if ($hasTag -and $lastTag -match '^v?(\d+)\.(\d+)\.(\d+)') {
                [int]$major = $Matches[1]
                [int]$minor = $Matches[2]
                [int]$patch = $Matches[3]
                $range = "$lastTag..HEAD"
            }
            else {
                [int]$major = 0
                [int]$minor = 1
                [int]$patch = 0
                $range = $null
                $hasTag = $false
            }

            # -z terminates each commit with NUL instead of newline, so multi-line bodies
            # (and BREAKING CHANGE: footers inside them) don't desync a line-based loop.
            $logArgs = @('log', '--no-color', '-z', '--pretty=format:%s%n%b')
            if ($range) { $logArgs += $range }

            $raw = & git @logArgs
            if ($LASTEXITCODE -ne 0) {
                throw "git log failed (exit code $LASTEXITCODE)"
            }

            $commits = if ($raw) { $raw -split "`0" } else { @() }

            # Conventional Commits subject line: type(scope)!: description
            $subjectPattern = '^(?<type>\w+)(?:\([^)]*\))?(?<breaking>!)?:\s*\S.*$'
            $footerPattern = '(?m)^BREAKING[ -]CHANGE:\s*\S'

            $bumpApplied = 'none'

            foreach ($commit in $commits) {
                if ([string]::IsNullOrWhiteSpace($commit)) { continue }

                $lines = $commit -split "`n", 2
                $subject = $lines[0]
                $body = if ($lines.Count -gt 1) { $lines[1] } else { '' }

                $subjectMatch = [Regex]::Match($subject, $subjectPattern, [RegexOptions]::IgnoreCase)
                $type = if ($subjectMatch.Success) { $subjectMatch.Groups['type'].Value.ToLower() } else { $null }
                $bangBreaking = $subjectMatch.Success -and $subjectMatch.Groups['breaking'].Success
                $footerBreaking = [Regex]::IsMatch($body, $footerPattern, [RegexOptions]::IgnoreCase)

                if ($bangBreaking -or $footerBreaking) {
                    $major++; $minor = 0; $patch = 0
                    $bumpApplied = 'major'
                }
                elseif ($type -and $type -in $MinorTypes) {
                    $minor++; $patch = 0
                    if ($bumpApplied -ne 'major') { $bumpApplied = 'minor' }
                }
                elseif ($type -and $type -in $PatchTypes) {
                    $patch++
                    if ($bumpApplied -eq 'none') { $bumpApplied = 'patch' }
                }
                # any other type (chore/docs/style/refactor/test/ci/build) -> no bump
            }

            return [PSCustomObject]@{
                Version        = "$major.$minor.$patch"
                LastTag        = if ($hasTag) { $lastTag } else { $null }
                CommitsScanned = $commits.Count
                BumpType       = $bumpApplied
            }
        }
        catch {
            Write-Error "An error occurred while creating AutoVersion Number: $($_.Exception.Message)"
        }
    }
}

Export-ModuleMember -Function Get-ConventionalCommitVersion