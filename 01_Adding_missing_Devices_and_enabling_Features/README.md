# About Fake Devices

Among the many `SSDT` patches included in this repo, a significant number of them can be categorized as patches for enabling or spoofing devices. These include:

- Devices which either do not exist in ACPI, or have a different names than expected by macOS to function properly. These patches rename these devices/methods for macOS only, so they can attach to the correct drivers and services in macOS, like CPU Power Management, Backlight Control, AC Power Adapter, ect.
- Fake EC for fixing Embedded Controller issues
- Patches which rename the original device to something else so it can be replaced by a SSDT which makes it easier to get it working, such as the Trackpads.
- A device is disabled for some reason, but macOS system needs it to work. 
- In a lot of cases, devices can also be enabled by using binary renames.

## Properties of Fake ACPI Devices

- **Features**:
  - The fake device already exists in ACPI, and is relatively short, small and self-contained in code.  
  - The original device has a canonical `_HID` or `_CID` parameter.
  - Even if the original device is not disabled, patching with a fake device will not harm ACPI.
- **Requirements**:
  - The fake name is **different** from the original device name of ACPI.
  - Patch content and original device main content **identical**.
  - The `_STA` section of the counterfeit patch should include the following to ensure that windows systems use the original ACPI:
    
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
  
- **Example**: Realtime Clock Fix (RTC0)
  
  - ***SSDT-RTC0*** - Counterfeit RTC
  - Original device name: RTC
  - _HID: PNP0B00
  
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
