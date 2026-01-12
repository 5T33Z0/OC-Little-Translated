# Method 1: Mapping USB Ports with Tools

This method uses tools to create a codeless kext containing an info.plist with the desired USB port mapping which is injected into macOS during boot.

> [!CAUTION]
>
> If your desktop mainboard has an LED-controller for driving RGB fans mapped via USB, you should disable these ports in macOS. There have been reports that these ports can cause shutdown/reboot issues under macOS, especially on ASRock boards ([A520m](https://github.com/5T33Z0/OC-Little-Translated/issues/121) and [B550M](https://www.reddit.com/r/hackintosh/comments/1flewc3/reboot_and_shutdown_problem_on_asrock_boards_with/) chipsets).

## Option 1: Mapping USB ports in Microsoft Windows (recommended)

- Boot into Windows from the BIOS boot menu (to bypass injections from OpenCore)
- Download the Windows version of [**USBToolBox**](https://github.com/USBToolBox/tool/releases)
- Run it and follow the [**instructions**](https://github.com/USBToolBox/tool#usage) to map your USB ports
- Export the `UTBMap.kext`
- Reboot into macOS and add the Kext to your `EFI\OC\Kexts` folder and config.

> [!NOTE]
> 
> When using **USBToolBox** in macOS, there are 2 mapping options available which results in 2 different types of kexts:
> 
> - **Option 1** (default): Generates `UTBMap.kext` which has to be used in tandem with `USBToolBox.kext` to make the whole construct work. It has the advantage that the mapping is *SMBIOS-independent* so it can be used with *any* SMBIOS.
> - **Option 2** (uses native Apple classes): Hit "C" to enter the settings and then "N" to enable native Apple classes (`AppleUSBHostMergeProperties`). This kext can only be used with the SMBIOS it was created with. If you decide to change your SMBIOS later, you have to adjust the `model` property inside the kext's `info.plist` – otherwise the mapping won't be applied!

## Option 2: Mapping ports in macOS

Since the `XhciPortLimit` quirk has been fixed since OC 0.9.3, it can be used again to map USB ports in macOS 11.4 and newer!

### Using USBMap (recommended)

The following method is applicable when using [**USBMap**](https://github.com/corpnewt/USBMap).

- [**Update OpenCore**](/Content/D_Updating_OpenCore) to the latest version (0.9.3 or newer is mandatory!)
- Enable Kernel Quirk `XchiPortLimit`
- Save your config and reboot
- Follow the [**instructions**](https://github.com/corpnewt/USBMap#general-mapping-process) to map your USB ports and generate a `USBPort.kext`
- Add the `USBPort.kext` to `EFI/OC/Kexts` and your config.plist. 
- Disable the `XhciPortLimit` Quirk again.
- Save your config.plist and reboot
- Enjoy working USB ports!

### Using Hackintool (outdated, inconvenient but prevalent)

This method is applicable when using [**Hackintool**](https://github.com/benbaker76/Hackintool). Although wide-spread, using Hackintool for mapping USB ports is a bit antiquated, requires a lot more prepwork and is unreliable in terms of detecting *internal* USB ports. You also need a USB 2 and a USB 3 flash drive to detect/map ports!

- [**Update OpenCore**](/Content/D_Updating_OpenCore) to the latest version (0.9.3 or newer is mandatory!)
- Mount your EFI
- Add Daliansky's variant of [**USBInjectAll.kext**](https://github.com/daliansky/OS-X-USB-Inject-All/releases) to `EFI/OC/Kexts` and your `config.plist` since it also supports the latest chipsets
- [**Prepare your system**](https://dortania.github.io/OpenCore-Post-Install/usb/system-preparation.html) for mapping by renaming USB controllers.
- Enable Kernel Quirk `XchiPortLimit`
- Save your config and reboot
- Run Hackintool
- Click on the "USB" Tab
- Click on the Brush icon to clear the screen
- Click on the Recycle icon to detect injected ports
- Put your USB 2 and USB 3 sticks into the ports of your system. Detected ports will turn green.
- Built-in Bluetooth/Cameras: make sure to change the detected port for Bluetooth devices and/or build-in cameras to "internal" to avoid sleep issues. Use IORegistryExplorer to figure out which port these devices are using if Hackintool doesn't detect them (or use Windows' Device Manager >> Details >> Property dropdown-menu >> BIOS path)
- Map up to 15 ports. If you have more, decide which ones you need and delete the other ones.
- Once you're done with mapping, click on "Export" (arrow pointing out of the box).
- `USBPorts.kext` (among other files) will be stored on your Desktop
- Add the `USBPorts.kext` to `EFI/OC/Kexts` and your config.plist. 
- Disable the `USBInjectAll.kext` and the `XhciPortLimit` Quirk.
- Save your config and reboot.
- Enjoy working USB ports!

> [!IMPORTANT]
> 
> If you decide to change the SMBIOS later, you have to adjust the `model` property inside the kext's `info.plist` – otherwise the mapping won't be applied!
> 
> **Example**:<br><img width="1170" height="369" alt="infoplist" src="https://github.com/user-attachments/assets/16f32ea8-5858-48b1-9573-d87834cad196" />

---

[← Previous: Technical Background](01_technical_background.md) | [Back to Overview](./README.md) | [Next: Method 2 - ACPI →](03_method2_acpi.md)

