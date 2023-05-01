# Fixing issues with external USB webcams

- Affected OS: macOS with support for Apple Mobile File Integrity (Sierra and newer)

## Symptoms
- Webcam is supported by macOS and is working fine in Facetime and/or Photobooth but not in 3rd party apps
- No Audio: You can't get audio from the webcam Mic or Headset
- No Video: Webcam won't turn on in 3rd party conferencing apps like Zoom, Microsoft Teams, Skype, etc. 

## Cause
- Prompts for granting permissions to 3rd party apps don't pop-up if Apple Mobile File Integrity (AMFI) is disabled. 

## Solution
Since disabling AMFI requires System Integrity Protection (SIP) to be disabled in the first place, re-enabling SIP can be a solution. Below you will find 3 different approaches for fixing this issue…

### Method 1: Re-enable SIP (not always possible)

- Change `csr-active-config` to `00000000` to re-enable SIP
- Save your config
- Reboot

Once SIP has been re-enabled, the prompts for granting access to the cam/mic will pop-up immediately once you launch the app requiring access to them. The apps will be listed in the Privacy Settings for Camera and Microphone afterwards.

**Problem**: If you are using legacy hardware which requires booting with SIP and/or AMFI disabled you cannot use this method. So you either have to upgrade macOS from an existing previous install where you already granted these permissions so they are carried over to the new OS or use Method 3 instead.

### Method 2: Grant permissions in Safe Mode (if SIP is disabled)

- Enable `PollAppleHotkeys` (under Misc/Boot)in your config.plist
- Reboot into Safe Mode (in BootPicker, hold Shift and Press Enter)
- Run the App that needs access to the mic/cam
- The system will ask for permissions to access the mic/cam
- Once you grant them, the apps will be listed in Privacy Settings for Camera/Microphone
- Reboot normally
- Webcam and Mic will work

**Problems**: 

- This works fine for Zoom but Microsoft Teams won't run in Safe Mode. There's no GUI so the prompts for granting the app access to the mic/cam are not triggered.
- Only applicable if you can boot into Safe Mode with SIP disabled. If you did apply any Root Patches with OpenCore Legacy Patcher (like re-installing iGPU/GPU drivers), booting in Safe Mode will get stuck since the graphics drivers can't be loaded. In this case you have to resort to Option 3 as well.

### Method 3: Add permissions manually (requires command line skills)

If you can't boot with SIP enabled, you must add permissions to the SQL3 database manually, as explained here: [Unable to grant special permissions to apps](https://dortania.github.io/OpenCore-Legacy-Patcher/ACCEL.html#unable-to-grant-special-permissions-to-apps-ie-camera-access-to-zoom)

## Furter Resources

- **More about tcc**: [What tcc does and doesn't](https://eclecticlight.co/2023/02/10/privacy-what-tcc-does-and-doesnt)
- **More about AMFI**: [AMFI: checking file integrity on your Mac](https://eclecticlight.co/2018/12/29/amfi-checking-file-integrity-on-your-mac/)
- **AMFI in macOS 13**: [How does Ventura check an app's security](https://eclecticlight.co/2023/03/09/how-does-ventura-check-an-apps-security/)
- **Another tool to add permissions**: https://github.com/jacobsalmela/tccutil
