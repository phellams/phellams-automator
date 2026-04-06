# 📄 Rolling Project Definition Record (PDR) - Phellams-Automator

## Project Overview
**Phellams-Automator** is a Debian-based Docker image (Debian 12-slim) designed as a high-performance, multi-language build environment for the **Automator-Devops** automation suite.

## Core Architectural Foundation
* **Base Image:** `debian:12.13-slim`
* **Default Shell:** `pwsh` (PowerShell Core 7.5.x)
* **Package Management:** `apt`, `gem`, `dotnet-install.sh`

## Integrated Toolchain (v2.8.0)
* **.NET:** SDK v8.0.412, SDK v10.0.103
* **PowerShell:** v7.5.3
* **NuGet:** v6.x (via Mono)
* **Ruby/Jekyll:** Ruby Latest, Bundler, Jekyll
* **Go:** Golang v1.19+
* **Rust:** rustc v1.63+
* **Elixir:** v1.14+
* **DevOps Tools:** Codecov, Coveralls, Git, GPG

## Build System
* **Local Builder:** `phellams-automator-local-builder.ps1` utilizing `docker buildx`.
* **CI/CD:** GitLab CI (`.gitlab-ci.yml`)

## Extension Rules
* Prioritize **Vanilla CSS** for frontend elements.
* Follow **Conventional Commits**.
* Maintain **AOT-compatibility** for .NET binaries.
