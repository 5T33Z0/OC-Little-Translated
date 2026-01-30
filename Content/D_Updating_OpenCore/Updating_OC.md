# Updating OpenCore and Kexts with OpenCore Auxiliary Tools (OCAT)

|![noschemafor](https://user-images.githubusercontent.com/76865553/180214676-455fd9d9-b7eb-4dbf-90c9-cd3225ebe2bc.jpeg)<br>_Say good bye to OpenCore config errors like these!_
|:--------------|

## About

Currently, the easiest and fastest method for keeping OpenCore, Drivers, Config and Kexts up to date is to use **OpenCore Auxiliary Tools** (OCAT). This way, you no longer have to work with tools like OCConfigCompare, the sample-config and PropTree to migrate and update your config.plist to the latest version manually, which is a tremendous time saver! Now upgrading the config literally seconds, instead of half an hour when updating manually.

**OCAT** has [**OCValidate**](https://github.com/acidanthera/OpenCorePkg/tree/master/Utilities/ocvalidate#readme) integrated. It checks your config.plist for syntactical and semantic consistency automatically and lists formal errors. Simply pressing the "Save" button will migrate and update the config to the latest version and feature-set – without losing settings. This will also fix all "No schema for…" errors. Any remaining errors will most likely be actual configuration errors which you will have to on your own using the OpenCore Install Guide, for example. 

For Quirks, OCAT also provides dropdown menus which include sets of recommended Quirks for various Intel and AMD CPU families. Selecting a preset will highlight the recommended Quirks in ***bold italics*** – you still have to enable them on your own.

Unlike other Configurator apps, OCAT is able to integrates new/unknown keys/features added to the config.plist into the GUI automatically and verifies it afterwards. This way, OCAT is much more future proof and secure than the rest of them.

## 1. Tools and Prerequisites

- Working Internet Connection
- Download and install [**OCAT**](https://github.com/ic005k/QtOpenCoreConfig/releases)

> [!CAUTION]
> 
> Keep a backup of your working EFI folder on a FAT32 formatted USB flash drive in case something goes wrong, so you can boot your system via USB!

### For users updating from OpenCore 0.6.5 or lower

:warning: When updating OpenCore from version ≤ 0.6.5, disabling `BootProtect` is mandatory prior to updating OpenCore, to avoid issue which otherwise can only be resolved by a CMOS reset. If you don't use `BootProtect` you can skip this part:

- Change `Misc/Security/BootProtect` to `None`
- Enable `Misc/Security/AllowNvramReset`
- Reboot
- Reset NVRAM from the BootPicker
- Boot into macOS 
- Update OpenCore, Config, Drivers and Kexts
- Delete the `Bootstrap` folder
- Set `Misc/Boot/LauncherOption` as needed (Refer to the [**Updating Bootstrap**](https://dortania.github.io/OpenCore-Post-Install/multiboot/bootstrap.html#updating-bootstrap-in-0-6-6) and Configuration.pdf for more details)

> [!TIP]
>
> - When updating from a very low version of OpenCore to the newest, it's wise to rebuild the config based on the latest Sample.plist. You could open both files in 2 ProperTree windows and copy over the existing settings (ACPI, Quirks, Device Properties, etc.).
> - Avoid Bootstrap/LauncherOption unless you _really_ need it. For example, if you have Windows and macOS installed on the same disk, as Laptops often do.

## 2. Pick an OpenCore variant

OCAT lets you choose and switch between 4 variants of OpenCore builds to update by combining settings in the "**Edit**" menu:

![EDIT](https://user-images.githubusercontent.com/76865553/155941606-84f4366d-c245-4797-8a77-2dae2f777f9e.png)

The following 4 combinations are possible: 

- **No check marks set** &rarr; Downloads the current official "Release" build of OpenCore (Default)
- **OpenCoe DEBUG** selected &rarr; Downloads the current "Debug" build
- **OpenCore DEV** selected &rarr; Downloads the latest nightly "Release" build
- **OpenCore DEBUG + OpenCore DEV** selected &rarr; Downloads the latest nightly "Debug" build.

For Kexts, you can also choose between `Release` and `DEV` builds in the Sync window. When "DEV" is checked, Kexts will be updated to the latest builds available on Dortania's build repo. Depending on the selected Mode, the Sync Window looks different.

## 3. Updating the database
Initially, OpenCore Auxiliary Tools won't include the latest OpenCore files. In order to get them, do the following:

1. Press "Upgrade OpenCore an Kexts" <br>![uppgrade](https://github.com/user-attachments/assets/4ef9ac96-b37c-499a-b5f4-38ecf32d13d5)
2. Click the "Get the latest version of OpenCore" Button: <br>![release](https://github.com/user-attachments/assets/e3d6bef2-caaa-4c01-8cac-16771340750b)
3. Once the download is complete, the displayed OC version will change in order to reflect the OpenCore version present in your database:<br>![main01](https://github.com/user-attachments/assets/9af27512-9735-41fc-95f2-96f49938aaa6)

> [!NOTE]
> 
> - When "OpenCore DEV" is selected, the Sync Window will hace a slightly different layout. In this case, you have to click on the "Get OpenCore" button:<br>![SyncDev](https://github.com/user-attachments/assets/3991bb2d-b51b-4c62-8caf-5031ae8a1484)

## 4. Updating/migrating the `config.plist`

1. Run OCAT, check for Updates (Help > Update Check)
2. Mount your ESP (select Edit > MountESP) or (⌘+M)
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

> [!NOTE]
> 
> Any remaining errors after saving the config.plist are most likely *actual configuration errors* which you need to fix – OC Validate might provide hints to do so. Otherwise refer to the OpenCore Installation Guide by Dortania.

## 5. Updating OpenCore Files, Drivers, Kexts and Resources

To update OpenCore files and Kexts, do the following:

1. Click on the `Sync` button (looks similar to a Recycle symbol):</br>![Sync_Button](https://user-images.githubusercontent.com/76865553/140640906-a3ba1ccd-157d-43a4-af51-12fa4ffbf80d.png)
2. In the next dialog window, you can see which files will be updated. Green = up to date, Red = outdated, Gray = link to repo is missing (add it to "Database" > "Kext Update URL"). Besides the displayed version (left = available online, right = currently used), md5 checksums also help you to determine if it's the same file or a different one:</br>![SyncWinel01](https://user-images.githubusercontent.com/76865553/179932059-9820f53d-6666-429b-a447-fb2b60175bca.png)
3. Mark the Checkboxes for Kexts you want to update (otherwise they will be ignored) and click on "Check Kexts Updates Online". This will download the latest available kexts. If some kext can't be found, add it's github URL to the Database "Kext Url" section and scan again.
4. Click on "Update" to apply the new Kexts. 
5. In the "OpenCore" list, select the OpenCore files, drivers you want to update and click on "Star Sync". The same color coding applies!
6. You will be notified once it's done:</br>![syncdone2](https://user-images.githubusercontent.com/76865553/140641897-c8f26c31-bb4c-47ae-be1f-fa8c1e0163a0.png)

Config OpenCore, Drivers, Kexts and Resources are up to date now. The next time you reboot the updated files will be used.

### Updating Kexts to Nightly Builds

The latest update of OCAT introduced updating Kexts to nightly builds from Dortania's repo as well. This makes updating kexts for macOS Ventura a lot easier. In the Sync window, enable the "DEV" option:

![kextsdev](https://user-images.githubusercontent.com/76865553/174356473-e35e2625-0286-40d7-94c3-1e4d9ea2179e.png)

## 6. The Sync Window: Release Mode vs. Dev Mode

As mentioned previously, the Sync Window looks different depending on the selected mode.

### Release Mode
For the Release version (default), you can choose the Release builds you want to install from a dropdown menu in the Sync Window. Obviously, selecting "Latest Version" will download the latest available Release build after clicking on "Get OpenCore":

![Relmode01](https://user-images.githubusercontent.com/76865553/179932353-b6bc9700-3cf9-4e82-aa7f-5264116230b1.png)

Once the OpenCore Package has been downloaded and integrated into the database, the OC Version displayed in the top left of OCAT's main Window will be updated to reflect the used version!

### Dev Mode
For downloading and syncing the latest **DEV** versions, you have to select `OpenCore DEV` in the "Edit" menu. This results in a slightly different looking Sync window. Here, you can select and change the repository from where to get the files from. If the default repo (Dortania) is not working, add https://github.com/bugprogrammer/HackinPlugins to the "OpenCore development version upgrade source" field and click "Get OpenCore".

![OC_DevMode](https://github.com/user-attachments/assets/6bf4c801-2beb-481f-ba21-fa516b28d077)

Alternatively, you can click on "Import" to open a downloaded `.zip` containing OpenCore files (for example the builds listed on [Dortania's Website](https://dortania.github.io/builds/?product=OpenCorePkg&viewall=true))

## Thoughts on updating OpenCore with OCAT vs. updating it manually

Updating and maintaining OpenCore with OCAT is remarkably straightforward. If you haven't experienced it yet, give it a try, and you'll quickly see how much easier it is. When comparing OCAT to the manual update process [outlined](https://dortania.github.io/OpenCore-Post-Install/universal/update.html#updating-opencore) by Dortania, the difference is clear. The manual method requires multiple tools, is time-consuming and doesn't align with OpenCore’s cutting-edge nature. OpenCore is a modern, innovative Boot Manager that continues to push technological boundaries, yet the traditional method for updating it involves several disconnected tools, creating an unnecessary challenge for users.

It’s exciting to see tools like [**OCAT**](https://github.com/ic005k/QtOpenCoreConfig) making OpenCore updates seamless and user-friendly. Even [**HackUpdate**](https://github.com/corpnewt/HackUpdate) is moving in the right direction, though there's still room for improvement. Until something better comes along, OCAT stands out as a practical solution that simplifies what could otherwise be a tedious process.

> [!TIP]
> 
> With OCAT you can switch back and forth between the RELEASE and DEBUG version easily. Check the [OCAT Tips & Tricks](/Content/D_Updating_OpenCore/OCAT_Bonus.md) section for more details.

## NOTES
- When setting-up your config for the very first time, you should create an OC Snapshot with [ProperTree](https://github.com/corpnewt/ProperTree) prior to deployment. Because it does a better job of detecting kext dependencies and organizing nested kexts which can prevent possible boot errors later.
- If you are updating from OpenCore ≤ 0.7.2, you need to set UEFI/APFS `MinDate` and `MinVersion` to `-1` if you are running macOS Catalina or older. More Details [here](/Content/A_Config_Tips_and_Tricks#mindateminversion-settings-for-the-apfs-driver) 
- The lists shown in the „Sync“"” Window are scrollable. Whether or not the scrollbar is visible or not, depends on the scrollbar behavior selected in "System Settings" > "General".
- If downloading files does not work in your region, select a different Server from "Database" > "Misc" Tab > "Upgrade download proxy setting".
- A nice touch when updating kexts is that OCAT writes the version number of a kext into the comments section so you don't have keep track of it.
