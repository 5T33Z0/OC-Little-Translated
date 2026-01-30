# OCAT Tips & Tricks

## About

This section highlights useful additional features of **OpenCore Auxiliary Tools (OCAT)**. If you only need instructions for updating OpenCore, drivers, and kexts, [**follow this guide**](Content/D_Updating_OpenCore/Updating_OC.md) instead.

## Switching between Release and Debug builds

To switch from the RELEASE to the DEBUG version of OpenCore to produce a proper OC bootlog, do the following:

* In OCAT, select **Edit → OpenCore DEBUG** from the menu bar (indicated by a checkmark)
* Navigate to `Misc → Debug`
  * Enable `AppleDebug`
  * Enable `ApplePanic`
  * Set `Misc/Debug/Target` to `67`
* Click **Upgrade OpenCore and kexts**
* In the next dialog:
  * Select **Get OpenCore**
  * Once the files are downloaded, click **Start Sync**
* Save `config.plist` and reboot

To revert back to the RELEASE build:

* Select **Edit → OpenCore DEBUG** again to **disable** it
* Mount your ESP and open `config.plist`
* Navigate to `Misc → Debug`
  * Disable `AppleDebug`
  * Disable `ApplePanic`
  * Set `Misc/Debug/Target` to `0`
* Click **Upgrade OpenCore and kexts**
* Update OpenCore files and drivers
* Save and reboot

## Adding kext URLs to OCAT

OCAT does not contain all the links to kext repos. You can tell if a link to a repo is missing by a grey box in front of a kext. In order to fetch updates for these kexts, you have to add links to the corresponding repos to `KextURL.txt`. You can do this manually from within the app, but it's a bit tedious. So we will edit the text file directly.

**Instructions**

1. Open Finder
2. Press <kbd>CMD</kbd>+<kbd>Shift</kbd>+<kbd>G</kbd>
3. Paste in this path and hit <kbd>Enter</kbd>: 
	```
	~/.config/OCAuxiliaryTools/
	```
4. Open `KextUrl.txt` with TextEdit
5. Add the following entries (examples):
	```text
	AdvancedMap.kext | https://github.com/narcyzzo/AdvancedMap
	AMFIPass.kext | https://github.com/bluppus20/AMFIPass
	IntelMausiEthernet.kext | https://github.com/Mieze/IntelMausiEthernet
	```
6. Save the file

The next time you check for kext updates in OCAT, the color of the squares in front of kexts you added will no longer be grey (not found) but either red (outdated) or green (up to date). [Kexts from the OCLP repo](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts) can't be fetched automatically, so they will remain grey!

## Refreshing the OCAT Database

If you want to reset OCATs preferences and its Database (after an update for example), do the folling:

- In Finder, navigate to your Home folder.
- Press <kbd>CMD</kbd>+<kbd>.</kbd> to show hidden files
- Delete the `.ocat` folder 
- Press <kbd>CMD</kbd>+<kbd>.</kbd> to hide the folders and files again.
- Next, run OCAT
- Fix Database errors downloading the lasted version of OpenCore from the Sync Window:
	- In `Release` mode: select "Latest Version" from the dropdown menu and click on "Get OpenCore"
	- In `Dev` Mode: select either "Get OpenCore" (or import a zip file of the latest build)
- Once the download has finished, the latest files will be integrated into the database so you can continue using OCAT as usual.

## Shortcomings of OCAT
As useful as OCAT is, it has some shortcomings. The ones that come to mind are database issues, downloading drivers from OcBinaryData and copying the hidden files `.contentFlavour` and `.contentVisibility` which were added in OC 0.8.8 into the EFI/OC/Boot folder.

### Fixing "Development/Debug version database does not exist" error

![Err01](https://user-images.githubusercontent.com/76865553/172384859-682df123-eecf-4d1b-8586-df02d99be268.png)

This error occurs when opening a `config.plist` which was created for a different/newer version of OpenCore which is not present in the Database yet. Do the following to get rid of the error:

1. Click on "**Edit**" and select "**Upgrade OpenCore and Kext**" (or click on the symbol).
2. Download the lasted version of OpenCore. Depending on the Mode OCAT is currently running in, the process differs.
	- In `Release` mode: select "Latest Version" from the dropdown menu and click on "Get OpenCore"
	- In `Dev` Mode: select either "Get OpenCore" (or import a zip file of the latest build) 
3. It will download and integrate the latest version of OpenCore into the database
4. Close the Syn Window. The version number displayed in the top left of the main window should have outdated as well:</br>![Err04](https://user-images.githubusercontent.com/76865553/172385405-630062a5-4108-4269-b8bb-d1a7cf8fe6cd.png)

### Integrating Drivers from OcBinaryData

OCAT is currently not fetching drivers from Acidanthers's OcBinaryData repo automatically, so you have add them to the database manually. Usually, this only concerns the HFS+ driver, so it's not really a big deal:

- Go to the [**OcBinaryData**](https://github.com/acidanthera/OcBinaryData/) repo
- Click on "Code", select "Download ZIP" and unpack it
- Place the Drivers here (Press <kbd>CMD</kbd>+<kbd>.</kbd> to show hidden files and folders):
  - `.ocat/Database/EFI/OC/Drivers/` (for the "Release" version)
  - `.ocat/Database/EFI/OC/Drivers/` (for the "Dev" version)
- Press <kbd>CMD</kbd>+<kbd>.</kbd> to hide the folders and files again

### Adding `.contentFlavour` and `.contentVisibility`
- Mount your EFI
- Download OpenCore Package
- Extract it
- Navigate to Downloads/OpenCore-0.9.X-RELEASE/X64/EFI/BOOT
- Press <kbd>CMD</kbd>+<kbd>.</kbd> to show hidden files
- Copy `.contentFlavour` and `.contentVisibility` to EFI/OC/Boot
- Press <kbd>CMD</kbd>+<kbd>.</kbd> to hide the folders and files again

> [!NOTE]
> 
> Refer to OpenCore's Documentation.pdf to find out how to configure these files.

