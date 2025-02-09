<#
     _____ __         ________             __  
    / ___// /_  ___  / / / __ \____  _____/ /__
    \__ \/ __ \/ _ \/ / / / / / __ \/ ___/ //_/
&  ___/ / / / /  __/ / / /_/ / /_/ / /__/ ,<
* /____/_/ /_/\___/_/_/_____/\____/\___/_/|_| Powerhell RunSpace Wrapper
----------------------------------------o
& CMDLET: [New-ShellDock]
~ VERSION: 0.1.0
- AUTHOR: Snoonx @ scriptlynx
- LICENSE: MIT   
* DESCRIPTION:   
    ShellDock is a function that helps you manage runspaces and runspace pools and execute scripts in the background.
? DEPENDANCIES:
    none
? NOTES
    @Colorful comments vscode url: 
        - #? https://marketplace.visualstudio.com/items?itemName=bierner.colorful-comments
TODO 
#>
Function New-ShellDock() {
    <#
        To achieve asynchronous execution and retrieve the output and errors, 
        we can use the InvokeAsync() method of the Pipeline object, but you 
        won't be able to use the EndInvokeAsync() method. Instead, you can 
        use the PipelineStateInfo to check the completion status of the 
        pipeline.
    #>
    [alias("nsd")]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [Scriptblock]$ScriptBlock,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [String]$Name,
        [Parameter(Mandatory = $false)]
        [PSobject]$Arguments,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [switch]$Ql = $false,
        [Parameter(Mandatory = $false)]
        [string]$qlname
    )
    Begin {
        if (!$qlname) { $qlname = "shd" }
        $tadpol = New-TPObject # Create a new TadPol Object
        # Create Instances or powershell and RunSpacefactory
        $ShellDock = [RunSpacefactory]::CreateRunSpace()
        $pwsh = [powershell]::Create()
        $ShellDock.OpenAsync()
        # Set the name of the RunSpace
        if ($name) {
            $ShellDock.name = $Name
        }
        else {
            $unq_name = "ShellDock-#$([System.Guid]::NewGuid().ToString().Split("-")[0])"
            $ShellDock.name = $unq_name
        }
        if ($ql) { Write-LogTastic -name $qlname -Message "[{ct:yellow:runspace}] @{pt:{$($ShellDock.Name)=Create" -Type "Action" }
        if ($ShellDock.RunspaceStateInfo.state -eq "Opened") {
            if ($ql) { Write-LogTastic -name $qlname -Message "@{pt:{$($ShellDock.Name)=$($ShellDock.RunspaceStateInfo.state)}}" -Type "Info" -submessage }
        }
        else {
            # Check if the RunSpace is opened
            while ($ShellDock.RunspaceStateInfo.state -like "Opening") {
                if ($ql) { Write-LogTastic -name $qlname -Message "Connecting to {ct:yellow:$($ShellDock.Name)}" -Type "Info" -submessage } 
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


        # Do other work here while the pipeline is executing asynchronously

        # Check the completion status of the pipeline
        $TadPol = New-TPObject
        while ($Response.IsCompleted -ne $true) {
            # Do additional work while waiting for the pipeline to complete
            Write-LogTastic -name $qlname -message "[$($TadPol.loader("bowls",'1','yellow'))] Executing ShellDock [runspace]::$($ShellDock.Name)..." -Type Action -SubMessage
            [Console]::SetCursorPosition(0, ([Console]::GetCursorPosition().Item2 - 1 ) );
            Start-Sleep -Milliseconds 200
        }
        if ($response.IsCompleted -eq $true) {
            Write-LogTastic -name $qlname -message "[$($tadpol.CompleteChar("bowls"))] Executing complete [runspace]::$($ShellDock.Name)" -Type Complete -SubMessage
        }

        # Retrieve the output
        $output = $pwsh.EndInvoke($Response)
        # Check for errors
        $errors = $command.Streams.Error


        if ($errors.Count -gt 0) {
            # Output the error messages to the PowerShell console
            foreach ($error in $errors) {
                Write-Error $error.Exception
            }
        }
        # Output the command output to the PowerShell console
        Write-Output $output
    }
    end {
        # Close the ShellDock
        $ShellDock.closeAsync()
        $ShellDock.Dispose()
    }
}
Export-Modulemember -Function New-ShellDock


# # $scriptblock = {
# #     cmd /c ping -n 10 $args
# # }
# $timer = [PSObject]@{count=10}
# $url = "google.com.au"
# New-ShellDock -Ql -ScriptBlock {
#     #get-childitem C:\users\gsnow
#     #Write-Output $args.url
#     cmd /c ping -n $args.timer.count $args.url
# } -Arguments ([PSObject]@{url=$url;timer=$timer})


