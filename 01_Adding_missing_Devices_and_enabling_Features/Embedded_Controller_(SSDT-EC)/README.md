# Adding a fake Embedded Controller (`SSDT-EC`) or (`SSDT-EC-USBX`)

- [What's an EC?](#whats-an-ec)
  - [Why do I need a fake/virtual EC?](#why-do-i-need-a-fakevirtual-ec)
  - [`SSDT-EC` or `SSDT-EC-USBX`: which one do I need?](#ssdt-ec-or-ssdt-ec-usbx-which-one-do-i-need)
  - [SSDT-EC in a nutshell](#ssdt-ec-in-a-nutshell)
- [Adding a fake EC Device](#adding-a-fake-ec-device)
  - [Method 1: automated SSDT generation using SSDTTime](#method-1-automated-ssdt-generation-using-ssdttime)
  - [Method 2: Manual patching method (recommended)](#method-2-manual-patching-method-recommended)
    - [Additional Steps (Desktop PCs only)](#additional-steps-desktop-pcs-only)
- [Adding the correct current values to `USBX` device](#adding-the-correct-current-values-to-usbx-device)
- [Credits](#credits)

---

## What's an EC?
An embedded controller (or `EC`) is a hardware microcontroller inside of computers (especially Laptops) that can handle a lot of different tasks: from receiving and processing signals from keyboards and/or touchpads, thermal measurements, managing the battery, handling switches and LEDs, handling USB power, Bluetooth toggle, etc., etc.

### Why do I need a fake/virtual EC?

Since macOS Catalina, the way devices are handled by the Embedded Controller has changed and checks for verifying its presence have been implemented ([more details](https://github.com/khronokernel/EC-fix-guide#so-why-do-i-get-these-errors)). So if it's not present, macOS boot will stall and you will receive status messages including:

- `apfs_module_start…` or 
- `Waiting for Root device` or 
- `Waiting on…IOResources…` or 
- `previous shutdown cause…`

On most wintel systems (some Lenovo Laptops excluded), the Embedded Controller is not named `EC__` but `EC0_`, `H_EC`, `ECDV` or `PGEC` so macOS doesn't detect it and can't attach the required `AppleACPIEC` driver to it.

For Desktop PCs this is a good thing, since Embedded Controllers of PC mainboards are usually incompatible with macOS and may break at any time. In other words: on Desktops, `AppleACPIEC` kext must be prevented from connecting to an existing `EC`. To ensure this, we disable the device when macOS is running add a fake/virtual `EC` so macOS is happy.

On Laptops, the `EC` microcontroller actually really exists but may not be detected because macOS expects a different name than what's provided by the system's `DSDT`. In this case we just use a fake EC to keep macOS happy.

| ![EC](https://user-images.githubusercontent.com/76865553/236379168-dad17c9e-da01-4162-865b-a754a438ba83.png)
|:--| 
| **Screensot**: `EC` device in a Lenovo Laptop which does't require `SSDT-EC` because it already has the correct name so macOS detects it 

### `SSDT-EC` or `SSDT-EC-USBX`: which one do I need?
In order to get USB Power Management working properly on **Skylake and newer**, we have to add a fake `EC` as well as a `USBX` device to inject USB power properties, so macOS can attach its `AppleBusPowerController` service to it. Both devices are included in `SSDT-EC-USBX`. For older systems, `SSDT-EC` alone is sufficient.

### SSDT-EC in a nutshell

- On **Desktops**, an existing `EC` has to be disabled and a fake one has to be added.
- On **Laptops**, we just need an additional fake `EC` if the ACPI name of the Embedded Controller isn't `EC__` already.
- **Skylake** and newer Intel CPUs require `SSDT-EC-USBX`, older CPUs require `SSDT-EC`.

## Adding a fake EC Device
There are 2 methods for adding a fake or virtual EC: automated (Method 1) or manual (Method 2). Use either one method or the other, not both!

> [!WARNING]
> 
> Don't rename `EC0`, `H_EC`, etc. to `EC` for desktop systems! These devices are incompatible with macOS and may break at any time. `AppleACPIEC` kext must NOT load on desktops.

### Method 1: automated SSDT generation using SSDTTime

With the python script **SSDTTime**, you can generate SSDT-EC and SSDT-USBX.

**HOW TO:**

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it
2. Press <kbd>D</kbd>, drag in your system's DSDT and hit and hit <kbd>Enter</kbd>
3. Based on your system, select either "Fake EC" or "Fake EC Laptop"
4. For Skylake and newer CPUs you also need to generate "USBX" as well
5. The SSDTs will be stored under `Results` inside the `SSDTTime-master` Folder along with `patches_OC.plist`.
6. Copy them to `EFI/OC/ACPI`
7. Open `patches_OC.plist` and copy the included entries to the corresponding section(s) of your `config.plist`.
8. Save and Reboot.

**Tip**: If you are editing your config using [**OpenCore Auxiliary Tools**](https://github.com/ic005k/QtOpenCoreConfig/releases), OCAT it will update the list of kexts and .aml files automatically, since it monitors the EFI folder.

### Method 2: Manual patching method (recommended)
1. In the `DSDT`, search for `PNP0C09` 
2. If multiple devices with the EisaID `PNP0C09` are discovered, confirm that it belongs to an EC Device (`EC`, `H_EC`, `EC0`, etc.).
3. Depending on the type of system you are using, open either `SSDT-EC.dsl`, `SSDT-EC-USBX_Desktop.dsl` or `SSDT-EC-USBX_Laptop.dsl`
4. Modify the chosen SSDT as needed so the PCI paths and name of the Low Pin Configuration Bus according to what's used in your `DSDT` (either `LPCB`or `LPC`). Read the comments in the .dsl files for further instructions.
5. Export the file as .aml (ACPI Machine Language Binary) and add it to `EFI/OC/ACPI` and your Config
6. Save and Reboot.

#### Additional Steps (Desktop PCs only)
To ensure that the existing EC in your `DSDT` does not attach to the `AppleACPIEC` driver, do the following after rebooting:

- Run [**IORegistryExplorer**](https://github.com/khronokernel/IORegistryClone)
- Search for the name of your real EC controller (`EC0`, `H_EC`, etc.)  If the device is not present, you're done!
- If the device is present (exact match!), you have to disable it. 
- Open the previously used .dsl file and remove the comments `/*` and `*/ `from the following section, so it's no longer displayed in green in MaciASL:
	```asl
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
- Adjust the device name and PCI path accordingly to what's used in you `DSDT`
- Export the file as .aml
- Replace the existing file in EFI/OC/ACPI
- Reboot
- Check IORegistryExplorer again for `EC0`, `H_EC` or whatever the device is called in your `DSDT`.
- If it's not present, you're done.

## Adding the correct current values to `USBX` device
Inside the **SSDT-EC-USBX.aml** or **SSDT-USBX.aml** table, you'll find the `USBX` device which is present in DSDTs of real Macs with Intel Skylake or newer CPUs. It contains electrical current values in hex. Older models and versions of macOS don't have an `USBX` device but rather use values stored in the [IOUSBHostFamily.kext](https://www.tonymacx86.com/threads/guide-usb-power-property-injection-for-sierra-and-later.222266/), in other words, it's handled by macOS (up to 10.12).

Below you'll find the default USB power properties used in the SSDT-EC-USBX files.

**For PCs**:

```asl
...
Return (Package (0x08)
{	
    "kUSBSleepPowerSupply", 
    0x13EC,
    "kUSBSleepPortCurrentLimit", 
    0x0834,
    "kUSBWakePowerSupply",
    0x13EC, 
    "kUSBWakePortCurrentLimit", 
    0x0834
})
...
```
**For Noetbooks/NUCs**:

```asl
...
Return (Package (0x08)
{	
    "kUSBSleepPortCurrentLimit", 
    0x0BB8,
    "kUSBWakePortCurrentLimit", 
    0x0BB8
})
...
```
Depending on the SMBIOS you are using, you may have to adjust these values accordingly. The table below lists values used in real Macs:.

|SMBIOS|kUSBSleepPowerSupply|kUSBSleepPortCurrentLimit|kUSBWakePowerSupply|kUSBWakePortCurrentLimit|
|-------|:----:|:----:|:----:|:----:|
**iMacPro1,1**|0x13EC|0x0834|0x13EC|0x0834
||||||
**iMac20,x**|0x13EC|0x0834|0x13EC|0x0834
iMac19,1|"|"|"|"
iMac18,3|"|"|"|"
iMac17,1|"|"|"|"
iMac16,x|"|"|"|"
iMac15,1 and older|N/A|N/A|N/A|N/A
||||||
**MacBook9,1**|0x05DC|0x05DC|0x05DC|0x05DC
MacBook8,1 and older|N/A|N/A|N/A|N/A
||||||
**MacBookAir9,1**|-|0x0BB8|-|0x0BB8
MacBookAir8,1|-|"|-|"
MacBookAir7,1 and older|N/A|N/A|N/A|N/A
||||||
**MacBookPro16,1**|-|0x0BB8|-|0x0BB8
MacBookPro15,x|-|0x0BB8|-|0x0BB8
MacBookPro14,1|-|0x0BB8|-|0x0BB8
MacBookPro13,x|-|0x0BB8|-|0x0BB8
MacBookPro12,x and older|N/A|N/A|N/A|N/A
||||||
**MacMini8,1**|0x0C80|0x0834|0x0C80|0x0834
MacMini7,1 and older|N/A|N/A|N/A|N/A
||||||
**MacPro7,1**|0x13EC|0x0834|0x13EC|0x0834|
MacPro6,1 and older|N/A|N/A|N/A|N/A

As you can see, desktop machines (iMac, iMacPro and MacPro) use the same values, whereas the values for notebooks and MacMinis differ.

## Credits
- Apple for IORegistryExplorer
- khronokernel for explanations about how EC works in macOS 
- CorpNewt for SSDTTime
