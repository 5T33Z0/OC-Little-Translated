# Enabling Devices and Features

Among the many `SSDT` patches included in this repo, a significant number of them can be categorized as patches for enabling or spoofing devices. These include:

- Devices which can be enabled simply by changing their name in binary code so macOS detects them. OpenCore users should avoid this method since OpenCore applies binary renames system-wide which can break other OSes, whereas Clover restricts renames and SSDT hotpatches to macOS only.
- Devices which either do not exist in ACPI or have a different name than expected by macOS to function properly. SSDT hotpatches rename these devices/methods for macOS only, so they can attach to drivers and services of macOS. Like CPU Power Management, Backlight Control, AC Power Adaptor, ect. Recommended method.
- Fake EC device for fixing Embedded Controller issues.
- Patches which rename the original device to something else so a replacement SSDT can be written which takes its place, such as Trackpads for example.
- Devices which are disabled for some reason, but macOS needs them to work. 

## Properties of Fake ACPI Devices

- **Features**:
  - The device already exists in ACPI, is relatively short, small and self-contained in code.  
  - The original device has a canonical `_HID` or `_CID` parameter.
  - Even if the original device is not disabled, patching with a fake device will not harm ACPI.
- **Requirements**:
  - The fake name is **different** from the original device name of ACPI.
  - Patch content and original device main content are **identical**.
  - The `_STA` section of the hotpatch should contain the [`_OSI`](https://uefi.org/specs/ACPI/6.4/05_ACPI_Software_Programming_Model/ACPI_Software_Programming_Model.html#osi-operating-system-interfaces) method to ensure that the code changes only apply to macOS (Darwin Kernel):
	
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

- **Example**: [Realtime Clock Fix (RTC0)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-RTC0))
  
  - ***SSDT-RTC0*** - Counterfeit RTC
  - Original device name: RTC
  - _HID: `PNP0B00`
  
**Note**: The `LPC/LPCB` name used in the SSDT should be identical with the one used in ACPI.

## Adding missing Devices and Features

Although adding any of the missing parts listed below may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which may be a requirement for Z390 Chipsets. Browse throught the folders above to find out which you may need.

**NOTE:** To add any of the components listed below, click on the name of the device listed in the menu above to find the corresponding SSDT.

### Preparations

In order to add/apply any of the Devices/Patches, it is necessary to research your machine's ACPI - more specifically, the `DSDT`. To obtain a copy of the DSDT, it is necessary to dump it from your system's ACPI Table. There are a few options to do this.

### Dumping the DSDT

- Using **Clover** (easiest way): hit `F4` in the Boot Menu. You don't even need a working configuration to do this. Just download the latest [**Release**](https://github.com/CloverHackyColor/CloverBootloader/releases) as a .zip file, extract it to an USB stick. The Dump will be located at: `EFI\CLOVER\ACPI\origin`
- Using **SSDTTime** (in Windows): if you use SSDTTime under Windows, you can dump the DSDT, which is not possible if you use it under macOS.
- Using **OpenCore** (requires Debug version and working config): enable Misc > Debug > `SysReport` Quirk. The DSDT will be dumped during next boot.
