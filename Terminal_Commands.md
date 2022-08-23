# Terminal\_Commands

## Terminal Commands

### macOS related

* **List of** [**defaults commands**](https://macos-defaults.com/) for modifying macOS default settings/behavior.
* **List of** [**PMSET Commands**](https://www.dssw.co.uk/reference/pmset.html) for modifying power management paramters.
  * **Example**: `sudo pmset proximitywake 0` → Disables wake based on proximity of other devices using the same iCloud ID (iWatch or similar).

**Show macOS Version and Build Number**:\


```shell
sw_vers
```

**Show macOS Kernel Version**:\


```shell
uname -r
```

**Disable Gatekeeper**:\


```shell
sudo spctl --master-disable
```

**Show the User Library in Big Sur+**:\


```shell
setfile -a v ~/Library
chflags nohidden ~/Library
```

**Disable/enable DMG Verification**:\


```shell
defaults write com.apple.frameworks.diskimages skip-verify TRUE 
defaults write com.apple.frameworks.diskimages skip-verify FALSE
```

**Disable/enable Notification Center**:

```shell
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist
launchctl load -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist
```

**Add "Quit" option to Finder**:\


```shell
defaults write com.apple.finder "QuitMenuItem" -bool "true" && killall Finder
```

**Add "GPU" Tab to Activity Monitor**:\


```shell
defaults write com.apple.ActivityMonitor ShowGPUTab -bool true
```

**Disable Library Validation**:\


```shell
sudo defaults write /Library/Preferences/com.apple.security.libraryvalidation.plist DisableLibraryValidation -bool true
```

**List MAC Addresses**:\


```shell
networksetup -listallhardwareports
```

**Show all Files in Finder**:\


```shell
defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder
defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder
```

Alternatively, use a **Key Command**: ⌘⇧. (Command-Shift-Dot)

**Rebuild Launch Services**:\


```shell
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
```

**Rebuild DYLD and XPC caches** (≤ macOS 10.15):

```shell
sudo update_dyld_shared_cache -force
sudo /usr/libexec/xpchelper --rebuild-cache
```

**Enable Sidecar**:\


```shell
defaults write com.apple.sidecar.display AllowAllDevices -bool true
defaults write com.apple.sidecar.display hasShownPref -bool true
```

**Disable Logging:**\


```shell
sudo rm /System/Library/LaunchDaemons/com.apple.syslogd.plist
```

**Enable Key Repeating**\


```shell
defaults write -g ApplePressAndHoldEnabled -bool false
```

**Disabling macOS from mastering iDevices**:

```shell
defaults write com.apple.iTunesHelper ignore-devices -bool YES
defaults write com.apple.AMPDeviceDiscoveryAgent ignore-devices 1
defaults write com.apple.AMPDeviceDiscoveryAgent reveal-devices 0
defaults write -g ignore-devices -bool true
```

**Source**: [**Apple-Knowledge**](https://github.com/hack-different/apple-knowledge/blob/main/docs/USB\_Modes.md)

### CPU related

**Show CPU Vendor**:\


```shell
sysctl -a | grep machdep.cpu.vendor
```

**Show CPU Model** (doesn't really tell you much):\


```shell
sysctl -a | grep machdep.cpu.model
```

**Show CPU Brand String**:\


```shell
sysctl machdep.cpu.brand_string
```

**List CPU features**:\


```shell
sysctl -a | grep machdep.cpu.features
```

**Display Bus and CPU Frequency**:\


```shell
sysctl -a | grep freq
```

**List supported instruction sets** (AVX2 and others):\


```shell
sysctl -a | grep machdep.cpu.leaf7_features
```

**Get CPU details** from IO Registry:\


```shell
ioreg -rxn "CPU0@0"
```

**NOTE**: Text in quotation marks = CPU name as defined in ACPI. On Intel CPUs it can also be "PR00@0", "P000@0" or "C000@0". Check `SSDT-PLUG/SSDT-PM` to find the correct name.

### Hackintosh specific

**Checking Reasons for Wake**:\


```shell
pmset -g log | grep -e "Sleep.*due to" -e "Wake.*due to"
```

**Currently used SMBIOS**:\


```shell
system_profiler SPHardwareDataType | grep 'Model Identifier'
```

**Check OpenCore version set in NVRAM**:\


```shell
nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:opencore-version
```

**Check currently active csr-active-config set in NVRAM**:\


```shell
nvram 7C436110-AB2A-4BBB-A880-FE41995C9F82:csr-active-config
```

**Find loaded Kexts** (excluding those from Apple):\


```shell
kextstat | grep -v com.apple
```

**Rebuild Kext Cache** (Deprecated in macOS 13):\


```shell
sudo kextcache -i /
```

**Update PreBoot Volume**:\


```shell
sudo diskutil apfs updatePreboot /
```

**Check the status of System Integrity Protection**:\


```shell
csrutil status
```

**Show last boot log**:\


```shell
log show --last boot
```

**Search for terms in last boot log**:\


```shell
log show --last boot | grep "your search term"
```

**Example**: `log show --last boot | grep "ACPI"`

**Create new shapshot** (macOS 11+ only) In Recovery, enter:\


```shell
csrutil authenticated-root disable
bless --folder /Volumes/x/System/Library/CoreServices --bootefi --create-snapshot
```

**x** = name of your macOS Big Sur/Monterey Volume

**Check if used Hardware supports Apple Secure Boot**:\


1. In Terminal, enter:\
   `nvram 94b73556-2197-4702-82a8-3e1337dafbfb:AppleSecureBootPolicy`
2. Check the Results:
   * if `%00` = No Security
   * if `%01` = Medium Security
   * if `%02` = Full Security

**Show currently used Board-ID**:\
`ioreg -l | grep -i board-id`

**Check Hibernation Settings**:\
`pmset -g`

**Make .command files executable**:\
`chmod +x` (drag file in terminal, hit enter)

**Find USB Controller Renames**:\


```shell
ioreg -l -p IOService -w0 | grep -i EHC1
ioreg -l -p IOService -w0 | grep -i EHC2
ioreg -l -p IOService -w0 | grep -i XHC1
ioreg -l -p IOService -w0 | grep -i XHCI
```

**Verifying if SMBus is working**:\


```shell
kextstat | grep -E "AppleSMBusController|AppleSMBusPCI"
```

**Debug ACPI Hotpatches**:\


```shell
log show --predicate "processID == 0" --start $(date "+%Y-%m-%d") --debug | grep "ACPI"
```

**Display CPU Features**:\


```shell
sysctl -a | grep machdep.cpu.features
sysctl -a | grep machdep.cpu.leaf7_features
sysctl machdep.cpu | grep AVX
```

**Disable/Delete Metal Support**:\


```shell
sudo defaults write /Library/Preferences/com.apple.CoreDisplay useMetal -boolean no
sudo defaults write /Library/Preferences/com.apple.CoreDisplay useIOP -boolean no
```

or:

```shell
sudo defaults delete /Library/Preferences/com.apple.CoreDisplay useMetal
sudo defaults delete /Library/Preferences/com.apple.CoreDisplay useIOP
```

[**Source**](https://github.com/lvs1974/NvidiaGraphicsFixup/releases)

**Change Update Seed to Developer**:\


```shell
sudo /System/Library/PrivateFrameworks/Seeding.framework/Resources/seedutil unenroll
sudo /System/Library/PrivateFrameworks/Seeding.framework/Resources/seedutil enroll DeveloperSeed
```

**Removing Network .plists (for troubleshooting)**:\


```shell
sudo rm /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist
sudo rm /Library/Preferences/SystemConfiguration/preferences.plist
```

**List ACPI Errors**:\


```shell
log show --last boot | grep AppleACPIPlatform
log show --last boot | grep AppleACPIPlatform > ~/Desktop/Log_"$(date '+%Y-%m-%d_%H-%M-%S')".log
```

The 2nd Command saves a log on the desktop.

**Dump Audio Codec** (in Linux):\


```shell
cd ~/Desktop && mkdir CodecDump && for c in /proc/asound/card*/codec#*; do f="${c/\/*card/card}"; cat "$c" > CodecDump/${f//\//-}.txt; done && zip -r CodecDump.zip CodecDump
```

**Disable Power Management Scheduler** (fixes high CPU usage for `Powerd` service in macOS Ventura beta 4):\


```shell
sudo pmset schedule cancelall
```

***

## Keyboard Shorcuts

**Show hidden Files and Folders in Finder**: ⌘⇧. (Command-Shift-Dot)
