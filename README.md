# 🐳  Phellams-Automator

```
                  ___
              ........          
        .    ..xxxxxx...   .   
          ≡-«( •)xx( •)»-≡                    _  _ 
              ..xxxx..                 /     // //  
               x[--]x.            _   /_  _ // // __.  ______  _  
            ....xxxx....         /_)_/ /_</_</_</_(_/|_/ / / <_/_)_
          ...xxxxxxxxxx...      / [P]owers[HELL][A]uto[M]ation[S]
       .... .xxxxxxxxxx. ....  `
      ...   .xxxxxxxxxx.   ...  
      ..    ..x......x..    ..  
     ....    .x.    .x.    .... 
    .////.  ..x.    .x... .    .
    ..//.    .x.    .x.   ./=/..
      /     .:x.    .x:. -| ■ Phellam Automator     
      ┋    ../..    ..\..-| ■ [ MIT ][ License ]
      ┋    -----    ----- | ■ v0.3.0                   
  ┌───┴───┐
  ▙ Shell ▟
─── ─ ••• ─ ─ ─────────────────────
```

![Static Badge](https://img.shields.io/badge/License-MIT-Blue?style=for-the-badge&labelColor=%232D2D34&color=%2317202a)

## About The Project

Debian base docker image base on *Debian-slim*, Used to build:
 - **PowerShell** Modules in the form or `folder`, `.zip`, or `.nupkg`.
 - **Dotnet** binaries.
 - **Nuget** packages for **psgallary** **gitlab**, **github**, and **chocolatey**.
 - **codecov** results.

## Features
 - Copy Build files: `Build-Module` see the **Psmpacker** [README](https://github.com/phellams/psmpacker/blob/main/README.md) for more information on how to use **Psmpacker**.
 - Build `DotNet` binaries: `dotnet build` see the [README](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-build) for more information on how to use `dotnet build`.
 - Package `Nuget` packages using `nuget pack` see:
   - [creating-a-package](https://learn.microsoft.com/en-us/nuget/create-packages/creating-a-package) for more information on how to create a Nuget package.
   - [using nuget pack](https://learn.microsoft.com/en-us/nuget/reference/cli-reference/cli-ref-pack) for more information on how to use nuget pack.
 - Build **Chocolatey** packages using `New-ChocoNuspecfile` and `New-ChocolateyPackage` see the [README](https://github.com/phellams/nupsforge/blob/main/README.md) for more details on how to use nupsforge.
 - Build **nuget** packages compatible with **proget**: `New-NupecFile` and `New-NugetPackage` see the [README](https://github.com/phellams/nupsforge/blob/main/README.md) for more details on how to use nupsforge.
 - Generate **Verification Checksums**: `New-VerificationFile` from [csverify](https://github.com/sgkens/csverify) see the [README](https://github.com/phellams/csverify/blob/main/README.md) for more information on how to use `csverify`.
 - Generate Semantic Version: `Get-SemanticVersion` from [csverify](https://github.com/sgkens/csverify) see the [README](https://github.com/phellams/csverify/blob/main/README.md) for more information on how to use `csverify`.
 - Publish code coverage results to [codecov](https://codecov.io)
 - Run Powershell commands and scripts using default shell: `pwsh -c './phellams/myscript.ps1'`


## Image Manifest

[![arc][arc-version]][arc-url] [![docker][docker-version]][docker-url] ![docker][docker-size] ![docker][docker-pulls]


***🔵 Binaries***
- ✅ [**.Net Core SDK channel 8.0**](https://dotnet.microsoft.com/download/dotnet-core/current)
- ✅ [**PowerShell Core 7.4.5**](https://github.com/PowerShell/PowerShell)
- ✅ [**Nuget**](https://www.nuget.org/downloads)
- ✅ [**Codecov**](https://codecov.io)

***🔵 Common Binaries***
- ✅ [**curl**](https://everything.curl.dev/)
- ✅ [**wget**](https://www.gnu.org/software/wget/)
- ✅ [**gpg**](https://www.gnupg.org/)
- ✅ [**apt-transport-https**](https://packages.debian.org/bookworm/apt-transport-https)
- ✅ [**software-properties-common**](https://packages.debian.org/bookworm/software-properties-common)
- ✅ [**ca-certificates**](https://packages.debian.org/bookworm/ca-certificates)

***🔵 Powershell Modules***
- [**✅ Pester 5.5.0**](https://github.com/pester/Pester)
  - Testing framework for PowerShell.
- ✅ [**PsScriptAnalyzer 1.0**](https://github.com/PowerShell/Psscriptanalyzer)
  - PowerShell Script Analyzer.
- ✅ [**PowerShell-Yaml 1.0**](https://github.com/cloudbase/powershell-yaml) 
  - PowerShell YAML parser.
- ✅ [**ColorConsole**](https://github.com/phellams/colorconsole)
  - Colorful console output using ANSI escape sequences default powershell console color pallete.
- ✅ [**Nupsforge**](https://github.com/phellams/nupsforge)
  - Nuget Package Generator: supports: **psgallary**, **chocolatey**, **proget**(psgallary,chocolatey), **gitlab packages**, **github packages**.
- ✅ [**Psmpacker**](https://github.com/phellams/psmpacker)
  - Build folder Generator.
- ✅ [**CSVerify**](https://github.com/phellams/csverify)
  - Code Verification via VERIFICATION.txt.
- ✅ [**GitAutoVersion**](https://github.com/phellams/CommitFusion/blob/main/src/Get-GitAutoVersion.psm1)
  - Git Semantic Versioning generator.

***🔵 Powershell Profile***
- ✅ ***powerShell.profile.ps1***
  - Custom powershell profile with default output displaying image information: e.g. modules and binaries info included in the image.



## Build

[![build][build-status]][build-url]

🟣 Building the container locally.

From:

![gitlab-logo][gitlab-badge]

```bash
git clone https://gitlab.com/phellams/phellams-automator.git
cd phellams-automator
docker build -t phellams-automator -f phellams-automator.dockerfile .
docker image inspect phellams-automator #| jq

# or use `phellams-automator-local-builder.ps1` powershell script
sudo pwsh -c './phellams-automator-local-builder.ps1'
``` 

![github-logo][github-badge]

```bash
git clone https://github.com/phellams/phellams-automator.git
cd phellams-automator
docker build -t phellams-automator -f phellams-automator.dockerfile .
docker image inspect phellams-automator #| jq

# or use `phellams-automator-local-builder.ps1` powershell script
sudo pwsh -c './phellams-automator-local-builder.ps1'
```

## Usage

🟣 Output container information.

```bash
docker run --rm phellams-automator
```
🟢 Mount paths examples for running commands inside the container.

```bash
# dynamic path
docker run -it -v .:/phellams-automator docker.io/sgkens/phellams-automator
# absolute path
docker run -it -v $(pwd):/phellams-automator docker.io/sgkens/phellams-automator
```
Or, if you want to use the absolute path with WSL2:

```bash 
docker run -it -v $(wslpath -w $(pwd)):/phellams-automator docker.io/sgkens/phellams-automator
```


🟣 Some examples running commands inside the container.

```bash
# nuget
docker run --rm -v .:yourfolder docker.io/sgkens/phellams-automator nuget pack ./
# pester
docker run --rm -v .:yourfolder docker.io/sgkens/phellams-automator invoke-pester -script .\tests\tests.ps1
# psscriptanalyzer
docker run --rm -v .:yourfolder docker.io/sgkens/phellams-automator invoke-psscriptanalyzer -script .\tests\tests.ps1
# dotnet
docker run --rm -v .:yourfolder docker.io/sgkens/phellams-automator dotnet build
# gitautoversion
docker run --rm -v .:yourfolder docker.io/sgkens/phellams-automator (Get-Gitautoversion).Version
```

🟣 Interactive shell

```bash
docker run --rm -it -v .:yourfolder docker.io/sgkens/phellams-automator:latest

# Running script in container
docker run -it --rm -v $(pwd):/phellams -w /phellams sgkens/phellams-automator:latest pwsh -c './phellams/myscript.ps1'
```

<!-- ROADMAP -->
## Roadmap

🟡 **Task List**

- [ ] Add Ruby support to allow building of jekyll websites
  - [ ] Add RubyGems support - required dependencies
- [ ] Add toml support with ptoml
- [ ] Add chocolatey support **Chocolatey is not officially supported by linux*** however it doesnt explicitly say it is not supported.
- [ ] Fix outstanding Security Vulnerabilities reported by dockerhub vulnerability scanner. 

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


<!-- MARKDOWN LINKS & IMAGES -->
[arc-version]: https://img.shields.io/badge/Debian-12.9_slim-cyan?logo=ubuntu&color=%232D2D34&labelcolor=red&style=for-the-badge
[arc-url]: https://hub.docker.com/r/sgkens/phellams-automator
[docker-version]: https://img.shields.io/docker/v/sgkens/phellams-automator?style=for-the-badge&logo=docker&logoColor=%233478BD&logoSize=auto&labelColor=%232D2D34&color=%23446878
[docker-url]: https://hub.docker.com/r/sgkens/phellams-automator/tags
[docker-size]: https://img.shields.io/docker/image-size/sgkens/phellams-automator?style=for-the-badge&logo=docker&logoColor=%233478BD&logoSize=auto&labelColor=%232D2D34&color=%23446878
[docker-pulls]: https://img.shields.io/docker/pulls/sgkens/phellams-automator?style=for-the-badge&logo=docker&logoColor=%233478BD&logoSize=auto&labelColor=%232D2D34&color=%23446878
[build-status]:https://img.shields.io/gitlab/pipeline-status/phellams%2Fphellams-automator?style=for-the-badge&logo=Gitlab&logoColor=%233478BD&labelColor=%232D2D34
[build-url]: https://gitlab.com/phellams/phellams-automator/-/pipelines
[gitlab-badge]: https://img.shields.io/badge/gitlab-4B0082?style=for-the-badge&logo=gitlab&logoColor=orange
[github-badge]: https://img.shields.io/badge/github-383838?style=for-the-badge&logo=github&logoColor=white