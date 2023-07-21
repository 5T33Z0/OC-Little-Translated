# Using Clover alongside OpenCore

This guide is for users who want to be able to switch between OpenCore and Clover for various reasons. May it be that they are trying to convert from one Boot Manager to the other or for testing things in one environment without risking to break their working configuration.

This is possible by using [**Bootloader Chooser**](https://github.com/jief666/BootloaderChooser). It's a clover-based pre-bootloader which allows to select the actual Boot Manager you want to use present in your EFI folder structure, namely the "CLOVER" and "OC" folder. It's a pretty handy utility to have stored on a backup USB boot stick. 

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
- Now it can be opened in by plist editors and you can change settings like the Timeout, etc.: <br> ![](/Users/stunner/Desktop/bLC.png) 

## Uninstalling
- Simply replace the `BootX64.efi` file by the one of your preferred Boot Manager