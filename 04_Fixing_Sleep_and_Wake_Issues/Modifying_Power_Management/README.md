# Modifying Power Management Settings

Open Terminl. Enter `man pmset` 

&rarr; Lists all avalaible `pmset` parameters to modify System Power Management!

:warning: **CAUTION**: Don't fiddle around with these settings unless you know what you are doing.

## Changing Hibernation modes

To check the currently selected Hibernation mode, enter:

```
pmset -g | grep hibernatemode
```

### hibernatemode 0: Suspend to RAM only
Default for desktops. The system will not back memory up to persistent storage. The system must wake from the contents of memory; the system will lose context on power loss. This is, historically, plain old sleep. 

To enable it, enter in Terminal:

```
sudo pmset -a hibernatemode 0
```

### hibernatemode 3: Suspend to disk and RAM
Default on portables. The system will store a copy of memory to persistent storage (the disk), and will power memory during sleep. The system will wake from memory, unless a power loss forces it to restore from hibernate image.

To enable it, enter in Terminal:

```
sudo pmset -a hibernatemode 3
```

### hibernatemode 25: Suspend to disk and RAM (reduced power consumption)
For portables as well. Mode 25 is only settable via `pmset`. Same as mode 3, but 
will remove power to memory. The system will restore from disk image. If you want "hibernation" - slower sleeps, slower wakes, and better battery life, you should
use this setting. When using this mode, entering the hibernation state takes a bit longer than using mode 0 using this mode but it als

To enable it, enter in Terminal:

```
sudo pmset -a hibernatemode 25
```
Please note that hibernatefile may only point to a file located on the root volume.
