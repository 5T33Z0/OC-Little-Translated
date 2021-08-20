## Terminal Commands

### macOS specific:

**Disable Gatekeeper:**</br>
`sudo spctl --master-disable`

**Update PreBoot Volume**:</br>
`sudo diskutil apfs updatePreboot /`

**Show all Files in Finder**:</br>
`defaults write com.apple.finder AppleShowAllFiles TRUE`</br>
`killall Finder`

**Show User Library in Big Sur**:</br>
`setfile -a v ~/Library`</br>
`chflags nohidden ~/Library`

**Make .command files executable**:</br>
`chmod +x` (drag file in terminal, hit enter)

**Check Hibernation Settings**:</br>
`pmset -g`

**Enable Sidecar**:</br>
`defaults write com.apple.sidecar.display AllowAllDevices -bool true`
`defaults write com.apple.sidecar.display hasShownPref -bool true`

**Disable Logging:**</br>
`sudo rm /System/Library/LaunchDaemons/com.apple.syslogd.plist`

**Disable Metal**:</br>
`sudo defaults write /Library/Preferences/com.apple.CoreDisplay useMetal -boolean no`
`sudo defaults write /Library/Preferences/com.apple.CoreDisplay useIOP -boolean no`
[Source](https://www.tonymacx86.com/threads/high-sierra-graphic-drivers-for-fermi-geforce-gfx-560-ti.234606/page-2#post-1749719)

### Hackintosh specific:

**Debug ACPI Hotpatches**:</br>
`log show --predicate "processID == 0" --start $(date "+%Y-%m-%d") --debug | grep "ACPI"`

**Finding USB Controller Renames**:</br>

`ioreg -l -p IOService -w0 | grep -i XHC1`</br>
`ioreg -l -p IOService -w0 | grep -i EHC1`</br>
`ioreg -l -p IOService -w0 | grep -i EHC2`
