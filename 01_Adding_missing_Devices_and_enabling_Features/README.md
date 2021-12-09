# Enabling Devices and Features for macOS
## About

Among the many `SSDT` patches included in this repo, a significant number of them can be categorized as patches for enabling or spoofing devices for macOS. These include:

- Devices which can be enabled simply by changing their name in binary code so macOS detects them. OpenCore users should avoid this method since OpenCore applies binary renames system-wide which can break other OSes, whereas Clover restricts renames and SSDT hotpatches to macOS only.
- Devices which either do not exist in ACPI or have a different name than expected by macOS to function properly. SSDT hotpatches rename these devices/methods for macOS only, so they can attach to drivers and services of macOS. Like CPU Power Management, Backlight Control, AC Power Adaptor, ect. Recommended method.
- Fake EC Device for fixing Embedded Controller issues.
- Patches which rename the original device to something else so a replacement SSDT can be written which takes its place, such as Trackpads for example.
- Devices which are disabled for some reason, but macOS needs them to work. 

## Properties of Fake ACPI Devices

- **Features**:
  - The device already exists in ACPI, is relatively short, small and self-contained in code.  
  - The original device has a canonical `_HID` or `_CID` parameter.
  - Even if the original device is not disabled, patching with a fake device will not harm ACPI.
- **Requirements**:
  - The fake name **differs** from the original device name of ACPI.
  - Patch content and original device main content are **identical**.
  - The `_STA` section of the hotpatch should contain the [`_OSI`](https://uefi.org/specs/ACPI/6.4/05_ACPI_Software_Programming_Model/ACPI_Software_Programming_Model.html#osi-operating-system-interfaces) method to ensure that the code changes only apply to macOS (Darwin Kernel):
	
		```swift
	Method (_STA, 0, NotSerialized)
       {
            If (_OSI ("Darwin"))
            {
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
        }
		```

- **Example**: [**Adding a fake Realtime Clock (RTC0)**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-RTC0))
  
  - ***SSDT-RTC0*** - Fake RTC
  - Original device name: RTC
  - _HID: `PNP0B00`

**Important**: The path and name of the Low Pin Confuguration Bus – either `LPC` or `LPCB` – used in a SSDT must match the one used in the original ACPI tabled in order for a patch to work!

## Adding missing Devices and Features

Although adding any of the missing parts listed below may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which may be a requirement for Z390 Chipsets. Browse throught the folders above to find out which you may need.

### Preparations

In order to add/apply any of the Devices/Patches, it is necessary to research your machine's ACPI - more specifically, the `DSDT`. To obtain a copy of the DSDT, it is necessary to dump it from your system's ACPI Table. There are a few options to do this.

#### Dumping the DSDT

- Using **Clover** (easiest way): hit `F4` in the Boot Menu. You don't even need a working configuration to do this. Just download the latest [**Release**](https://github.com/CloverHackyColor/CloverBootloader/releases) as a .zip file, extract it to an USB stick. The Dump will be located at: `EFI\CLOVER\ACPI\origin`
- Using **SSDTTime** (in Windows): if you use SSDTTime under Windows, you can dump the DSDT, which is not possible if you use it under macOS.
- Using **OpenCore** (requires Debug version and working config): enable Misc > Debug > `SysReport` Quirk. The DSDT will be dumped during next boot.

### Included Hotpatches
Listed below are all SSDTs contained in this chapter. Search for the listed terms in your system's `DSDT`. If you can't find the term/device/hardware-ID, you can add it with the corresponding SSDT. In any case, read the instructions first, to find out if you really need it and how to apply it. If there's no search term listed further analysis of the `DSDT` is required to apply the hotpach.

|SSDT-…|Description|Search term(s) in DSDT 
|----|-------------|:-------------------:|
[**SSDT-AC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/AC_Adapter_(SSDT-AC))|Adds an AC Adaptor Device (for Laptops)|`ACPI0003` or `Device (AC)` 
|[**SSDT-ALS0/ALSD**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Ambient_Light_Sensor_(SSDT-ALS0))|Adds a fake Ambient Light Sensor (SSDT-ALS0) or enables and existing one in macOS (SSDT-ALSD)|`ACPI0008`
|[**SSDT-PNLF**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Brightness_Controls_(SSDT-PNLF))|Adds Backlight Control (for Laptop Screens)|–
[**SSDT-PLUG**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management_(SSDT-PLUG))| Enables XCPM CPU Power Management for Intel CPUS|–
[**SSDT-DMAC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/DMA_Controller_(SSDT-DMAC))|Adds DMA Crontroller|`PNP0200` or `DMAC` 
[**SSDT-EC/-USBX**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Embedded_Controller_(SSDT-EC))|Adds a fake Embedded Controller (SSDT-EC) and enables USB Power Management (SSDT-EC-USBX).|`PNP0C09`
[**SSDT-LAN**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Fake_Ethernet_Controller_(LAN))|Adds a fake Ethernet controller if the included controller isn't supported natively.|–
[**SSDT-HPET**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/IRQ_and_Timer_Fix_(SSDT-HPET))|Fixes IRQ conflicts. Required for on-board sound to work|–
[**SSTD-IMEI**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Intel_MEI_(SSDT-IMEI))|Adds Intel Management Engine Interface to ACPI. Required for Intel iGPU acceleration.|`0x00160000`
[**SSTD-GPIO**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/OCI2C-GPIO_Patch)|Enables GPIO device|–
[**SSTD-XOSI**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/OS_Compatibility_Patch_(XOSI))|OS Compatibility Patch. Read for details.|–
[**SSDT-PMC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/PMC_Support_(SSDT-PMC))|Adds Apple exclusice `PCMR` Device to ACPI (required for 300- to 600-series chipsets)|`PMCR` or `APP9876` 
[**SSDT-PPMC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Platform_Power_Management_(SSDT-PPMC))| Adds Platform Power Management Controller (for 100- and 200-series chipsets only)|`0x001F0002` or `Device (PPMC)` 
[**SSDT-PWRB/SSDT-SLPB**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Power_Button_(SSDT-PWRB)_%26_Sleep_Button_(SSDT-SLPB))|Adds Power and Sleep Button Devices (for Laptops)|`PNP0C0C`(Power), `PNP0C0E`(Sleep)
[**SSDT-MEM2**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/SSDT-MEM2)|Adds Mem Device to iGPU (for 4th to 7th Gen Intel Core CPUs)|`PNP0C01`
[**SSDT-ASPM**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Setting_ASPM_Operating_Mode)|For setting the Active State Power Management (ASPM) to fix/prohibit wake issues caused by device like Bluetooth peripherals or others which can interrupt sleep.|–
[**SSDT-AWAC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-AWAC))|Disables AWAC system clock for macOS and force-enables RTC instead. For 300-series chipsets and newer.|–
[**SSDT-RTC0**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-RTC0))|Adds a fake RTC. Required for 300-series chipsets only.|–
[**SSDT-SBUS-MCHC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Management_Bus_(SMBus)_%26_Memory_Controller_(MCHC))|Fixes System Management Bus and Memory Controller in macOS|`0x001F0003` or `0x001F0004`
[**SSDT-XCPM**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Xtra_Enabling_XCPM_on_Ivy_Bridge_CPUs)|Kernel Patches and SSDT to force-enable XCPM Power Management for Ivy Bridge CPUs|–
