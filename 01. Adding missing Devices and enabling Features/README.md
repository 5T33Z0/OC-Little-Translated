# About Fake Devices

Among the many `SSDT` patches, a significant number of them can be categorized as patches for spoofing components. These include:

- Devices which either do not exist in ACPI, or have a different name as required by macOS to function correctly. Patches that correctly rename these devices can load device drivers. For example, "05-2-PNLF Injection Method", "Adding Missing Parts", "Spoofing Ethernet", etc.
- Fake EC for fixing Embedded Controller issues
- For some devices, using a method that prohibit the original device from being detected/used will make it easier for us to adjust the patch. Such as the "OCI2C-TPXX Patching Method".
- A device is disabled for some reason, but macOS system needs it to work. See `this chapter` for an example.
- In most cases, devices can also be enabled using the Binary Renaming and Preset Variables.

## Properties of Fake ACPI Devices

- Features:
  - The fake device already exists in ACPI, and is relatively short, small and self-contained in code.  
  - The original device has a canonical `_HID` or `_CID` parameter.
  - Even if the original device is not disabled, patching with a counterfeit device will not harm ACPI.
- Requirements:
  - The counterfeit device name is **different** from the original device name of ACPI.
  - Patch content and original device main content **identical**.
  - The `_STA` section of the counterfeit patch should include the following to ensure that windows systems use the original ACPI.
    ```swift
        Method (_STA, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                ...
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
        }
    ```
  
- Example: Realtime Clock Fix (RTC0)
  
  - ***SSDT-RTC0*** - Counterfeit RTC
  - Original device name: RTC
  - _HID: PNP0B00
  
**Note**: The `LPC/LPCB` name used in the SSDT should be identical with the one used in ACPI.

## Adding missing Devices and Features

Although adding any of the missing parts listed below may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which may be a requirement for Z390 Chipsets.

**NOTE:** To add any of the components listed below, click on the name of the device listed in the menu above to find the corresponding SSDT.

### Preparations

In order to add/apply any of the following Devices/Patches, it is necessary to research your machine's ACPI - more specifically, the `DSDT`. To obtain a copy of the DSDT, it is necessary to dump it from your system's ACPI Table. There are a few options to do this.

### Dumping the DSDT

- Using **Clover** (easiest way): hit `F4` in the Boot Menu. You don't even need a working configuration to do this. Just download the latest [**Release**](https://github.com/CloverHackyColor/CloverBootloader/releases) as a .zip file, extract it to an USB stick. The Dump will be located at: `EFI\CLOVER\ACPI\origin`
- Using **SSDTTime** (in Windows): if you use SSDTTime under Windows, you can dump the DSDT, which is not possible if you use it under macOS.
- Using **OpenCore** (requires Debug version and working config): enable Misc > Debug > `SysReport` Quirk. The DSDT will be dumped during next boot.

### Looking for missing Devices/Features in the DSDT

In **DSDT**, search for the following:

- `PNP0200`, if missing, add ***SSDT-DMAC.aml***. Adds Direct Memory Access [**(DMA) Controller**](https://binaryterms.com/direct-memory-access-dma.html).
- `PNP0C01`, if missing, add ***SSDT-MEM2.aml***. Seems to be related to Laptop iGPU's only. Not very much is known about this device, [though](https://www.tonymacx86.com/threads/guide-patching-laptop-dsdt-ssdts.152573/post-1277391)
- `0x00160000`, if missing, add ***SSDT-IMEI.aml***. Adds Intel MEI required for Intel GPU acceleration (for 6th-series mainboards only)
- `0x001F0002`, if missing, add ***SSDT-PPMC.aml***. For 6th Gen machines or later. Adds Platform Power Management Controller 
- `MCHC`, if missing, add ***SSDT-MCHC.aml***
- `0x001F0003` (before generation 6) or `0x001F0004` (generation 6 and later). Find the name of the device it belongs to. It will either be called `SBUS`or `SMBU`. Select the corresponding SSDT (SBUS/SMBU) to fix System Management Bus. **NOTE**: `SSDT-MCHC`and `SSTD-SBUS/SMBU`have since been combined into one ACPI sample.cUse ***SSDT-SBUS-MCHC.aml*** included in the OpenCore package instead.
- Search for `PNP0C0C` and add ***SSDT-PWRB*** if it is missing. Adds Power Button Device
- Search for `PNP0C0E` and add ***SSDT-SLPB*** if missing, this part is needed for the `PNP0C0E Sleep Correction Method`.
- `PMCR` or `APP9876`, if missing, add ***SSDT-PMCR***. For 6th gen or later. Z390 Chipsets also require this.</br>
	**Note**: Patch provided by @Pleasecallmeofficial which has now become the official OpenCore SSDT sample.
   
**CAUTION:** When using the any of the patches, note that `LPC`/`LPCB` name should be consistent with the name used in the original ACPI.
