Function New-ShellDock(){
    <#
        To achieve asynchronous execution and retrieve the output and errors, 
        we can use the InvokeAsync() method of the Pipeline object, but you 
        won't be able to use the EndInvokeAsync() method. Instead, you can 
        use the PipelineStateInfo to check the completion status of the 
        pipeline.

        !NOTE: Reading the output from runspace while executing
               using the stream properties
    #>
    [alias("nsd")]
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
        [string] $LogName
    )
    Begin{

        $kvs = $global:_shelldock.kvstring

        if(!$LogName){$LogName = "shelldock"}

        $TadPol = New-TPObject # Create a new TadPol Object

        # Create Instances of powershell and RunSpacefactory
        $ShellDock = [RunSpacefactory]::CreateRunSpace()
        $ShellDock.OpenAsync()
        
        $pwsh = [powershell]::Create()

        # Set the name of the RunSpace
        if($name){ $ShellDock.name = $Name}
        else{
            $unq_name       = "ShellDock-$([System.Guid]::NewGuid().ToString().Split("-")[0])"
            $ShellDock.name = $unq_name
        }
        Write-Quicklog -name $LogName -Message "creating $($kvs.invoke("runspace",$ShellDock.name)) @{pt:{runspacefactory=create}}" -Type "Action" 
        if($ShellDock.RunspaceStateInfo.state -eq "connected"){
            Write-Quicklog -name $LogName -Message "@{pt:{$($ShellDock.Name)=$($ShellDock.RunspaceStateInfo.state)}}" -Type "Info" -submessage 
        }else{
            # Check if the RunSpace is opened
            while($ShellDock.RunspaceStateInfo.state -like "Opening"){
                Write-Quicklog -name $LogName -Message "Connecting to {cs:yellow:$($ShellDock.Name)}" -Type "Info" -submessage
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
    process{

        # Asynchronously invoke the pipeline
        $Response = $pwsh.BeginInvoke()

        # Do other work here while the pipeline is executing asynchronously
        # ----

        # Check the completion status of the pipeline
        #$TadPol = New-TPObject #
        while ($Response.IsCompleted -ne $true) {
            # Do additional work while waiting for the pipeline to complete
            Write-Quicklog -name $LogName -message "[$($TadPol.loader("bowls",'1','cyan'))] Executing ShellDock..." -Type Action -SubMessage
            [Console]::SetCursorPosition(0, ([Console]::GetCursorPosition().Item2 - 1 ) );
            Start-Sleep -Milliseconds 200
        }
        #TODO: Add write-qicklog complete spinnner
        if($response.IsCompleted -eq $true){
            Write-Quicklog -name $LogName -message "executing shell [$($tadpol.CompleteChar("bowls"))] {cs:green:execution completed}" -Type Complete -SubMessage
        }

        # Retrieve the output
        $output = $pwsh.EndInvoke($Response)
        
        # Check for errors
        $errors = $command.Streams.Error


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

