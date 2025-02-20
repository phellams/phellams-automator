using module libs/lib.psm1
using module libs/cmdlets/New-Quicklog.psm1
using module libs/cmdlets/Write-Quicklog.psm1
using module libs/cmdlets/Write-QuicklogProgress.psm1
using module libs/cmdlets/Get-QuicklogTypes.psm1

<#                                                                                     
  ,ad8888ba,                 88              88         88                            
 d8"'    `"8b                ""              88         88                            
d8'        `8b                               88         88                            
88          88  88       88  88   ,adPPYba,  88   ,d8   88   ,adPPYba,    ,adPPYb,d8
88          88  88       88  88  a8"     ""  88 ,a8"    88  a8"     "8a  a8"    `Y88  
Y8,    "88,,8P  88       88  88  8b          8888[      88  8b       d8  8b       88  
 Y8a.    Y88P   "8a,   ,a88  88  "8a,   ,aa  88`"Yba,   88  "8a,   ,a8"  "8a,   ,d88  
  `"Y8888Y"Y8a   `"YbbdP'Y8  88   `"Ybbd8"'  88   `Y8a  88   `"YbbdP"'    `"YbbdP"Y8  
    ____________________________________________________________________________• 88  
                                                                           "Y8bbdP"  #>

$global:_quicklog = @{                                                                         
    rootpath     = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
    themeConfig  = @{}
}
# init $global:_quicklog instance allowing access to the initialized rootpath
$global:_quicklog.themeConfig.utfe = Get-Content -Path "$($global:_quicklog.rootpath)\libs\themes\theme-utf8-lt.json" -raw | ConvertFrom-Json
$global:_quicklog.themeConfig.nerdf = Get-Content -Path "$($global:_quicklog.rootpath)\libs\themes\theme-nerdfont-lt.json" -raw | ConvertFrom-Json
$global:_quicklog.themeConfig.ascii = Get-Content -Path "$($global:_quicklog.rootpath)\libs\themes\theme-ascii-lt.json" -raw | ConvertFrom-Json


# Set up the quicklog instance
$quicklog_instance = New-Object -TypeName quicklog
$quicklog_instance.Theme = 'ascii' # Set the default theme to ascii (nerdf, utfe, ascii, noemoji)

# Set up the global quicklog instance
$global:_quicklog.Instance = $quicklog_instance
    

# Set up the module config
$moduleconfig = @{
    function = @(
        'Write-Quicklog',
        'Write-QuicklogProgress',
        'Get-QuicklogTypes',
        'New-Quicklog'
    )
    alias = @(
        'qlqt',
        'qlwp',
        'qln',
        'qlm'
    )
}

# Export the module
Export-ModuleMember @moduleconfig