<a id="top"></a>

### `P[owerS]hella[uto]m[ations]` (Powershell Automations)

Houses PowerShell Modules, ***Scripts***, ***Libraries***, ***Tools***, ***Dotnet Libraries***, ***Dotnet (AOT) cli apps***.

#### ☑️ Finished Projects

- ![phellams-logo][phellams-logo-link] [**Phellams-Automator**](https://gitlab.com/phellams/phellams-automator) - *Docker Container to build and publish modules to the PowerShell Gallery, choco, gitlab packages and publish release via gitlab*

- ![commitfusion-logo][commitfusion-logo-link] [**CommitFusion**](https://gitlab.com/phellams/commitfusion) - *Conventional Commit Helper*

---

# **Phellams-Automator**

![Static Badge][license-badge] [![arc][arc-version]][arc-url] [![docker][docker-version]][docker-url] ![docker][docker-size] ![docker][docker-pulls] [![build][build-status]][build-url]

## **About The Project**

**Phellams-Automator** is a high-performance, multi-language build environment based on *Debian-12-slim*. It is specifically designed to work with the [Automator-Devops](https://gitlab.com/phellams/Automator-Devops) suite.

**💠 Use Cases:**

* 🔹 **PowerShell:** Build modules in `folder`, `.zip`, or `.nupkg` formats.
* 🔹 **.NET:** Build AOT-compatible binaries for SDK v8 and v10.
* 🔹 **NuGet/Choco:** Generate and package `.nupkg` for GitLab, Chocolatey, ProGet, etc.
* 🔹 **JS Runtime:** Native support for **Bun** (replacing Node.js) for high-speed JS/TS execution.
* 🔹 **DevOps:** Integrated **Codecov** and **Coveralls** reporting.
* 🔹 **Multi-Language:** Runtimes for **Ruby/Jekyll**, **Go**, **Rust**, and **Elixir**.

<div align="right"><a href="#top"><code>☝</code> <b>Back to top</b></a></div>

---

## **Features**

### **PowerShell Automation**
* 🟦 **Build-Module** via **Psmpacker**.
* 🟦 **Semantic Versioning** via **GitAutoVersion**.
* 🟦 **Man-page Generation** via **Phwriter**.
* 🟦 **Verification Checksums** via **CSVerify**.

### **Build Systems**
* 🔸 **.NET:** Native `dotnet build` and `dotnet pack` support.
* 🔸 **NuGet/Choco:** `nuget pack` and custom **Nupsforge** cmdlets for multi-repository compatibility.
* 🔸 **JavaScript:** High-performance execution via **Bun**.

### **CI/CD Integration**
* 💠 Native support for **GitLab CI**.
* 💠 Pre-configured **Codecov** and **Coveralls** uploaders.

<div align="right"><a href="#top"><code>☝</code> <b>Back to top</b></a></div>

---

## **Image Manifest**

### **Binaries**

* 🔹 [**.NET SDK v8.0.412 & v10.0.103**](https://dot.net)
* 🔹 [**PowerShell Core 7.5.3**](https://github.com/PowerShell/PowerShell)
* 🔹 [**Bun (Primary JS Runtime)**](https://bun.sh)
* 🔹 [**NuGet 6.x (via Mono)**](https://www.nuget.org/)
* 🔹 [**Go**, **Rust**, **Elixir**]
* 🔹 [**Ruby & Jekyll**]
* 🔹 [**Codecov & Coveralls**]

### **PowerShell Modules**

* 🟦 **Pester** & **PSScriptAnalyzer** (Testing & Linting)
* 🟦 **PowerShell-Yaml**
* 🟦 **ColorConsole** & **Quicklog** (UI & Logging)
* 🟦 **Tadpol** (Progress Bars & Spinners)
* 🟦 **ShellDock** (Runspace Executor)
* 🟦 **Nupsforge**, **Psmpacker**, **CSVerify**, **GitAutoVersion** (Build Toolchain)

<div align="right"><a href="#top"><code>☝</code> <b>Back to top</b></a></div>

---

## **Build & Local Usage**

### **Building Locally**

**💠 Using Docker CLI:**

```bash
docker buildx build -t phellams-automator -f phellams-automator.dockerfile .
```

**💠 Using Local Builder Script:**

```powershell
./phellams-automator-local-builder.ps1 -buildMode Base
```

### **Script Parameters**

| Parameter | Description |
| :--- | :--- |
| **`-Automator`** | Builds using the Docker image. |
| **`-Pester`** | Runs Pester tests before build. |
| **`-Build`** | Packs the module into the `dist` folder. |
| **`-Nuget`** | Generates NuGet packages. |

<div align="right"><a href="#top"><code>☝</code> <b>Back to top</b></a></div>

---

## **Roadmap**

### **Current Phase: Beta**

* 🔄 **Infrastructure Modernization**
  * 🔹 Port to Debian 13 (Trixie) slim.
  * 🔹 Implement Multi-platform builds (amd64/arm64).
  * 🔹 Replace Node.js with Bun. (#7)
* 🔄 **Technical Debt**
  * 🔹 Resolve outstanding CVEs.
  * 🔹 Standardize high-performance CLI patterns.

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
[arc-version]: https://img.shields.io/badge/Debian-12.13_slim-cyan?logo=ubuntu&color=%232D2D34&labelcolor=red&style=for-the-badge
[arc-url]: https://hub.docker.com/r/sgkens/phellams-automator
[docker-version]: https://img.shields.io/docker/v/sgkens/phellams-automator?style=for-the-badge&logo=docker&logoColor=%233478BD&logoSize=auto&labelColor=%232D2D34&color=%23446878
[docker-url]: https://hub.docker.com/r/sgkens/phellams-automator/tags
[docker-size]: https://img.shields.io/docker/image-size/sgkens/phellams-automator?style=for-the-badge&logo=docker&logoColor=%233478BD&logoSize=auto&labelColor=%232D2D34&color=%23446878
[docker-pulls]: https://img.shields.io/docker/pulls/sgkens/phellams-automator?style=for-the-badge&logo=docker&logoColor=%233478BD&logoSize=auto&labelColor=%232D2D34&color=%23446878
[build-status]: https://img.shields.io/gitlab/pipeline-status/phellams%2Fphellams-automator?style=for-the-badge&logo=Gitlab&logoColor=%233478BD&labelColor=%232D2D34
[build-url]: https://gitlab.com/phellams/phellams-automator/-/pipelines
[license-badge]: https://img.shields.io/badge/License-MIT-Blue?style=for-the-badge&labelColor=%232D2D34&color=%2317202a
