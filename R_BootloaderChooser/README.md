# Using Clover alongside OpenCore

This guide is for users who want to be able to switch between OpenCore and Clover for various reasons. May it be that they are trying to convert from one Boot Manager to the other or for testing things in one environment without risking to break their working configuration.

This is possible by using [**Bootloader Chooser**](https://github.com/jief666/BootloaderChooser). It's a clover-based pre-bootloader which allows to select the actual Boot Manager you want to use present in your EFI folder structure, namely the "CLOVER" and "OC" folder. It's a pretty handy utility to have stored on a backup USB boot stick to select the Bootloades present on your USB flash drive and internal EFI folder on your SSD/NVMe, as shown in this example:

![20230721_092840_HDR](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/a5972f35-afa1-4dd7-991f-d1eb8904092a)

## Installing
- Download the [**latest release**](https://github.com/jief666/BootloaderChooser/releases) of `BootX64.efi`
- Mount your EFI partition
- Replace the `BootX64.efi` file in `EFI/BOOT`
- Reboot
- Optional: set a Timeout in the `Options` menu, if the menu is skipped
- Select your actual Boot Manager from the list
- Boot into macOS

## Fixing the `BLC.plist`
The BLC configuration file which is generated once Bootloader Chooser is executed for the first time is missing an argument so it cannot be opened with plist editors if you want to adjust things later – so let's fix it.

- Mount your EFI folder again
- Navigate to `EFI/BOOT`
- Open the `BLC.plist` with the TextEdit app
- Add `</plist>` to the last line
- Save the file
- Now it can be opened in by plist editors and you can change settings like the Timeout, etc.: <br> ![bLC](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/1bc35fc0-3390-453d-8d12-73ebcda9fc24)

> [!NOTE]
> 
>  This has been fixed in version 1.4.

## Uninstalling
- Simply replace the `BootX64.efi` file by the one of your preferred Boot Manager
- Delete the `BLC.plist`
