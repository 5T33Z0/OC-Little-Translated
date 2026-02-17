## Obtaining ACPI Tables
In order to to figure out which SSDTs are required for your system, it is necessary to research your machine's ACPI tables - more specifically, your system's `DSDT` (Differentiated System Description Table) stored in your system's BIOS/UEFI. There are a couple of options to obtain a copy of it listed below.

**Requirements**: FAT32 formatted USB flash drive (for Clover/OpenCore) and one of the following methods to dump your system's ACPI tables.

### Option 1: Dumping ACPI tables with Clover (easiest and fastest method)
Clover can dump ACPI tables *without* a working config within seconds.

- Download the latest [**Release**](https://github.com/CloverHackyColor/CloverBootloader/releases) (CloverV2-51xx.zip) and extract it 
- Put the `EFI` folder on the USB flash drive. 
- Start the system from the flash drive. 
- Hit `F4` in the Boot Menu. The screen should blink once.
- Pull the USB flash drive, reset the system and reboot into your OS
- Put the USB flash drive back in. The dumped ACPI tables will be stored on the flash drive under: `EFI\CLOVER\ACPI\origin`.

### Option 2: Dumping ACPI tables with OpenCore (requires Debug version)
Normally, you would need an already working `config.plist` in order to obtain the ACPI tables from your system with OpenCore. But since you need the ACPI tables *first* in order to figure out which SSDT hotfixes you *actually* need to boot macOS this is a real dilemma. Luckily, the guys from Utopia-Team have created a generic, pre-configured Debug OpenCore EFI which can dump your system's ACPI tables *without* a bootable config.

- Download the [**OC Debug EFI**](https://github.com/utopia-team/opencore-debug/releases) and extract it
- Put the `EFI` folder on the USB flash drive. 
- Start the system from the flash drive.
- Let the text run through until you reach the text-based boot menu. This takes about a minute
- Pull out the USB stick and reboot into a working OS.
- Put the USB flash drive back in. The dumped ACPI tables will be located in the "SysReport".

### Option 3: Dumping ACPI tables with `SSDTTime` (Windows version only)
If you are using [**SSDTTime**](https://github.com/corpnewt/SSDTTime) in Microsoft Windows, you can also dump the DSDT, which is not possible when running it in macOS. 

- Download **SSDTTime**
- Double-click on `SSDTTime.bat`
- You should see a menu with a lot of options. 
- Press "p" to dump the `DSDT`
- It will be located in a sub-folder called "Results".

> [!NOTE]
> 
> If you get an error message because automatic downloading of the required tools (`iasl.exe` and `acpidump.exe`) fails, [download them from Intel](https://www.intel.com/content/www/us/en/download/774881/acpi-component-architecture-downloads-windows-binary-tools.html), extract the .zip, place both executables in the "Scripts" folder and run the `SSDTTime.bat` file again.

[←**Back to Overview**](./README.md) | [**Next: SSDTs vs. Device Properties →**](04_SSDTs_vs_Properties.md)
