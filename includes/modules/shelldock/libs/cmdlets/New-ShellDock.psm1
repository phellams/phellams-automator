<#
    .SYNOPSIS
        Creates a new ShellDock
    .DESCRIPTION
        Creates a new ShellDock
    .PARAMETER ScriptBlock
        The ScriptBlock to execute
    .PARAMETER Name
        The name of the ShellDock
    .PARAMETER Arguments
        The arguments to pass to the ScriptBlock
    .PARAMETER LogName
        The name of the log file
#>
<#
    To achieve asynchronous execution and retrieve the output and errors, 
    we can use the InvokeAsync() method of the Pipeline object, but you 
    won't be able to use the EndInvokeAsync() method. Instead, you can 
    use the PipelineStateInfo to check the completion status of the 
    pipeline.

    !NOTE: Reading the output from runspace while executing
            using the stream properties
#>
#NOTE: For intergration with other modules that dont use quicklog, change quicklog output for if the 
#NOTE: -| logname is not specified and quicklog param is flagged use default module name and quicklog to output
#NOTE: -| if logname is specified and quicklog param is not flagged that output with use Global:__shelldock.utilities and use console.write
Function New-ShellDock(){
    [alias("shelldock")]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [Scriptblock] $ScriptBlock,
        
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [String] $Name,
        
        [Parameter(Mandatory = $false)]
        [PSobject] $Arguments,
        
        [Parameter(Mandatory = $false)]
        [validateScript({if($_.length -gt 0){$true}else{$false}})]
        [string] $LogName, # for quicklog
        
        [Parameter(Mandatory = $false)]
        [switch] $Ql # Enable Quicklog output
    )
    Begin{

        $kvinc = $global:__shelldock.kvinc

        if(!$logname){$logname = $global:__shelldock.utility.logName}

        $TadPol = New-TPObject # Create a new TadPol Object

        # Create Instance ofRunSpacefactory
        $ShellDock = [RunSpacefactory]::CreateRunSpace()
        $ShellDock.OpenAsync()
        
        # Create Instance of powershell
        $pwsh = [powershell]::Create()

        # Set the name of the RunSpace
        $unq_name       = "ShellDock-$([System.Guid]::NewGuid().ToString().Split("-")[0])"
        $ShellDock.name = $unq_name
        
        if($Ql){Write-Quicklog -name $LogName -Message "creating $($kvinc.invoke("runspace",$ShellDock.name)) > runspacefactory create}}" -Type "Action" }
        else{[console]::write("$($kvinc.invoke("runspace",$ShellDock.name)) > Runspacefactory create`n")}
        
        if($ShellDock.RunspaceStateInfo.state -eq "connected"){
            if($Ql){Write-Quicklog -name $LogName -Message "@{pt:{$($ShellDock.Name)=$($ShellDock.RunspaceStateInfo.state)" -Type "Info" -submessage}
            else{[console]::write("$($ShellDock.Name) > $($ShellDock.RunspaceStateInfo.state)`n")}
        }else{
            # Check if the RunSpace is opened
            while($ShellDock.RunspaceStateInfo.state -like "Opening"){
                if($Ql){Write-Quicklog -name $LogName -Message "Connecting to {cs:yellow:$($ShellDock.Name)}" -Type "Info" -submessage}
                else{[console]::write("connecting to $($kvinc.invoke("runspace",$ShellDock.Name))`n")}
                [Console]::SetCursorPosition(0, ([Console]::GetCursorPosition().Item2 - 1 ) );
                Start-Sleep -Seconds 1
            }
        }
        # add powershell instance to runspace
        #  - add scriptblock to powershell instance
        #  - add arguments to powershell instance
        $pwsh.RunSpace = $ShellDock
        $pwsh.AddScript($ScriptBlock) | out-null
        $pwsh.AddArgument($Arguments) | out-null
    }
    process {

        # Asynchronously invoke the pipeline
        $Response = $pwsh.BeginInvoke()

        # Check the completion status of the pipeline
        # The PowerShell object has a property called Streams which is a collection of PSDataCollection objects. These collections represent the different output streams in PowerShell:
        #     Output (Success Stream): The default stream for successful results from cmdlets and scripts. This is where objects are written to the pipeline.
        #     Error: For error records.
        #     Warning: For warning messages.
        #     Verbose: For verbose output (when the -Verbose common parameter is used).
        #     Debug: For debug messages (when the -Debug common parameter is used).
        #     Information: For informational messages (like those from Write-Information).
        while ($Response.IsCompleted -ne $true) {
            # Do additional work while waiting for the pipeline to complete
            if($Ql){Write-Quicklog -name $LogName -message "[$($TadPol.loader("bowls",'1','cyan'))] Executing ShellDock..." -Type Action -SubMessage}
            else{[console]::write("[$($TadPol.loader("bowls",'1','cyan'))] Executing ShellDock...`n")}
            [Console]::SetCursorPosition(0, ([Console]::GetCursorPosition().Item2 - 1 ) );
            Start-Sleep -Milliseconds 200
        }

        #TODO: Add write-qicklog complete spinnner
        if($response.IsCompleted -eq $true){
            [console]::writeLine("")
            [Console]::SetCursorPosition(0, ([Console]::GetCursorPosition().Item2 - 1 ) );
            if($Ql){Write-Quicklog -name $LogName -message "executing shell [$($tadpol.CompleteChar("bowls"))] {cs:green:execution completed}" -Type Complete -SubMessage}
            else{[console]::write("Shelldock [$($tadpol.CompleteChar("bowls"))] $(csole -s "execution completed" -c "green")")}
        }

        # Retrieve the output
        $output = $pwsh.EndInvoke($Response)
        
        # Check for errors
        $errors = $pwsh.Streams.Error


        if($errors.Count -gt 0){
            # Output the error messages to the PowerShell console
            foreach($error in $errors){
                Write-Error $error.Exception
            }
        }

        # Output the command output to the PowerShell console
        Write-Output $output
        }
    end{
        # Close the ShellDock ie runspace
        $ShellDock.closeAsync()
        $ShellDock.Dispose()
    }
}

$cmdlet_config = @{
    function = @('New-ShellDock')
    alias = @('sdock')
}

Export-Modulemember @cmdlet_config

