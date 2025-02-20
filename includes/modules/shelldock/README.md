
# ShellDock

![license-badge][license-badge]

A simple powershell module to execute code inside a runspace, while displaying animated output.

## Features
- Create and excute a code block/script inside a local runspace with animated output.
- Customize the runspace name and quicklog entry name to intergate with other modules/scripts.
- Alias `sdock` to excute code block/script inside a local runspace with animated output.

## Usage

#### 🔘 New-ShellDock
🔸 Parameters
- `Name` - The name of the runspace
- `LogName` - The display name of the runspace quicklog entry name
- `ScriptBlock` - The code block to execute inside the runspace
- `Arguments` - The arguments to pass to the code block


**Examples:**

🔹 Create a new runspace and execute a code block.

```powershell
New-ShellDock -ScriptBlock { ping -n 10 google.com }

# alias
sdock -s { ping -n 10 google.com }
```

🔹 Create a new runspace and execute a code block with parameters.

```powershell
New-ShellDock -ScriptBlock { ping -n $args.number $args.url } -Arguments (@{url="google.com";number=10})

# alias
sdock -s { ping -n $args.number $args.url } -a @{url="google.com";number=10}
```
> **🦜 Note!**
> `$args` supports any powershell object e.g: **objects**(`Arrays`, `PSOjects`, `PSCustomObjects`,`Hashtables`, ...).

🔻Example Output:

```pre
⌠╮customscript:12:56:21⌡❂┅ creating { runspace : ShellDock-16f54dd1 } ⬡═runspacefactory:create ⇾ ↨ ex:0ms
⌠╮customscript:12:56:30⌡     ↪ executing shell [●●●●●●] execution completed ⇾ ☑

Pinging google.com [142.250.71.78] with 32 bytes of data:
Reply from 142.250.71.78: bytes=32 time=16ms TTL=117
Reply from 142.250.71.78: bytes=32 time=16ms TTL=117
Reply from 142.250.71.78: bytes=32 time=16ms TTL=117
Reply from 142.250.71.78: bytes=32 time=16ms TTL=117
Reply from 142.250.71.78: bytes=32 time=16ms TTL=117
Reply from 142.250.71.78: bytes=32 time=16ms TTL=117
Reply from 142.250.71.78: bytes=32 time=16ms TTL=117
Reply from 142.250.71.78: bytes=32 time=16ms TTL=117
Reply from 142.250.71.78: bytes=32 time=16ms TTL=117
Reply from 142.250.71.78: bytes=32 time=16ms TTL=117

Ping statistics for 142.250.71.78:
    Packets: Sent = 10, Received = 10, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 16ms, Maximum = 16ms, Average = 16ms
```

# License

This project is released under the [MIT License](LICENSE)


[license-badge]: https://img.shields.io/badge/License-MIT-Blue?style=for-the-badge&labelColor=%232D2D34&color=%2317202a