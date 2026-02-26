# 🐳  Phellams-Automator

![Static Badge][license-badge]

## About The Project

Debian-based Docker image derived from *Debian-12-slim*.

Use case:

* Build: **PowerShell** modules in the form of `folder`, `.zip`, or `.nupkg`.
* Build: **.NET** binaries.

  * .NET SDK v8.0.412

    * Libraries and binaries (AOT)
  * .NET SDK v10.0.103

    * Libraries and binaries (AOT)
* Build: **NuGet** packages:

  * GitLab `.nupkg` packages.
  * Chocolatey `.nupkg` packages.
  * ProGet NuGet `.nupkg` packages.
  * ProGet Chocolatey `.nupkg` packages.
* Send: **Codecov** results/reports.
* Send: **Coveralls** results/reports.
* Build: **RubyGems** gems.
* Build: **Jekyll** websites.

  * Build **Gem-based** Jekyll websites.

This image is intended to be used with the [Automator-Devops](https://gitlab.com/phellams/Automator-Devops) automation suite to build and deploy PowerShell modules, .NET binaries, NuGet packages, Chocolatey packages, RubyGems packages, and Jekyll websites.

This image is not intended to be used as a standalone image. It is intended to be used with the Automator-Devops automation suite or other similar automation suites or scripts.

---

## Features

**Copy Build files:**

> **NOTE!** PowerShell module specific

* `Build-Module` from **Psmpacker**. See the [README](https://github.com/phellams/psmpacker/blob/main/README.md) for more information on how to use **Psmpacker**.

**Build .NET binaries:**

* `dotnet build`. See the [README](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-build) for more information on how to use `dotnet build`.

**Package .nupkg packages:**

* `nuget pack`. See:

  * [creating-a-package](https://learn.microsoft.com/en-us/nuget/create-packages/creating-a-package) for more information on how to create a NuGet package.
  * [using nuget pack](https://learn.microsoft.com/en-us/nuget/reference/cli-reference/cli-ref-pack) for more information on how to use `nuget pack`.

**Package .nupkg packages compatible with `psgallery`, `chocolatey`, `gitlab packages`, `github packages`:**

* Chocolatey `.nupkg` packages: `New-ChocoNuspecFile` and `New-ChocoPackage`. See the [README](https://github.com/phellams/nupsforge/blob/main/README.md) for more details on how to use Nupsforge.
* ProGet NuGet `.nupkg` packages: `New-NuspecPackageFile` and `New-NupkgPackage`. See the [README](https://github.com/phellams/nupsforge/blob/main/README.md) for more details on how to use Nupsforge.
* ProGet Chocolatey `.nupkg` packages: `New-ChocoNuspecFile` and `New-ChocoPackage`. See the [README](https://github.com/phellams/nupsforge/blob/main/README.md) for more details on how to use Nupsforge.

**Generate Verification Checksums:**

* `New-VerificationFile` from [csverify](https://github.com/sgkens/csverify). See the [README](https://github.com/phellams/csverify/blob/main/README.md) for more information on how to use `csverify`.

**Generate Semantic Version using `Get-GitAutoVersion` cmdlet:**

* Git semantic versioning generator: `Get-GitAutoVersion` cmdlet.

**Publish code coverage results to [codecov](https://codecov.io):**

* Publish code coverage results to Codecov.

**Publish code coverage results to [coveralls](https://coveralls.io):**

* Publish code coverage results to Coveralls.

**Run PowerShell commands and scripts using default shell:**

* `pwsh -c './phellams/myscript.ps1'`

**Build, pack, and deploy RubyGems:**

* [WIP] Build, pack, and deploy RubyGems packages using `GemCommander`. See the [README](https://github.com/phellams/GemCommander/blob/main/README.md) for more details on how to use GemCommander.

**Build, pack, and deploy Jekyll websites:**

* [WIP] Build, pack, and deploy Jekyll websites using `JekyllCommander`. See the [README](https://github.com/phellams/JekyllCommander/blob/main/README.md) for more details on how to use JekyllCommander.

---

## Image Manifest

[![arc][arc-version]][arc-url] [![docker][docker-version]][docker-url] ![docker][docker-size] ![docker][docker-pulls]

### ***🟣 Binaries***

* ✅ [**.NET SDK v8.0.412**](learn.microsoft.com/en-us/dotnet/core/install/linux-debian?tabs=dotnet9)
* ✅ [**.NET SDK v10.0.103**](learn.microsoft.com/en-us/dotnet/core/install/linux-debian?tabs=dotnet10)
* ✅ [**PowerShell Core 7.5.2**](https://github.com/PowerShell/PowerShell)
* ✅ [**Git**](https://git-scm.com/)
* ✅ [**Chocolatey**](https://chocolatey.org/)

  * For Choco packages `choco pack` and `choco push`, use the official Choco Docker image: [https://github.com/chocolatey/choco-docker](https://github.com/chocolatey/choco-docker). You can build the `.nuspec` file with Nupsforge and then use the Choco Docker image to pack and deploy.
  * > Note! Chocolatey is not officially supported on Linux, but it can be run through Mono.
  * > Note! Chocolatey can be compiled to run on Mono but requires special configuration.
* ✅ [**NuGet**](https://www.nuget.org/downloads)

  * NuGet 6.x is executed through Mono and can be called using the default `nuget` executable.
* ✅ [**Codecov**](https://codecov.io)
* ✅ [**curl**](https://everything.curl.dev/)
* ✅ [**wget**](https://www.gnu.org/software/wget/)
* ✅ [**Ruby**](https://www.ruby-lang.org/en/documentation/installation/#apt)
* ✅ [**RubyGems**](https://rubygems.org/pages/download)

### ***🟡 Common Binaries***

* ✅ [**gpg**](https://www.gnupg.org/)
* ✅ [**apt-transport-https**](https://packages.debian.org/bookworm/apt-transport-https)
* ✅ [**software-properties-common**](https://packages.debian.org/bookworm/software-properties-common)
* ✅ [**ca-certificates**](https://packages.debian.org/bookworm/ca-certificates)

### ***🔵 PowerShell Modules***

* [**✅ Pester 5.5.0**](https://gitlab.com/pester/Pester)

  * Testing framework for PowerShell.
* ✅ [**PSScriptAnalyzer 1.0**](https://gitlab.com/PowerShell/Psscriptanalyzer)

  * PowerShell script analyzer.
* ✅ [**PowerShell-Yaml 1.0**](https://gitlab.com/cloudbase/powershell-yaml)

  * PowerShell YAML parser.
* ✅ [**ColorConsole**](https://gitlab.com/phellams/colorconsole)

  * Colorful console output using ANSI escape sequences with the default PowerShell console color palette.
* ✅ [**Tadpol**](https://gitlab.com/phellams/tadpol)

  * Progress bars, loaders, and spinners generator.
* ✅ [**ShellDock**](https://gitlab.com/phellams/shelldock)

  * Simple runspace executor with progress indicator.
* ✅ [**Quicklog**](https://gitlab.com/phellams/quicklog)

  * Console logger with color support.
* ✅ [**Nupsforge**](https://gitlab.com/phellams/nupsforge)

  * NuGet package generator supporting: **psgallery**, **chocolatey**, **proget** (psgallery, chocolatey), **gitlab packages**, **github packages**.
* ✅ [**Psmpacker**](https://gitlab.com/phellams/psmpacker)

  * Build folder generator.
* ✅ [**CSVerify**](https://gitlab.com/phellams/csverify)

  * Code verification via `VERIFICATION.txt`.
* ✅ [**GitAutoVersion**](https://gitlab.com/phellams/CommitFusion/blob/main/src/Get-GitAutoVersion.psm1)

  * Git semantic versioning generator.
* ✅ [**Phwriter**](https://gitlab.com/phellams/phwriter)

  * Generate Linux man pages for PowerShell cmdlets/functions.
* [***WIP***] [**GemCommander**](https://gitlab.com/phellams/GemCommander)

  * Build and deploy RubyGems packages.
* [***WIP***] [**JekyllCommander**](https://gitlab.com/phellams/JekyllCommander)

  * Build and deploy Jekyll websites.

### ***🔵 PowerShell Profile***

* ✅ ***PowerShell.profile.ps1***

  * Custom PowerShell profile displaying image information.
  * Imports modules and functions from the `./includes` folder.

## Build

[![build][build-status]][build-url]

### Building the image locally

Clone and run `docker build -t phellams-automator -f phellams-automator.dockerfile .` to build the image.

```bash
git clone https://gitlab.com/phellams/phellams-automator.git
cd phellams-automator
docker build -t phellams-automator -f phellams-automator.dockerfile .
docker image inspect phellams-automator #| jq
```

or alternatively, use the local build script:

```powershell
# Windows
./phellams-automator-local-builder.ps1 -buildMode Base

# linux
sudo pwsh -c ./phellams-automator-local-builder.ps1 -buildMode Base
```

> Local builds are tagged with `:localbuild`

## Usage

### Output image information
> Default shell is `pwsh` and will output the container information.

```bash
docker run --rm phellams-automator
```

### Mount path examples

```bash
# dynamic path
docker run -it -v .:/phellams-automator docker.io/sgkens/phellams-automator 

# absolute path
docker run -it -v $(pwd):/phellams-automator docker.io/sgkens/phellams-automator
```
Or, if you want to use the absolute path with WSL2:

```bash
# Wsl2
docker run -it -v $(wslpath -w $(pwd)):/phellams-automator docker.io/sgkens/phellams-automator
```

```bash
# Linux
docker run -it -v $(pwd):/phellams-automator docker.io/sgkens/phellams-automator
```


### Examples running commands inside the container

```bash
# nuget
docker run --rm -v .:yourfolder docker.io/sgkens/phellams-automator nuget pack ./

# pester
docker run --rm -v .:yourfolder docker.io/sgkens/phellams-automator invoke-pester -script ./tests/tests.ps1

# psscriptanalyzer
docker run --rm -v .:yourfolder docker.io/sgkens/phellams-automator invoke-psscriptanalyzer -script ./tests/tests.ps1

# dotnet
docker run --rm -v .:yourfolder docker.io/sgkens/phellams-automator dotnet build

# gitautoversion
docker run --rm -v .:yourfolder docker.io/sgkens/phellams-automator (Get-Gitautoversion).Version
```

###  Interactive shell

```bash
docker run --rm -it -v .:yourfolder docker.io/sgkens/phellams-automator:latest

# Running script in container
docker run -it --rm -v $(pwd):/phellams -w /phellams sgkens/phellams-automator:latest pwsh -c './phellams/myscript.ps1'
```

<!-- ROADMAP -->
## Roadmap

### 🟡 **Task List**

- [x] Add Ruby support to allow building of jekyll websites
  - [x] Add RubyGems support - required dependencies
- [ ] Add Jekyll support
- [ ] Add toml support with ptoml, and linux toml support
- [x] Add chocolatey support **Chocolatey is not officially supported by linux*** however it doesnt explicitly say it is not supported, use mono and compile choco for mono, use choco offical package, `docker.io/chocolatey/choco:latest`
- [ ] Fix outstanding Security Vulnerabilities reported by dockerhub vulnerability scanner. 
- [x] update nupsforge to support gitlab packages
- [x] Add coveralls
- [x] add codecov
- [x] add nuget via mono to access nuget v 6.x + in debian 12
- [ ] use mono to attempt to run choco executable
  - [x] opted to use mono docker image to run choco builds and deploy does support all but for build and deploy choco packages to chocolatey is sufficent.
- [ ] Start porting binaries to Debian bins 13 slim and test

## Contributing

Feel free to contribute!  Fork the repo and submit a **merge request** with your improvements.  Or, open an **issue** with the `enhancement` tag to discuss your ideas.

1. Fork the Project from `git clone https://gitlab.com/phellams/phellams-automator.git`
2. Create your Feature Branch check out the branch dev `git switch dev`.
   1. `git switch -c feature/AmazingFeature`
   2. or 
   3. `git checkout -b feature/AmazingFeature`
3. Commit your Changes `git commit -m 'Add some AmazingFeature'`
4. Push to the Branch `git push origin feature/AmazingFeature`
5. [Open a Merge Request](https://gitlab.com/phellams/phellams-automator/-/merge_requests/new)

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information. 

## Changelog


<!-- MARKDOWN LINKS & IMAGES -->
[arc-version]: https://img.shields.io/badge/Debian-12.13_slim-cyan?logo=ubuntu&color=%232D2D34&labelcolor=red&style=for-the-badge
[arc-url]: https://hub.docker.com/r/sgkens/phellams-automator
[docker-version]: https://img.shields.io/docker/v/sgkens/phellams-automator?style=for-the-badge&logo=docker&logoColor=%233478BD&logoSize=auto&labelColor=%232D2D34&color=%23446878
[docker-url]: https://hub.docker.com/r/sgkens/phellams-automator/tags
[docker-size]: https://img.shields.io/docker/image-size/sgkens/phellams-automator?style=for-the-badge&logo=docker&logoColor=%233478BD&logoSize=auto&labelColor=%232D2D34&color=%23446878
[docker-pulls]: https://img.shields.io/docker/pulls/sgkens/phellams-automator?style=for-the-badge&logo=docker&logoColor=%233478BD&logoSize=auto&labelColor=%232D2D34&color=%23446878
[build-status]: https://img.shields.io/gitlab/pipeline-status/phellams%2Fphellams-automator?style=for-the-badge&logo=Gitlab&logoColor=%233478BD&labelColor=%232D2D34
[build-url]: https://gitlab.com/phellams/phellams-automator/-/pipelines
[gitlab-badge]: https://img.shields.io/badge/gitlab-4B0082?style=for-the-badge&logo=gitlab&logoColor=orange
[github-badge]: https://img.shields.io/badge/github-mirror-383838?style=for-the-badge&logo=github&logoColor=white
[license-badge]: https://img.shields.io/badge/License-MIT-Blue?style=for-the-badge&labelColor=%232D2D34&color=%2317202a

