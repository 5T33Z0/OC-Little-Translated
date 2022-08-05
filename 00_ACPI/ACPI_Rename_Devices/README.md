# Renaming Devices via SSDT

Whenever possible, using SSDTs for renaming Devices is preferred over using binary renames because you can limit it to macOS which is impossible otherwise since OpenCore applies binary renames system-wide (unlike Clover). In this section we take a look at  how this can be achieved and when to use which approach.

## Patching Principle
The SSDT to rename a device must conform to the following conditions in order to work:

- Look for ("Scope") a Device (`DeviceObj`) in the DSDT at specific location (PCI path) defined in the "External" Section of the SSDT
- If the loaded Kernel is "Darwin" (= the macOS Kernel) do the following:
	- Disable Device X (set Method `_STA` = `Zero`) and
	- Enable Device Y (set Method `_STA` = `0x0F`)

**NOTE**: For each `Scope` expression you are using there has to be a corresponding `External` reference. See examples.

### Example 1: Rename SATA Controller from `SAT1` to `SATA`
Renaming `SAT1` to `SATA` is not a requirement (it's purely cosmetic), but it's an easy to understand example (read the comments indicated by `//` for explanations):

```asl
DefinitionBlock ("", "SSDT", 2, "STZ0", "SATA", 0x00001000)
{
    External (_SB_.PCI0, DeviceObj)         // Adjust ACPI Paths according to your DSDT
    External (_SB_.PCI0.SAT1, DeviceObj)    // Adjust Device name as needed
    
    If (_OSI ("Darwin"))                    // If the macOS Kernel is running…
    {
        Scope (\_SB.PCI0)                   // …look here for…
        {
            Scope (SAT1)                    // …Device SAT1 and…
            {
                Method (_STA, 0, NotSerialized) // 
                {
                    Return (Zero)          // … set its Status to 0 (disable it)
                }
            }

            Device (SATA)                  // Add Device SATA…
            {   
                Name (_ADR, 0x001F0002)    // …with Address (get it from DSDT)
                Method (_STA, 0, NotSerialized)
                {
                    Return (0x0F)          // …and enable it
                }
            }
        }
    }
}
```
#### Testing and verifying
- Make sure you have a backup of your working EFI folder on a FAT32 formatted flash drive
- Export the SSDT as .aml file
- Add it to `/EFI/OC/ACPI` and config.plist
- Save and reboot
- Run IORegistry Exlorer
- Search for `SAT`
- The output should look like this:</br>![SATA](https://user-images.githubusercontent.com/76865553/182600459-febd1490-585e-4a7a-9d7f-3dc966482c56.png)
- :warning: **CAUTION**: If you don't add the `Name (_ADR,0x000…)` portion to the code, the controller will still work, but you won't find it:</br>![SAD](https://user-images.githubusercontent.com/76865553/182600512-396acfb7-85da-4a40-85b4-f16cebb72cdc.png)

### Example 2: renaming USB Controllers (up to Skylake)
This example is from my Ivy Bridge Laptop which uses SMBIOS `MacBookPro10,1`. It has USB Controllers `EHC1`, `EHC2` and `XHCI` present in the DSDT. The have to be renamed to `EH01`, `EH02` and `XHC` to disable the port injectors built into macOS that match the SMBIOS you're using.

Usually, this is done with binary renames but you can do it via SSDT as well. It follows the same patching principle mentioned earlier.

Depending on the SMBIOS you are using, different renames for your USB Controller(s) may be required. Refer to [this section](https://dortania.github.io/OpenCore-Post-Install/usb/system-preparation.html#checking-what-renames-you-need) of Dortania's Post-Install Guide for details.

```asl
DefinitionBlock ("", "SSDT", 2, "STZ0", "EHCxRNME", 0x00001000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.EHC1, DeviceObj)
    External (_SB_.PCI0.EHC2, DeviceObj)
    External (_SB_.PCI0.XHCI, DeviceObj)

    If (_OSI ("Darwin"))
    {
        Scope (\_SB.PCI0)
        {
            Scope (EHC1)
            {
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (Zero)
                }
            }

            Device (EH01)
            {
                Name (_ADR, 0x001D0000)  // _ADR: Address
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }
            }

            Scope (EHC2)
            {
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (Zero)
                }
            }

            Device (EH02)
            {
                Name (_ADR, 0x001A0000)  // _ADR: Address
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }
            }

            Scope (XHCI)
            {
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (Zero)
                }
            }

            Device (XHC)
            {
                Name (_ADR, 0x00140000)  // _ADR: Address
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }
            }
        }
    }
}
```
#### Testing and verifying
- Make sure you have a backup of your working EFI folder on a FAT32 formatted flash drive
- Export the SSDT as .aml file
- Add it to `/EFI/OC/ACPI` and config.plist
- Save and reboot
- Run Hackingtool and click on the "USB" Tab. The Controllers should be renamed to whatever device names you assigned to them when running macOS:</br>![ctrlrshcktl](https://user-images.githubusercontent.com/76865553/183024743-b28f84c0-afa8-43b0-aa56-d23c28e9e401.png)

**Note**: Since I am using a Laptop and the USB ports defined for the used USB 2 and USB 3 controllers stay within the 15 port limit of macOS, I am done at this stage. But for Desktop systems which usually define 26 ports for `XHCI`, you will have to map USB Ports afterwards. More about this in the section [**USB Fixes**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03_USB_Fixes).

## Credits and Resources
- Dortania for [**Rename-SSDT**](https://github.com/dortania/OpenCore-Install-Guide/blob/master/extra-files/Rename-SSDT.dsl)
