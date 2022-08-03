# Renaming Device and Methods via SSDT

Whenever possible, using SSDTs for renaming Devices and Methods is preferred over using binary renames because you can limit it to macOS which is impossible otherwise.

In this section we take a look at  how this can be achieved and when to use which.

To be continued…

## Patching Principle
The SSDT to rename a method or a device must conform to the following conditions in order to work:

- Look for ("Scope") a Device (`DeviceObj`) or Method (`MethodObj`) in the DSDT at specific location(s) (PCI path(s) defined in the "External" Section of the SSDT
- If the loaded Kernel is "Darmin" (= the macOS Kernel).
- Disable Device/Method X (set Method `_STA` = `Zero`) and
- Enable Devie/Method Y (set Method `_STA` = `0x0F`)

**NOTE**: For each `Scope` expression you are using there has to be a corresponding `External` reference. See examples.

### Example 1: Rename SATA Controller from `SAT1` to `SATA`
Renaming `SAT1` to `SATA` is not really a requirement (it's purely cosmetic), but it's an easy to understand example (read the comments indicated with `//` for explanations):

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
- Mmake sure you have a backup of your working EFI folder on a FAT32 formatted flash drive
- Export the SSDT as .aml file
- Add it to `/EFI/OC/ACPI` and config.plist
- Run IORegistry Exlorer
- Search for `SAT`
- The output should look like this:</br>![](/Users/5t33z0/Desktop/SATA.png)
- :Warning: **CAUTION**: If you don't add the `Name (_ADR,0x000…)` portion to the code, the controller will still work, but you won't find it:</br>![](/Users/5t33z0/Desktop/SAD.png)

## Credits and Resources
- Dortania for [**Rename-SSDT**](https://github.com/dortania/OpenCore-Install-Guide/blob/master/extra-files/Rename-SSDT.dsl)
