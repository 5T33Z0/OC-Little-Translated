# Add PMCR Device (`SSDT-PMCR`)

## About
`PMCR` or `APP9876` is an Apple exclusive device which won't be present in your DSDT. It's required for mainboards with Z390 chipsets to enable NVRAM support so the system boots (see "Technical Background" for details).

### Affected Chipsets/Mainboards

- :warning: Mandatory for 390-series mainboards
- Optional for 400/500/600-series (for cosmetics)
- Users with 100 and 200-series mainboards can use [**SSDT-PPMC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Platform_Power_Management_(SSDT-PPMC)) instead!

### Instructions
There are 2 methods to add the PMCR device – choose either or

#### Method 1: automated, using SSDTTime

You can use **SSDTTime** which can generate the following SSDTs by analyzing your system's `DSDT`:

* ***[SSDT-AWAC](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-AWAC))*** – Context-aware AWAC and Fake RTC
* ***[SSDT-BRG0](https://github.com/5T33Z0/OC-Little-Translated/tree/main/11_Graphics/GPU/GPU_undetected)*** – ACPI device for missing PCI bridges for passed device path
* ***[SSDT-EC](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Embedded_Controller_(SSDT-EC))*** – OS-aware fake EC for Desktops and Laptops
* ***[SSDT-USBX](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Embedded_Controller_(SSDT-EC))*** – Adds USB power properties for Skylake and newer SMBIOS
* ***[SSDT-HPET](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/IRQ_and_Timer_Fix_(SSDT-HPET))*** – Patches out IRQ Conflicts
* ***[SSDT-PLUG](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management_(SSDT-PLUG))*** – Sets plugin-type to `1` on `CPU0`/`PR00` to enable the X86PlatformPlugin for CPU Power Management
* ***[SSDT-PMC](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/PMCR_Support_(SSDT-PMCR))*** – Enables Native NVRAM on true 300-Series Boards and newer
* ***[SSDT-PNLF](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Brightness_Controls_(SSDT-PNLF))*** – PNLF device for laptop backlight control
* ***SSDT-USB-Reset*** – Resets USB controllers to allow USB port mapping

**NOTE**: When used in Windows, SSDTTime also can dump the `DSDT`.

**HOW TO:**

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it
2. Press <kbd>D</kbd>, drag in your system's DSDT and hit and hit <kbd>Enter</kbd>
3. Generate all the SSDTs you need.
4. The SSDTs will be stored under `Results` inside the `SSDTTime-master` Folder along with `patches_OC.plist`.
5. Copy the generated SSDTs to `EFI/OC/ACPI`
6. Open `patches_OC.plist` and copy the included entries to the corresponding section(s) of your `config.plist`.
7. Save and Reboot.

#### Method 2: manual patching

- Download ***SSDT-PMCR.aml*** 
- Open it in maciASL 
- Verify that the name and path of the LPC Bus (either `LPC` or `LPCB`) matches the one used in your system's `DSDT`. Adjust it if necessary.
- Copy the file to `EFI/OC/ACPI` and `config.plist`
- Save and reboot.

### Verifying that the patch is working
Open IORegistryExplorer and search for `PCMR`. If the SSDT works, you should find it:</br>

![Bildschirmfoto 2021-11-01 um 16 37 33](https://user-images.githubusercontent.com/76865553/139699060-75fdc4b4-ff16-448e-9e19-96af3c392064.png)

## Technical Background
> Starting from Z390 chipsets, PMCR (D31:F2) is only available through MMIO. Since there is no standard device for PMCR in ACPI, Apple introduced its own naming "APP9876" to access this device from AppleIntelPCHPMCR driver. To avoid confusion we disable this device for all other operating systems, as they normally use another non-standard device with "PNP0C02" HID and "PCHRESV" UID. […]
> 
> PMCR device has nothing to do to LPC bus, but is added to its scope for faster initialization. If we add it to PCI0, where it normally exists, it will start in the end of PCI configuration, which is too late for NVRAM support.

## Credits

- Pleasecallmeofficial who discovered this patch
- Acidathera for improving the SSDT.
- CorpNewt for SSDTTime

**HOW TO:**

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it
2. Press <kbd>D</kbd>, drag in your system's DSDT and hit and hit <kbd>Enter</kbd>
3. Generate all the SSDTs you need.
4. The SSDTs will be stored under `Results` inside the `SSDTTime-master` Folder along with `patches_OC.plist`.
5. Copy the generated SSDTs to `EFI/OC/ACPI`
6. Open `patches_OC.plist` and copy the included entries to the corresponding section(s) of your `config.plist`.
7. Save and Reboot.
