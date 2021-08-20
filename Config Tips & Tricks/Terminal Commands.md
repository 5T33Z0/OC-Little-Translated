## Terminal Commands

### macOS specific

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

**Rebuild Launch Services**:</br>
`/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user`

**Make .command files executable**:</br>
`chmod +x` (drag file in terminal, hit enter)

**Check Hibernation Settings**:</br>
`pmset -g`

**Enable Sidecar**:</br>
`defaults write com.apple.sidecar.display AllowAllDevices -bool true`</br>
`defaults write com.apple.sidecar.display hasShownPref -bool true`

**Disable Logging:**</br>
`sudo rm /System/Library/LaunchDaemons/com.apple.syslogd.plist`

**Disable/Delete Metal Support**:</br>
`sudo defaults write /Library/Preferences/com.apple.CoreDisplay useMetal -boolean no`</br>
`sudo defaults write /Library/Preferences/com.apple.CoreDisplay useIOP -boolean no`

or

`sudo defaults delete /Library/Preferences/com.apple.CoreDisplay useMetal`</br>
`sudo defaults delete /Library/Preferences/com.apple.CoreDisplay useIOP`

[Source](https://github.com/lvs1974/NvidiaGraphicsFixup/releases)

### Hackintosh specific

**Debug ACPI Hotpatches**:</br>
`log show --predicate "processID == 0" --start $(date "+%Y-%m-%d") --debug | grep "ACPI"`

**Finding USB Controller Renames**:</br>

`ioreg -l -p IOService -w0 | grep -i XHC1`</br>
`ioreg -l -p IOService -w0 | grep -i EHC1`</br>
`ioreg -l -p IOService -w0 | grep -i EHC2`
