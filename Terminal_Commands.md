# Terminal Commands

## macOS Look and Feel

### Defaults
Collection of `Defaults` commands For modifying macOS default settings/behavior.

**https://macos-defaults.com/**

### Power Management
Collection of `PMSET` commands to adjust Powwer Management (Standby, Sleep, Hibernation, etc.)

**https://www.dssw.co.uk/reference/pmset.html**

#### Check Hibernation Settings
`pmset -g`

#### Checking Reasons for Wake

```shell
pmset -g log | grep -e "Sleep.*due to" -e "Wake.*due to"
```

Alternative Command (searches in syslog instead):

```shell
log show --style syslog | fgrep "Wake reason"
```

#### Disable Power Management Scheduler
Fixes high CPU usage for `Powerd` service in macOS Ventura beta 4

```shell
sudo pmset schedule cancelall
```

### Disable Notification Center

- Disable:

	```shell
	launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist
	```
	
- Re-Enable:

	```shell
	launchctl load -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist
	```	

### Enable Key Repeating

```shell
defaults write -g ApplePressAndHoldEnabled -bool false
```

### Add "GPU" Tab to Activity Monitor

```shell
defaults write com.apple.ActivityMonitor ShowGPUTab -bool true
```

### macOS Info

#### Display macOS Version and Build Number

```shell
sw_vers
```
#### Display Darwin Kernel Version

```shell
uname -r
```

### Display Model Identifier (SMBIOS)

```shell
system_profiler SPHardwareDataType | grep 'Model Identifier'
```

## System Behavior

### Disable Gatekeeper (< macOS 15.0 beta 3)

```shell
sudo spctl --master-disable
```

> [!IMPORTANT]
>
> In macOS Sequoia, Gatekeeper can no longer be disabled via Terminal ([new method](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Disable_Gatekeeper.md))

### Disable DMG verification

-  Disable Disk Image verification:

	```shell
	defaults write com.apple.frameworks.diskimages skip-verify TRUE
	```
-  To Re-enable: 

	```shell
	defaults write com.apple.frameworks.diskimages skip-verify FALSE
	``` 

### Change Update Seed to Developer (≤ macOS 12 only)

1. Unenroll from current seed:

	```shell
	sudo /System/Library/PrivateFrameworks/Seeding.framework/Resources/seedutil unenroll
	```
2. Change seed:

	```
	sudo /System/Library/PrivateFrameworks/Seeding.framework/Resources/seedutil enroll DeveloperSeed
	```

> [!NOTE]
> 
> In macOS 13+, [switching update seeds via seedutil is no longer supported](https://nwstrauss.com/posts/2023-05-18-seedutil-beta-programs/). Instead, registering your system in Apples [beta program](https://beta.apple.com/) via Apple-ID is required. After that you can switch the updated seed in system sttings. 

### Reset all Privacy Settings
Brings back all the window pop-ups that ask for granting pernission to access periferals like microphones, webcams, etc.

```shell
tccutil reset All
```

## Finder-related

### Show User Library in macOS 11 and newer

```shell
setfile -a v ~/Library
chflags nohidden ~/Library
```

### Show all Files and Folders in Finder

- Show: 

	```shell
	defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder
	```
- Hide:

	```shell
	defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder
	```

> [!NOTE] 
> 
> Alternatively, simply use this Keyboard Shortcut: <kbd>⌘</kbd><kbd>⇧</kbd><kbd>.</kbd> (Command+Shift+Dot)

### Rebuilding Launch Services
You can use this to fix the “Open with…” sub-menu (if it contains entries from apps that are no onger installed, etc.)  

```shell
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
```

### Add "Quit" option to Finder menu

```shell
defaults write com.apple.finder "QuitMenuItem" -bool "true" && killall Finder
```

### Disable `.DS_Store` file creation on network storages

- Disable:

	```shell
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	```

- Re-enable:

	```shell
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool false
	```

## Filesystem-related

### Rebuilding the Spotlight Index

- System-wide: 
	
	```shell
	sudo mdutil -a -i off
	sudo mdutil -a -i on
	```

- For a specific volume:

	```shell
	sudo mdutil -i off /Volumes/Your Volume Name
	sudo mdutil -i on /Volumes/Your Volume Name
	```

### Checking if the APFS volume snapshots is intact

```shell
diskutil apfs list
```

> [!NOTE]
> 
> If you apply root patches with OCLP, the status of the entry `Snapshot sealed` seal will change from `Yes` to `Broken`. But if you revert the root patches with OCLP *prior* to updating macOS, the seal will become intact again. And if the snapshot is sealed, incremental (or delta) OTA updates are available again so System Update won't download the complete installer!

### Update the PreBoot Volume (APFS volumes only)

```shell
sudo diskutil apfs updatePreboot /
```

### Disable Library Validation

```shell
sudo defaults write /Library/Preferences/com.apple.security.libraryvalidation.plist DisableLibraryValidation -bool true
```

> [!NOTE]
>
> This change is only temporary. Requires a Kernel Patch to make it persistant.

### Rebuild DYLD and XPC caches (macOS 10.15 or older only)

```shell
sudo update_dyld_shared_cache -force
sudo /usr/libexec/xpchelper --rebuild-cache
```

### Create new snapshot (macOS 11+ only)

In Recovery, enter:

```shell
csrutil authenticated-root disable
bless --folder /Volumes/x/System/Library/CoreServices --bootefi --create-snapshot
``` 
**x** = name of your macOS Volume

## Enabling/Disabling Features

### Enable Sidecar

```shell
defaults write com.apple.sidecar.display AllowAllDevices -bool true
defaults write com.apple.sidecar.display hasShownPref -bool true
```

> [!NOTE]
> 
> Requires Intel CPU with on-board graphics and is limited to specific SMBIOSes. It’s easier to enable it via [**FeatureUnlock.kext**](https://github.com/acidanthera/FeatureUnlock)!

### Disable Logging

```shell
sudo rm /System/Library/LaunchDaemons/com.apple.syslogd.plist
```

### Disable/Delete Metal Support

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

### Prohibit macOS from mastering iDevices

```shell
defaults write com.apple.iTunesHelper ignore-devices -bool YES
defaults write com.apple.AMPDeviceDiscoveryAgent ignore-devices 1
defaults write com.apple.AMPDeviceDiscoveryAgent reveal-devices 0
defaults write -g ignore-devices -bool true
```
**Source**: [**Apple-Knowledge**](https://github.com/hack-different/apple-knowledge/blob/main/_docs/USB_Modes.md)

### Change default state of Bluetooth (on/off)

&rarr; Check this [guide](https://mogutan.wordpress.com/2018/07/24/switch-bluetooth-setting-from-command-line-on-macos/) for instructions.

## Networking

### List MAC Addresses of Network Adapters

```shell
networksetup -listallhardwareports
```

### Delete Network .plists

```shell
sudo rm /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist
sudo rm /Library/Preferences/SystemConfiguration/preferences.plist
```

### Disable TPC/IPv6 Protocol

You really should disable IPv6 for security reasons, if you don't need it!

List all Network devices:

```shell
sudo networksetup -listallnetworkservices 
```
Disable IPv6 for the following interfaces:

```shell
sudo networksetup -setv6off Ethernet
sudo networksetup -setv6off Wi-Fi
```
To re-enable:

```shell
sudo networksetup -setv6automatic Wi-Fi
sudo networksetup -setv6automatic Ethernet
```

## CPU-related

### Show CPU Vendor

```shell
sysctl -a | grep machdep.cpu.vendor
```

### Show CPU Model
Doesn't really tell you much

```shell
sysctl -a | grep machdep.cpu.model
```

### Show CPU Brand String

```shell
sysctl machdep.cpu.brand_string
```

### List CPU features

```shell
sysctl -a | grep machdep.cpu.features
```

### Display Bus and CPU Frequency

```shell
sysctl -a | grep freq
```

### List supported CPU instructions

```shell
sysctl -a | grep machdep.cpu.leaf7_features
```

### Get CPU details from IO Registry

```shell
ioreg -rxn "CPU0@0"
```

> [!NOTE]
> 
> Text in quotation marks = CPU name as defined in ACPI. On Intel CPUs it can also be "PR00@0", "P000@0" or "C000@0". Check `SSDT-PLUG`/`SSDT-PM` to find the correct name.

## Troubleshooting

### Show log of last boot

```shell
log show --last boot
```

### Search for terms in last boot log

```shell
log show --last boot | grep "your search term"
```
**Example**: `log show --last boot | grep "ACPI"`

### Check OpenCore version

```shell
nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:opencore-version
```

### Display currently used Board-ID

```shell
ioreg -l | grep -i board-id
```
or

```shell
`var_ID=$(ioreg -p IODeviceTree -r -n / -d 1 | grep board-id);var_ID=${var_ID##*<\"};var_ID=${var_ID%%\">};echo $var_ID`
```

### Checking Reasons for Wake

```shell
pmset -g log | grep -e "Sleep.*due to" -e "Wake.*due to"
```

Alternative Command (searches in syslog instead):

```shell
log show --style syslog | fgrep "Wake reason"
```

### Check currently active `csr-active-config`

```shell
nvram 7C436110-AB2A-4BBB-A880-FE41995C9F82:csr-active-config
```

### Check the status of System Integrity Protection (SIP)

```shell
csrutil status
```

### Install Command Line Developer Tools

```shell
xcode-select --install
```

### Kext-related

#### Find loaded Kexts (excluding those from Apple)

```shell
kextstat | grep -v com.apple
```

#### Rebuild Kext Cache (macOS 11+)

```shell
sudo kextcache -U /
```

#### Rebuild Kext Cache (macOS 10.15 or older)

```shell
sudo kextcache -i /
```

### Check status of Apple Secure Boot

1. In Terminal, enter:</br>
`nvram 94b73556-2197-4702-82a8-3e1337dafbfb:AppleSecureBootPolicy` 
2. Check the Results:
	-  if `%00` = No Security
	-  if `%01` = Medium Security
	-  if `%02` = Full Security

> [!NOTE]
>
> To achieve full securiity `02` additional measures are required.

### Make .command files executable

`chmod +x` (drag file in terminal, hit enter)

### Finding USB Controller Renames

```shell
ioreg -l -p IOService -w0 | grep -i EHC1
ioreg -l -p IOService -w0 | grep -i EHC2
ioreg -l -p IOService -w0 | grep -i XHC1
ioreg -l -p IOService -w0 | grep -i XHCI
```
### Verifying if SMBus is working

```shell
kextstat | grep -E "AppleSMBusController|AppleSMBusPCI"
```

> [!NOTE]
> 
> The search should return two matches: `com.apple.driver.AppleSMBusController` and `com.apple.driver.AppleSMBusPCI`. On modern Laptops, only AppleSMBusController may return in the search results!

### ACPI-related
#### Debug ACPI Tables

```shell
log show --predicate "processID == 0" --start $(date "+%Y-%m-%d") --debug | grep "ACPI"
```

#### List ACPI Errors

```shell
log show --last boot | grep AppleACPIPlatform
log show --last boot | grep AppleACPIPlatform > ~/Desktop/Log_"$(date '+%Y-%m-%d_%H-%M-%S')".log
```

The 2nd Command saves a log on the desktop.
___

## Keyboard Shortcuts

### Collection of Keyboard Shortcuts

[**Mac Keyboard Shortcuts**](https://support.apple.com/en-us/HT201236)

### Show hidden Files and Folders in Finder

<kbd>⌘</kbd><kbd>⇧</kbd><kbd>.</kbd> (Command+Shift+Dot)

### Disable Press and Hold for Keyboard Keys (requires reboot)

```shell
defaults write -g ApplePressAndHoldEnabled -bool false
```

### Accessing Terminal in macOS Setup-Assistant

<kbd>⌘</kbd><kbd>⌥</kbd><kbd>⌃</kbd><kbd>T</kbd> (Command+Option+Control+T)

---
## Linux

### Generate Audio Codec Dump (in Linux)

```shell
cd ~/Desktop && mkdir CodecDump && for c in /proc/asound/card*/codec#*; do f="${c/\/*card/card}"; cat "$c" > CodecDump/${f//\//-}.txt; done && zip -r CodecDump.zip CodecDump
```

### Search for firmware used by devices

```shell
sudo dmesg|grep -i firmware
```
