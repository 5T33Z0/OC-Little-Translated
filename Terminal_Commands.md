# macOS Terminal Commands

## Essential System Information

### Display macOS Version and Build
```shell
sw_vers
```

### Display Darwin Kernel Version
```shell
uname -r
```

### Display Model Identifier (SMBIOS)
```shell
system_profiler SPHardwareDataType | grep 'Model Identifier'
```

### Show CPU Information
```shell
# CPU Brand
sysctl machdep.cpu.brand_string

# CPU Vendor
sysctl -a | grep machdep.cpu.vendor

# CPU Features
sysctl -a | grep machdep.cpu.features

# Bus and CPU Frequency
sysctl -a | grep freq
```

---

## Critical Troubleshooting

### View System Logs
```shell
# Show log of last boot
log show --last boot

# Search for specific terms in boot log
log show --last boot | grep "your search term"

# Example: Search for ACPI issues
log show --last boot | grep "ACPI"
```

### Check Wake/Sleep Issues
```shell
# Check reasons for wake/sleep
pmset -g log | grep -e "Sleep.*due to" -e "Wake.*due to"

# Alternative (searches syslog)
log show --style syslog | fgrep "Wake reason"

# Check hibernation settings
pmset -g
```

### Delete Error Logs
```shell
sudo rm -rf /Library/Logs/DiagnosticReports/*
```

### Kext Management

```shell
# Find loaded kexts (excluding Apple's)
kextstat | grep -v com.apple

# Rebuild kext cache (macOS 11+)
sudo kextcache -U /

# Rebuild kext cache (macOS 10.15 or older)
sudo kextcache -i /
```

### Fix Application Code Signing Issues
Run line by line:

```shell
xcode-select --install
sudo codesign --force --deep --sign - <drag the app here>
sudo xattr -d -r com.apple.quarantine <drag the app here>
sudo chmod +x <drag the app here>
```

---

## System Security & Permissions

### System Integrity Protection (SIP)
```shell
# Check SIP status
csrutil status

# Check active csr-active-config
nvram 7C436110-AB2A-4BBB-A880-FE41995C9F82:csr-active-config
```

### Apple Secure Boot Status
```shell
nvram 94b73556-2197-4702-82a8-3e1337dafbfb:AppleSecureBootPolicy
```
**Results:**

- `%00` = No Security
- `%01` = Medium Security
- `%02` = Full Security

### Gatekeeper Management
```shell
# Disable Gatekeeper
sudo spctl --master-disable
```

> [!NOTE]
> 
> In macOS Sequoia+, you have to also confirm the changes in System Settings → Gatekeeper → "Allow apps from 'Everywhere'"

### Privacy Settings
```shell
# Reset all privacy settings (brings back permission pop-ups)
tccutil reset All
```

### Disable Library Validation (Temporary)
```shell
sudo defaults write /Library/Preferences/com.apple.security.libraryvalidation.plist DisableLibraryValidation -bool true
```
> [!NOTE]
> 
> Requires a kernel patch to make persistent

---

## Finder & File System

### Show Hidden Files and Folders

**Keyboard Shortcut:** 

<kbd>⌘</kbd><kbd>⇧</kbd><kbd>.</kbd> (Command+Shift+Dot)

**Terminal Commands:**
```shell
# Show all files
defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder

# Hide files again
defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder
```

### Show User Library (macOS 11+)
```shell
setfile -a v ~/Library
chflags nohidden ~/Library
```

### Add "Quit" Option to Finder Menu
```shell
defaults write com.apple.finder "QuitMenuItem" -bool "true" && killall Finder
```

### Disable .DS_Store on Network Storage
```shell
# Disable
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Re-enable
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool false
```

### Rebuild Launch Services
Fixes "Open with…" menu issues:
```shell
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
```

### Rebuild Spotlight Index
```shell
# System-wide
sudo mdutil -a -i off
sudo mdutil -a -i on

# Specific volume
sudo mdutil -i off /Volumes/Your Volume Name
sudo mdutil -i on /Volumes/Your Volume Name
```

---

## APFS & Storage Management

### Check APFS Volume Snapshots
```shell
diskutil apfs list
```
> [!NOTE]
> 
> `Snapshot sealed: Yes` means incremental OTA updates are available

### Update PreBoot Volume
```shell
sudo diskutil apfs updatePreboot /
```

### Create New Snapshot (macOS 11+)
In Recovery, enter:
```shell
csrutil authenticated-root disable
bless --folder /Volumes/x/System/Library/CoreServices --bootefi --create-snapshot
```
**x** = name of your macOS Volume

### Disable DMG Verification
```shell
# Disable
defaults write com.apple.frameworks.diskimages skip-verify TRUE

# Re-enable
defaults write com.apple.frameworks.diskimages skip-verify FALSE
```

---

## Networking

### List Network Adapters and MAC Addresses
```shell
networksetup -listallhardwareports
```

### Disable IPv6 (Recommended for Security)
```shell
# List all network services
sudo networksetup -listallnetworkservices

# Disable IPv6
sudo networksetup -setv6off Ethernet
sudo networksetup -setv6off Wi-Fi

# Re-enable IPv6
sudo networksetup -setv6automatic Wi-Fi
sudo networksetup -setv6automatic Ethernet
```

### Delete Network Configuration
```shell
sudo rm /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist
sudo rm /Library/Preferences/SystemConfiguration/preferences.plist
```

---

## Performance & Power Management

### Power Management Commands
**Reference:** https://www.dssw.co.uk/reference/pmset.html

```shell
# Check hibernation settings
pmset -g

# Disable power management scheduler (fixes high CPU usage for powerd)
sudo pmset schedule cancelall
```

### Rebuild System Caches (macOS 10.15 or older)
```shell
sudo update_dyld_shared_cache -force
sudo /usr/libexec/xpchelper --rebuild-cache
```

---

## User Interface Customization

### Activity Monitor
```shell
# Add "GPU" tab
defaults write com.apple.ActivityMonitor ShowGPUTab -bool true
```

### Keyboard Settings
```shell
# Enable key repeating (disable press and hold)
defaults write -g ApplePressAndHoldEnabled -bool false
```

### Notification Center
```shell
# Disable
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist

# Re-enable
launchctl load -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist
```

### Disable Liquid Glass (macOS Tahoe)
```shell
defaults write -g com.apple.SwiftUI.DisableSolarium -bool YES
```

---

## Hackintosh-Specific Commands

### Check OpenCore Version
```shell
nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:opencore-version
```

### Display Currently Used Board-ID
```shell
ioreg -l | grep -i board-id
```
Or:
```shell
var_ID=$(ioreg -p IODeviceTree -r -n / -d 1 | grep board-id);var_ID=${var_ID##*<\"};var_ID=${var_ID%%\">};echo $var_ID
```

### Find USB Controller Renames
```shell
ioreg -l -p IOService -w0 | grep -i EHC1
ioreg -l -p IOService -w0 | grep -i EHC2
ioreg -l -p IOService -w0 | grep -i XHC1
ioreg -l -p IOService -w0 | grep -i XHCI
```

### Verify SMBus is Working
```shell
kextstat | grep -E "AppleSMBusController|AppleSMBusPCI"
```
> **Note:** Should return `com.apple.driver.AppleSMBusController` and `com.apple.driver.AppleSMBusPCI`

### Get CPU Details from IO Registry
```shell
ioreg -rxn "CPU0@0"
```
> **Note:** CPU name varies (can be "PR00@0", "P000@0", or "C000@0"). Check SSDT-PLUG/SSDT-PM

### ACPI Debugging
```shell
# Debug ACPI tables
log show --predicate "processID == 0" --start $(date "+%Y-%m-%d") --debug | grep "ACPI"

# List ACPI errors
log show --last boot | grep AppleACPIPlatform

# Save ACPI errors to desktop log
log show --last boot | grep AppleACPIPlatform > ~/Desktop/Log_"$(date '+%Y-%m-%d_%H-%M-%S')".log
```

---

## Advanced Features

### Enable Sidecar
```shell
defaults write com.apple.sidecar.display AllowAllDevices -bool true
defaults write com.apple.sidecar.display hasShownPref -bool true
```
> **Note:** Easier to enable via [FeatureUnlock.kext](https://github.com/acidanthera/FeatureUnlock)

### Force AMD GPU for DRM Video
```shell
defaults write com.apple.AppleGVA gvaForceAMDKE -boolean yes
defaults write com.apple.AppleGVA gvaForceAMDAVCEncode -boolean YES
defaults write com.apple.AppleGVA gvaForceAMDAVCDecode -boolean YES
defaults write com.apple.AppleGVA gvaForceAMDHEVCDecode -boolean YES
```

### Disable/Delete Metal Support
```shell
sudo defaults write /Library/Preferences/com.apple.CoreDisplay useMetal -boolean no
sudo defaults write /Library/Preferences/com.apple.CoreDisplay useIOP -boolean no
```
Or delete:
```shell
sudo defaults delete /Library/Preferences/com.apple.CoreDisplay useMetal
sudo defaults delete /Library/Preferences/com.apple.CoreDisplay useIOP
```
**Source:** [NvidiaGraphicsFixup](https://github.com/lvs1974/NvidiaGraphicsFixup/releases)

---

## Special Features & Utilities

### Disable Logging
```shell
sudo rm /System/Library/LaunchDaemons/com.apple.syslogd.plist
```

### Prevent macOS from Managing iDevices
```shell
defaults write com.apple.iTunesHelper ignore-devices -bool YES
defaults write com.apple.AMPDeviceDiscoveryAgent ignore-devices 1
defaults write com.apple.AMPDeviceDiscoveryAgent reveal-devices 0
defaults write -g ignore-devices -bool true
```
**Source:** [Apple-Knowledge](https://github.com/hack-different/apple-knowledge/blob/main/_docs/USB_Modes.md)

### Make .command Files Executable
```shell
chmod +x <drag file here>
```

### Install Command Line Developer Tools
```shell
xcode-select --install
```

---

## Beta & Update Management

### Change Update Seed to Developer (≤ macOS 12)
```shell
# Unenroll from current seed
sudo /System/Library/PrivateFrameworks/Seeding.framework/Resources/seedutil unenroll

# Enroll in developer seed
sudo /System/Library/PrivateFrameworks/Seeding.framework/Resources/seedutil enroll DeveloperSeed
```
> **Note:** In macOS 13+, use [Apple's beta program](https://beta.apple.com/) instead

---

## Useful Keyboard Shortcuts

### Essential Shortcuts
- **Show hidden files in Finder:** <kbd>⌘</kbd><kbd>⇧</kbd><kbd>.</kbd>
- **Access Terminal in Setup Assistant:** <kbd>⌘</kbd><kbd>⌥</kbd><kbd>⌃</kbd><kbd>T</kbd>

### Complete Reference
[Mac Keyboard Shortcuts](https://support.apple.com/en-us/HT201236)

---

## Linux Commands (for Hackintosh Users)

### Generate Audio Codec Dump
```shell
cd ~/Desktop && mkdir CodecDump && for c in /proc/asound/card*/codec#*; do f="${c/\/*card/card}"; cat "$c" > CodecDump/${f//\//-}.txt; done && zip -r CodecDump.zip CodecDump
```

### Search for Firmware Used by Devices
```shell
sudo dmesg|grep -i firmware
```

---

## Quick Reference Links

- **macOS Commands A-Z Index:** https://ss64.com/mac/
- **macOS Defaults Database:** https://macos-defaults.com/
- **PMSET Reference:** https://www.dssw.co.uk/reference/pmset.html
- **Bluetooth Management Guide:** https://mogutan.wordpress.com/2018/07/24/switch-bluetooth-setting-from-command-line-on-macos/
