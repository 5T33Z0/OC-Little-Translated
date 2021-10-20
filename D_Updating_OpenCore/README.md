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
3. Open your `config.plist`. If it is outdated, should see some OC Validate warnings (indicated by red warning icon: </br>![OCAT_errors](https://user-images.githubusercontent.com/76865553/138106690-c44543f3-fe82-4369-b07c-02fab777651a.png)
4. Click on the warning symbol to see the errors: </br>![OCAT_errors2](https://user-images.githubusercontent.com/76865553/138106763-c84bfcdc-8813-46bd-9b2d-9537dc631aa2.png)
5. Close the warnings
6. Hit the Save Button (good Old Floppy Disk Icon)
7. The error may be gone, if just some features were missing:</br>
![Save](https://user-images.githubusercontent.com/76865553/138106803-0c118267-2f43-4ad6-802e-27efba7cd313.png)
8. After Saving, the icon should change and the errors should be gone: </br>
![ConfigOK](https://user-images.githubusercontent.com/76865553/138106894-a2a6de27-cc23-4203-85d0-7788e5eac6e2.png)</br>
(Any remaining erors are actually configurattion errors which you need to fix on your own.)
10. You're already done with updating your config. On to updating files…

### Updating OpenCore Files, Drivers and Resourcse
1. Still in OCAT, ckick on the icon which looks like a Recycle symbol: ![Update](https://user-images.githubusercontent.com/76865553/138106950-faeda539-632f-4083-b8cc-fba490428069.png)
2. In the next dialog window, you can see what will be updated: ![Sync](https://user-images.githubusercontent.com/76865553/138107015-958c991d-8176-46ed-9d9f-7f63505b509b.png)
3. Once you hit the "Start Sync" Button the selected Files (including Resources) will be updatedt and you will be notified once it's done:</br> ![Done](https://user-images.githubusercontent.com/76865553/138107072-9af89efb-2543-4f95-ab82-59748cf78306.png)
4. Done. On to updating Kexts…

### Updating Kexts with Kext Updater
1. Run Kext Updater
2. Click on "Check" button to check and download the latest Kexts for your EFI
3. Downloaded kexts will be stored in Desktop > Kext-Updates by default
4. Copy and replace existing `.kext` files in the EFI > OC > Kexts Folder with those downloaded by Kext Updater
5. Done

Congratulations! Your EFI folder should now be up to date!

**NOTE**: This will only check for update of kexts which are enabled in the config. If you wannt to upate everything, use the "Tools" function and click on "Choose Folder" instead and then perform the check.
