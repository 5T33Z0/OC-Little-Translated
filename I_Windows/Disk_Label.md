# Changing Windows disk label shown in Bootpicker

## 1. Generating disk label files
- Download the latest [OpenCore Package](https://github.com/acidanthera/OpenCorePkg/releases) and unzip it
- Inside the OpenCore folder you will find `/Utilities/disklabel`
- Run Terminal
- Enter `cd` and hit <kbd>Space</kbd>
- Drag the "disklabel" folder into the terminal window and hit <kbd>Enter</kbd> to change to this directory.
- Next, enter the following command (replace the text in the quotes `""` ):
	```shell
	sudo ./disklabel -e "YOUR DISK LABEL" .disk_label .disk_label_2x
	```
- Hit <kbd>Enter</kbd> again

The disk label files will be stored in the "disklabel" folder but they are hidden.

## 2. Moving the files to the correct location
- In Finder, press <kbd>CMD</kbd><kbd>Shift</kbd><kbd>.</kbd> to reveal hidden files:</br>![disklabel01](https://user-images.githubusercontent.com/76865553/212529706-99c6f186-b527-44e6-bf2f-4ec7aed53609.png)
- Copy `.disk_label` and `.disk_label_x2`
- Mount the EFI containing the "Microsoft" Folder
- Paste/Move the disk label files into the `Microsoft/Boot` folder. It should look like this:</br>![](https://user-images.githubusercontent.com/76865553/174456629-b915ee78-ee62-412a-acd5-d424cbd7b27e.png)
- Press <kbd>CMD</kbd><kbd>Shift</kbd><kbd>.</kbd> again to mask the hidden files.

The disk labels are now in the correct location but to be displayed, the `PickerAttributes` have to be adjusted…

## 3. Adjusting `PickerAttributes`
- Open your config.plist with OCAT
- Go to `Misc/PickerAttributes` and click on "Select" (or just add 2 to the current value)
- Check box "OC_ATTR_USE_DISK_LABEL_FILE":<br>![label05](https://user-images.githubusercontent.com/76865553/174456642-4e42b5e0-3ede-4bbe-9c16-4605b84ba081.png)
- Save the config and reboot
- The new disk label should be applied:</br>![label06](https://user-images.githubusercontent.com/76865553/174456651-2a75695d-1efb-4d0f-8e71-8b9e84c41db7.png)

## Credits
Cobanramo for the [guide](https://www.hackintosh-forum.de/forum/thread/56428-opencore-namen-von-den-booteintr%C3%A4gen-%C3%A4ndern/?postID=748264#post748264)
