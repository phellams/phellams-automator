<#  
* Name:    :----- powerunicode
* Description:--- Return converted utf-8 unicode to console
* Versiona:------ 1.0
* Author:-------- gsnow
* Date:---------- Wednesday, 24 August 2022 4:51:26 PM
* Copyright:----- Copyright (c) 2022 gsnow
* license: ------ MiT License
#>
class PowerUnicode{
   
    static [string] $name
    static [string] $unicode
    static [string] $label
    static [object] $codex

    <# ----------------
    * Name: powerunicode
    * Description: Constructor
    ? @param
    #>
    static powerunicode(){

    }

    <# ---------------
    * Name: unicodeget
    * Description: parses unicode.com html webpage filters unicode names and codes 
    *              and output json file to script dir
    ? @param
    ! @return
    #>
    static [void] unicodeget(){

        # enable class static prop
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        # ======================================
        # make webrequest
        $req = Invoke-Webrequest -URI https://unicode.org/emoji/charts/full-emoji-list.html
        # convert html to PSObject for parsing
        $htmlObject = ConvertFrom-Html -Content $req.Content

        $unicodeIndex = @()

        $htmlObject = ConvertFrom-Html -Content $req.Content

        foreach ($node in $htmlObject.SelectSingleNode("//body").childnodes) {
            if ($node.Attributes.name -eq 'class' -and $node.Attributes.Value -eq 'main') {
                foreach ($subnode in $node.childnodes) {
                    if ($subnode.name -eq 'table') {
                        foreach ($trnode in $subnode.childnodes) {
                            if ($trnode.name -eq 'tr') {
                                foreach ($tdnode in $trnode.childnodes) {
                                    #? Get Name from html table entry
                                    if ($tdnode.Attributes.Name -eq "class" -and $tdnode.Attributes.value -eq "name") {
                                        # Unicode Name
                                        [powerunicode]::name = $tdnode.innertext
                                        $unicode_label_string = [powerunicode]::name -replace ' ', '_' -replace '“', '' -replace '-', '_' -replace ':', '' -replace '\(', '' -replace '\)', ''
                                        $unicode_label_string = $unicode_label_string -replace '__', '' -replace '!', '' -replace ';', '' -replace '⊛_', '' -replace '”', '' -replace '⊛ ', ''
                                        [powerunicode]::label = $unicode_label_string
                                    }
                                    #? get unicode value from html table entry
                                    if ($tdnode.Attributes.Name -eq "class" -and $tdnode.Attributes.value -eq "code") {
                                        # Unicode Name
                                        # ? Codes with Multipla values
                                        if ($tdnode.childnodes[0].innertext -like "* *" -and $tdnode.childnodes[0].innertext -notlike "*flag*" ) {
                                            [powerunicode]::unicode = $tdnode.childnodes[0].innertext
                                        }
                                        #? Code with single unicode value
                                        elseif ($tdnode.childnodes[0].innertext -notlike "*flag*" ) {
                                            [powerunicode]::unicode = $tdnode.childnodes[0].innertext.tostring()
                                        }
                                        else {

                                        }

                                    }
                                }
                                $unicode_f = ([powerunicode]::unicode -split " ")[0] -replace "u\+",'#'
                                # populate hastable array with unicode objects
                                $unicodeIndex += new-object -TypeName psobject -Property @{
                                    label   = [powerunicode]::label
                                    unicode = $unicode_f
                                    name    = [powerunicode]::name
                                    char    = $([char]::ConvertFromUtf32($unicode_f))
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        
        $unicodeIndex | where-object { $_.name -notlike "*flag*" } | convertto-json | Out-File "$([powerunicode]::pexpath)\unicode-index.json"
    }

    <# -------------------
    * Name: importunicodes
    * Description: parses unicode.com html webpage filters unicode names and codes 
    *              and output json file to script dir
    ? @param
    #>
    static [void] importunicodes(){
        #[string] $PSCT_path = (Get-PSCallStack | where-object $_.Position -like "*importunicodes*").ScriptName -replace '\\[^\\]+[^.]+$',''; 
        
        $pathtofile = "$PSScriptRoot\unicode-index.json"
        $codexobject = get-content -Path $pathtofile | convertfrom-json

        [powerunicode]::codex = $codexobject
    }

    static [string] printByUnicode([string] $unicode) {

        #$label_f = [powerunicode]::codex | where-object { $_.unicode -eq $unicode }

        return [char]::ConvertFromUtf32($unicode)

    }
    <# -------------------
    * Name: printByLabel
    * Description: print utf-code by label name, can be fetch via [powerunicode]::search("")
    ? @param [string] $label
    #>
    static [string] printByLabel([string] $label) {

        # Import Codex
        [powerunicode]::importunicodes()

        $label_f = [powerunicode]::codex | where-object { $_.label -eq $label }

        return [char]::ConvertFromUtf32($label_f.unicode)

    }
    <# -------------------
    * Name: printallWithCode
    * Description: print all the utf values with code names to console
    ? @param 
    #>
    static [void] printallWithCode(){

        # Import Codex
        [powerunicode]::importunicodes()

        foreach ($code in [powerunicode]::codex){
            write-host -foregroundcolor magenta "$($code.unicode)" -nonewline; write-host "$([char]::ConvertFromUtf32( $code.unicode )) |" -nonewline;
        }
    }

    <# -------------------
    * Name: printall
    * Description: print all the utf values to console
    ? @param 
    #>
    static [void] printall() {
        [powerunicode]::importunicodes()
        foreach ($code in [powerunicode]::codex) {
            write-host "$([char]::ConvertFromUtf32($code.unicode)) " -nonewline;
        }
    }
    <# -------------------
    * Name: search
    * Description: Searces Codex and matches label names
    ? @param [string] $string
    ! return [object]
    #>
    static [object] search([string] $string) {

        # Import Codex Object
        [powerunicode]::importunicodes()
        [powerunicode]::codex | where-object { $_.name -like "*$string*" }

        return [powerunicode]::codex | where-object { $_.name -like "*$string*" }

    }
}