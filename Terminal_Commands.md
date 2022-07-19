# Terminal Commands

## macOS related

**Collection of defaults commands** (for modifying behavior, options, look and feel of macOS):</br>
**https://macos-defaults.com/**

**List of PMSET Commands**<br>
https://www.dssw.co.uk/reference/pmset.html

- **Example**: `sudo pmset proximitywake 0` &rarr; disables wake based on proximity of other devices using the same iCloud ID (iWatch or similar).

**Show macOS Version and Build Number**</br>
`sw_vers`

**Show macOS Kernel Version**:</br>
`uname -r`

**Disable Gatekeeper:**</br>
`sudo spctl --master-disable`

**Show the User Library in Big Sur+**:</br>

```
setfile -a v ~/Library
chflags nohidden ~/Library`
```
**Disable/enable DMG Verification**:</br>

```
defaults write com.apple.frameworks.diskimages skip-verify TRUE 
defaults write com.apple.frameworks.diskimages skip-verify FALSE
```

**Add "Quit" option to Finder**:</br>
`defaults write com.apple.finder "QuitMenuItem" -bool "true" && killall Finder`

**Add "GPU" Tab to Activity Monitor**:</br>
`defaults write com.apple.ActivityMonitor ShowGPUTab -bool true`

**Disable Library Validation**</br>
`sudo defaults write /Library/Preferences/com.apple.security.libraryvalidation.plist DisableLibraryValidation -bool true`

**List MAC Addresses**</br>
`networksetup -listallhardwareports`

**Show all Files in Finder**:</br>

```
defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder
defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder
```
Alternatively, use a **Key Command**: ⌘⇧. (Command-Shift-Dot)

**Rebuild Launch Services**:</br>
`/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user`

**Rebuild DYLD and XPC caches** (≤ macOS 10.15)

```
sudo update_dyld_shared_cache -force
sudo /usr/libexec/xpchelper --rebuild-cache
```

**Enable Sidecar**:</br>

```
defaults write com.apple.sidecar.display AllowAllDevices -bool true
defaults write com.apple.sidecar.display hasShownPref -bool true
```

**Disable Logging:**</br>
`sudo rm /System/Library/LaunchDaemons/com.apple.syslogd.plist`

**Enable Key Repeating**</br>
`defaults write -g ApplePressAndHoldEnabled -bool false`

## CPU related

**Show CPU Vendor**</br>
`sysctl -a | grep machdep.cpu.vendor`

**Show CPU Model** (doesn't really tell you much)</br> 
`sysctl -a | grep machdep.cpu.model`

**Show CPU Brand String**</br>
`sysctl machdep.cpu.brand_string`

**List CPU features**</br>
`sysctl -a | grep machdep.cpu.features`

**Display Bus and CPU Frequency** </br>
`sysctl -a | grep freq`

**List supported instruction sets** (AVX2 and others):<br>
`sysctl -a | grep machdep.cpu.leaf7_features`

**Get CPU details** from IO Registry:</br>
`ioreg -rxn "CPU0@0"`

**NOTE**: Text in quotation marks = CPU name as defined in ACPI. On Intel CPUs it can also be "PR00@0", "P000@0" or "C000@0". Check `SSDT-PLUG/SSDT-PM` to find the correct name.

## Hackintosh specific
**Checking Reasons for Wake**</br>
`pmset -g log | grep -e "Sleep.*due to" -e "Wake.*due to"`

**Currently used SMBIOS**</br>
`system_profiler SPHardwareDataType | grep 'Model Identifier'`

**Check OpenCore version set in NVRAM**:</br>
`nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:opencore-version`

**Check currently active csr-active-config set in NVRAM**:</br>
`nvram 7C436110-AB2A-4BBB-A880-FE41995C9F82:csr-active-config`

**Find loaded Kexts** (excluding those from Apple)</br>
`kextstat | grep -v com.apple`</br>

**Rebuild Kext Cache**: (Deprecated in macOS 13)</br>
`sudo kextcache -i /`</br>

**Update PreBoot Volume**:</br>
`sudo diskutil apfs updatePreboot /`

**Check Status of System Integrity Protection**:</br>
`csrutil status`

**Show last boot log**:</br>
`log show --last boot`

**Search for terms in last boot log**:</br>
`log show --last boot | grep "your search term"` </br>
Example: `log show --last boot | grep "ACPI"`

**Create new shapshot** (macOS 11+ only) In Recovery, enter:</br>

```
csrutil authenticated-root disable
bless --folder /Volumes/x/System/Library/CoreServices --bootefi --create-snapshot
``` 
**x** = name of your macOS Big Sur/Monterey Volume

**Check if used Hardware supports Apple Secure Boot**:</br>

1. In Terminal, enter:</br>
`nvram 94b73556-2197-4702-82a8-3e1337dafbfb:AppleSecureBootPolicy` 
3. Check the Results:
	-  if `%00` = No Security
	-  if `%01` = Medium Security
	-  if `%02` = Full Security 

**Show currently used Board-ID**:<br>
`ioreg -l | grep -i board-id`

**Check Hibernation Settings**:</br>
`pmset -g`

**Make .command files executable**:</br>
`chmod +x` (drag file in terminal, hit enter)

**Find USB Controller Renames**:</br>

```
ioreg -l -p IOService -w0 | grep -i EHC1
ioreg -l -p IOService -w0 | grep -i EHC2
ioreg -l -p IOService -w0 | grep -i XHC1
ioreg -l -p IOService -w0 | grep -i XHCI
```

**Verifying if SMBus is working**:</br>
`kextstat | grep -E "AppleSMBusController|AppleSMBusPCI"`

**Debug ACPI Hotpatches**:</br>
`log show --predicate "processID == 0" --start $(date "+%Y-%m-%d") --debug | grep "ACPI"`

**Display CPU Features**</br>
`sysctl -a | grep machdep.cpu.features` </br>
`sysctl -a | grep machdep.cpu.leaf7_features` </br>
`sysctl machdep.cpu | grep AVX`

**Disable/Delete Metal Support**:</br>

```
sudo defaults write /Library/Preferences/com.apple.CoreDisplay useMetal -boolean no
sudo defaults write /Library/Preferences/com.apple.CoreDisplay useIOP -boolean no
```
or:

```
sudo defaults delete /Library/Preferences/com.apple.CoreDisplay useMetal
sudo defaults delete /Library/Preferences/com.apple.CoreDisplay useIOP
```
[**Source**](https://github.com/lvs1974/NvidiaGraphicsFixup/releases)

**Change Update Seed to Developer**</br>

```
sudo /System/Library/PrivateFrameworks/Seeding.framework/Resources/seedutil unenroll
sudo /System/Library/PrivateFrameworks/Seeding.framework/Resources/seedutil enroll DeveloperSeed
```

**Removing Network .plists (for troubleshooting**</br>

```
sudo rm /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist
sudo rm /Library/Preferences/SystemConfiguration/preferences.plist
```

**List ACPI Errors**</br>

```
log show --last boot | grep AppleACPIPlatform
log show --last boot | grep AppleACPIPlatform > ~/Desktop/Log_"$(date '+%Y-%m-%d_%H-%M-%S')".log
```
The 2nd Command saves a log on the desktop.

**Dump Audio Codec** (in Linux)</br>
`cd ~/Desktop && mkdir CodecDump && for c in /proc/asound/card*/codec#*; do f="${c/\/*card/card}"; cat "$c" > CodecDump/${f//\//-}.txt; done && zip -r CodecDump.zip CodecDump`
___

# Keyboard Shorcuts

**Show hidden Files and Folders in Finder**: ⌘⇧. (Command-Shift-Dot)
