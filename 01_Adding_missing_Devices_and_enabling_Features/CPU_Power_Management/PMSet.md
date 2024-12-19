# macOS Power Management Settings explained

## `pmset` parameters

Listed below are power managements settings you can configure in Terminal via **`pmset`**

 Setting       | Description | Value |
---------------|-------------|:-------:|
`displaysleep`| Display sleep timer; replaces `dim` argument in 10.4.| Minutes, or 0 to disable 
`disksleep`   | Disk spindown timer; replaces `spindown` argument in 10.4.| Minutes, or `0` to disable 
`sleep`       | System sleep timer.| Minutes, or `0` to disable 
`womp`        | Wake on Ethernet magic packet. Same as "Wake for network access" in the Energy Saver preferences. | `0`/`1`
`ring`| Wake on modem ring.| `0`/`1`
`powernap`   | Enable/disable Power Nap on supported machines.| `0`/`1`
`proximitywake`          | Controls system wake from sleep based on proximity of devices using the same iCloud ID on supported systems.| `0`/`1`
`autorestart`| Automatic restart on power loss.| `0`/`1`
`lidwake`| Wake the machine when the laptop lid (or clamshell) is opened.| `0`/`1`
`acwake`| Wake the machine when power source (AC/battery) is changed.| `0`/`1`
`lessbright`| Slightly turn down display brightness when switching to this power source.| `0`/`1`
`halfdim`| Display sleep will use an intermediate half-brightness state between full brightness and fully off.| `0`/`1`
`sms` | Use Sudden Motion Sensor to park disk heads on sudden changes in G force.| `0`/`1`
`hibernatemode`| Change hibernation mode. Use with caution. | Integer 
`hibernatefile`| Change hibernation image file location. Image may only be located on the root volume. Please use with caution.| Path
`ttyskeepawake` | Prevent idle system sleep when any tty (e.g., remote login session) is active. A tty is inactive only when its idle time exceeds the system sleep timer.| `0`/`1`
`networkoversleep` | Affects how OS X networking presents shared network services during system sleep. Not used by all platforms; changing its value is unsupported. | Unsupported 
`destroyfvkeyonstandby`  | Destroy File Vault Key when going to standby mode. If the keys are destroyed, the user will be prompted to enter the password while coming out of standby mode. | `1` - Destroy, <br> `0` - Retain

## Using pmset commands

The general form to apply power management settings via pmset is:

```shell
sudo pmset -a paramateryouwanttosetorchange value
```

**Example**: Recommended pm settings for hackintoshes (at least on desktops):

```shell
sudo pmset -a hibernatemode 0
sudo pmset -a proximitywake 0
sudo pmset -a powernap 0
```
**Source**: [Insanelymac](https://www.insanelymac.com/forum/topic/342002-darkwake-on-macos-catalina-boot-args-darkwake8-darkwake10-are-obsolete/)