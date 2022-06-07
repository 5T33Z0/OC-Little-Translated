# Updating OpenCore and Kexts with OCAT
Currently, the easiest method to keep your OpenCore files, drivers, config and kexts up to date is to use a OpenCore Auxiliary Tools (OCAT). OCAT actually merges any changes made to the structure of the config-plist and feature-set, thereby updating it to the latest version, without losing settings. This saves so much time compared to older method, where you had to do all of this manually. 

## Tools and prerequisites
- Working Internet Connection
- Downlaod and install [**OCAT**](https://github.com/ic005k/QtOpenCoreConfig/releases)

### For users updating from OpenCore 0.6.5 or lower
:warning: **ATTENTION**: When updating OpenCore from version ≤ 0.6.5, disabling `Bootstrap` is mandatory prior to updating OpenCore, to avoid issue which otherwise can only be resolved by a CMOS reset:

- Disable `BootProtect` (set it to `None`)
- Reboot
- Reset NVRAM 
- Boot into macOS and then update OpenCore. 

Please refer to the [**OpenCore Post-Install Guide**](https://dortania.github.io/OpenCore-Post-Install/multiboot/bootstrap.html#updating-bootstrap-in-0-6-6) for more details on the matter. I'd suggest to avoid Bootstrap/LauncherOption unless you really need it. For example, if you have Windows and macOS installed on the same disk, like Laptops often do.

## How-to update your `config.plist`
1. Run OCAT, check for Updates (Globe Icon)
2. Mount your ESP (select Edit > MountESP) or (⌘+M)
3. Highlight your `config.plist` and create a duplicate as a backup (⌘+D)
4. Open your `config.plist`. If it is outdated, should see some OC Validate warnings (indicated by red warning icon): </br>
	![Warning](https://user-images.githubusercontent.com/76865553/140640760-8cafb9bd-3b4a-4681-8471-47443dd49c6e.png)
4. Click on the warning symbol to see the errors: </br>
	![Warning_details](https://user-images.githubusercontent.com/76865553/140640767-5e6de7f0-2309-42cf-9b42-099ddb3296d5.png)
5. Close the warnings
6. Hit the Save Button (good old :floppy_disk:):</br>
	![Save1](https://user-images.githubusercontent.com/76865553/140640826-b6de2593-7cf7-4f6d-a295-9fbeb8337aca.png)
7. After Saving, the icon should change and the errors should be gone: </br>
	![Save_ok](https://user-images.githubusercontent.com/76865553/140640868-b76f0ca8-496f-42cb-9cb4-737ce03bca1a.png)
8. You're already done with updating your config. On to updating files…

**NOTE**: Remaining errors after saving the config.plist are most likely actual configuration errors which you need to fix on your own. OC Validate might provide hints to do so. Otherwise refer to the OpenCore Installation Guide by Dortania.

### Updating OpenCore Files, Drivers, Kexts and Resources
In newer versions of OCAT, you can choose 4 variants and builds of OpenCore to install and update by combining settings in the "Edit" menu:

![EDIT](https://user-images.githubusercontent.com/76865553/155941606-84f4366d-c245-4797-8a77-2dae2f777f9e.png)

The following combinations are possible: 

- OpenCore Release (default, no check mark set)
- OpenCoe DEBUG
- OpenCore DEV (nightly builds)
- OpenCore DEV DEBUG (Debug versions of nightly builds)

To update OpenCore files and Kexts, do the following:

1. Click on the `Sync` button (looks similar to a Recycle symbol):</br>
	![Sync_Button](https://user-images.githubusercontent.com/76865553/140640906-a3ba1ccd-157d-43a4-af51-12fa4ffbf80d.png)
2. In the next dialog window, you can see which files will be updated. Green = up to date, Red = outdated, Gray = link to repo is missing (add it to "Database" > "Kext Update URL"). Besides the displayed version (left = available online, right = currently used), md5 checksums also help you to determine if it's the same file or a different one:</br> 
	![Sync Window](https://user-images.githubusercontent.com/76865553/141829918-6118358f-904a-420c-b6b8-eed9b2a4b6d1.png)
3. Mark the Checkboxes for Kexts you want to update (otherwise they will be ignored) and click on "Check Kexts Updates Online". This will download the latest available kexts. If some kext can't be found, add it's github URL to the Database "Kext Url" section and scan again.
4. Click on "Update" to apply the new Kexts. 
5. In the "OpenCore" list, select the OpenCore files, drivers you want to update and click on "Star Sync". The same color coding applies!
6. You will be notified once it's done:</br>
	![syncdone2](https://user-images.githubusercontent.com/76865553/140641897-c8f26c31-bb4c-47ae-be1f-fa8c1e0163a0.png)
t. Done – Config OpenCore, Drivers, Kexts and Resources are up to date now.

### Release builds vs Dev builds
The sync window looks different depending on the OpenCore variant you choose in the "View" menu: 

![](https://user-images.githubusercontent.com/76865553/155941606-84f4366d-c245-4797-8a77-2dae2f777f9e.png) 

For the release version (default), you can only select Release Versions of OpenCore version you want to install from a dropdown menu:

![Sync_release](https://user-images.githubusercontent.com/76865553/155942200-876515cc-02c7-4144-830b-dfe266ad98d2.png)

For downloading and syncing the latest **Dev** versions, you have to change View to `Dev` and add https://github.com/bugprogrammer/HackinPlugins to the "OpenCore development version upgrade source" field and click "Get OpenCore":

![NIGHTLY](https://user-images.githubusercontent.com/76865553/155942273-805db986-8743-435a-8665-8714c940af38.png)

Alternatively, you can click on "Import" to open a downloaded .zip containing OpenCore files (for example the builds listed on [Dortania's Website](https://dortania.github.io/builds/?product=OpenCorePkg&viewall=true))

## Fixing "Development version database does not exist" issue

![Err01](https://user-images.githubusercontent.com/76865553/172384859-682df123-eecf-4d1b-8586-df02d99be268.png)

This error usually appears when opening a config.plist which was created for a newer dev version of OpenCore. Do the following to fix it:

1. Press "OK" 
2. DON'T save the config!
3. **Option 1**: 
	- Click on "Help > Download Upgrade Packages":</br>![Err02](https://user-images.githubusercontent.com/76865553/172385089-28a836fb-c438-42da-bee8-2d9e7c3b489f.png)</br> This should fix the issue. If the config is even newer, use Option 2
4. **Option 2**:	
	- Download the latest OC release build from [Dortanias Repo](https://dortania.github.io/builds/?product=OpenCorePkg&viewall=true)
	- Open the "Upgrade OpenCore an Kexts" Window
	- Click on "Import"
	- Navigate to the "OpenCore-0.8.X-RELEASE.zip" and open it
	- Ignore the error messages (hit "OK" twice)
5. Close the Syn Window. Now you have the latest avaialble files in the database:</br>![Err04](https://user-images.githubusercontent.com/76865553/172385405-630062a5-4108-4269-b8bb-d1a7cf8fe6cd.png)

## NOTES

- If you are updating from OpenCore ≤ 0.7.2, you need to set UEFI > APFS > `MinDate` and `MinVersion` to `-1` if you are using macOS Catalina or older. More Details [here](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A_Config_Tips_and_Tricks#settings-for-mindateminversion) 
- The lists shown in the Sync Window are scrollable. Whether or not the scrollbar is visible or not, depends on the scrollbar behavior selected in "System Settings" > "General".
- If downloading files does not work in your region, select a different Server from "Database" > "Misc" Tab > "Upgrade download proxy setting". For me, `https://ghproxy.com/https://github.com/` works.
