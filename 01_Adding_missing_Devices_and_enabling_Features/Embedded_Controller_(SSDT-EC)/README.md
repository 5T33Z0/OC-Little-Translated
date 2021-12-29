# Adding a fake Embedded Controller (`SSDT-EC`) or (`SSDT-EC-USBX`) 

## About Embedded Controllers
An embedded controller (or `EC`) is a hardware micro controller inside of computers (especially Laptops) that can handle a lot of different tasks: from receiving and processing signals from keyboards and/or touchpads, thermal measurments, managing the battery, handling switches and LEDs, handling USB power, Bluetooth toggle, etc, etc.

### Why do I need a fake EC?
On Desktop PCs, the `EC` device usually isn't named correctly for what macOS expects so it can be  attached to `AppleACPIEC` driver. To work around this, we disable the device included in the system's `DSDT` when running macOS and a fake `EC` device for macOS to play with.

### `SSDT-EC` or `SSDT-EC-USBX`: which to use?
In order to get USB Power Management working properly for **Skylake and newer** Intel CPUs, we have to add a fake `EC` as well as a `USBX` device to supply USB power properties because macOS requires it to attach its `AppleBusPowerController` service to it. Both devices are integrated in the `SSDT-EC-USBX`. For older system `SSDT-EC` alone is sufficient (if required at all).

On Laptops, the `EC` micro controller actually really exist but may be incompatibile because macOS expects a different name than what's provided by the system's `DSDT`. In this case we just use a fake EC to keep macOS happy.

So, in general:

- On Desktops, the real `EC` will be disabled and a fake EC will be used instead
- On Laptops we just need an additional fake EC to be present (not always required)
- Skylake and newer CPUs require `SSDT-EC-USBX`.

## Adding a fake EC
There are 2 methods for adding a fake EC: either by manually by adding the required `SSDT-EC `or `SSDT-EC-USBX` (depending on the used Intel CPU Family). Use either one method or the other, not both!

### Method 1: Manual patching method (recommended)
- In the `DSDT`, search for `PNP0C09` 
- If multiple devices with the EisaID `PNP0C09` are discovered, confirm that it belongs to an EC Device (`EC`, `H_EC`, `EC0`, etc).
- Depending on the type of system you are using, open either `SSDT-EC.dsl`, `SSDT-EC-USBX_Desktop.dsl` or `SSDT-EC-USBX_Laptop.dsl`
- Modify the chosen SSDT as needed so the PCI paths and name of the Low Pin Configuration Bus according to what's used in your `DSDT` (either `LPCB`or `LPC`). Read the comments in the .dsl files for more info as well.
- Export the file as .aml (ACPI Machine Language Binary) and add it to EFI > OC > ACPI and your Config
- Save and Reboot.

#### Additional Steps (Desktop PCs only)
- After rebooting, run IORegistryExlorer
- Search for `EC0`. If the devie is not present, you're done!
- If the `EC0` is present (exact match!), you have to disable it. 
- Open the previously used .dsl file and remove the comments `/*` and `*/ `from the following section, so it's no longer displayed in green in MaciASL:
	```swift
    External (_SB_.PCI0.LPCB.EC0, DeviceObj)

    Scope (\_SB.PCI0.LPCB.EC0)
    {
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If (_OSI ("Darwin"))
            {
                Return (0) // Disables EC0 in macOS!
            }
            Else
            {
                Return (0x0F) // Leaves EC0 enabled for all other OSes!
            }
        }
    }
    ```
- Export the file as .aml 
- Replace the existing file in EFI > OC > ACPI
- Reboot
- Check IORegistryExplorer again for `EC0`
- If it's not present, you're done.

### Method 2: automated SSDT generation using SSDTTime
**SSDTTime** is a the python script which can generate various SSDTs from analyzing your system's `DSDT`. Unfortunately, SSDTTime does not generate a Fake EC with an included `USBX` Device. So if you are using a system with a Skylake or newer CPU, you either have to add an addtional SSDT containing the USBX device or add it the to the existing SSDT-EC or use the manual method instead!

**HOW TO:**

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it
2. Pres "D", drag in your system's DSDT and hit "ENTER"
3. Generate all the SSDTs you need.
4. The SSDTs will be stored under `Results` inside of the `SSDTTime-master`Folder along with `patches_OC.plist`.
5. Copy the generated `SSDTs` to EFI > OC > ACPI and your Config using OpenCore Auxiliary Tools
6. Open `patches_OC.plist` and copy the the included patches to your `config.plist` (to the same section, of course).
7. Save and Reboot. Done.

**Tip**: If you are editing your config using [**OpenCore Auxiliary Tools**](https://github.com/ic005k/QtOpenCoreConfig/releases), OCAT it will update the list of .kexts and .aml files automatically, since it monitors the EFI folder.
