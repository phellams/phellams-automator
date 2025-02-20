class TadPol {
    hidden [string]$modulefolder
    hidden [int]$loadercount
    hidden [string]$loadertheme
    [string]$LoaderWait
    [string]$LoaderComplete2
    [int]$loadertick

    TadPol() {
        # import theme parts default.json
        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
        $this.modulefolder = Join-Path -Path $PSScriptRoot -ChildPath '..\'
        $this.loaderTick = 1
        # default theme
    }
    <##
    /**
    * * NAME: themes
    * * DESCRIPTION: returns a list of all themes in the themes folder
    *-----
    * ? PARAMS: none
    * ! RETURNS: [psobject]
    *-----
    *---------------------------------------------*/#>
    [psobject] ThemeBars(){
        $objectarrayBar = @()
        $allthemesbars = Get-ChildItem -Recurse -Path "$($this.modulefolder)\themes\bars" -Filter *.json
        foreach ($bar in $allthemesbars) {
            $themeBarPart = get-content -path $bar.FullName | ConvertFrom-Json
            if($bar.baseName -like "*wide*") { 
                $themeBarPart.example = "$($this.progress(40, 100, 10, $bar.BaseName, 'Status','blue'))"
            }
            else{
                $themeBarPart.example = "$($this.progress(40, 100, 25, $bar.BaseName, 'Status','blue'))"
            }
            
            $objectarrayBar += $themeBarPart
            
        }
        Return $objectarrayBar
    }
    <##
    /**
    * * NAME: themes
    * * DESCRIPTION: returns a list of all themes in the themes folder
    *-----
    * ? PARAMS: none
    * ! RETURNS: [psobject]
    *-----
    *---------------------------------------------*/#>
    [psobject] ThemeLoaders() {
        $objectarrayLoader = @()
        $allthemeloaders = Get-ChildItem -Recurse -Path "$($this.modulefolder)\themes\loaders" -Filter *.json
        foreach ($loader in $allthemeloaders) {
            $themeLoaderParts = get-content -path $loader.FullName | ConvertFrom-Json
            $objectarrayLoader += $themeLoaderParts
        }
        return $objectarrayLoader
    }
    <##
    /**
    * * NAME: progress
    * * DESCRIPTION: returns a loader string from a theme json file
    *-----
    * ? PARAMS: [string] $count, [int] $total, [string] $theme, [int] $barLength, [string] $status
    * ! RETURNS: [string]
    *-----
    *---------------------------------------------*/#>
    [string] Progress([Int]$count, [int]$total, [Int]$barLength, [String]$theme, [string]$status, [string]$color) {

        # set default theme 
        if ($theme.length -eq 0) { $theme = 'default' }

        # set default color 
        if ($color.length -eq 0) { $color = 'white' }

        $themeParts = get-content -path "$($this.modulefolder)\themes\bars\$($theme).json" | ConvertFrom-Json
        
        # add pointer if progress is 0 and not 100
        if($null -ne $themeParts.pointer -or $count -eq 0 -or $count -lt $total){ 
            $themeParts.pointer = $themeParts.pointer } 
        else { $themeParts.pointer = "" }
        
        # Calc percent
        $percentComplete = [math]::Round($count / $total * 100)

        # calc barlength
        $completedLength = [math]::Round($percentComplete / 100 * $barLength)
        $remainingLength = $barLength - $completedLength
        
        # join bars
        $completedBar = [string]::Join("", $themeParts.completed * $completedLength)
        $remainingBar = [string]::Join("", $themeParts.incomplete * $remainingLength) 
        
        $progressbar = ""
        if($status.Length -eq 0){
            $progressbar = "$($themeParts.open)$(csole -s $completedBar -c $color)$($themeParts.pointer)$remainingBar($percentComplete%)$($themeParts.close)"
        }
        else{
            $progressbar = "$($themeParts.open)$(csole -s $completedBar -c $color)$($themeParts.pointer)$remainingBar$($themeParts.close) $percentComplete% $($status)"
        }

        return $progressbar

    }
    <#
    * ==> DESCRIPTION <==
       Generates a loader string from a theme json file based on the tick count
    &-> @param [string]
            $name: Name of the theme File
    &-> @param [int]
            $length: Minimum number of runspaces
    &-> @param [int]
            $color: Color of the loader Default: white
    !-> @return:
            [string]#>
    [string] Loader( [string]$theme, [int]$length = 1, [string]$color = $null ){
        if($color -eq "" -or $null -eq $color){ $color = "white" }
        $loader = Get-Content -Path "$($this.modulefolder)\themes\loaders\$($theme).json" | ConvertFrom-Json
        $this.loadercount = $loader.levels.count
        if ($this.loaderTick -gt $this.loadercount -or $this.loadercount -eq 0) { $this.loaderTick = 1 }
        $ltstring = $this.loaderTick
        if($null -ne $length -and $length -gt 1){ 

            $randomizer = $This.loadercount - (get-random -minimum 1 -maximum $this.loadercount)
            $loaderchar = ( $loader.levels | 
                where-object { $_.psobject.properties.name -eq $randomizer }).$randomizer * $length
        }
        else{
            $loaderchar = ($loader.levels | 
                where-object { $_.psobject.properties.name -eq $($this.loaderTick) }).$ltstring
        }
        if($color -ne "while"){
            $loaderchar = "$(csole -s $loaderchar -c $color)"
        }
        $this.loaderTick++
        return $loaderchar
        #TODO: Add another prop to the json file to allow for a custom tick rate
        #TODO: Add a prop to the json file position and remove the increment allowing next value to be return
        #
    }
    [string] CompleteChar ( [string]$theme ){
        $loader = Get-Content -Path "$($this.modulefolder)\themes\loaders\$($theme).json" | ConvertFrom-Json
        return $loader.complete
    }
    [string] WaitChar ( [string]$theme ){
        $loader = Get-Content -Path "$($this.modulefolder)\themes\loaders\$($theme).json" | ConvertFrom-Json
        return $loader.waiting
    }
}
