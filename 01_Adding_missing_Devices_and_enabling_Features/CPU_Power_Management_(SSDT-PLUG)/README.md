# Enabling CPU Power Management (`SSDT-PLUG`)

## Description

Enables `X86PlatformPlugin` to implement CPU Power Management on 4th Gen Intel Core CPUs (Haswell and newer). AMD CPUs require [**SSDT-CPUR.aml**](https://github.com/dortania/Getting-Started-With-ACPI/blob/master/extra-files/compiled/SSDT-CPUR.aml) instead.

## Patching method 1: automated, using SSDTTime

The manual patch method described below is outdated, since the patching process can now be automated using **SSDTTime** which can generate the following SSDTs based on analyzing your system's `DSDT`:

* ***SSDT-AWAC*** – Context-aware AWAC and Fake RTC
* ***SSDT-EC*** – OS-aware fake EC for Desktops and Laptops
* ***SSDT-PLUG*** – Sets plugin-type to `1` on `CPU0`/`PR00`
* ***SSDT-HPET*** – Patches out IRQ Conflicts
* ***SSDT-PMC*** – Enables Native NVRAM on true 300-Series Boards and newer
* ***SSDT-USB-Reset*** – Resets USB controllers to allow hardware mapping

**NOTE**: When used in Windows, SSDTTime also can dump the `DSDT`.

**HOW TO:**

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it
2. Pres "D", drag in your system's DSDT and hit "ENTER"
3. Generate all the SSDTs you need.
4. The SSDTs will be stored under `Results` inside of the `SSDTTime-master` Folder along with `patches_OC.plist`.
5. Copy the generated `SSDTs` to EFI > OC > ACPI
6. Open `patches_OC.plist` and copy the the included patches and files listes under ACPI > Add to your `config.plist` (to the same section, of course).
7. Save. Reboot. Done. 

## Patching method 2: manual

- In `DSDT`, search for `Processor`, e.g.:

```  swift
        Scope (_PR)
      {
          Processor (CPU0, 0x01, 0x00001810, 0x06){}
          Processor (CPU1, 0x02, 0x00001810, 0x06){}
          Processor (CPU2, 0x03, 0x00001810, 0x06){}
          Processor (CPU3, 0x04, 0x00001810, 0x06){}
          Processor (CPU4, 0x05, 0x00001810, 0x06){}
          Processor (CPU5, 0x06, 0x00001810, 0x06){}
          Processor (CPU6, 0x07, 0x00001810, 0x06){}
          Processor (CPU7, 0x08, 0x00001810, 0x06){}
      }
```

  Based on the query result, select the injection file ***SSDT-PLUG-_PR.CPU0***

```swift
       Scope (_SB)
      {
          Processor (PR00, 0x01, 0x00001810, 0x06){}
          Processor (PR01, 0x02, 0x00001810, 0x06){}
          Processor (PR02, 0x03, 0x00001810, 0x06){}
          Processor (PR03, 0x04, 0x00001810, 0x06){}
          Processor (PR04, 0x05, 0x00001810, 0x06){}
          Processor (PR05, 0x06, 0x00001810, 0x06){}
          Processor (PR06, 0x07, 0x00001810, 0x06){}
          Processor (PR07, 0x08, 0x00001810, 0x06){}
          Processor (PR08, 0x09, 0x00001810, 0x06){}
          Processor (PR09, 0x0A, 0x00001810, 0x06){}
          Processor (PR10, 0x0B, 0x00001810, 0x06){}
          Processor (PR11, 0x0C, 0x00001810, 0x06){}
          Processor (PR12, 0x0D, 0x00001810, 0x06){}
          Processor (PR13, 0x0E, 0x00001810, 0x06){}
          Processor (PR14, 0x0F, 0x00001810, 0x06){}
          Processor (PR15, 0x10, 0x00001810, 0x06){}
      }
```

According to the query result, select the injection file: ***SSDT-PLUG-_SB.PR00***

If the query result and the patch file name **do not match**, please select any file as a sample and modify the patch file related content by yourself. If you are unsure what to do, use the `SSDT-PLUG.aml` sample included with the OpenCore package since it covers all cases of possible CPU device names.

## Notes and Credits
- The `X86PlatformPlugin` is not available for 2nd Gen (Sandy Bridge) and 3rd Gen (Ivy Bridge) Intel CPUs - they use the `ACPI_SMC_PlatformPlugin`instead. 
- You can use [**ssdtPPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) to generate a `SSDT-PM` for these CPUs instead to enable proper CPU Power Management.
- Dortania for `SSDT-CPUR.aml` 
