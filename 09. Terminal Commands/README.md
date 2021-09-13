## Terminal Commands

### macOS related

**Collection of defaults commands** (for modifying behavior, options, look and feel of macOS):</br>
`https://macos-defaults.com/`

**Disable Gatekeeper:**</br>
`sudo spctl --master-disable`

**Disable/enable DMG Verification**:</br>
`defaults write com.apple.frameworks.diskimages skip-verify TRUE`</br>
`defaults write com.apple.frameworks.diskimages skip-verify FALSE`</br>

**Add "Quit" option to Finder**:</br>
`defaults write com.apple.finder QuitMenuItem -bool YES`</br>
`killall Finder`</br>

**Show all Files in Finder**:</br>
`defaults write com.apple.finder AppleShowAllFiles TRUE`</br>
`killall Finder`

**Show the User Library in Big Sur**:</br>
`setfile -a v ~/Library`</br>
`chflags nohidden ~/Library`

**Rebuild Launch Services**:</br>
`/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user`

**Enable Sidecar**:</br>
`defaults write com.apple.sidecar.display AllowAllDevices -bool true`</br>
`defaults write com.apple.sidecar.display hasShownPref -bool true`

**Disable Logging:**</br>
`sudo rm /System/Library/LaunchDaemons/com.apple.syslogd.plist`

### Hackintosh specific

**Rebuild Kext Cache**:</br>
`sudo kextcache -i /`</br>

**Update PreBoot Volume**:</br>
`sudo diskutil apfs updatePreboot /`

**Check Status of System Integrity Protection**:</br>
`csrutil status`

**Create a new shapshot** (after changing system files):
`bless --folder /Volumes/x/System/Library/CoreServices --bootefi --create-snapshot` (x = name of your macOS Big Sur/Monterey Volume)

**Check if used Hardware supports Apple Secure Boot**:</br>

1. In Terminal, execute: `nvram 94b73556-2197-4702-82a8-3e1337dafbfb:AppleSecureBootPolicy` 
2. Check the Results:
	-  if `%00` = No Security mode.
	-  if `%01` = Medium Security mode
	-  if `%02` = Full Security mode 

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

[Source](https://github.com/lvs1974/NvidiaGraphicsFixup/releases)

