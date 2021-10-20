# Enabling CPU Power Management (`SSDT-PLUG`)

## Description

Enables `X86PlatformPlugin` to implement CPU Power Management.

## Patch Method: automated, using SSDTTime

The manual patch method described below is outdated, since the patching process can now be automated using **SSDTTime** which can generate the following SSDTs based on analyzing your system's `DSDT`:

* ***SSDT-AWAC*** – Context-aware AWAC and Fake RTC
* ***SSDT-EC*** – OS-aware fake EC for Desktops and Laptops
* ***SSDT-PLUG*** – Sets plugin-type to `1` on `CPU0`/`PR00`
* ***SSDT-HPET*** – Patches out IRQ Conflicts
* ***SSDT-PMC*** – Enables Native NVRAM on true 300-Series Boards
* ***SSDT-USB-Reset*** – Resets USB controllers to allow hardware mapping

**NOTE**: When used in Windows, SSDTTime also can dump the `DSDT`.

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
If you are editng your config using [**OpenCore Auxiliary Tools**](https://github.com/ic005k/QtOpenCoreConfig/releases), OCAT it will update the list of .kexts and .aml files automatically, since it monitors the EFI folder.
<details>
<summary><strong>Old Method (kept for documentary purposes)</strong></summary>

## Instructions for use

- Search for ``Processor`` in DSDT, e.g.:

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

According to the query result, select the injection file:***SSDT-PLUG-_SB.PR00***

If the query result and the patch file name **do not correspond**, please select any file as a sample and modify the patch file related content by yourself.
</details>

## Note
The `X86PlatformPlugin` is not available for 2nd and 3rd Gen Intel CPUs - they use the `ACPI_SMC_PlatformPlugin`instead. Use [**ssdtPPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) to generate an `SSDT-PM` for these CPUs instead.
