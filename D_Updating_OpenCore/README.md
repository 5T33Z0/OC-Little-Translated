# Updating OpenCore and Kexts with OCAT

![noschemafor](https://user-images.githubusercontent.com/76865553/180214676-455fd9d9-b7eb-4dbf-90c9-cd3225ebe2bc.jpeg)

**TABLE of CONTENTS**

- [About](#about)
- [Tools and prerequisites](#tools-and-prerequisites)
	- [For users updating from OpenCore 0.6.5 or lower](#for-users-updating-from-opencore-065-or-lower)
- [OCAT's Different Modes](#ocats-different-modes)
- [How-to update your `config.plist`](#how-to-update-your-configplist)
- [Updating OpenCore Files, Drivers, Kexts and Resources](#updating-opencore-files-drivers-kexts-and-resources)
	- [Updating Kexts to Nightly Builds](#updating-kexts-to-nightly-builds)
- [Sync Window: Release Mode vs. Dev Mode](#sync-window-release-mode-vs-dev-mode)
	- [Release Mode](#release-mode)
	- [Dev Mode](#dev-mode)
- [Fixing "Development/Debug version database does not exist" error](#fixing-developmentdebug-version-database-does-not-exist-error)
- [Notes](#notes)

## About
Currently, the easiest and fastest method for keeping OpenCore, Drivers, Config and Kexts up to date is to use **OpenCore Auxiliary Tools** (OCAT). This way, you no longer have to work with tools like OCConfigCompare, the sample-config and PropTree to migrate and update your config.plist to the latest version manually, which is a tremendous time saver!

**OCAT** has [**OCValidate**](https://github.com/acidanthera/OpenCorePkg/tree/master/Utilities/ocvalidate#readme) integrated. It checks your config.plist for errors automatically and lists them. Simply pressing the "Save" button will migrate and update the config to the latest version and feature-set – without losing settings. This will also fix all "No schema for…" errors. Any remaining errors will most likely be actual configuration errors you will have to fix yourself.

OCAT also integrates new keys/features added to the config.plist into the GUI automatically – no other Configurator App can do this.

## Tools and prerequisites
- Working Internet Connection
- Download and install [**OCAT**](https://github.com/ic005k/QtOpenCoreConfig/releases)

### For users updating from OpenCore 0.6.5 or lower
:warning: **CAUTION**: When updating OpenCore from version ≤ 0.6.5, disabling `Bootstrap` is mandatory prior to updating OpenCore, to avoid issue which otherwise can only be resolved by a CMOS reset:

- Disable `BootProtect` (set it to `None`)
- Reboot
- Reset NVRAM 
- Boot into macOS and then update OpenCore. 

Please refer to the [**OpenCore Post-Install Guide**](https://dortania.github.io/OpenCore-Post-Install/multiboot/bootstrap.html#updating-bootstrap-in-0-6-6) for more details on the matter. I'd suggest to avoid Bootstrap/LauncherOption unless you really need it. For example, if you have Windows and macOS installed on the same disk, like Laptops often do.

## OCAT's Different Modes
OCAT lets you choose and switch between 4 variants and builds of OpenCore to download, install and update by combining settings in the "Edit" menu:

![EDIT](https://user-images.githubusercontent.com/76865553/155941606-84f4366d-c245-4797-8a77-2dae2f777f9e.png)

The following combinations are possible: 

- **OpenCore Release** (default, no check marks set)
- **OpenCoe DEBUG** ("Debug" option checked)
- **OpenCore DEV** (nightly builds, "Dev" option checked)
- **OpenCore DEV DEBUG** (Debug versions of nightly builds, "Dev" and "Debug" options checked)

If you switch from the default variant of OpenCore to any other, the displayed OC version may drop back to a lower number. That's because the selected variant of OpenCore is not present in the Database yet. In this case you just need to download the latest version from the Sync window. See &rarr; "Fixing 'Development version database does not exist' issue" for details.
 
For Kexts, you can also choose between Release and DEV builds in the Sync window. When "DEV" is checked, Kexts will be updated to the latest builds available on Dortania's build repo. Depending on the selected Mode, the Sync Window looks different.

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

## Updating OpenCore Files, Drivers, Kexts and Resources

To update OpenCore files and Kexts, do the following:

1. Click on the `Sync` button (looks similar to a Recycle symbol):</br>
	![Sync_Button](https://user-images.githubusercontent.com/76865553/140640906-a3ba1ccd-157d-43a4-af51-12fa4ffbf80d.png)
2. In the next dialog window, you can see which files will be updated. Green = up to date, Red = outdated, Gray = link to repo is missing (add it to "Database" > "Kext Update URL"). Besides the displayed version (left = available online, right = currently used), md5 checksums also help you to determine if it's the same file or a different one:</br>![SyncWinel01](https://user-images.githubusercontent.com/76865553/179932059-9820f53d-6666-429b-a447-fb2b60175bca.png)
3. Mark the Checkboxes for Kexts you want to update (otherwise they will be ignored) and click on "Check Kexts Updates Online". This will download the latest available kexts. If some kext can't be found, add it's github URL to the Database "Kext Url" section and scan again.
4. Click on "Update" to apply the new Kexts. 
5. In the "OpenCore" list, select the OpenCore files, drivers you want to update and click on "Star Sync". The same color coding applies!
6. You will be notified once it's done:</br>
	![syncdone2](https://user-images.githubusercontent.com/76865553/140641897-c8f26c31-bb4c-47ae-be1f-fa8c1e0163a0.png)
t. Done – Config OpenCore, Drivers, Kexts and Resources are up to date now.

### Updating Kexts to Nightly Builds
The latest update of OCAT introduced updating Kexts to nightly builds from Dortania's repo as well. This makes updating kexts for macOS Ventura a lot easier:

- In the Sync window, enable the "DEV" option:</br>![kextsdev](https://user-images.githubusercontent.com/76865553/174356473-e35e2625-0286-40d7-94c3-1e4d9ea2179e.png)

## Sync Window: Release Mode vs. Dev Mode
As mentioned previously, the Sync Window looks different depending on the selected mode.

### Release Mode
For the Release version (default), you can choose the Release builds you want to install from a dropdown menu in the Sync Window. Obviously, selecting "Latest Version" will download the latest available Release build after clicking on "Get OpenCore":

![Relmode01](https://user-images.githubusercontent.com/76865553/179932353-b6bc9700-3cf9-4e82-aa7f-5264116230b1.png)

Once the OpenCore Package has been downloaded and integrated into the database, the OC Version displayed in the top left of OCAT's main Window will be updated to reflect the used version!

### Dev Mode
For downloading and syncing the latest **DEV** versions, you have to select `OpenCore DEV` in the "Edit" menu. This results in a slightly different looking Sync window. Here, you can select and change the repository from where to get the files from. If the default repo (Dortania) is not working, add https://github.com/bugprogrammer/HackinPlugins to the "OpenCore development version upgrade source" field and click "Get OpenCore".

![devrepo](https://user-images.githubusercontent.com/76865553/177286293-1fbbf191-3af0-4751-8c84-5c878b58fd51.png)

Alternatively, you can click on "Import" to open a downloaded `.zip` containing OpenCore files (for example the builds listed on [Dortania's Website](https://dortania.github.io/builds/?product=OpenCorePkg&viewall=true))

## Fixing "Development/Debug version database does not exist" error

![Err01](https://user-images.githubusercontent.com/76865553/172384859-682df123-eecf-4d1b-8586-df02d99be268.png)

This error occurs when opening a `config.plist` which was created for a different/newer version of OpenCore which is not present in the Database yet. Do the following to fix it:

1. Open the "Upgrade OpenCore and Kext" Window
2. Download the lasted version of OpenCore. Depending on the Mode OCAT is currently running in, the process differs.
	- In Release mode: select "Latest Version" from the dropdown menu and click on "Get OpenCore"
	- In Dev Mode: select either "Get OpenCore" (or import a zip file of the latest build) 
3. It will download and integrate the latest version of OpenCore into the database
4. Close the Syn Window. The version number displayed in the top left of the main window should have outdated as well:</br>![Err04](https://user-images.githubusercontent.com/76865553/172385405-630062a5-4108-4269-b8bb-d1a7cf8fe6cd.png)

## Notes

- If you are updating from OpenCore ≤ 0.7.2, you need to set UEFI/APFS `MinDate` and `MinVersion` to `-1` if you are using macOS Catalina or older. More Details [here](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A_Config_Tips_and_Tricks#settings-for-mindateminversion) 
- The lists shown in the Sync Window are scrollable. Whether or not the scrollbar is visible or not, depends on the scrollbar behavior selected in "System Settings" > "General".
- If downloading files does not work in your region, select a different Server from "Database" > "Misc" Tab > "Upgrade download proxy setting". For me, `https://ghproxy.com/https://github.com/` works.
