# Fixing issues with peripherals

- **Affected OS**: macOS with support for Apple Mobile File Integrity (Sierra and newer).

## Affected devices and Syptoms
- **Webcams**:
	- Webcam is supported by macOS and is working fine in Facetime and/or Photobooth but not in 3rd party apps
	- No Audio: You can't get audio from the webcam Mic or Headset
	- No Video: Webcam won't turn on in 3rd party conferencing apps like Zoom, Microsoft Teams, Skype, etc. 
- **Wireless Mice**:
	- Pairing Logitech Wireless Mice via Logitech Unifying Software might not be possible. If the mouse can also be paired via BT, then it's not an issue.

## Cause
- Prompts for granting permissions to 3rd party apps don't pop-up if Apple Mobile File Integrity (AMFI) is disabled. 

## Solutions
Since disabling AMFI requires System Integrity Protection (SIP) to be disabled in the first place, re-enabling SIP can be a solution. Below you will find 4 different solutions for fixing this issue…

### Solution 0: Add `AMFIPass.kext` (best)
The beta version of OpenCore Legacy patcher 0.6.7 introduced a new Kext called `AMFIPass` which allows booting macOS with SIP disabled and AMFI enabled even if root patches have been applied – which would be impossible otherwise. Since this kext is not publicly available yet, you have to extract it from OCLP itself which  it's a bit of a pita because the file will be located in temporary folder with a dynamic path once the app is started.

#### Extracting AMFIPass from OpenCore Patcher
1. Download and unzip [**OCLP 0.6.7 beta**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases/tag/amfipass-beta-test)
2. Download and unzip [**AMFIPass-v1.2.1-Extract.zip**](https://github.com/5T33Z0/OC-Little-Translated/files/11611061/AMFIPass-v1.2.1-Extract.zip)
3. Right-click the OpenCore-Patcher app to bring up the context menu
4. Hold <kbd>Alt</kbd> to show additional options. This changes the option "Copy" to "Copy as path"
5. Select "Copy OpenCore-Patcher as path name" (or similar)
6. Now run AMFIPass-v1.2.1-Extract
7. Press <kbd>CMD</kbd>+<kbd>V</kbd> to paste in the path to the OpenCore-Patcher.app and hit <kbd>Enter</kbd>.
8. Once the extraction is done, `AMFIPass-v1.2.1-RELEASE.zip` will be available on your desktop  

#### Add AMFIPass to your EFI and Config:
- Mount your EFI
- Add the kext to `EFI/OC/Kexts` 
- Open your config.plist
- Add the kext to Kernel/Add manually or create a new OC Snapshot in ProperTree
- **Optional**: Adjust `MinKernel` to the kernel version which would require AMFI to be disabled in order to boot. For example: `20.0.0` for Big Sur, `21.0.0` for Monterey, `22.0.0` for Ventura, etc.
- Delete boot-arg `amfi_get_out_of_my_way=0x1` or `AMFI=0x80` (if present)
- Save your config and reboot

**Voilà**: Now, you can boot with AMFI enabled and grant 3rd party apps access to Mics and Cameras again!

> **Note**: 
> <ul><li> You will still need `AMFI=0x80` before re-applying root patches after installing system updates
> <li> Once AMFIPass is released on it's own repo, this laborious process will no longer be required.

### Solution 1: Re-enable SIP (not always possible)

- Change `csr-active-config` to `00000000` to re-enable SIP
- Save your config
- Reboot

Once SIP has been re-enabled, the prompts for granting access to the cam/mic will pop-up immediately once you launch the app requiring access to them. The apps will be listed in the Privacy Settings for Camera and Microphone afterwards.

**Problem**: If you are using legacy hardware which requires booting with SIP and/or AMFI disabled you cannot use this method. So you either have to upgrade macOS from an existing previous install where you already granted these permissions so they are carried over to the new OS or use Method 3 instead.

### Solution 2: Grant permissions in Safe Mode (if SIP is disabled)

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

### Solution 3: Add permissions manually (requires command line skills)

If you can't boot with SIP enabled, you must add permissions to the SQL3 database manually, as explained here: [Unable to grant special permissions to apps](https://dortania.github.io/OpenCore-Legacy-Patcher/ACCEL.html#unable-to-grant-special-permissions-to-apps-ie-camera-access-to-zoom)

> **Note** This guide is applicable to *any* 3rd party app which requires access to the microphone and/or camera – Digital Audio Workstations and Video Editing Software included!

## Furter Resources

- **More about TCC**: [What TCC does and doesn't](https://eclecticlight.co/2023/02/10/privacy-what-tcc-does-and-doesnt)
- **More about AMFI**: [AMFI: checking file integrity on your Mac](https://eclecticlight.co/2018/12/29/amfi-checking-file-integrity-on-your-mac/)
- **AMFI in macOS 13**: [How does Ventura check an app's security](https://eclecticlight.co/2023/03/09/how-does-ventura-check-an-apps-security/)
- **Another tool to add permissions**: https://github.com/jacobsalmela/tccutil
