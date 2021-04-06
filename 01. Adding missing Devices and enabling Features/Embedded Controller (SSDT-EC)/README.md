# Fake Embedded Controller (SSDT-EC)

Although OpenCore does not require renaming of the Embedded Controller (EC), in order to load USB Power Management, it may be necessary to impersonate another EC.

## Patch Method (NEW): Using SSDTTime

The old patch method described below is outdated, because the patching process can now be automated using **SSDTTime** which can generate the following SSDTs based on analyzing your system's `DSDT`:

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

<details>
<summary><strong>Old Method (kept for documentary purposes)</strong></summary>

## Instructions for use

Search for `PNP0C09` in DSDT and check the name of the device it belongs to. If the name is not `EC`, use this patch; if it is `EC`, ignore this patch.

## Note

- If multiple `PNP0C09`s are searched, you should confirm the real and valid `PNP0C09` device.
- The patch uses `LPCB`, if it is not `LPCB`, please modify the patch content by yourself.

