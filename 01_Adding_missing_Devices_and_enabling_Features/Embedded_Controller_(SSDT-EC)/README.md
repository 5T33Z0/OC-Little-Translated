# Fake Embedded Controller (SSDT-EC)

Although OpenCore does not require renaming of the Embedded Controller (EC), in order to load USB Power Management, it may be necessary to impersonate another EC.

# Add Device USBX (SSDT-EC_USBX_Laptop\Desktop)

On desktops, the EC(or better known as the embedded controller) isn't compatible with AppleACPIEC driver, to get around this we disable this device when running macOS
AppleBusPowerController will look for a device named EC, so we will want to create a fake device for this kext to load onto
AppleBusPowerController also requires a USBX device to supply USB power properties for Skylake and newer, so we will bundle this device in with the EC fix.
On laptops, the EC is used for hotkeys and battery so disabling this isn't all too ideal. Problem is our EC's name isn't compatible, so we will create a simple "fake" EC device that will satisfy Apple.

So:

EC is embedded controller
Desktops will want real EC off, and a fake EC created
Laptops will just want an additional fake EC present
Skylake and newer devices will want USBX as well.

```
Desktop:
        Device (USBX)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03                                             // .
                    })
                }

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
            }
Laptop:
        Device (USBX)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03                                             // .
                    })
                }

                Return (Package (0x04)
                {
                    "kUSBSleepPortCurrentLimit", 
                    0x0BB8, 
                    "kUSBWakePortCurrentLimit", 
                    0x0BB8
                })
            }

Source: Real Mac ioreg analysis
```
## Patch Method: Using SSDTTime

The previous (old) patch method described below is outdated, because the patching process can now be automated using **SSDTTime** which can generate the following SSDTs based on analyzing your system's `DSDT`:

* ***SSDT-AWAC*** – Context-Aware AWAC and Fake RTC
* ***SSDT-EC*** – OS-aware fake EC for Desktops and Laptops
* ***SSDT-PLUG*** – Sets plugin-type to 1 on `CPU0`/`PR00`
* ***SSDT-HPET*** – Patches out IRQ Conflicts
* ***SSDT-PMC*** – Enables Native NVRAM on True 300-Series Boards

**HOW TO:**

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it
2. Pres "D", drag in your system's DSDT and hit "ENTER"
3. Generate all the SSDTs you need.
4. The SSDTs will be stored under `Results` inside of the `SSDTTime-master`Folder along with `patches_OC.plist`.
5. Copy the generated `SSDTs` to EFI > OC > ACPI
6. Open `patches_OC.plist` and copy the the included patches to your `config.plist` (to the same section, of course).
7. Save your config
8. Download and run [**ProperTree**](https://github.com/corpnewt/ProperTree)
9. Open your config and create a new snapshot to get the new .aml files added to the list.
10. Save. Reboot. Done. 

**NOTE**
If you are editing your config using [**OpenCore Auxiliary Tools**](https://github.com/ic005k/QtOpenCoreConfig/releases), OCAT it will update the list of .kexts and .aml files automatically, since it monitors the EFI folder.

## Manual method

Search for `PNP0C09` in the `DSDT` and check the name of the device it belongs to. If the name is not `EC`, use this patch; if it is `EC`, ignore this patch.

## Note

- Desktop PC only: search in ioreg IOService EC0, if you have this device you have to add the part between them slesh in SSDT_EC_USBX_Desktop.This operation deactivates the EC0 device.`DO NOT USE THIS PROCEDURE ON A PC LAPTOP WILL INTERRUPT SOME FUNCTIONS`
- If multiple `PNP0C09`s are searched, you should confirm the real and valid `PNP0C09` device.
- The patch uses `LPCB`, if it is not `LPCB`, please modify the patch content by yourself.

