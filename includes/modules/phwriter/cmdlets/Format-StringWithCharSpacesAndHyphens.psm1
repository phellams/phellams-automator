function Format-StringWithCharSpacesAndHyphens {
    <#
    .SYNOPSIS
    Formats a string by splitting words into individual characters separated by spaces,
    and replacing original word-separating spaces with hyphens.

    .DESCRIPTION
    This function takes an input string, splits it into words based on spaces.
    For each word, it then splits the word into its individual characters and
    rejoins them with spaces in between (e.g., "WORD" becomes "W O R D").
    Finally, the original spaces between words are replaced with hyphens.

    .PARAMETER InputString
    The string to be formatted.

    .EXAMPLE
    Format-StringWithCharSpacesAndHyphens -InputString "PHWRITER PSMMODULE"
    # Expected Output: P H W R I T E R - P S M M O D U L E

    .EXAMPLE
    "Hello World" | Format-StringWithCharSpacesAndHyphens
    # Expected Output: H E L L O - W O R L D

    .EXAMPLE
    "My Awesome String" | Format-StringWithCharSpacesAndHyphens
    # Expected Output: M Y - A W E S O M E - S T R I N G

    .EXAMPLE
    "  Test   Me  Now  " | Format-StringWithCharSpacesAndHyphens
    # Expected Output: T E S T - M E - N O W
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$InputString
    )

    begin {
        # Initialize an array to hold the processed words
        $processedWords = @()
    }

    process {
        # Split the input string by spaces to get individual words
        $words = $InputString.Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)

        # Process each word
        foreach ($word in $words) {
            # Convert the word to a character array
            $characters = $word.ToCharArray()

            # Join the characters with a space.
            # This effectively puts a space between every character,
            # achieving "P H W R I T E R" from "PHWRITER".
            $charSpacedWord = ($characters -join ' ')

            # Add the character-spaced word to our collection
            $processedWords += $charSpacedWord
        }
    }

    end {
        # Join all the processed words with a hyphen,
        # replacing the original spaces.
        $finalFormattedString = ($processedWords -join ' - ')

        # Output the final formatted string
        return $finalFormattedString
    }
}

Export-ModuleMember -Function Format-StringWithCharSpacesAndHyphens