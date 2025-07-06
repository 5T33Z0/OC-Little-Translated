# What's this?

So, you've clicked on the "Database" button in OCAT in order to generate a pre-configured OpenCore EFI for your Intel CPU – but all you got was a pop-up with a link redirecting you to my repo?!

Well, the developer of OCAT removed direct access to the config templates stored in the database and instead redirected you here, since I am the maintainer of these config files. This makes it easier to maintain them and keep them up to date.

## Instructions

- Open the "plist" folder 
- Select a config for your CPU family and click on it (or download the **Config_Templates.zip** to skip a few steps)
- On the toolbar above the code, click on the button that says "Download raw file"
- Open the .plist in OCAT (or drag it into the main window)
- Go to `PlatformInfo/Generic` and click the `Generate` button (next to the SMBIOS dropdown menu)
- Select "Edit" > "Create EFI Folder on Desktop"
- The EFI folder will be populated on the desktop

> [!NOTE]
> 
> Before deployment, you probably have to adjust settings or add more/different Kexts to suit your needs. Please refer to the main article [Generating an OpenCore EFI folder with OCAT](/Content/F_Desktop_EFIs#generating-an-opencore-efi-folder-with-opencore-auxiliary-tools) for further instructions.
