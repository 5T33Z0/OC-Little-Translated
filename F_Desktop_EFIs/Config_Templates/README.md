# What's this?

So, you've clicked on the "Database" button in OCAT in order to generate a pre-configured OpenCore EFI for your Intel CPU – but all you got was a pop-up with a link redirecting you to my repo?

Well, the developer of OCAT removed direct access to the config templates stored in the database and instead redirected you here, since I am the maintainer of these config files. This makes it easier to keep maintain the config files and keep them up to date.

## Instructions

1. Select a config for your CPU family and click on it
2. On the toolbar of the page, click on the button that says "Download raw file"
3. Open the .plist in OCAT (or drag it into the main window)
4. Go to `PlatformInfo/Generic` and click the `Generate` button (next to the SMBIOS dropdown menu)
5. Select "Edit" > "Create EFI Folder on Desktop",
6. The EFI folder will be populated on your desktop
7. Put the folder on a FAT32 formatted USB flash drive and test it
8. If it doesn't work right away yo have to adjust it as explained in the main article: [**Generating and OpenCore EFI folder with OpenCore Auxiliary Tools**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/F_Desktop_EFIs).



