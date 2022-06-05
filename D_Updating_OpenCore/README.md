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
	![Sync Window](https://user-images.githubusercontent.com/76865553/141829918-6118358f-904a-420c-b6b8-eed9b2a4b6d1.png)</br>
**Addendum**: The sync window is object to change during app development. Currently, depending on the OC variant you chose in the "View" menu, the sync dialog window will look different. For the release version, you can select the OpenCore version you want to install from a dropdown menu:</br>
![Sync_release](https://user-images.githubusercontent.com/76865553/155942200-876515cc-02c7-4144-830b-dfe266ad98d2.png)</br>
For Dev versions, you need to add the [link to the repo](https://github.com/bugprogrammer/HackinPlugins) to download the OC files from. Alternatively, you can click on "Import" to open a downloaded .zip containing OpenCore files (for example the builds listed on [Dortania's Website](https://dortania.github.io/builds/?product=OpenCorePkg&viewall=true)):</br>
![NIGHTLY](https://user-images.githubusercontent.com/76865553/155942273-805db986-8743-435a-8665-8714c940af38.png)</br>
3. Mark the Checkboxes for Kexts you want to update (otherwise they will be ignored) and click on "Check Kexts Updates Online". This will download the latest available kexts. If some kext can't be found, add it's github URL to the Database "Kext Url" section and scan again.
4. Click on "Update" to apply the new Kexts. 
5. In the "OpenCore" list, select the OpenCore files, drivers you want to update and click on "Star Sync". The same color coding applies!
6. You will be notified once it's done:</br>
	![syncdone2](https://user-images.githubusercontent.com/76865553/140641897-c8f26c31-bb4c-47ae-be1f-fa8c1e0163a0.png)
6. Done – Config OpenCore, Drivers, Kexts and Resources are up to date now.

## NOTES

- If you are updating from OpenCore ≤ 0.7.2, you need to set UEFI > APFS > `MinDate` and `MinVersion` to `-1` if you are using macOS Catalina or older. More Details [here](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A_Config_Tips_and_Tricks#settings-for-mindateminversion) 
- As of now, OCAT does not support online updates of OpenCore, so you will not get the latest available version. To find out which version of OpenCore and Resources are used, click on the newly added "Source" links in the Sync window.
- The lists shown in the Sync Window are scrollable. Whether or not the scrollbar is visible or not, depends on the scrollbar behavior selected in "System Settings" > "General".
- If Downloading files does not work in your region, select a different Server from "Database" > "Misc" Tab > "Upgrade download proxy setting". For me, `https://ghproxy.com/https://github.com/` works.
