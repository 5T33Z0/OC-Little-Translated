# Automated SSDT Generation with SSDTTime

The python script **SSDTTime** can generate the following SSDTs by analyzing your system's `DSDT.aml`:

SSDT | Description
:---: |---------
[***SSDT-AWAC***](/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-AWAC)/README.md) | Context-aware AWAC and Fake RTC (System Clock)
[***SSDT-Bridge***](/11_Graphics/GPU/GPU_undetected/README.md) | ACPI device for missing PCI bridges for passed device path
[***SSDT-EC***](/01_Adding_missing_Devices_and_enabling_Features/Embedded_Controller_(SSDT-EC)/README.md) | OS-aware fake EC for Desktops and Laptops
[***SSDT-USBX***](/01_Adding_missing_Devices_and_enabling_Features/Embedded_Controller_(SSDT-EC)/README.md) | Adds USB power properties for Skylake and newer SMBIOS
[***SSDT-HPET***](/01_Adding_missing_Devices_and_enabling_Features/IRQ_and_Timer_Fix_(SSDT-HPET)/README.md) | Patches out IRQ conflicts. Symptom: No Audio. Usually only required on older Intel chipsets (pre Skylake).
[***SSDT-PLUG***](/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(SSDT-PLUG)/README.md) | Sets plugin-type to `1` on `CPU0`/`PR00` to enable the X86PlatformPlugin for CPU Power Management in macOS Big Sur and older. Not required in macOS Monterey and newer. Also not required when CPUFriend and CPUFriendDataProvider kexts are injected.
[***SSDT-PMC***](/01_Adding_missing_Devices_and_enabling_Features/PMCR_Support_(SSDT-PMCR)/README.md) | Enables Native NVRAM on true 300-Series Boards and newer
[***SSDT-PNLF***](/01_Adding_missing_Devices_and_enabling_Features/Brightness_Controls_(SSDT-PNLF)/README.md) | PNLF device for enabling backlight control of Laptop displays.
[***SSDT-XOSI***](/01_Adding_missing_Devices_and_enabling_Features/OS_Compatibility_Patch_(XOSI)/README.md) | SSDT hotfix and and binary rename(s) to make macOS "believe" that it's currently running Windows on a Mac &rarr; Mainly required to improve I2C TouchPad support on Laptops.
[***SSDT-SBUS-MCHC***](/01_Adding_missing_Devices_and_enabling_Features/System_Management_Bus_and_Memory_Controller_(SSDT-SBUS-MCHC)/README.md) | Defines an MCHC and BUS0 device for SMBus compatibility
***SSDT-USB-Reset*** | Resets USB controllers to allow USB port mapping

Additionally, it can modify the following ACPI table:

Table <br>Signature  | Description
:------------------: |---------
[***DMAR***](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00_ACPI/ACPI_Dropping_Tables#method-2-dropping-tables-based-on-table-signature) |  Removes Reserved Memory Regions from the `DMAR` table and creates a rule to drop and replace the original table.

> [!TIP]
>
> **SSDTTime** should be your goto utility for preparing a new/unknown system's ACPI tables for installing/running macOS.

## Instructions

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it.
2. Press <kbd>D</kbd>, drag your system's `DSDT` into the Terminal Window and hit <kbd>Enter</kbd>.
3. Generate the required SSDTs for your system. Refer to Dortania's OpenCore Install Guide if you are unsure which tables your system requires.
4. The SSDTs will be stored under `Results` inside the `SSDTTime-master` folder alongside `patches_Clover.plist` and `patches_OC.plist`. 
5. Copy the generated SSDTs to `EFI/OC/ACPI`
6. Open `patches_OC.plist` and copy the included entries to the corresponding section(s) of your `config.plist` manually or run `patchmerge.command` to merge the content of `patches_OC.plist` with your config automatically. A new `config.plist` file will be created in the `Results` folder. Copy it over to `EFI/OC`, replacing the existing plist. 
7. Add required Kexts to `EFI/OC/Kexts` and your `config.plist` if they are not present already. Usually Lilu, VirtualSMC, WhateverGreen (for Graphics) and AppleALC (for Audio).
8. Save and Reboot.

> [!NOTE]
> - The Windows and Linux version of SSDTTime can also dump your system's `DSDT` which is not possible under macOS (for good reasons).
> - If you are using [**OpenCore Auxiliary Tools**](https://github.com/ic005k/QtOpenCoreConfig/releases) for editing your config, you can drag files into the respective sections of the App to add them to the EFI/OC folder (.aml, .kext, .efi) and `config.plist`. Alternatively, you can just copy SSDTs, Kexts, Drivers and Tools to the corresponding sections of EFI/OC and the config.plist will be updated automatically to reflect the changes since **OCAT** monitors the EFI folder.
