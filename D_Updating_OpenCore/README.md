# Updating OpenCore and Kexts with OCAT
Currently, the easiest method to keep your OpenCore Files, Config and Kexts up to date is to use a OpenCore Auxiliary Tools (OCAT). OCAT actually merges any changes made to the structure of the config-plist and feature-set, thereby updating it to the latest version, without losing settings. This saves so much time and effort compared to older methods, where you had to do all of this manually. On top of that it updates OpenCore, Drivers and Kexts. So no more additional tools are needed.

## Tools and prerequisites
- Working Internet Connection
- Downlaod and install [**OCAT**](https://github.com/ic005k/QtOpenCoreConfig/releases)

## How-to
### For users updating from OpenCore 0.6.5 or lower
:warning: **ATTENTION**: When updating OpenCore from version ≤ 0.6.5, disabling `Bootstrap` is mandatory prior to updating OpenCore, to avoid issue which otherweise can only be resolved by a CMOS reset:

- Disable `BootProtect` (set it to `None`)
- Reboot
- Reset NVRAM 
- Boot into macOS and then update OpenCore. 

Please refer to the [**OpenCore Post-Install Guide**](https://dortania.github.io/OpenCore-Post-Install/multiboot/bootstrap.html#updating-bootstrap-in-0-6-6) for more details on the matter. I'd suggest to avoid Bootstrap/LauncherOption unless you really need it. For example, if you have Windows and macOS installed on the same disk, like Laptops often do.

### Updating your `config.plist`
1. Run OCAT, check for Updates (Globe Icon)
2. Mount your ESP (seletc Edit > MountESP) or ( M)
3. Open your `config.plist`. If it is outdated, should see some OC Validate warnings (indicated by red warning icon): </br>![OCAT_errors](https://user-images.githubusercontent.com/76865553/138106690-c44543f3-fe82-4369-b07c-02fab777651a.png)
4. Click on the warning symbol to see the errors: </br>![OCAT_errors2](https://user-images.githubusercontent.com/76865553/138106763-c84bfcdc-8813-46bd-9b2d-9537dc631aa2.png)
5. Close the warnings
6. Hit the Save Button (good Old Floppy Disk Icon)
7. The error may be gone, if just some features were missing:</br>
![Save](https://user-images.githubusercontent.com/76865553/138106803-0c118267-2f43-4ad6-802e-27efba7cd313.png)
8. After Saving, the icon should change and the errors should be gone: </br>
![ConfigOK](https://user-images.githubusercontent.com/76865553/138106894-a2a6de27-cc23-4203-85d0-7788e5eac6e2.png)</br>
(Any remaining erors are actually configurattion errors which you need to fix on your own.)
10. You're already done with updating your config. On to updating files…

### Updating OpenCore Files, Drivers, Kexts and Resources
1. Still in OCAT, ckick on the icon which looks like a Recycle symbol:</br> ![Update](https://user-images.githubusercontent.com/76865553/138106950-faeda539-632f-4083-b8cc-fba490428069.png)
2. In the next dialog window, you can see which files will be updated. Green = up to date, Red = outdated. Besides the displayed file version (left = available online, right = currently used), md5 checksums also help you to determine if it's the same file or a different one:</br> ![sync_nu3](https://user-images.githubusercontent.com/76865553/140295064-c9512999-4b47-4acb-bc61-b425cdb2caff.png)
3. Mark the Checkboxes for Kexts you want to update (otherwise they will be ignored) and click on "Online Upgrade Kexts"
4. In the "OpenCore" list, select the OpenCore files, drivers you want to update and click on "Star Sync". The same color coding applies!
5. You will be notified once it's done:</br> ![Done2](https://user-images.githubusercontent.com/76865553/140290803-3298dc72-d6cb-43c5-b65e-2d9b77c52ac5.png)
6. Done – Config OpenCore, Drivers, Kexts and Resources are up to date now.

## NOTES

- The lists shown in the Sync Window are scrollable. Whether or not the scrollbars are visible by default or not, depends on the scrollbar behavior selected in "System Settings" > "General".
- As of now, OCAT will always use the latest OpenCore Build available under https://github.com/acidanthera/OpenCorePkg/actions.
- If Downloading files does not work in your region, select a different Server from "Database" > "Misc" Tab > "Upgrade download proxy setting". For me, `https://ghproxy.com/https://github.com/` works.
