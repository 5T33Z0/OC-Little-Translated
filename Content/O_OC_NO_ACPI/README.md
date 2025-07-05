# Switching from official OpenCore to OpenCore_NO_ACPI_Build

## About
**OpenCore_NO_ACPI_Build** is an *unofficial* fork of OpenCore by [**btwise**](https://gitee.com/btwise/OpenCore_NO_ACPI), not endorsed by Acidanthera (the dev team behind OpenCore) nor by me. I just want to provide some info about it. The main (and only) difference between this fork and the official OpenCore version is that it allows to ***prevent*** ACPI injection (e.g. patches, tables, boot parameters) into other OSes besides macOS.

It might be useful in cases where injecting ACPI tables and settings cause issues in other Operating Systems such as Microsoft Windows, where injecting non-ACPI conform SSDTs are the #1 reason for the dreaded "Blue Screen of Death". So basically, it's aimed at n00b users (and so-called Hackintosh "Veterans") who don't know how to add 3 lines of code to their SSDTs to disable code injection into Windows. If your EFI is configured correctly, you don't need this fork of OpenCore.

**Q**: So, how does it work? <br>
**A**: It has one more Quirk added to the `ACPI/Quirks` and `Booter/Quirks` section called `EnableForAll`. If these are set to `false`, no ACPI patches, SSDTs and Booter parameters will be injected into other OSes besides macOS.

## Prerequisites
1. An already working EFI folder and `config.plist`
2. :warning: Ensure that your OpenCore build and the OpenCore_NO_ACPI_Build you want to switch to are on the same version! Otherwise you will get validation errors. In other words: if your OpenCore build is on 0.8.7, OpenCore_NO_ACPI_Build needs to be on 0.8.7 as well!

## Instructions
1. :warning: Backup your current EFI folder on a FAT32 formatted USB flash drive!
2. Download the correct [**OpenCore_NO_ACPI_Build**](https://github.com/wjz304/OpenCore_NO_ACPI_Build/releases) that matches your OpenCore version and unzip it
3. Replace the following files in your `EFI` Folder:
	- **BootX64.efi** (in EFI/Boot)
	- **OpenCore.efi** (in EFI/OC)
	- Any **Drivers** you use (in EFI/OC/Drivers)
	- Any **Tools** you use (in EFI/OC/Tools)
4. Add the following Keys to your `config.plist`:
	- Under `ACPI/Quirks`, add: `EnableForAll` (Type: Boolean) and set it to `NO`
	- Under `Booter/Quirks`, add: `EnableForAll` (Type: Boolean) and set it to `NO`
5. Save and reboot.

## Verifying
- Boot Windows from the OpenCore BootPicker
- Run [**HWiNFO**](https://sourceforge.net/projects/hwinfo/)
- In the main window, check the "Computer Brand Name". It should be a combination of manufacturer and mainboard (or Laptop) model. If it says "Acidanthera" followed by the mac Model set in SMBIOS instead, then you've done something wrong.

> [!NOTE]
> 
> If you just want to prohibit SMBIOS injection into Windows, you can achieve this with the regular OpenCore build as well. You just have change the following settings in your config.plist:
> 
> - `Kernel/Quirks/CustomSMBIOSGuid` = `YES`
> - `PlatformInfo/SMBIOS/UpdateSMBIOSMode` = `Custom`

## Resources
- **OpenCore_NO_ACPI** – [Latest Build](https://github.com/wjz304/OpenCore_NO_ACPI_Build/releases)
