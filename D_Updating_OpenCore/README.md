# Updating OpenCore and Kexts with OCAT and Kext Updater
Currently, the easiest method to keep your OpenCore Files, Config and Kexts up to date is to use a combination of OpenCore Auxiliary Tools (OCAT) and Kext Updater. OCAT actually merges any changes made to the structure of the config-plist, thereby updating it to the latest version, without losing settings. This saves so much time and effort compared to older methods, where you had to do all of this manually.

## Tools and prerequisites
- Disable System Integrity Protection, reboot and perform NVRAM Reset: 
	- `FF030000` &rarr; for macOS 10.13
	- `FF070000` &rarr; for macOS 10.14/10.15
	- `67080000` &rarr; for macOS 11
	- `EF0F0000` &rarr; for macOS 12
- Working Internet Connection
- Downlaod and install [**OCAT**](https://github.com/ic005k/QtOpenCoreConfig/releases)
- Download and install [**Kext Updater**](https://www.sl-soft.de/en/kext-updater/)

## How-to

### Updating your `config.plist`
1. Run OCAT, check for Updates (Globe Icon)
2. Mount your ESP (seletc Edit > MountESP) or ( M)
3. Open your `config.plist`. If it is outdated, should see some OC Validate warnings (indicated by red warning icon: </br>![](/Users/kl45u5/Desktop/OCAT_errors.png)
4. Click on the warning symbol to see the errors:![](/Users/kl45u5/Desktop/OCAT_errors2.png)
5. Close the warnings
6. Hit the Save Button (good Old Floppy Disk Icon)
7. The error may be gone, if just some features were missing:![](/Users/kl45u5/Desktop/Save.png)
8. After Saving, the icon should change and the errors should be gone: ![](/Users/kl45u5/Desktop/ConfigOK.png) (Any remaining erors, are actually configirattion errors which you need to fix)
9. You're already done with updating your config. On to updating files…

### Updating OpenCore Files, Drivers and Resourcse
1. Still in OCAT, ckick on the icon which looks like a Recycle symbol: ![](/Users/kl45u5/Desktop/Update.png)
2. In the next dialog window, you can see what will be updated: ![](/Users/kl45u5/Desktop/Sync.png)
3. Once you hit the "Start Sync" Button the selected Files (including Resources) will be updatedt and you will be notified once it's done: ![](/Users/kl45u5/Desktop/Done.png)
4. Done. On to updating Kexts…

### Updating Kexts with Kext Updater
1. Run Kext Updater
2. Click on "Check" button to check and download the latest Kexts for your EFI
3. Downloaded kexts will be stored in Desktop > Kext-Updates by default
4. Copy and replace existing `.kext` files in the EFI > OC > Kexts Folder with those downloaded by Kext Updater
5. Done

Congratulation your EFI folder should now be up to date!

**NOTE**: This will only check for update of kexts which are enabled in the config. If you wannt to upate everything, use the "Tools" function and click on "Choose Folder" instead and then perform the check.
