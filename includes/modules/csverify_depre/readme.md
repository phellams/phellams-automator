# <img width="25" src="https://raw.githubusercontent.com/phellams/phellams-general-resources/main/modules/csverify/dist/svg/csverify-x.svg"/> **CSVERIFY**

![license][license-badge]


PowerShell module designed to assist in ensuring the integrity of a codebase by generating and verifying a **VERIFICATION.txt** file.

## Features
 - Generates and returns `sha256` hash for each file within the specified folder
 - Reads the verification file and returns a `PSCustomObject` *array* containg the file, path, size and hash.
 - Unitilizes `New-Checksum` & `Read-CheckSum`
 - Read and save checksums to `VERIFICATION.txt` file with `New-VerificationFile`.

## Verification File

**`New-VerificationFile`** generates the verification file. recersivlly compiles a list of all files present. For each file, it computes the SHA256 hash and records the **file**, **path**, **size** and its **hash** in the verification file(**VERIFICATION.txt**).

>Default output .\tools\VERIFICATION.txt

```powershell
cd /path/to/folder
New-VerificationFile 
```

⚪ **VERIFICATION.txt** output example:

<pre>
VERIFICATION
Verification is intended to assist the moderators and community
in verifying that this package's contents are trustworthy.

To Verify the files in this package, please download/Install module csverify from chocalatey.org or from the powershell gallery.
Get-CheckSum -Path $Path
e
-[checksum hash]-
___________________
1.23KB | 37511B972FBE38C353B680D55EC5CFE51C04C79CA3304922301C5AB44BAC94F9 | .\README.md
1.05KB | D3FF5A1DB41D78399BD676A16C9321F127BB52B7E7EBF56B14EC5ABC21971213 | .\LICENSE
0.34KB | 813818335A37527755ABDCF200322962E340E2278BBF3E515B21D4D232D9A92A | .\csverify.psm1
4.44KB | 394B7998E79D6DDE3B6FF1318550ED21BC9671F2C8F1AA2354861A120738B422 | .\csverify.psd1
1.14KB | 7E246407DE6B586B7BB2C46E82E089B72064AB6941F7EE83EDFBF9E0BD7D4CD3 | .\.gitlab-ci.yml
</pre>

## Verification

**`Test-Verification`** is used to verify the integrity of the codebase base it compares the `SHA256` values from **VERIFICATION.txt** file and Returns file report

⚪ Verification output
<pre>
Running Verification: Hashed Checksums
  └─ Verified o--(5 / 5 Files » Found 1 that could not be verified)
Status   hash                                                             Path                                Size
------   ----                                                             ----                                ----
Verified 0DC558C6B5C5B34D9B77D177AEE6130AEAF75C10A0948C635AEC98F5C445790E .\README.md                         0.95KB
Verified D3FF5A1DB41D78399BD676A16C9321F127BB52B7E7EBF56B14EC5ABC21971213 .\LICENSE                           1.05KB
Verified F5CEFD9EE2498D5A6BB80F3F26A6B07FD405F3AB3AB63917426CB31EBF5719B9 .\csverify.psm1                     0.35KB
Verified EB749553314E1280C22EB6CD2E7CF3687EBF0A8D6C259A59C33AA4DFB215D85D .\csverify.psd1                     4.44KB
Verified 7E246407DE6B586B7BB2C46E82E089B72064AB6941F7EE83EDFBF9E0BD7D4CD3 .\.gitlab-ci.yml                    1.14KB
</pre>


## Build


[![build][build-status]][build-url]

🟣 Building the container locally.

From:

![gitlab-logo][gitlab-badge]

```bash
git clone https://gitlab.com/phellams/csverify.git
# download and install psmpacker with provides the `build-module` cmdlet
find-module -name csverify | install-module | import-module

cd csverify
import-module .\
```

```powershell
# or use `phellams-automator-local-builder.ps1` powershell script
pwsh -c './phellams-automator-local-builder.ps1'
``` 

![github-logo][github-badge]

```bash
git clone https://github.com/phellams/csverify.git
# download and install psmpacker with provides the `build-module` cmdlet
find-module -name csverify | install-module | import-module

cd csverify
import-module .\
```

## Install

**CSVerify** can be installed by cloning the repository and importing the module or from the **psgallary**(PowerShell Gallary), **choco**(chocolatey), **gitlab** packages.

### 🟡 Clone

 1. Clone the repository from GitHub `git clone https://github.com/sgkens/csverify.git`
 2. Open a *PowerShell* session and navigate to the cloned repository directory. 
 3. **Run** the *Module Import* via the command `import-module`.

```bash
git clone https://github.com/sgkens/csverify.git
cd csverify
Import-Module -Name csverify
Get-Module -Name csverify # Check imported module
```

### 🔵 PSGallery **📦 Package**

[![psgallarry][psgallary-badge]][psgallary-link]

Install The Module from the **PSGallary** into default powershell module directory for user.

> *Note!*  
> You may need to `Set-ExecutionPolicy` to `RemoteSigned` or `Unrestricted` to install from the PSGallary.

```powershell
Find-Module -Name csverify | Install-Module -force | Import-Module
Get-Module -Name csverify 
```

### 🟤 Choco **📦 Package**

[![chocolatey][choco-badge]][choco-link]

Install The Module from the **choco** into default powershell module directory for user

> *How-to!* \
> Installing *Chocolatey* Package Repository
[**How to Install**](https)  [🧷https://chocolatey.org/install](https://chocolatey.org/install)


```powershell
choco install csverify --installdir "$ENV:USERPROFILE\Documents\WindowsPowerShell\Modules"
Import-Module -Name csverify
Get-Module -Name csverify # Check imported module
```

### 🟠 Gitlab **📦 Package**

Install The Module from the **Gitlab Packages** `nuget` repository into default powershell module directory for user.

```powershell
# Install The Module from the Gitlab Packages
nuget install csverify -source https://gitlab.com/phellams/nuget/v3/index.json
Import-Module -Name csverify
Get-Module -Name csverify # Check imported module
```


## Releases

Download the latest release from the [**Releases**](https://github.com/sgkens/csverify/releases) page.


## Usage

#### 🟣 New-CheckSum
New-CheckSum generates and returns sha256 hash for each within the specified folder. New-Verification unitilizes `New-Checksum` & `Read-CheckSum`.

```powershell
New-CheckSum -Path .\
```

#### 🟣 Read-CheckSum
Read-CheckSum reads the verification file and returns a `PSCustomObject` *array* containg the file, path, size and hash.

```powershell
Read-CheckSum -Path .\
```

#### 🟣 New-VerificationFile
New-VerificationFile generates the verification file. recersivlly compiles a list of all files present. For each file, it computes the SHA256 hash and records the **file**, **path**, **size** and its **hash** in the verification file(**VERIFICATION.txt**).

 * **Syntax:** `New-VerificationFile -RootPath <String> -OutPutPath <String>`
 * **Parameters:**
   * `RootPath` `<String>` - The path to the folder to generat
 * **Example:**
    ```powershell
    New-VerificationFile
    ```

#### 🟣 Test-Verification
Test-Verification is used to verify the integrity of the codebase base it compares the `SHA256` values from **VERIFICATION.txt** file and Returns file report.

```powershell 
Test-Verification
```


<!--LINKS AND BADGES-->
[psgallary-badge]: https://img.shields.io/powershellgallery/v/csverify?include_prereleases&style=for-the-badge&logo=powershell
[psgallary-link]: https://www.powershellgallery.com/packages/csverify
[choco-badge]: https://img.shields.io/chocolatey/v/csverify?style=for-the-badge&logo=chocolatey
[choco-link]: https://chocolatey.org/packages/csverify
[build-status]: https://img.shields.io/gitlab/pipeline-status/csverify?style=for-the-badge&logo=Gitlab&logoColor=%233478BD&labelColor=%232D2D34
[build-url]: https://gitlab.com/phellams/csverify/-/pipelines
[gitlab-badge]: https://img.shields.io/badge/gitlab-4B0082?style=for-the-badge&logo=gitlab&logoColor=orange
[github-badge]: https://img.shields.io/badge/github-383838?style=for-the-badge&logo=github&logoColor=white
[license-badge]: https://img.shields.io/badge/License-MIT-Blue?style=for-the-badge&labelColor=%232D2D34&color=%**2317202a**