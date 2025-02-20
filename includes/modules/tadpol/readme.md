# Description

Generate custom *Progress Bars* and *loaders* from a `theme.json` config file

# cmdlets

```Powershell
Get-TPThemes
New-TPObject
Write-TPProgress
```

## Examples

Return all available themes from $moduleroot/themes/bars/*.json 
```powershell
Get-TPThemes
Get-TPThemes -Type Bars
Get-TPThemes -Type Loaders
```

Create a new progress bar.
```powershell
Write-TPProgress -Count 20 -Total 100 -barLength 100 -Status Downloading
```