# Updating OpenCore and Kexts with OCAT

**TABLE of CONTENTS**

- [About](#about)
- [Tools and prerequisites](#tools-and-prerequisites)
	- [For users updating from OpenCore 0.6.5 or lower](#for-users-updating-from-opencore-065-or-lower)
- [How-to update your `config.plist`](#how-to-update-your-configplist)
	- [Updating OpenCore Files, Drivers, Kexts and Resources](#updating-opencore-files-drivers-kexts-and-resources)
- [Release Mode vs Dev Mode](#release-mode-vs-dev-mode)
	- [Release Mode](#release-mode)
	- [Dev Mode](#dev-mode)
- [Updating Kexts to Nightly Builds](#updating-kexts-to-nightly-builds)
- [Fixing "Development version database does not exist" issue](#fixing-development-version-database-does-not-exist-issue)
- [NOTES](#notes)

## About
Currently, the easiest method for keeping your OpenCore files, drivers, config and kexts up to date is to use [OpenCore Auxiliary Tools](https://github.com/ic005k/OCAuxiliaryTools) (OCAT). 

OCAT has OCValidate integrated and runs it automatically when opening the config.plist and points to errors. Simply hitting the "save" button will merge any changes present in the config-sample into the config.plist, thereby updating it to the latest version and feature set, which will fix most of the errors already, without losing settings. This saves so much time compared to using OCConfigCompare and ProperTree where you had to do all of this manually.

It also integrates new keys/features added to the config.plist into the GUI automatically – no other Configurator App can do this.

## Tools and prerequisites
- Working Internet Connection
- Download and install [**OCAT**](https://github.com/ic005k/QtOpenCoreConfig/releases)

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

For Kexts, you can also choose between Release and DEV builds in the Sync window. When "DEV" is checked, Kexts will be updated to the latest builds available on Dortania's build repo.

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

## Release Mode vs Dev Mode
OCAT can run in 2 main modes: RELEASE or DEV. Release mode downloads the official release versions of OpenCOre. DEV downloads nightly builds from Dortania's Build Repo. On top of that it can DEBUG versions of both, depending on the settings selected in the "Edit" menu: 

![](https://user-images.githubusercontent.com/76865553/155941606-84f4366d-c245-4797-8a77-2dae2f777f9e.png)

- No checkmark set = Release Version will be downloaded (Default)
- **OpenCore DEV** selected = OpenCore nightlies will be downloaded (Recommended when playing with the latest macOS betas)
- **OpenCore Debug** selected = Downloads the Debug build of either the RELEASE or DEV version (depending on the settings)

### Release Mode
For the release version (default), you can only select the official release builds of OpenCore you want to install from a dropdown menu in the Sync Window. Obviously, selecting "Latest Version" will download the latest available release build after clicking on "Get OpenCore":

![LatestVersn](https://user-images.githubusercontent.com/76865553/179836491-9bc040c3-1d7a-4eb5-bf1a-f1fbda7f9eed.png)

After the OpenCore Package has been downloaded and integrated into the database, the OC Version displayed in the top left of OCAT's main Window will be updated to reflect the used version!

### Dev Mode
The sync window looks different depending on the OpenCore variant you choose in the "View" menu: 

![](https://user-images.githubusercontent.com/76865553/155941606-84f4366d-c245-4797-8a77-2dae2f777f9e.png) 

For downloading and syncing the latest **Dev** versions, you have to change View to `Dev`, which results in a slightly different Sync menu. Here, you can select and change the repository from where to get the files from. If the default repo (Dortania) is not working, add https://github.com/bugprogrammer/HackinPlugins to the "OpenCore development version upgrade source" field and click "Get OpenCore".

![devrepo](https://user-images.githubusercontent.com/76865553/177286293-1fbbf191-3af0-4751-8c84-5c878b58fd51.png)

Alternatively, you can click on "Import" to open a downloaded `.zip` containing OpenCore files (for example the builds listed on [Dortania's Website](https://dortania.github.io/builds/?product=OpenCorePkg&viewall=true))

## Updating Kexts to Nightly Builds
The latest update of OCAT introduced updating Kexts to nightly builds from Dortania's repo as well. This makes updating kexts for macOS Ventura a lot easier:

- In the Sync window, enable the "DEV" option:</br>![kextsdev](https://user-images.githubusercontent.com/76865553/174356473-e35e2625-0286-40d7-94c3-1e4d9ea2179e.png)

## Fixing "Development version database does not exist" issue

![Err01](https://user-images.githubusercontent.com/76865553/172384859-682df123-eecf-4d1b-8586-df02d99be268.png)

This error usually appears when opening a config.plist which was created for a newer dev version of OpenCore. Do the following to fix it:

1. Press "OK" 
2. DON'T save the config!
3. **Option 1**: 
	- Click on "Help > Download Upgrade Packages":</br>![Err02](https://user-images.githubusercontent.com/76865553/172385089-28a836fb-c438-42da-bee8-2d9e7c3b489f.png)</br> This should fix the issue. If the config is even newer, use Option 2
4. **Option 2**:	
	- Download the latest OC release build from [Dortania's Repo](https://dortania.github.io/builds/?product=OpenCorePkg&viewall=true)
	- Open the "Upgrade OpenCore an Kexts" Window
	- Click on "Import"
	- Navigate to the "OpenCore-0.8.X-RELEASE.zip" and open it
	- Ignore the error messages (hit "OK" twice)
5. Close the Syn Window. Now you have the latest available files in the database:</br>![Err04](https://user-images.githubusercontent.com/76865553/172385405-630062a5-4108-4269-b8bb-d1a7cf8fe6cd.png)

## NOTES

- If you are updating from OpenCore ≤ 0.7.2, you need to set UEFI/APFS `MinDate` and `MinVersion` to `-1` if you are using macOS Catalina or older. More Details [here](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A_Config_Tips_and_Tricks#settings-for-mindateminversion) 
- The lists shown in the Sync Window are scrollable. Whether or not the scrollbar is visible or not, depends on the scrollbar behavior selected in "System Settings" > "General".
- If downloading files does not work in your region, select a different Server from "Database" > "Misc" Tab > "Upgrade download proxy setting". For me, `https://ghproxy.com/https://github.com/` works.
