# Updating OpenCore and Kexts with OCAT
Currently, the easiest method to keep your OpenCore Files, Config and Kexts up to date is to use a OpenCore Auxiliary Tools (OCAT). OCAT actually merges any changes made to the structure of the config-plist and feature-set, thereby updating it to the latest version, without losing settings. This saves so much time and effort compared to older methods, where you had to do all of this manually. On top of that it updates OpenCore, Drivers and Kexts. So no more additional tools are needed.

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

## How-to
### Updating your `config.plist`
1. Run OCAT, check for Updates (Globe Icon)
2. Mount your ESP (select Edit > MountESP) or ( M)
3. Open your `config.plist`. If it is outdated, should see some OC Validate warnings (indicated by red warning icon): </br>
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
1. Still in OCAT, click on the Sync button (looks similar to a Recycle symbol):</br> 
	![Sync_Button](https://user-images.githubusercontent.com/76865553/140640906-a3ba1ccd-157d-43a4-af51-12fa4ffbf80d.png)
2. In the next dialog window, you can see which files will be updated. Green = up to date, Red = outdated. Besides the displayed file version (left = available online, right = currently used), md5 checksums also help you to determine if it's the same file or a different one:</br> 
	![Sync_explained](https://user-images.githubusercontent.com/76865553/140642162-fd3ec6e3-b462-4404-9d60-468a102df4b5.png)
3. Mark the Checkboxes for Kexts you want to update (otherwise they will be ignored) and click on "Check Kexts Updaates Online". This will download the latest available kexts. If some kext can't be found, add it's github URL to the Database "Kext Url" section and scan again.
4. Click on "Update" to apply the new Kexts. 
5. In the "OpenCore" list, select the OpenCore files, drivers you want to update and click on "Star Sync". The same color coding applies!
6. You will be notified once it's done:</br>
	![syncdone2](https://user-images.githubusercontent.com/76865553/140641897-c8f26c31-bb4c-47ae-be1f-fa8c1e0163a0.png)
6. Done – Config OpenCore, Drivers, Kexts and Resources are up to date now.

## NOTES

- The lists shown in the Sync Window are scrollable. Whether or not the scrollbars are visible by default or not, depends on the scrollbar behavior selected in "System Settings" > "General".
- As of now, OCAT will always use the latest OpenCore Build available under https://github.com/acidanthera/OpenCorePkg/actions.
- If Downloading files does not work in your region, select a different Server from "Database" > "Misc" Tab > "Upgrade download proxy setting". For me, `https://ghproxy.com/https://github.com/` works.
