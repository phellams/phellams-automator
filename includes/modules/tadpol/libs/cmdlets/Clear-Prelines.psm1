function Clear-Prelines() {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $false,
            #ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )] [int]$lines
    )
    PROCESS{
        $originalCursorPosition = [console]::CursorTop

        # Move the cursor position to the beginning of the first line to rewrite
        $newCursorPosition = [Math]::Max(0, $originalCursorPosition - $lines)
        [console]::SetCursorPosition(0, $newCursorPosition)

        # Resize the console buffer height if necessary
        $newBufferHeight = [Math]::Max($originalCursorPosition + 1, $newCursorPosition + $lines)
        if ($newBufferHeight -gt [console]::BufferHeight) {
            [console]::BufferHeight = $newBufferHeight
        }

        # Rewrite the specified number of lines
        for ($i = 0; $i -lt $lines; $i++)
        {
            [console]::SetCursorPosition(0, $newCursorPosition  + $i)
            $blankLine = " " * [console]::WindowWidth
            Write-Host "$blankLine"
        }

        # Reset the cursor position to the beginning of the first line to rewrite
        [console]::SetCursorPosition(0, $newCursorPosition)
    }
}

Export-modulemember -function Clear-Prelines