# Quicklog CACHE

<img width="128" src="https://raw.githubusercontent.com/sgkens/resources/main/modules/Quicklog/dist/v2/Quicklog-logo-128x128.png"/>

# **Quicklog**

<!--license-->
<a href="https://github.com/sgkens/Quicklog/">
  <img src="https://img.shields.io/badge/MIT-License-blue?style=&logo=unlicense&color=purple"></a>
<!--Code Factor-->
<a href="https://www.codefactor.io/repository/github/sgkens/Quicklog/">
  <img src="https://www.codefactor.io/repository/github/sgkens/Quicklog/badge"></a>
<!--coverage-->
<a href="https://coveralls.io/github/sgkens/Quicklog">
  <img src="https://img.shields.io/coverallsCoverage/github/sgkens/Quicklog?branch=main"></a>

---
**Quicklog** outputs styled log messages to the console. It is designed to be used in conjunction with other PowerShell modules and scripts to provide a consistent look and feel to the console output. Quicklog  uses ```system.console.write``` instead of `Write-Host` to output log string to the console.

|🔨 BUILD STATUS|💼 RELEASES|
|-|-|
|<a href="https://gitlab.lab.davilion.online/powershell/Quicklog/-/pipelines"><img src="https://gitlab.lab.davilion.online/powershell/Quicklog/badges/main/pipeline.svg"></a>|<a href="https://gitlab.lab.davilion.online/powershell/Quicklog/-/releases"><img src="https://gitlab.lab.davilion.online/powershell/Quicklog/-/badges/release.svg"></a>|

|📦 PACKAGES|
|-|
|[<img src="https://img.shields.io/powershellgallery/v/csverify?include_prereleases&logo=powershell"/>](https://www.powershellgallery.com/packages/nupsforge)|
|[<img src="https://img.shields.io/chocolatey/v/csverify?&logo=chocolatey"/>](https://Chocolatory.org/sgkens/Quicklog)|

## 💠 Module Features

- **Enable**/**Disable** log name in log message template, Distinguish between running scripts
- **Enable**/**Disable** time/date in log message `[🍥-logt⏰01:40:52]...`.
- **Enable**/**Disable** custom utf-8 Unicode Icon Log name `[🍥-logt]...`.
- **Add** colorized-preview into log messages with `#` > `{czh|chr|czg:#hex}`.
- **Add** colored text [***powershell color palet***] into log message with `{ct:colorName:texts}`.
- **Add** property names And value into log message via `@{pt:{Name=Value}}`
- **Switch** outputs between `Parent` and `SubMessage` types.
- **Ouput** basic progress bars `[########>------------------>(25mb/sec | 6.88% Complete)]`, for cuztomizable bars and loaders you can use [`Tadpol`](https://github.com/sgkens/tadpol).

## 💠 Installing Module

### 📥 Clone source

1. Clone the repository from **GitHub** `git clone https://github.com/sgkens/Quicklog.git`
2. Open a ***PowerShell*** session and navigate to the cloned repository directory.
3. **Run** the *Module Import* via the command below:

    ```powershell
    # Import the module
    git clone https://github.com/sgkens/Quicklog.git
    cd Quicklog
    import-module -Name Quicklog

    # Get version
    get-module -name Quicklog | select-object name,version

    # Check imported module functions
    get-module -Name Quicklog | select-object -expand exportedfunctions
    get-module -Name Quicklog | select-object version
    ```

### 💼 Releases

Download the latest release from the [**Releases**](https://github.com/sgkens/Quicklog/releases) page.

### 💼 Release

```powershell
# Import the module
git clone https://gitlab.snowlab.tk/shelltastic/Quicklog.git
cd Quicklog
Import-Module -Name Quicklog
```

## 🐥 Using the Module

#### 🔹`Write-Quicklog`

Used to write logmessages to the console.

```powershell
Write-Quicklog [-Message] '<message>' [[-Type] '<type>']
                [-Name '<name>'] [-Unicode '<unicode>'] 
                [-SubMessage] [-NoDateTime] [-NoLogIcon] 
                [-NoExectime] [-NoEmoji]
```

```powershell
# Minimal Params Default type=info
Write-Quicklog -Message "My Message String" 
# Output
[🍥-logt⏰01:41:41]📝❯ My Message String 🔸 ⏱ ex: 0m 1s 0ms

# ------

# Log Message with property in body specify color
Write-Quicklog -Message "My {ct:red:Custom Text} @{pt:{Message=String}}" -Type Info -Name customname -Unicode "#2795"
# Ouput
[➕-customname⏰02:02:47]📝❯ My Custom Text ○-Message:String 🔸 ⏱ ex: 0m 1s 0ms

# -----
# SubMessage with specified emoji
Write-Quicklog -Name 'LT' -Message "My Message String" -Type info -Unicode "#1F433" -SubMessage
# Output
[🐳-LT⏰02:00:44]     ↪ My Message String
```

#### 🔹`New-Quicklog`

Returns a new instance of the Quicklog class.

```powershell
# using Quicklog class 
# -> Generate Log Message
$Quicklog = New-Quicklog
$Quicklog.Theme = 'utfe' # default(utfe) avail: acsii(WIP), NerdF(WIP)
$Quicklog.noemoji = $true # disable emojis and ouput (Get-LogTypes).logName
$Quicklog.Name = 'logt'
$Quicklog.enablelogdate()
$Quicklog.disablelogdate()
$Quicklog.unicode = # utfcode
$Quicklog.disableLogIcon()
$Quicklog.EnableLogIcon()
$Quicklog.EnableExTime()
$Quicklog.DisableExTime()
$Quicklog.GenerateLog(
    "MyMessage @{pt:{prop=in message {ct:red:this is colored red}}",
    "info", # 'Error', 'Success', 'Info', 'Complete', 'Action','response','request','upload','download','read','write'
    $false # $true for submessage
)
$Quicklog.WriteLog()

# ----

# -> Generate Log Message
$Quicklog.GenerateProgress(@{
    barcount = 60
    percent = 80
    status = "Running"
    submessage = $false
    total = 100 
    bandwidth = "1.2mb"
    transfered = "86.2mb"
    eta = ""
})
$Quicklog.WriteProgress()

```

#### 🔹`Get-LogTypes`

Return a list of LogTypes as `system.object[]` **array**.

```powershell
Get-LogTypes

# Output
id       name     logname emoji
--       ----     ------- -----
Error    Error    ERR     ⭕
Success  Success  SUC     🟢
Info     Info     INF     📝
Complete Complete COM     ✅
Action   Action   ACT     🧿
response response RES     🌎
request  request  REQ     🌐
upload   upload   UPL     ⏫
download download DOW     ⏬
```

#### 🔹`New-QuicklogProGressBar`

Ouputs a custom progress bar.

```powershell
Write-QuicklogProgress [-Barcount(Manditory) '<[int]count>']
                        [-Percent(Manditory) '<[int]percentComplete>']
                        [-Total(Manditory) '[int]<Total>'] 
                        [-Name '<[string]Name>'] 
                        [-Status '<secondsRemaining>'] 
                        [-Submessage '<currentOperation>'] 
                        [-Bandwidth '<[string]Bandwidth>'] 
                        [-Transferred '<[string]Transferred>']
                        [-Eta '<[string]EstimatedTime>']
                        [-NoDateTime '<switch|bool>']
                        [-NoLogIcon '<switch|bool>']

```

```powershell
```

#### 🔹`Get-QuicklogModuleInstance`

Returns Module instance of Quicklog used by other cmdlets.

```powershell
(Get-QuicklogModuleInstance).GenerateLog(...
(Get-QuicklogModuleInstance).WriteLog()
```

## 📑 License

 **Quicklog** is released under the **MIT License**. See [LICENSE]() for more details.

👤 Authored and maintained @sgkens.
