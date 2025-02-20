using module ..\libs\cmdlets\New-ShellDock.psm1

# $scriptblock = {
#     cmd /c ping -n 10 $args
# }
$timer = [PSObject]@{count=10}
$url = "google.com.au"
New-ShellDock -Ql -ScriptBlock {
    #get-childitem C:\users\gsnow
    #Write-Output $args.url
    cmd /c ping -n $args.timer.count $args.url
} -Arguments ([PSObject]@{url=$url;timer=$timer})
