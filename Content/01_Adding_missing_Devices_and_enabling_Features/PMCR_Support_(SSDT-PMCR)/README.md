# Add PMCR Device (`SSDT-PMCR`)

**INDEX**

- [About](#about)
- [Affected Chipsets/Mainboards](#affected-chipsetsmainboards)
- [Instructions](#instructions)
  - [Method 1: automated, using SSDTTime](#method-1-automated-using-ssdttime)
  - [Method 2: manual patching](#method-2-manual-patching)
- [Verifying that the patch is working](#verifying-that-the-patch-is-working)
- [Technical Background](#technical-background)
- [Credits](#credits)

---

## About
`PMCR` or `APP9876` is an Apple-only ACPI device not present in DSDTs of Wintel systems. It's required for mainboards with Z390 chipsets to enable NVRAM support so the system boots (&rarr; see ["Technical Background"](#technical-background) for details). Also contained in the OpenCore Package (as `SSDT-PMC`).

## Affected Chipsets/Mainboards

- :warning: Mandatory for 390-series mainboards
- Optional for 400/500/600-series (for cosmetics)
- Users with 100 and 200-series mainboards can use [**SSDT-PPMC**](/Content/01_Adding_missing_Devices_and_enabling_Features/Platform_Power_Management_(SSDT-PPMC)) instead!

## Instructions
There are 2 methods to add the PMCR device – choose either or.

### Method 1: automated, using SSDTTime

You can use **SSDTTime** to generate `SSDT-PMC` for you.

**HOW TO:**

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it
2. Press <kbd>D</kbd>, drag in your system's DSDT and hit and hit <kbd>Enter</kbd>
3. Generate all the SSDTs you need.
4. The SSDTs will be stored under `Results` inside the `SSDTTime-master` Folder along with `patches_OC.plist`.
5. Copy the generated SSDTs to `EFI/OC/ACPI`
6. Open `patches_OC.plist` and copy the included entries to the corresponding section(s) of your `config.plist`.
7. Save and reboot

### Method 2: manual patching

1. Download ***SSDT-PMCR.aml*** 
2. Open it in maciASL 
3. Verify that the name and path of the LPC Bus (either `LPC` or `LPCB`) matches the one used in your system's `DSDT`. Adjust it if necessary.
4. Copy the .aml file to `EFI/OC/ACPI` 
5. Add its path to `ACPI/Add` in `config.plist`
6. Save and reboot into macOS

If the patch was applied correctly, it should be possible to boot into macOS.

## Verifying that the patch is working
Open IORegistryExplorer and search for `PCMR`. If the SSDT works, you should find it:</br>

![Bildschirmfoto 2021-11-01 um 16 37 33](https://user-images.githubusercontent.com/76865553/139699060-75fdc4b4-ff16-448e-9e19-96af3c392064.png)

## Technical Background
> Starting from Z390 chipsets, PMCR (D31:F2) is only available through MMIO. Since there is no standard device for PMCR in ACPI, Apple introduced its own naming "APP9876" to access this device from AppleIntelPCHPMCR driver. To avoid confusion we disable this device for all other operating systems, as they normally use another non-standard device with "PNP0C02" HID and "PCHRESV" UID. […]
> 
> PMCR device has nothing to do to LPC bus, but is added to its scope for faster initialization. If we add it to PCI0, where it normally exists, it will start in the end of PCI configuration, which is too late for NVRAM support.
>
>– Acidanthera

## Credits

- Pleasecallmeofficial who discovered this patch
- Acidathera for improving the SSDT
- CorpNewt for SSDTTime
