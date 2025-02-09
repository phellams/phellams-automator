using module sm\Get-Elapsed.psm1
using module sm\Get-PropTune.psm1
#using module sm\Get-CTune.psm1
using module sm\colorconsole\libs\cmdlets\New-ColorConsole.psm1
#using module sm\powerunicode\powerunicode.psm1

class quicklog {
    [String]$Name
    [String]$Type
    [String]$icon
    [Bool]$Submessage
    [String]$Datestring
    [datetime]$Date
    [String]$Message
    [PSCustomObject]$Icons
    [Bool]$Logdate
    [Bool]$Logicon
    [Bool]$Logfile
    [Bool]$ExecTime
    #[String]$PTSeperator
    [Int]$Sm_indent
    [String]$CurrentLogTime
    [String]$LastLogTime
    [PSCustomObject]$ThemeProperties
    [String]$Theme
    [string]$LogMessage
    [bool]$NoEmoji
    [string]$ThemeType
    [string]$Progressbar
    

    quicklog() {
        $module_root = $global:_quicklog.rootpath
        $this.themeProperties = [PSCustomObject]@{ ascii = ""; utfe = ""; nerdf = ""; custom = ""; }
        $this.themeProperties.utfe  = Get-Content -Path "$module_root\libs\themes\theme-utf8-lt.json" -raw | ConvertFrom-Json
        $this.themeProperties.nerdf = Get-Content -Path "$module_root\libs\themes\theme-nerdfont-lt.json" -raw | ConvertFrom-Json
        $this.themeProperties.ascii = Get-Content -Path "$module_root\libs\themes\theme-ascii-lt.json" -raw | ConvertFrom-Json
        switch ($this.theme) {
            "utfe" {
                $this.themeType = "utfe"
                $this.icons = $this.themeProperties.utfe
            }
            "nerdf" {
                $this.themeType = "nerdf"
                $this.icons = $this.themeProperties.nerdf
            }
            "ascii" {
                $this.themeType = "ascii"
                $this.icons = $this.themeProperties.ascii
            }
            "custom" {
                #//TODO
            }
            default {
                $this.themeType = "ascii"
                $this.icons = $this.themeProperties.ascii
            }
        }
        
        if ($this.noemoji -eq $true) {
            $this.ThemeType = "noemoji"
        }
        else {
            $this.ThemeType = $this.theme
        }
        $this.logdate = $true
        $this.Type = "info"
        $this.sm_indent = 5
        if ($null -eq $this.icon -or $this.icon.Length -eq 0) {
            $this.icon = "default-icon" # 🍥
        }
        $this.SetConsoleEncoding()
        #$this.CurrentLogTime = (get-date).ToString()
        #$this.LastLogTime = (get-date).ToString()
    }

    [void]setConsoleEncoding() { [Console]::OutputEncoding = [Text.Encoding]::UTF8}

    [void]enableLogdate() { $this.logdate = $true }

    [void]disableLogdate() { $this.logdate = $false }

    [void]enableLogIcon() { $this.logicon = $true }

    [void]disableLogIcon() { $this.logicon = $false }

    [void]enableLogfile() { $this.logfile = $true }

    [void]disableLogfile() { $this.logfile = $false }

    [void]enableExectime() { $this.Exectime = $true }

    [void]disableExectime() { $this.Exectime = $false}

    [string]newIndent([int]$indent) {
        [string] $indentstring = " "
        $indentstring = $indentstring * $indent
        return $indentstring
    }

    [string]getLogTime() {
        [string] $logtime = (Get-Date).tostring()
        return $logtime
    }

    [void]enableLogfile([string]$path) {
        if (test-path -path $path) {
            Start-Transcript -path "$path\documents\$($this.name).log" -Append
        }
        else {
            Start-Transcript -path "$env:HOMEDRIVE$env:HOMEPATH\documents\$($this.name).log" -Append
        }
    
    }
    
    [PSCustomObject]getThemeProperty([string]$property) {

        return $this.icons."$($this.theme)".Where({ $_.id -eq $property })
    }


    <#
        GetTheme
        Returns the ascii/utf8-e/nerdfont property element from the theme object,
        use to output dynamic icons based on provided theme file
        @return [string]
        @param [string] $id 
            - id to target the pscustomobject with the array and return a property[$prop] from the pscustomobject
        @param [string] $prop
        @example GetTheme('default-icon','icon')
        you can also use the #//TODO Get-Theme function to get the icon for a specific theme
    #>
    [string]getTheme([string]$id, [string]$prop) { 
        [string]$propObjectValue = $null
        switch ($this.theme) {
            "noemoji" {
                $propObjectValue = ($this.icons.properties.Where({ $_.id -eq $id })).$prop
            }
            "utfe" {
                $propObjectValue = ($this.icons.properties.Where({ $_.id -eq $id })).$prop
            }
            "ascii" {
                $propObjectValue = ($this.icons.properties.Where({ $_.id -eq $id })).$prop
            }
            "nerdf" {
                $propObjectValue = $($this.icons.properties.Where({ $_.id -eq $id })).$prop
            }
            default {
                [console]::write("ERROR: No theme type specified")
            }
        }
        return $propObjectValue
    }

    <#/ . . . . . . . . . . . . . . . . . . . . . . . . ./
        ThemeIcon
        Returns the ascii/utf8-e/nerdfont property element from the theme object wrapped in colorconsole or colorizer
        @return [string]
        @param [string] $id 
    / . . . . . . . . . . . . . . . . . . . . . . . . ./#>
    [string]themeIcon([string]$id, [string]$prop){
        $colored_theme_prop = csole -s $this.getTheme($id, $prop) -c $this.getTheme($id, 'color')
        return $colored_theme_prop
    }
    
    <#/ . . . . . . . . . . . . . . . . . . . . . . . . ./
        Get-LogTypes
        Returns a list of log types for the current theme
        @return [array]
        @example Get-LogTypes
        you can change the theme with #//TODO Set-Theme - impliment
        You can also use the #//TODO Get-Theme function to get the icon for a specific theme
        you can alo use the global instance $global:_quicklog.Instance.Theme = "nerdf"|"utfe"|"ascii"|"noemoji"
    / . . . . . . . . . . . . . . . . . . . . . . . . . #>
    [pscustomobject[]]GetLogTypes() { #//TODO change to Get-LogPeices
        return $this.icons.properties
    }

    [Void]GenerateLog([string]$message, [string]$type = "info", [bool]$submessage) {
        $this.datestring = Get-Date -Format "hh:mm:ss"
        $this.message = $message
        $this.type = $type
        $this.submessage = $submessage
        $this.LogMessage = $this.themeIcon('open-bracket', 'icon')
        # Update LastLogTime
        if($null -eq $this.lastLogtime) { $this.LastLogTime = $this.GetLogTime() }
        $this.CurrentLogTime = $this.GetLogTime()
        # Enable/Disable log icon
        if ($this.logicon -eq $true) {
            $this.LogMessage += $this.themeIcon('default-icon', 'icon')
            #$this.LogMessage += "$(csole -s "•" -c cyan)"
            $this.LogMessage += "$(csole -s $this.name -c $this.getTheme('log-name','color'))"
        }
        else {
            $this.LogMessage += "$(csole -s "$($this.name)" -c darkcyan)"
        }

        # if submessage is true, print logtime
        #TODO Move into below if submessage above the switch
        if ($this.submessage -eq $true) {
            if ($this.logdate -eq $true) {
                $this.LogMessage += $this.themeIcon('log-time','icon')
                $this.LogMessage += "$(csole -s "$($this.datestring)" -c Gray)"
                $this.LogMessage += $this.themeIcon('close-bracket', 'icon')
            }
        }
        else {
            if ($this.logdate -eq $true) {
                $this.LogMessage += $this.themeIcon('log-time','icon')
                $this.LogMessage += "$(csole -s "$($this.datestring)" -c Gray)"
                $this.LogMessage += $this.themeIcon('close-bracket','icon')
            }
            else {
                $this.LogMessage += $this.themeIcon('close-bracket','icon')
            }
        }
        # if submessage is true, do not print logtime
        if ($this.submessage -eq $true) {
            switch ($type) {
                success { 
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$($this.themeIcon('sub-message','icon')) "
                }
                error { 
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$($this.themeIcon('sub-message','icon')) "
                }
                info { 
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$($this.themeIcon('sub-message','icon')) "
                }
                complete { 
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$($this.themeIcon('sub-message','icon')) "
                }
                action { 
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$($this.themeIcon('sub-message','icon')) "
                }
                request {
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$($this.themeIcon('sub-message','icon')) "
                }
                response {
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$($this.themeIcon('sub-message','icon')) "
                }
                download {
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$($this.themeIcon('sub-message','icon')) "
                }
                upload {
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$($this.themeIcon('sub-message','icon')) "
                }
                read {
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$($this.themeIcon('sub-message','icon')) "
                }
                write {
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$($this.themeIcon('sub-message','icon')) "
                }
                default { 
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$($this.themeIcon('sub-message','icon')) "
                }
            }
        }
        else {
            switch ($this.type) {
                success { 
                    $this.LogMessage += "$($this.themeIcon('success','icon'))$($this.themeIcon('log-pointer','icon')) "
                }
                error { 
                    $this.LogMessage += "$($this.themeIcon('error','icon'))$($this.themeIcon('log-pointer','icon'))$($this.themeIcon('error-q','icon')) "
                }
                info { 
                    $this.LogMessage += "$($this.themeIcon('info','icon'))$($this.themeIcon('log-pointer','icon')) "
                }
                complete { 
                    $this.LogMessage += "$($this.themeIcon('complete','icon'))$($this.themeIcon('log-pointer','icon')) "
                }
                action { 
                    $this.LogMessage += "$($this.themeIcon('action','icon'))$($this.themeIcon('log-pointer','icon')) "
                }
                request {
                    $this.LogMessage += "$($this.themeIcon('request','icon'))$($this.themeIcon('log-pointer','icon')) "
                }
                response {
                    $this.LogMessage += "$($this.themeIcon('response','icon'))$($this.themeIcon('log-pointer','icon')) "
                }
                download {
                    $this.LogMessage += "$($this.themeIcon('download','icon'))$($this.themeIcon('log-pointer','icon')) "
                }
                upload {
                    $this.LogMessage += "$($this.themeIcon('upload','icon'))$($this.themeIcon('log-pointer','icon')) "
                }
                read {
                    $this.LogMessage += "$($this.themeIcon('read','icon'))$($this.themeIcon('log-pointer','icon')) "
                }
                write {
                    $this.LogMessage += "$($this.themeIcon('write','icon'))$($this.themeIcon('log-pointer','icon')) "
                }
                default { 
                    $this.LogMessage += "$($this.themeIcon('info','icon'))$($this.themeIcon('log-pointer','icon')) "
                }   
            }
        }

        # Message Area -if colortune Key is prsent ---------------
        $ColorElements = [regex]::Matches($this.message, "(\{cs:)(.*?)(\})")
        if ($ColorElements) {
            for ($i = 0; $i -lt $ColorElements.count; $i++) {
                $PropColorData = $ColorElements[$i].value -replace "{cs:", "" -replace "}", ""
                $color = $PropColorData.split(":")[0]
                $text = $PropColorData.split(":")[1]
                $this.message = $this.message.replace($ColorElements[$i].value, $(csole -s "$text" -c "$color"))
            }
        }

        $this.message = $this.message.Replace("\\", "/")
        $PropElements = [regex]::Matches($this.message, "@\{pt:\{([^}]*)\}\}")
        if ($PropElements.count -ne 0) {
            foreach ($emsp in $PropElements) {
                $emsp_cleaned = $emsp -replace "@{pt:{", "" -replace "}}", ""
                $props = Get-PropTune -StringData $emsp_cleaned
                $FormattedProp = ''
                foreach ($propname in $props.keys) {
                    $FormattedProp = $this.themeIcon('proptune','icon')
                    $FormattedProp += csole -s $propname -c $this.getTheme('proptune-property-name','color')
                    $FormattedProp += ":"
                    $FormattedProp += csole -s "$($props[$propname])" -c $this.getTheme('proptune-property-value','color')
                    $FormattedProp += ""
                    $this.message = $this.message.replace($emsp, $FormattedProp)
                }
            }
            $this.LogMessage += $this.message
        }
        else {
            $this.LogMessage += $this.message
        }

        <#-#MESSAGES#-#>
        if (!$this.submessage) {
            switch ($this.type) {
                success { 
                    if ($this.Exectime) {
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('separator','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('exec-time','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "ex" -c yellow):$(csole -s "$(Get-Elapsed -From $this.LastLogTime -To $this.CurrentLogTime -Formattedstring)" -c Green)"

                    }
                    else {
                        # write-host ""

                        $this.LogMessage += ""
                    }
                }
                error { 
                    if ($this.Exectime) {
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('separator','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('exec-time','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "ex" -c yellow):$(csole -s "$(Get-Elapsed -From "$($this.LastLogTime)" -To "$($this.CurrentLogTime)" -Formattedstring)" -c Red)"
                    }
                    else {
                        # write-host ""

                        $this.LogMessage += ""
                    }
                }
                info { 
                    if ($this.Exectime) {
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('separator','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('exec-time','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "ex" -c yellow):$(csole -s "$(Get-Elapsed -From "$($this.LastLogTime)" -To "$($this.CurrentLogTime)" -Formattedstring)" -c DarkCyan)"

                    }
                    else {
                        # write-host ""

                        $this.LogMessage += ""
                    }
                }
                complete { 
                    if ($this.Exectime) {
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('separator','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('exec-time','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "ex" -c yellow):$(csole -s "$(Get-Elapsed -From "$($this.LastLogTime)" -To "$($this.CurrentLogTime)" -Formattedstring)" -c DarkCyan)"

                    }
                    else {
                        # write-host ""

                        $this.LogMessage += ""
                    }
                }
                action { 
                    if ($this.Exectime) {
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('separator','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('exec-time','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "ex" -c yellow):$(csole -s "$(Get-Elapsed -From "$($this.LastLogTime)" -To "$($this.CurrentLogTime)" -Formattedstring)" -c DarkCyan)"
                    }
                    else {
                        # write-host ""

                        $this.LogMessage += ""
                    }
                }
                request {
                    if ($this.Exectime) {
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('separator','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('exec-time','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "ex" -c yellow):$(csole -s "$(Get-Elapsed -From "$($this.LastLogTime)" -To "$($this.CurrentLogTime)" -Formattedstring)" -c DarkCyan)"
                    }
                    else {
                        $this.LogMessage += ""
                    }
                }
                response {
                    if ($this.Exectime) {
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('separator','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('exec-time','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "ex" -c yellow):$(csole -s "$(Get-Elapsed -From "$($this.LastLogTime)" -To "$($this.CurrentLogTime)" -Formattedstring)" -c DarkCyan)"
                    }
                    else {
                        $this.LogMessage += ""
                    }
                }
                download { 
                    if ($this.Exectime) {
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('separator','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('exec-time','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "ex" -c yellow):$(csole -s "$(Get-Elapsed -From "$($this.LastLogTime)" -To "$($this.CurrentLogTime)" -Formattedstring)" -c DarkCyan)"
                    }
                    else {
                        $this.LogMessage += ""
                    }
                }
                upload {
                    if ($this.Exectime) {
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('separator','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('exec-time','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "ex" -c yellow):$(csole -s "$(Get-Elapsed -From "$($this.LastLogTime)" -To "$($this.CurrentLogTime)" -Formattedstring)" -c DarkCyan)" 
                    }
                    else {
                        $this.LogMessage += ""
                    }
                }
                read {
                    if ($this.Exectime) {
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('separator','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('exec-time','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "ex" -c yellow):$(csole -s "$(Get-Elapsed -From "$($this.LastLogTime)" -To "$($this.CurrentLogTime)" -Formattedstring)" -c DarkCyan)"
                    }
                    else {
                        $this.LogMessage += ""
                    }
                }
                write {
                    if ($this.Exectime) {
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('separator','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('exec-time','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "ex" -c yellow):$(csole -s "$(Get-Elapsed -From "$($this.LastLogTime)" -To "$($this.CurrentLogTime)" -Formattedstring)" -c DarkCyan)"
                    }
                    else {
                        $this.LogMessage += ""
                    }
                }
                Default { 
                    if ($this.Exectime) {
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('separator','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "$($this.GetTheme('exec-time','icon'))" -c DarkCyan)"
                        $this.LogMessage += " $(csole -s "ex" -c yellow):$(csole -s "$(Get-Elapsed -From "$($this.LastLogTime)" -To "$($this.CurrentLogTime)" -Formattedstring)" -c DarkCyan)"
                    }
                    else {

                        $this.LogMessage += ""
                    }
                }
            }    
        }
        <#-#SUBMESSAGES#-#>
        else {
            switch ($this.type) {
                success { 
                    $this.LogMessage += " "
                }
                error { 
                    $this.LogMessage += " "
                }
                info {
                    $this.LogMessage += " "
                }
                complete {
                    $this.LogMessage += " $($this.GetTheme('separator','icon')) $($this.GetTheme('tick','icon'))"
                }
                action {
                    $this.LogMessage += " "
                }
                request {
                    $this.LogMessage += " "
                }
                response {
                    $this.LogMessage += " "
                }
                download {
                    $this.LogMessage += " "
                }
                upload {
                    $this.LogMessage += " "
                }
                read {
                    $this.LogMessage += " "
                }
                write {
                    $this.LogMessage += " "
                }
                default {
                    $this.LogMessage += " "
                }                
            }
        }
        $this.LastLogTime = $this.GetLogTime()
    }

    [void]writeLog() { 
        [console]::Write("$($this.LogMessage)`n") 
    }

    [string]buildProgressBar([int]$percent, [int]$barcount = 50) {
        # 25 is the number of characters in the progress bar
        $fillChar = $this.themeIcon('progress-fill','icon')
        $emptyChar = $this.themeIcon('progress-empty','icon')
        $pointerChar = $this.themeIcon('progress-pointer','icon')
        $bar = ""
        $bar = $bar += $this.themeIcon('open-bracket-progress','icon')
        $bar = $bar += $fillChar * [math]::floor(($barcount * $percent) / 100)
        $bar = $bar += $pointerChar
        $bar = $bar += $emptyChar * [math]::floor($barcount - (($barcount * $percent) / 100))
        $bar = $bar += $this.themeIcon('close-bracket-progress','icon')
        return $bar
    }

    [Void]GenerateProgress([PSCustomObject]$stats) {
        $this.progressbar = $this.themeIcon('open-bracket','icon')
        if ($this.LogIcon -eq $true) {
            $this.progressbar += "$($this.themeIcon('Default-Icon','icon'))$(csole -s $this.name -c $this.getTheme('log-name','color'))"
        }
        else {
            $this.progressbar += csole -s $this.name -c $this.getTheme('log-name','color')
        }

        if ($stats.submessage -eq $true) {
            $this.progressbar += "$(if($this.logdate -eq $true){$this.themeIcon('log-time','icon')})$(if($this.logdate -eq $true){$this.datestring})"
            $this.progressbar += $this.themeIcon('close-bracket','icon')
            $this.progressbar += "$($this.NewIndent($this.sm_indent))" # submess
            $this.progressbar += "$($this.themeIcon('sub-message','icon')) "
            $this.progressbar += "$($this.buildprogressbar($stats.percent,$stats.barcount))"
            $this.progressbar += " $(csole -s $this.GetTheme('open-bracket-progress','icon') -c yellow)" # [
            $this.progressbar += "$($this.themeIcon('bandwidth','icon')) "
            $this.progressbar += "$($stats.bandwidth)"
            $this.progressbar += " $([char]0x00BB) "
            $this.progressbar += "("
            $this.progressbar += "$($stats.transferred)"
            $this.progressbar += "/"
            $this.progressbar += "$($stats.Total)"
            $this.progressbar += ")"
            $this.progressbar += $this.themeIcon('close-bracket-progress','icon')
            $this.progressbar += "$([char]0x2524)" 
            $this.progressbar += "$($stats.status)"
            $this.progressbar += " $($stats.eta)"
        }
        else {
            $this.progressbar += "$(if($this.logdate -eq $true){$this.themeIcon('log-time','icon')})$(if($this.logdate -eq $true){$this.datestring})"
            $this.progressbar += $this.themeIcon('close-bracket','icon')
            $this.progressbar += "$($this.themeIcon('progress','icon')) "
            $this.progressbar += $this.themeIcon('log-pointer','icon')
            $this.progressbar += "$($this.buildprogressbar($stats.percent,$stats.barcount))"
            $this.progressbar += " $($this.themeIcon('open-bracket-progress','icon'))" # [
            $this.progressbar += "$($this.themeIcon('bandwidth','icon')) "
            $this.progressbar += "$($stats.bandwidth)"
            $this.progressbar += " $([char]0x00BB) "
            $this.progressbar += "("
            $this.progressbar += "$($stats.transferred)"
            $this.progressbar += "/"
            $this.progressbar += "$($stats.Total)"
            $this.progressbar += ")"
            $this.progressbar += $this.themeIcon('close-bracket-progress','icon')
            $this.progressbar += "$([char]0x2524)"
            $this.progressbar += "$($stats.status)"
            $this.progressbar += " $($stats.eta)"
        }
    }

    [void]WriteProgress() { [console]::Write("$($this.progressbar)`n") }
}