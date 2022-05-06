# Terminal Commands

## macOS related

**Collection of defaults commands** (for modifying behavior, options, look and feel of macOS):</br>
https://macos-defaults.com/

**Show macOS Kernel Version**:</br>
`uname -r`

**Disable Gatekeeper:**</br>
`sudo spctl --master-disable`

**Disable/enable DMG Verification**:</br>
`defaults write com.apple.frameworks.diskimages skip-verify TRUE`</br>
`defaults write com.apple.frameworks.diskimages skip-verify FALSE`</br>

**List MAC Addresses**</br>
`networksetup -listallhardwareports`

**Add "Quit" option to Finder**:</br>
`defaults write com.apple.finder QuitMenuItem -bool YES`</br>
`killall Finder`</br>

**Show all Files in Finder**:</br>
`defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder`</br>
`defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder` (to revert it)

**Show the User Library in Big Sur**:</br>
`setfile -a v ~/Library`</br>
`chflags nohidden ~/Library`

**Rebuild Launch Services**:</br>
`/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user`

**Rebuild DYLD and XPC caches**
```
sudo update_dyld_shared_cache -force
sudo /usr/libexec/xpchelper --rebuild-cache
```

**Enable Sidecar**:</br>
`defaults write com.apple.sidecar.display AllowAllDevices -bool true`</br>
`defaults write com.apple.sidecar.display hasShownPref -bool true`

**Disable Logging:**</br>
`sudo rm /System/Library/LaunchDaemons/com.apple.syslogd.plist`

## Hackintosh specific
**Currently used SMBIOS**</br>
`system_profiler SPHardwareDataType | grep 'Model Identifier'` 

**Find loaded Kexts** (excluding those from Apple)</br>
`kextstat | grep -v com.apple`</br>

**Rebuild Kext Cache**:</br>
`sudo kextcache -i /`</br>

**Update PreBoot Volume**:</br>
`sudo diskutil apfs updatePreboot /`

**Check Status of System Integrity Protection**:</br>
`csrutil status`

**Show last boot log**:</br>
`log show --last boot`

**Search for terms in last boot log**:</br>
`show --last boot | grep` your searchterm

log show --last boot | grep "VRMI"

**Check currently active csr-active-config set in NVRAM**:</br>
`nvram 7C436110-AB2A-4BBB-A880-FE41995C9F82:csr-active-config`

**Create new shapshot** (macOS 11+ only) In Recovery, enter:</br>
`csrutil authenticated-root disable`</br>
`bless --folder /Volumes/x/System/Library/CoreServices --bootefi --create-snapshot` (x = name of your macOS Big Sur/Monterey Volume)

**Check if used Hardware supports Apple Secure Boot**:</br>
1. In Terminal, execute:</br>
`nvram 94b73556-2197-4702-82a8-3e1337dafbfb:AppleSecureBootPolicy` 
3. Check the Results:
	-  if `%00` = No Security mode.
	-  if `%01` = Medium Security mode
	-  if `%02` = Full Security mode 

**Display CPU details**:</br>
`ioreg -rxn "CPU0@0"` (The text in quotes = CPU name as defined in ACPI. On modern Intel it can be "PR00@0". Check `SSDT-PLUG.aml` for reference)

**Show currently used Board-ID**:<br>
`ioreg -l | grep -i board-id`

**Check Hibernation Settings**:</br>
`pmset -g`

**Make .command files executable**:</br>
`chmod +x` (drag file in terminal, hit enter)

**Find USB Controller Renames**:</br>
`ioreg -l -p IOService -w0 | grep -i EHC1`</br>
`ioreg -l -p IOService -w0 | grep -i EHC2`</br>
`ioreg -l -p IOService -w0 | grep -i XHC1`</br>
`ioreg -l -p IOService -w0 | grep -i XHCI`</br>

**Verifying if SMBus is working**:</br>
`kextstat | grep -E "AppleSMBusController|AppleSMBusPCI"`

**Debug ACPI Hotpatches**:</br>
`log show --predicate "processID == 0" --start $(date "+%Y-%m-%d") --debug | grep "ACPI"`

**Display CPU Features**</br>
`sysctl -a | grep machdep.cpu.features` </br>
`sysctl -a | grep machdep.cpu.leaf7_features` </br>
`sysctl machdep.cpu | grep AVX`

**Disable/Delete Metal Support**:</br>
`sudo defaults write /Library/Preferences/com.apple.CoreDisplay useMetal -boolean no`</br>
`sudo defaults write /Library/Preferences/com.apple.CoreDisplay useIOP -boolean no`

or

`sudo defaults delete /Library/Preferences/com.apple.CoreDisplay useMetal`</br>
`sudo defaults delete /Library/Preferences/com.apple.CoreDisplay useIOP`

[**Source**](https://github.com/lvs1974/NvidiaGraphicsFixup/releases)

**Change Update Seed to Developer**</br>
`sudo /System/Library/PrivateFrameworks/Seeding.framework/Resources/seedutil unenroll`</br>
`sudo /System/Library/PrivateFrameworks/Seeding.framework/Resources/seedutil enroll DeveloperSeed`

**Removing Network .plists (for troubleshooting**</br>
`sudo rm /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist`</br>
`sudo rm /Library/Preferences/SystemConfiguration/preferences.plist`</br>

**Listing ACPI Errors**
`log show --last boot | grep AppleACPIPlatform` </br>
`log show --last boot | grep AppleACPIPlatform > ~/Desktop/Log_"$(date '+%Y-%m-%d_%H-%M-%S')".log (creates a Log on Desktop)

**Checking for Wake Reasons**</br>
`pmset -g log | grep -e "Sleep.*due to" -e "Wake.*due to"`

**List of PMSET Commands**<br>
https://www.dssw.co.uk/reference/pmset.html

- **Example**: `sudo pmset proximitywake 0` &rarr; disables wake based on proximity of other devices using the same iCloud ID (iWatch or similar).

**Find aut current Bus and CPU Frequency** </br>
`sysctl -a | grep freq`
