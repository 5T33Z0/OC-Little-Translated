# Changing Windows disk label shown in Bootpicker

## 1. Generating disk label files
- Download the latest [OpenCore Package](https://github.com/acidanthera/OpenCorePkg/releases) and unzip it
- Inside the OpenCore folder will be /Utilities/disklabel
- Run Terminal
- Drag the executable unix file `disklabel` (not the .exe) into the Terminal window and hit "Enter". It should look like this:</br>![label01](https://user-images.githubusercontent.com/76865553/174456603-77257d72-0f36-4130-92a6-aa2b4357d579.png)
- Append the following text to the line: `-e "nameofyourdisk" .disk_label .disk_label_2x`. The complete line should look like this:</br>![label02](https://user-images.githubusercontent.com/76865553/174456611-e35625f2-2e6d-4a23-80c7-c76ff3a6e795.png)
- Hit enter

The disk label files will be stored in your home folder but they are hidden…

## 2. Moving the files to the correct location
- In Finder, got to your Home Folder
- Press `Cmd–Shift–.` to display hidden files. It should look like this:</br>![label03](https://user-images.githubusercontent.com/76865553/174456622-352005ff-07b6-40e6-b602-b09592893e93.png)
- Copy `.disk_label` and `.disk_label_x2`
- Mount the EFI containing the "Microsoft" Folder
- Paste/Move the disk label files into the `Microsoft/Boot` folder. It should look like this:</br>![label04](https://user-images.githubusercontent.com/76865553/174456629-b915ee78-ee62-412a-acd5-d424cbd7b27e.png)
- Press `Cmd–Shift–.` again to mask the hidden files.

The disk labels are now in the correct location but to be displayed, the `PickerAttributes` have to be adjusted…

## 3. Adjusting `PickerAttributes`
- Open your config.plist with OCAT
- Go to `Misc/PickerAttributes` and click on "Select" (or just add 2 to the current value)
- Check box "OC_ATTR_USE_DISK_LABEL_FILE":<br>![label05](https://user-images.githubusercontent.com/76865553/174456642-4e42b5e0-3ede-4bbe-9c16-4605b84ba081.png)
- Save the config and reboot
- The new disk label should be applied:</br>![label06](https://user-images.githubusercontent.com/76865553/174456651-2a75695d-1efb-4d0f-8e71-8b9e84c41db7.png)

## Credits
Cobanramo for the [guide](https://www.hackintosh-forum.de/forum/thread/56428-opencore-namen-von-den-booteintr%C3%A4gen-%C3%A4ndern/?postID=748264#post748264)
