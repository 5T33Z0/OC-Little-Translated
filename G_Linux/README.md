# Selecting Linux from OpenCore Bootpicker (OC 0.7.3+)

Booting Linux from OpenCore's Bootpicker has become a lot easier, since OpenCore 0.7.3 introduced a new dedicated driver for Linux called `OpenLinuxBoot.efi`.

## Enabling Linux support in OpenCore

1. Add the following Drivers to `/EFI/OC/Drivers` and your config.plist:
	- `OpenLinuxBoot.efi` (included in the [**OpenCore Package**](https://github.com/acidanthera/OpenCorePkg))
	- `btrfs_x64.efi` and/or
	- `ext4_x64.efi` based on the file system the chosen Linux Distribution uses (both included in [**OC Binary Data.zip**](https://github.com/acidanthera/OcBinaryData/archive/refs/heads/master.zip))
2. Enable `UEFI/Quirks` &rarr; `RequestBootVarRouting`
3. Enable `Misc/Boot` &rarr; `LauncherOption` to prevent Linux bootloaders from taking over the first slot of the boot entries. Choose either/or:
	- `Full`: For AMI, Phoenix, and any other modern UEFI BIOS.
	- `Short`: For older types of firmware, typically from Insyde, that are unable to manage full device paths.
4. If you are using `Misc/Entries` or `Misc/BlessOverride` to boot Linux, delete the entries.
5. Save the config and reboot.
6. Reset NVRAM.
7. Linux should be available in the Boot Picker now.

> [!CAUTION]
> 
> Check the `EFI/BOOT` folder before rebooting. Ensure that there are no other files besides OpenCore's `BOOTx64.efi` to prevent GRUB from hijacking the boot menu!

### Troubleshooting
If it doesn't work, do the following:

- Check your kernel configuration. Set `CONFIG_EFI_STUB=y`. If there's no `CONFIG_EFI_STUB`, it is probably commented-out (with a `#` before it). If the value is `n`, the kernel has to be recompiled. However, almost all modern distros set it to `y`.
- Check if the required file system drivers are installed in `/EFI/OC/Drivers` and listed in your config under UEFI > Drivers. If so, try changing the order (File system drivers first, then OpenLinuxBoot).

## Notes
- If multiple Linux Kernels are present, the Boot Picker will become cluttered with entries since OpenLinuxBoot will create a boot entry of each kernel. You can set Misc > Boot > `HideAuxiliary` to `True` to reduce the clutter (press space bar in boot picker to reveal the Linux entries again). This will also hide macOS Recovery, Reset NVRAM and any other tool marked as "Auxiliary".
- If the kernel is not in /boot or the name doesn't start with `vmlinuz`, they won't be detected.
- The original Linux bootloader (grub, systemd-boot, syslinux, etc) should not be deleted.

## Credits
- Acidanthera for OpenCore Package and OpenCore Binaray Data
- **mswgen** from insanelymac.com for the [guide](https://www.insanelymac.com/forum/topic/349838-guide-using-openlinuxboot-to-easily-boot-linux-from-opencore/)
