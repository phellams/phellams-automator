# 🐳  Phellams-PSM-Builder
![Static Badge](https://img.shields.io/badge/License-MIT-Blue?style=for-the-badge&labelColor=%232D2D34&color=%2317202a)

Docker image debian base containing **.Net Core SDK**, **PowerShell Core.x**, **NuGet**, **Pester**, **PSScriptAnalyzer**, **PowerShell-Yaml**, **ColorConsole**, **Nupsforge**, **Psmpacker**, **CSVerify**, **GitAutoVersion**, and custom **PowerShell Profile**.

Used to build powershell modules, can be used to build other things as well depending on your needs.

## Container Manifest

[![arc][arc-version]][arc-url] [![docker][docker-version]][docker-url] ![docker][docker-size] ![docker][docker-pulls]


***🔵 Binaries***
- [**.Net Core SDK channel 8.0** ](https://dotnet.microsoft.com/download/dotnet-core/current)
- [**PowerShell Core 7.4.5**](https://github.com/PowerShell/PowerShell)
- [**NuGet**](https://www.nuget.org/downloads)

***🔵 Modules***
- [**Pester 5.5.0**](https://github.com/pester/Pester) ⬅ Testing framework for PowerShell
- [**PsScriptAnalyzer 1.0**](https://github.com/PowerShell/Psscriptanalyzer) ⬅ PowerShell Script Analyzer
- [**PowerShell-Yaml 1.0**](https://github.com/cloudbase/powershell-yaml) PowerShell YAML parser
- [**ColorConsole**](https://github.com/phellams/colorconsole) ⬅ Colorful console output
- [**Nupsforge**](https://github.com/phellams/nupsforge) ⬅ NuGet Package Builder
- [**Psmpacker**](https://github.com/phellams/psmpacker) ⬅ Build Generator
- [**CSVerify**](https://github.com/phellams/csverify) ⬅ Code Verification
- [**GitAutoVersion**](https://github.com/phellams/CommitFusion/blob/main/src/Get-GitAutoVersion.psm1)  Git Versioning

***🔵 Powershell Profile***
- ***powerShell.profile.ps1*** ⬅ Custom powershell profile with default output displaying container, modules and binaries info included in the image.



## Build

[![build][build-status]][build-url]

🟣 Building the container locally.

```bash
git clone https://github.com/sgkens/phellams-psm-builder.git
cd phellams-psm-builder
docker build -t phellams-psm-builder -f phellams-psm-builder.dockerfile .
docker image inspect phellams-psm-builder #| jq
``` 

🟣 Testing the container.

```bash 
docker run --rm phellams-psm-builder pwsh -c pwsh
```

## Usage

🟣 Output container information.

```bash
docker run --rm phellams-psm-builder pwsh
```

🟣 Running `nuget pack` with folder passthrough.

```bash
docker run -rm -it -v $(pwd):phellams sgkens/phellams-psm-builder nuget pack /phellams/.
```

🟣 Container Usage

```bash
docker run --rm sgkens/phellams-psm-builder:latest pwsh -c '$PSVersionTable.PSVersion.ToString()'

# Running script in container
docker run -it --rm -v $(pwd):/phellams -w /phellams sgkens/phellams-psm-builder:latest pwsh -c './phellams/myscript.ps1'
```


<!-- MARKDOWN LINKS & IMAGES -->
[arc-version]: https://img.shields.io/badge/Debian-12.7-cyan?logo=ubuntu&color=%232D2D34&labelcolor=red&style=for-the-badge
[arc-url]: https://hub.docker.com/r/sgkens/phellams-psm-builder
[docker-version]: https://img.shields.io/docker/v/sgkens/phellams-psm-builder?style=for-the-badge&logo=docker&logoColor=%233478BD&logoSize=auto&labelColor=%232D2D34&color=%23446878
[docker-url]: https://hub.docker.com/r/sgkens/phellams-psm-builder/tags
[docker-size]: https://img.shields.io/docker/image-size/sgkens/phellams-psm-builder?style=for-the-badge&logo=docker&logoColor=%233478BD&logoSize=auto&labelColor=%232D2D34&color=%23446878
[docker-pulls]: https://img.shields.io/docker/pulls/sgkens/phellams-psm-builder?style=for-the-badge&logo=docker&logoColor=%233478BD&logoSize=auto&labelColor=%232D2D34&color=%23446878
[build-status]:https://img.shields.io/gitlab/pipeline-status/phellams%2Fphellams-psm-builder?style=for-the-badge&logo=Gitlab&logoColor=%233478BD&labelColor=%232D2D34
[build-url]: https://gitlab.com/phellams/phellams-psm-builder/-/pipelines