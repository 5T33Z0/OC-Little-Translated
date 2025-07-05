# Fixing the System Clock (`SSDT-AWAC`)

**INDEX**

- [Description](#description)
  - [To HPET, or not to HPET?](#to-hpet-or-not-to-hpet)
- [Automated SSDT generation: using SSDTTime](#automated-ssdt-generation-using-ssdttime)
  - [Instructions](#instructions)
- [Manual patching methods](#manual-patching-methods)
  - [Method 1: using `SSDT-AWAC`](#method-1-using-ssdt-awac)
  - [Method 2: using `SSDT-AWAC-ARTC`](#method-2-using-ssdt-awac-artc)
    - [Instructions](#instructions-1)
- [Notes](#notes)
- [Credits](#credits)

---

## Description
Hotpatches for enabling `RTC` and disabling `AWAC` system clock at the same time. Required For 300-series chipsets and newer, since `AWAC` is not supported by macOS. The OpenCore Package contains a similiar patch (`SSDT-AWAC-DISABLE`), but it uses the `_INI` method instead.

### To HPET, or not to HPET?
With the release of the Skylake X and Kaby Lake CPU families, `HPET` (`AppleHPET` in macOS) was declared a  legacy device kept for backward compatibility. In Windows 10 and newer, `HPET` is not used as the primary timer for the system. Instead, Windows 10 uses a combination of the `TSC` (Time Stamp Counter) and the ACPI `PM` timer to keep track of time. 

:bulb: The `HPET` device itself might still be present in your system's `DSDT`, and if macOS detects it, it will service it. If this is the case, I suggest you cross-reference the `.ioreg` file of a real Mac using the same SMBIOS as your system and check for the presence of `AppleHPET`. If it is present, use **Method 1** to enable `RTC`, if it is not present, you can try **Method 2** to enable `RTC`. You can find a collection of Mac ioregs on [**DarwinDumped**](https://github.com/khronokernel/DarwinDumped).

**EXAMPLES**:

- On My Lenovo T490 Notebook, which has an 8th Gen Whiskey Lake CPU, I am using the `MacBookPro15,2` SMBIOS. `AppleHPET` is present in the .ioreg file of the corresponding Mac. For testing, I disabled `HPET` via Method 2, but the system feels snappier with it enabled.
- On my Z490 System (i9 10850K) which uses the `iMac20,2` SMBIOS, `AppleHPET` is not present in the .ioreg of the corresponding Mac. I tried both methods to enable RTC but I can't notice any difference in system behavior.

## Automated SSDT generation: using SSDTTime
With the python script **SSDTTime**, you can generate SSDT-AWAC by analyzing your system's `DSDT`.

### Instructions

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it
2. Press <kbd>D</kbd>, drag in your system's DSDT and hit and hit <kbd>Enter</kbd>
3. Generate all the SSDTs you need.
4. The SSDTs will be stored under `Results` inside the `SSDTTime-master` Folder along with `patches_OC.plist`.
5. Copy the generated SSDTs to `EFI/OC/ACPI`
6. Open `patches_OC.plist` and copy the included entries to the corresponding section(s) of your `config.plist`.
7. Save and Reboot.

> [!NOTE]
> 
> If you are editing your config using [**OpenCore Auxiliary Tools**](https://github.com/ic005k/QtOpenCoreConfig/releases), OCAT it will update the list of kexts and .aml files automatically, since it monitors the EFI folder.

## Manual patching methods
Besides using SSDTTime to generate `SSDT-AWAC.aml`, there are other methods for disabling AWAC. Depending on the search results in your DSDT, you can use different methods and SSDT-AWAC variants. Here are some examples.

Below you'll find a code snippet of how `Device (RTC)` and `Device (AWAC)` might be defined in your `DSDT`:

```asl
Device (RTC)
{
    ...
    Method (_STA, 0, NotSerialized)
    {
            If ((STAS == One)) 	// If STAS = 1
            {
                Return (0x0F)  	// Turn RTC ON
            }
            Else		// if STAS ≠ 1
            {
                Return (Zero)  	// Turn RTC OFF
            }
    }
    ...
}
Device (AWAC)
{
    ...
    Method (_STA, 0, NotSerialized)
    {
            If ((STAS == Zero))	// If STAS = 0
            {
                Return (0x0F) 	// enable AWAC
            }
            Else		// if STAS ≠ 0
            {
                Return (Zero)	// disable AWAC
            }
    }
    ...
}
```
As you can see, you can enable `RTC` and disable `AWAC` at the same time if `STAS=1`, using one of the following methods/hotpatches.

### Method 1: using `SSDT-AWAC`
```asl
External (STAS, IntObj)
Scope (\)
{
    If (_OSI ("Darwin"))
    {
        STAS = One
    }
}
``` 
**Explanation**: This changes `STAS` to `One` for macOS which will enable the `RTC` Device, since the following conditions are met: 

- If `STAS` is `One` enable RTC (set it to `0x0F`). 
- On the other hand, changing `STAS` to `One` will disable `AWAC` because the *Else* condition is met: *"if the value for `STAS` is anything but Zero, return `Zero`* – in other words, turn of `AWAC`.

### Method 2: using `SSDT-AWAC-ARTC`
This SSDT is for systems with 7th Gen Intel Core or newer CPUs. In DSDTs of real Macs, `ARTC` ("ACPI000E") is used instead of `RTC`. This SSDT disables `AWAC` and `HPET` (High Precision Event Timer, which is now a legacy device) and adds `RTC` ("PNP0B00") "disguised" as `ARTC` instead.

Applicable to the following **SMBIOSes**:

- iMac19,1 iMac20,x (8th-10th Gen)
- iMacPro1,1 (Xeon W)
- MacPro7,1 (Xeon W)
- macBookAir9,x (10th Gen)
- macBookPro15,x (8th/9th Gen)
- macBookPro16,x (9th/10th Gen)

**Here's the code**:

```asl
DefinitionBlock ("", "SSDT", 2, "Hack", "ARTC", 0x00000000)
{
    External (_SB_.PCI0.LPCB, DeviceObj)
    External (HPTE, IntObj)
    External (STAS, FieldUnitObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            STAS = 0x02
            HPTE = Zero
        }
    }

    Scope (\_SB.PCI0.LPCB)
    {
        Device (ARTC)
        {
            Name (_HID, EisaId ("PNP0B00") /* AT Real-Time Clock */)  // _HID: Hardware ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                IO (Decode16,
                    0x0070,             // Range Minimum
                    0x0070,             // Range Maximum
                    0x01,               // Alignment
                    0x02,               // Length
                    )
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
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
        }
    }
}
``` 
#### Instructions

1. In `DSDT`, check if `Device HPET` or `PNP0103` is present. If not, you don't need this patch!
2. Next, search for `Device (AWAC)` or `ACPI000E`.
3. If present, check if `STAS` == `Zero` (refer to the DSDT code snippet from the beginning).
4. If the above conditions are met, you can add `SSDT-AWAC-ARTC.aml` to your ACPI Folder and `config.plist`.
5. Open maciASL. Under "File" → "New from ACPI", check if `HPET` is listed. If not, continue with step 6. But if it is present, you should drop it. In order to do so, open your `config.plist`, go to `ACPI` &rarr; `Delete`. Create a new rule. Under `TableSignature`, enter `48504554` (HEX for "HPET"). Check the guide for [Dropping ACPI Tables in OpenCore](/Content/00_ACPI/ACPI_Dropping_Tables) if you don't know how to do this.
6. Save and reboot.
7. In IORegistryExplorer, verify the following:
	-  `ARTC`: should be present
	-  `HPET`: should not be present
8. In maciASL the `HPET` should also not be present.

## Notes
- On some **X299** mainboards (ASUS), the `RTC` device can be defective, so even if there's an `AWAC` device that can be disabled, the `RTC` won't work so booting macOS fails. To work around this issues, leave `AWAC` enabled (so `RTC` won't be available) but add a [**Fake RTC**](/Content/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-RTC0)) instead.
- Disabling `AWAC` via [**Preset Variable**](/Content/00_ACPI/ACPI_Basics/Advanced_Patching_Techniques.md#example-2-ssdt-awac)

## Credits
- [**Baio1977**](https://github.com/Baio1977) for `SSDT-AWAC-ARTC`
- **CorpNewt** for SSDTTime
- **daliansky** for `SSDT-AWAC.dsl`
- **dreamwhite** for additional information and guidance on keeping the tables conform to ACPI specs.
