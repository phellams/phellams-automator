<a id="top"></a>

# **Phellams-Automator**

![Static Badge][license-badge] [![arc][arc-version]][arc-url] [![docker][docker-version]][docker-url] ![docker][docker-size] ![docker][docker-pulls] [![build][build-status]][build-url]

## **About The Project**

**Phellams-Automator** is a multi-language build environment based on *Debian-12-slim*. While engineered specifically for integration with the [Automator-Devops](https://gitlab.com/phellams/Automator-Devops) suite, it functions as a standalone runner image optimized for multi-platform CI/CD pipelines.

---

## **Features & Capabilities**

### **Automation Toolchain**

* **PowerShell Pipeline:** Automated module packaging into directory structures, `.zip` archives, or `.nupkg` artifacts via **Psmpacker**.
* **Version Management:** Automated Semantic Versioning orchestration via **GitAutoVersion**.
* **Documentation Engine:** Native man-page and help-file generation via **Phwriter**.
* **Integrity Verification:** Automated checksum generation and verification via **CSVerify**.

### **Multi-Language Build Systems**

* **.NET:** Native execution support for `dotnet build` and `dotnet pack` targetting SDK v8 and v10 (including AOT compilation targets).
* **Package Management:** Native `nuget pack` capabilities coupled with custom **Nupsforge** cmdlets for multi-repository distribution (GitLab, Chocolatey, ProGet).
* **JavaScript / TypeScript:** Native execution handled via **Bun** for high-velocity runtime performance (replacing standard Node.js).
* **Systems Languages:** Built-in toolchains for **Rust**, **Go**, and **Elixir**.
* **Ruby / Jekyll:** Optimized runner configuration featuring integrated **Bundler** with CI hardening policies:
* Overridden `BUNDLE_SILENCE_ROOT_WARNING: "1"`
* Enforced deterministic dependency pathing via `BUNDLE_PATH: "vendor/bundle"`
* Pre-baked system dependencies (`ruby-dev`, `build-essential`) to eliminate runtime compilation failures.



### **CI/CD & DevOps Integration**

* Native optimization for **GitLab CI** execution runners.
* Pre-configured, zero-dependency coverage upload targets for **Codecov** and **Coveralls**.

### **Feature Matrix & Roadmap**

| Capability | Component / Runtime | Status |
| --- | --- | --- |
| **PowerShell Core** | Module packaging, testing, and distribution | 🟩 Production Ready |
| **.NET Toolchain** | Compilation, packing, and AOT support | 🟩 Production Ready |
| **JS/TS Runtime** | Bun execution engine | 🟩 Production Ready |
| **Node.js Compatibility** | Bun-backed Node.js emulation interface | 🟨 Work In Progress |
| **DevOps Pipelines** | Codecov & Coveralls reporting agents | 🟩 Production Ready |
| **PHP8 Ecosystem** | Native runtime, PHPStan, PHPUnit, Composer | 🟥 Planned |
| **Python Toolchain** | Environment runtimes | 🟥 Planned |

<div align="right"><a href="#top"><code>☝</code> <b>Back to top</b></a></div>

---

## **Image Manifest**

### **System Binaries**

* 🟩 **[.NET SDK v8.0.412 & v10.0.103](https://dot.net)**
* 🟩 **[PowerShell Core 7.5.3](https://github.com/PowerShell/PowerShell)**
* 🟩 **[Bun Runtime](https://bun.sh)**
* 🟩 **[NuGet 6.x](https://www.nuget.org/)** *(via Mono)*
* 🟩 **[Go Compiler](https://go.dev)**
* 🟩 **[Rust Toolchain](https://www.rust-lang.org)**
* 🟩 **[Elixir Runtime](https://elixir-lang.org)**
* 🟩 **[Ruby & Jekyll](https://www.ruby-lang.org)** *(with hardened Bundler toolset)*
* 🟩 **[Codecov / Coveralls CLI](https://codecov.io)**

### **Pre-Baked PowerShell Modules**

* 🟦 **Pester** & **PSScriptAnalyzer** *(Testing & Static Analysis)*
* 🟦 **PowerShell-Yaml** *(Data Serialization)*
* 🟦 **ColorConsole** & **Quicklog** *(UI Layout & High-Performance Logging)*
* 🟦 **Tadpol** *(Runspace Progress Bars & Spinners)*
* 🟦 **ShellDock** *(Isolated Runspace Executor)*
* 🟦 **Nupsforge**, **Psmpacker**, **CSVerify**, **GitAutoVersion** *(Core Build Stack)*


<div align="right"><a href="#top"><code>☝</code> <b>Back to top</b></a></div>

---

## **Build & Local Usage**

### **Building the Image Locally**

**Using Docker CLI:**

```bash
docker buildx build -t phellams-automator -f phellams-automator.dockerfile .
```

**Using local PowerShell Orchestrator:**

```powershell
./phellams-automator-local-builder.ps1 -buildMode Base
```

### **Automation Script Parameters**

| Parameter | Type | Description |
| --- | --- | --- |
| **`-Automator`** | Switch | Forces execution inside the local container context. |
| **`-Pester`** | Switch | Executes the Pester test suite validation layer prior to building. |
| **`-Build`** | Switch | Compiles and writes the completed package artifacts into the `dist/` directory. |
| **`-Nuget`** | Switch | Generates compliance-ready NuGet package objects. |

<div align="right"><a href="#top"><code>☝</code> <b>Back to top</b></a></div>

---

## **Roadmap**

### **Current Phase: Beta**

* 🔄 **Infrastructure Modernization**
* 🔹 Transition base layer to Debian 13 (Trixie) slim profile.
* 🔹 Implement automated Multi-platform engine targets (`amd64`/`arm64`).
* 🔹 Completely abstract Node.js reliance over to Bun.
* 🔄 **Technical Debt Mitigation**
* 🔹 Automate vulnerability scanning and resolve downstream image CVEs.
* 🔹 Standardize TUI padding and performance behaviors across console tooling components.


<div align="right"><a href="#top"><code>☝</code> <b>Back to top</b></a></div>

---

## **Contributing & License**

### **Contributing**
1. Fork the Project.
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`).
3. Commit your Changes (`git commit -m 'feat: Add AmazingFeature'`).
4. Push to the Branch (`git push origin feature/AmazingFeature`).
5. Open a **Merge Request**.

### **License**
Distributed under the **MIT License**. See `LICENSE` for more information.

<div align="right"><a href="#top"><code>☝</code> <b>Back to top</b></a></div>

---

[phellams-logo-link]: https://raw.githubusercontent.com/phellams/phellams-general-resources/main/logos/phellams/dist/png/phellams-logo-16x16.png
[commitfusion-logo-link]: https://raw.githubusercontent.com/phellams/phellams-general-resources/main/logos/commitfusion/dist/png/commitfusion-logo-16x16.png
[arc-version]: https://img.shields.io/badge/Debian-12.13_slim-cyan?logo=ubuntu&color=%232D2D34&labelcolor=red&style=flat
[arc-url]: https://hub.docker.com/r/sgkens/phellams-automator
[docker-version]: https://img.shields.io/docker/v/sgkens/phellams-automator?style=flat&logo=docker&logoColor=%233478BD&logoSize=auto&labelColor=%232D2D34&color=%23446878
[docker-url]: https://hub.docker.com/r/sgkens/phellams-automator/tags
[docker-size]: https://img.shields.io/docker/image-size/sgkens/phellams-automator?style=flat&logo=docker&logoColor=%233478BD&logoSize=auto&labelColor=%232D2D34&color=%23446878
[docker-pulls]: https://img.shields.io/docker/pulls/sgkens/phellams-automator?style=flat&logo=docker&logoColor=%233478BD&logoSize=auto&labelColor=%232D2D34&color=%23446878
[build-status]: https://img.shields.io/gitlab/pipeline-status/phellams%2Fphellams-automator?style=flat&logo=Gitlab&logoColor=%233478BD&labelColor=%232D2D34
[build-url]: https://gitlab.com/phellams/phellams-automator/-/pipelines
[license-badge]: https://img.shields.io/badge/License-MIT-Blue?style=flat&labelColor=%232D2D34&color=%2317202a
