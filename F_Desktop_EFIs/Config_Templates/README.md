# What's this?

So, you've clicked on the "Database" button in OCAT in order to generate a pre-configured OpenCore EFI for your Intel CPU – but all you got was a pop-up with a link redirecting you to my repo?

Well, the developer of OCAT removed direct access to the config templates stored in the database and instead redirected you here, since I am the maintainer of these config files. This makes it easier to keep maintain the config files and keep them up to date.

## Instructions

- Open the "plist" folder (or download the [**Config_Templates.zip**](https://github.com/5T33Z0/OC-Little-Translated/raw/main/F_Desktop_EFIs/Config_Templates/Config_Templates.zip) to save time)
- Select a config for your CPU family and click on it
- On the toolbar above the code, click on the button that says "Download raw file"
- Open the .plist in OCAT (or drag it into the main window)
- Go to `PlatformInfo/Generic` and click the `Generate` button (next to the SMBIOS dropdown menu)
- Select "Edit" > "Create EFI Folder on Desktop"
- [**Further Modify/adjust the config before deplpoyment**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/F_Desktop_EFIs#2-modifying-the-configplist)
