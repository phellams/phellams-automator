# CHANGELOG

## **v2.11.0**

**Notes**

- Add **GUI, Graphics & AppImage build dependencies** to the Docker build:
  - **Photino** runtime requirements (`libgtk-3-dev`, `libwebkit2gtk-4.0-dev`, `libnotify-dev`)
  - **Inkscape** and **ImageMagick** (`magick`)
  - **AppImage** creation dependencies (`binutils`, `desktop-file-utils`, `fakeroot`, `fuse`, `libfuse2`, `patchelf`, `squashfs-tools`, `zsync`, `libgdk-pixbuf2.0-dev`)
- Add **jq** and **yq** to the base OS dependencies in the Docker image.
- Refactor PowerShell Profile:
  - Stack three boxes (`Info Box` next to mascot, `Binaries Box` with 3 columns, and `Modules Box` with 3 columns) to form a robust, modern TUI.
  - Fix layout tearing by introducing length truncation and padding helpers (`Get-FixedLengthString`), securing aligned margins even for extremely long version strings (like kernel details) and module names.
  - Apply high-fidelity color overrides: truecolor vertical gradients for the mascot and box borders, horizontal lightblue-to-orange gradients for names, and light-magenta `v` + italic-gray version highlights.
  - Implement dynamic version normalized registry object parsing for all binary and module versions (matching `v0.0.0` / `v0.0` formats including pre-releases like `-rc1` or `.beta-rc1`).
  - Added version checks for **jq**, **yq**, **inkscape**, **magick**, and **photino** (reading photino from local NuGet package cache).

> Wednesday, 15 July 2026 2:40:00 AM

---

## **v2.10.1**

**Notes**

- Add `Get-GitAutoveriosn` replacement `Get-CoventionalCommitVersion`
- Add **Node.js** and **NPM** `24+` to the image
- Add **BUN.JS** `0.5.4` to the image                                 
- Update Phellams Header to output new logo
- Bumped **12-slim** to **12.14-slim**
- Updated ascii logo meta with new binarry versions.
- Ajusted parsing logic for some binary version retrevers 
- Added `Generate-Badge` to generate build times for CI jobs `scripts/generate-badge.ps1`

> Friday, 19 June 2026 9:51:49 PM

---

## **v2.9**

**Notes**

- Update **powershell** to `v7.6.2`
- Add **PHP8** + **Composer** + **PHP-FPM** + **Xdebug** + **PHPUnit** + **PHPStan**
- Update DevOps Tools: **Codecov** + **Coveralls**
- Update: base binaries to `apt-get install -y --no-install-recommends`: **tar**, **perl**
- Add `ENV` for `COMPOSER_HOME`, `BUNDLE_SILENCE_ROOT_WARNING`, `BUNDLE_PATH`, `BUNDLE_APP_CONFIG`

> `Friday, 19 June 2026 7:04:06 PM`

---

## **v2.8.1**

**Notes**

- BUMP: Update **powershell** to `v7.6.1`
- UPDATE: Docs

---

## **v2.8.0**

**Notes**

- ADD: **Go** support
- ADD: **Rust** support
- ADD: **Elixir** support
- IMPROVE: Use `docker buildx` for local builds
- FIX: ASCII logo typo and alignment

---

## **v2.7.3**

**Notes**

- Add **RubyGems** support
- Add DonNet SDK v10.0.103
- Add **Jekyll** support
  - Build **Gem** based jekyll websites.

---

## **v2.6.3**

**Notes**

- Updated **NuPsforge** to latest version v0.7.4

---

## **v2.6.1**

**Notes**

- Updated **NuPsforge** to latest version v0.7.3

---

## **v2.6**

**Notes**

- ADD: **PHWriter** to container [phwriter](https://gitlab.com/phellams/phwriter/-/blob/main/CHANGELOG.md)
- ADD: import for **PHWriter** in profile
- UPDATE: Powershell Profile to output PHWriter info
- UPDATE: Add Copy statement to .dockerfile for phwriter

---

## v2.5.1

**Notes**

- Updated **NuPsforge** to latest version

---

## **v2.5**

**Notes** 

- Updated **NuPsforge** to latest version
- Updated **Powershell** to v7.5.3

---

## **v2.0**

**Notes**

- Updated **NuPsforge** to latest version

---

## **v1.0.**

**Notes**

- Added **CodeCov** Support
- Added **Coveralls** Support
- Updated **Powershell** to v7.5.1
- Updated **NuPsforge** to latest version
- Updated **CsVerify** To the Latest Version