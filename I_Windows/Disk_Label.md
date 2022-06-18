# Changing Windows disk label shown in Bootpicker

## 1. Generating disk label files
- Download the latest [OpenCore Package](https://github.com/acidanthera/OpenCorePkg/releases) and unzip it
- Inside the OpenCore folder will be /Utilities/disklabel
- Run Terminal
- Drag the excutable unix file `disklabel` (not the .exe) into the Terminal window and hit "Enter". It should look like this:</br>![](/Users/5t33z0/Desktop/label01.png)
- Append the following text to the line: `-e "nameofyourdisk" .disk_label .disk_label_2x`. The complese line should look like this:</br>![](/Users/5t33z0/Desktop/label02.png)
- Hit enter.

The disk label files will be stored in your home folder but they are hidden…

## 2. Moving the files to the correct location
- In Finder, got to your Home Folder
- Press `Cmd–Shift–.` to display hidden files. It shoul look like this:</br>![](/Users/5t33z0/Desktop/label03.png)
- Copy `.disk_label` and `.disk_label_x2`
- Mount the EFI containing the "Microsoft" Folder
- Paste/Move the disk label files into the `Microsoft/Boot` folder. It should look like this:</br>![](/Users/5t33z0/Desktop/label04.png)
- Press `Cmd–Shift–.` again to mask the hidden files.

The disk labels are now in the correct location but to be displayed, the `PickerAttributes` have to be adjusted…

## 3. Adjusting `PickerAttributes`
- Open your config.plist with OCAT
- Go to `Misc/PickerAttributes` and click on "Select" (or just add 2 to the current value)
- Check box "OC_ATTR_USE_DISK_LABEL_FILE":<br>![](/Users/5t33z0/Desktop/label05.png)
- Save the config and reboot
- The new disk label should be applied:</br>![](/Users/5t33z0/Desktop/label06.png)

## Credits
Cobanramo for the [guide](https://www.hackintosh-forum.de/forum/thread/56428-opencore-namen-von-den-booteintr%C3%A4gen-%C3%A4ndern/?postID=748264#post748264)
