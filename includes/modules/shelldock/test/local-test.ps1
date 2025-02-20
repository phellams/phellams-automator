Import-Module G:\devspace\projects\powershell\_repos\tadpol\
Import-Module G:\devspace\projects\powershell\_repos\colorconsole\
Import-Module G:\devspace\projects\powershell\_repos\quicklog\
Import-Module .\

New-ShellDock -ScriptBlock { ping -n $args.number $args.url } -Arguments (@{url = "google.com"; number = 10 }) -LogName customscript