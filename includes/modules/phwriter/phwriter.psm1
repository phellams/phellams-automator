using module .\cmdlets\New-Paragraph.psm1
using module .\cmdlets\Format-StringWithCharSpacesAndHyphens.psm1
using module .\cmdlets\New-ColorConsole.psm1

$script:__phwriter = @{
    rootpath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
}

# *=============================================
# Function: Write-PHAsciiLogo
# Description: Displays an ASCII art logo for the PHWriter module.
# Parameters: None
# Returns: None
# *---------------------------------------------
function Write-PHAsciiLogo {
    param(
        [parameter(mandatory = $true, HelpMessage = "Sets the Name of the module for the logo display.")]
        [string]$Name, # Default module name if not provided
        [parameter(mandatory = $false, HelpMessage = "Sets a custom logo for the module display.")]
        [string]$CustomLogo = $null # Optional custom logo, if provided
    )
    
    $logoLines = @()

    # if no name provided and custom logo is not set, use default logo
    if(!$CustomLogo) {
        $Name_Spaced = Format-StringWithCharSpacesAndHyphens -InputString "-$Name-" # Format the name with spaces and hyphens
        # Elements
        $top_border = "`▫▫▫▫▫▫▫▫════════════════════════════════════════════════════════▫▫▫▫▫▫═╗"
        $bottom_border = "`▫▫▫▫▫▫▫▫════════════════════════════════════════════════════════▫▫▫▫▫▫═╝"
        [int]$padding_left = ($top_border.Length) - ($top_border.Length / 2 ) - ($Name_Spaced.Length / 2) - 1 # Calculate padding for left side
        [int]$padding_right  = $null
        if ($Name.Length % 2 -eq 0) { 
            # write-host "Value is even"
            $padding_right = $padding_left - 1  # If even, add one more space to the right
        } 
        if ($Name.Length % 2 -eq 1) { 
            # write-host "Value is odd"
            $padding_right = $padding_left + 1 # If odd, keep it the same as left
        }
        # Populate the logo lines
        $logoLines = @(
            $top_border,
            "░$("░" * $padding_left)$Name_Spaced$("░" * ($padding_right))╢",
            $bottom_border
        )
    }
    else {
        # If a custom logo is provided, split it into lines
        $logoLines = $CustomLogo -split "`n" # Split the custom logo into
        # lines based on new line characters
        # Ensure each line is trimmed to remove any leading/trailing whitespace
        $logoLines = $logoLines | ForEach-Object { $_.Trim() }
        # Add borders to the custom logo lines
    }

    foreach ($line in $logoLines) {
        [console]::writeline("$($line)")
    }
    [console]::write("`n") # Add a new line for spacing after the logo
}

# *=============================================
# Function: New-PHWriter
# Description: Generates formatted help text for PowerShell cmdlets with custom layouts and coloring.
# Parameters:
#   - ParamTable: An array of hashtables defining cmdlet parameters.
#   - Padding: Number of spaces for padding between columns.
#   - Indent: Number of spaces for left indentation of each line.
# Returns: None
# *---------------------------------------------

function New-PHWriter {
    [CmdletBinding()] # Enables common cmdlet parameters like -Verbose, -Debug, etc.
    [outputtype('void')]
    param(
        [Parameter(Mandatory = $false, HelpMessage = "JsonImporter object to import json data from file.")]
        [string]$JsonFile,

        # Default module name for the logo
        [Parameter(HelpMessage = "Sets the Name of the default logo to display. default: 'P H W R I T E R'.")]
        [string]$Name, 

        # Default to the current command name props: 'ModuleName', 'Cmdlet', 'Description'
        [Parameter(Mandatory = $false, HelpMessage = "Name & Description of the cmdlet to display version information.")]
        [pscustomobject]$CommandInfo, 

        # ParamTable is a mandatory parameter that accepts an array of hashtables.
        # Each hashtable defines a parameter for which help text will be generated.
        [Parameter(Mandatory = $false, HelpMessage = "An array of hashtables defining help parameters.")]
        [array]$ParamTable,

        [Parameter(Mandatory = $false, HelpMessage = "Example cmdlet cmdlet calls.")]
        [string[]]$Examples, # Optional examples for the cmdlet, default is an empty array

        [Parameter(Mandatory = $false, HelpMessage = "Version of the cmdlet to display.")]
        [string]$Version, # Default version of the cmdlet

        # Padding specifies the number of spaces between the parameter alias/name, type, and description.
        # This helps in aligning columns for a clean look.
        [Parameter(HelpMessage = "Number of spaces for padding between columns.")]
        [int]$Padding = 3, # Default padding of 4 spaces

        # Indent specifies the left padding for each line of the help output.
        # This indents the entire help block from the left edge of the console.
        [Parameter(HelpMessage = "Number of spaces for left indentation of each line.")]
        [int]$Indent = 1, # Default indent of 4 spaces

        [Parameter(HelpMessage = "Sets a custom logo for the module display. If not provided, a default logo will be used.")]
        [string]$CustomLogo = $null, # Optional custom logo, if provided

        [parameter(HelpMessage = "Display Help for the cmdlet.")]
        [switch]$Help
    )

    Process {

        if(!$version){
            $Version = '1.0.0' # Default version if not provided
        }

        # Create an indentation string based on the Indent parameter.
        $indentString = " " * $Indent
        if(!$Description){$Description = "-"}

        # Indernal Help
        $phwriter_ParamTable = @(
            @{
                name        = "Name"
                param       = "n|Name"
                type        = "String"
                description = "Sets the Name of the default logo to display. Default: 'P H W R I T E R'."
                inline      = $false
            },
            @{
                name        = "c|CommandInfo"
                param       = "CommandInfo"
                type        = "hashtable"
                description = "cmdlet, synopsis, and Description of the cmdlet to display version information."
                inline      = $false
            }, 
            @{
                name        = "ParamTable"
                param       = "p|ParamTable"
                type        = "Hashtable[]"
                description = "An array of hashtables defining help parameters."
                inline      = $false
            },
            @{
                name        = "Examples"
                param       = "e|Examples"
                type        = "string[]"
                description = "Example cmdlet cmdlet calls."
                inline      = $false
            },
            @{
                name        = "Version"
                param       = "v|Version"
                type        = "String"
                description = "Version of the cmdlet to display."
                inline      = $false
            },
            @{
                name        = "Padding"
                param       = "pad|Padding"
                type        = "Int"
                description = "Number of spaces for padding between columns."
                inline      = $false
            },
            @{
                name        = "Indent"
                param       = "i|Indent"
                type        = "Int"
                description = "Number of spaces for left indentation of each line."
                inline      = $false
            },
            @{
                name        = "CustomLogo"
                param       = "CustomLogo"
                type        = "String"
                description = "Sets a custom logo for the module display. If not provided, a default logo will be used."
                inline      = $false
            },
            @{
                name        = "Help"
                param       = "h|Help"
                type        = "Switch"
                description = "Display Help for the cmdlet."
                inline      = $false
            }
        )
        $phwriter_commandinfo = @{
            cmdlet = "New-PHWriter";
            synopsis = "New-PHWriter [-HelpTable <Hashtable[]>] [-Padding <Int>] [-Indent <Int>]";
            description = "This cmdlet generates formatted help text for PowerShell cmdlets with custom layouts and coloring, mimicking the output of the 'help' command. It supports custom layouts, coloring, and inline/newline descriptions."
            source = "https://gitlab.com/phellams/phwriter/blob/main/README.md"
        }
        $phwriter_examples = @(
            'New-PHWriter -Help',
            'New-PHWriter -Name "PHWriter" -ComandInfo [Hashtable] -ParamTable [HashTable[]] -Version [String] -Padding [int] -Indent [int]',
            'New-PHWriter -Name "PHWriter" -ComandInfo [Hashtable] -ParamTable [HashTable[]] -version [String] -Padding [int] -Indent [int]'
        )
        if($Help){
            # If the Help switch is set, display the help information and exit.
            New-PHWriter -Name 'PHWRITER' -CommandInfo $phwriter_commandinfo -ParamTable $phwriter_ParamTable -Padding 4 -Indent 2 `
             -CustomLogo $CustomLogo -Version '0.3.5' -Examples $phwriter_examples
            [console]::write("`n") # Add a new line for spacing after the
            return
        }
        #TODO: examples paths with double // replace with / 
        # Load JSON data if a JsonFile is provided
        [pscustomobject]$jsonData = $null
        if ($JsonFile) {
            $jsonFile_FullPath = Get-ChildItem -Path $JsonFile | Select-Object -First 1
            if ($null -ne $jsonFile_FullPath) {
                try {
                    # Get Property 
                    $jsonFile_FullPath = Get-ChildItem -Path $JsonFile | Select-Object -First 1
                    $jsonData = ConvertFrom-Json $(get-content -Path $jsonFile_FullPath.FullName -raw) -AsHashtable
                    # Override parameters with JSON data if they exist
                    if ($jsonData.name) { $Name = $jsonData.name } else { throw "Name is required." }
                    if ($jsonData.commandinfo) { $CommandInfo = $jsonData.commandinfo } else { throw "CommandInfo is required." }
                    if ($jsonData.paramtable) { $ParamTable = $jsonData.paramtable }
                    if ($jsonData.examples) { $Examples = $jsonData.examples }
                    if ($jsonData.version  ) { $Version = $jsonData.version }
                    if ($jsonData.padding) { $Padding = $jsonData.padding }
                    if ($jsonData.indent) { $Indent = $jsonData.indent }
                    if ($jsonData.customlogo) { $CustomLogo = $jsonData.customlogo }
                } catch {
                    Write-Warning "Failed to parse JSON file: $_"
                    exit
                }
            } else {
                Write-Warning "JSON file not found: $JsonFile"
                exit
            }
        }

        # Fallback to default name if not provided
        if (!$name -or !$jsonfile) { $name = 'PHW' } 
        # Display the ASCII logo at the top of the help output.
        if(!$CustomLogo -or !$JsonFile) { Write-PHAsciiLogo -Name $name}
        else{ Write-PHAsciiLogo -CustomLogo $CustomLogo -Name $name }

        $section_char = "$(csole -String "◉" -color darkgreen -format bold, italic)"
        $header_char = "$(csole -String "▶" -color darkgreen -format bold, italic)"
        
        #NOTE: change write-host to New-ColorConsole 4bit color with formatting
        # Display the module version information.
        [console]::write("$indentString $(csole -s "MODULE " -color gray) $(csole -s $Name -color cyan -bgcolor gray)")
        [console]::write("$indentString$header_char  $(csole -s "CMDLET" -color gray) $(csole -s $($CommandInfo.cmdlet) -color cyan -bgcolor gray)")
        [console]::write("$indentString$header_char $(csole -s "VERSION" -color gray) $(csole -s "v$Version" -color DarkMagenta -bgcolor gray)")
        [console]::write("`n`n") # Add a new line for spacing

        # Display the SYNOPSIS section, outlining the basic usage of the cmdlet.
        [console]::write("$indentString$section_char$(csole -s "SYNTAX" -color Yellow -format bold,underline)`n`n")
        #[console]::write("$indentString $(csole -string "$($CommandInfo.synopsis)" -color white)")
        New-Paragraph -position 100 -indent $indentString+2 -string "$(csole -s "$($CommandInfo.synopsis)" -color white)"
        [console]::write("`n`n") # Add a new line for spacing

        # Display a general DESCRIPTION of what this cmdlet does.
        [console]::write("$indentString$section_char$(csole -s "DESCRIPTION" -color Yellow -format bold,underline)`n`n")
        #[console]::write("$(csole -s "$indentString     $($CommandInfo.description)" -color white)")
        New-Paragraph -position 100 -indent $indentString+2 -string "$(csole -s "$($CommandInfo.description)" -color white)"
        [console]::write("`n`n") # Add a new line for spacing

        # Display the PARAMETERS section header.
        if (!$ParamTable -or $ParamTable.Count -eq 0) {
            Write-Warning "No parameters provided in ParamTable. Skipping parameter display."
            return
        }else{
            [console]::write("$indentString$section_char$(csole -s PARAMETERS -color Yellow -format bold,underline)")
            [console]::write("`n`n")

        }
        # --- Calculate maximum lengths for alignment ---
        $maxParamLength = 0
        $maxTypeLength = 0

        foreach ($paramInfo in $ParamTable) {
            # Validate that all required properties are present.
            if (-not ($paramInfo.name -and $paramInfo.param -and $paramInfo.type -and $paramInfo.description)) {
                Write-Warning "Skipping an entry in ParamTable due to missing required properties (Name, Param, Type, Description, Inline)."
                continue
            }
            # Calculate length for the parameter alias/name part (e.g., "-p|Path").
            # Add 1 for the leading hyphen and 1 for the space after.
            $currentParamLength = ("-{0}" -f $paramInfo.param).Length + 1 # +1 for the space after alias

            # Calculate length for the type part (e.g., "[string]").
            $currentTypeLength = ("[{0}]" -f $paramInfo.type).Length

            if ($currentParamLength -gt $maxParamLength) {
                $maxParamLength = $currentParamLength
            }
            if ($currentTypeLength -gt $maxTypeLength) {
                $maxTypeLength = $currentTypeLength
            }
        }

        # --- Iterate and display with calculated padding ---
        foreach ($paramInfo in $ParamTable) {
            # Re-validate in case some entries were skipped during length calculation.
            if (-not ($paramInfo.name -and $paramInfo.param -and $paramInfo.type -and $paramInfo.description)) {
                continue # Skip if invalid
            }

            # Extract properties from the current hashtable for easier access.
            $paramName = $paramInfo.name
            $paramAlias = $paramInfo.param
            $paramType = $paramInfo.type
            $paramDescription = $paramInfo.description
            $required = $paramInfo.required -or $false # Default to false if not specified
            if ($required) { $required_text = "$(csole -string "(Req) " -color red)"; } # Append "(Req)" if required
            else { $required_text = ""; } # No text if not required
            $paramInline = [bool]$paramInfo.inline # Ensure Inline is treated as a boolean

            # Format the parameter alias/name part, applying padding.
            $formattedParamAlias = ("-{0}" -f $paramAlias).PadRight($maxParamLength + $Padding)
            # Format the type part, applying padding.
            $formattedParamType = ("[{0}]" -f $paramType).PadRight($maxTypeLength + $Padding)

            # Output the indented parameter line.
            [console]::write("$indentString   $(csole -s "$formattedParamAlias" -color DarkMagenta)")
            [console]::write("$(csole -s $formattedParamType -color DarkCyan) $required_text")
            [console]::write("$(csole -s " $paramName" -color White)")

            # Handle the description display based on the 'Inline' property.
            if ($paramInline) {
                # If Inline is true, append the description on the same line.
                [console]::write("$(csole -s " $paramDescription" -color Gray)")
            }
            else {
                # If Inline is false, start the description on a new line with indentation.
                [console]::write("`n") # Ensure a new line after the parameter name
                # Calculate the indentation for the description based on the overall indent and column widths.
                $descriptionIndent = $indentString + (" " * ($maxParamLength + $maxTypeLength + (2 * $Padding) + 1)) # +1 for the space after param name
                [console]::write("$descriptionIndent $(csole -s "   $paramDescription" -color Gray)")
            }

            [console]::write("`n") # Add a new line for spacing between different parameters
        }
        #TODO: Implement examples for cmdlet parameters
        [console]::write("$indentString$section_char$(csole -s "EXAMPLES" -color White -format bold,underline)`n")
        foreach ($example in $Examples) {
            [console]::write("`n$indentString$(" "* 3)$(csole -s "$($example.replace("//","/"))" -color Gray)")
            # Add a new line after each example for better readability
            [console]::write("`n") # Add a new line for spacing
        }
        # Output at the end github docs LINK
        [console]::write("`n")

        [console]::write("$indentString ★ Docs: $(csole -s "$($CommandInfo.source)" -format bold,underline -c darkcyan) for more info")

        [console]::write("`n`n") # Add a new line for spacing

    }
}

$cmdlet_config = @{
    function = @(
        'New-PHWriter',
        'Write-PHAsciiLogo'
    )
    alias = @()
}

Export-ModuleMember @cmdlet_config
