# How OpenCore handles ACPI 

## Order of operations

Before you start fiddling with SSDTs, it's a good idea to understand how OpenCore handles ACPI tables and patches.

Unlike Clover's traditional OS-dependent ACPI patching approach, OpenCore applies ACPI changes globally to every operating system. The effective processing order is as follows:

1. `Delete` — Removes matching ACPI tables.
2. `Quirks` — Applies built-in ACPI workarounds.
3. `Patch` — Applies binary patches to ACPI tables.
4. `Add` — Loads the specified ACPI tables.

For more details about how ACPI is handled by OpenCore, refer to the official [**OpenCore Reference Manual**](https://dortania.github.io/docs/release/Configuration.html#introduction1).

## ACPI quirks integrated into OpenCore

OpenCore provides several built-in ACPI quirks to work around firmware issues by modifying specific ACPI tables or their contents. They are configured in the `ACPI -> Quirks` section of the `config.plist`.

![ACPI_quirks](https://user-images.githubusercontent.com/76865553/166452836-80cf06a7-3337-4a32-88b1-ac822c5fb43d.png)

| Quirk | Affected Table(s) | Table Description | What it fixes |
|:--|:--|:--|:--|
| **FadtEnableReset** | `FACP` (FADT) | Fixed ACPI Description Table. Contains fixed hardware information, including the reset register and reset value. | Provides the reset register and reset value in the FADT to enable reboot and shutdown. Mainly required on legacy hardware and some newer laptops. Can also fix power-button shortcuts in macOS. Enable it only if needed. |
| **NormalizeHeaders** | All ACPI table headers | Normalizes ACPI table header fields. | Cleans up ACPI header fields to work around compatibility issues with macOS. Historically used to prevent boot crashes with macOS High Sierra (10.13); the relevant issue was fixed in macOS Mojave (10.14), so this quirk is generally unnecessary on newer versions. |
| **ResetLogoStatus** | `BGRT` | Boot Graphics Resource Table. Contains information about the boot image displayed by firmware. | Resets the `Displayed` field in the BGRT to `0`. This works around firmware implementations that incorrectly report the boot image as already displayed, potentially causing problems with screen updates during boot. Not all systems provide a BGRT. |
| **RebaseRegions** | ACPI memory regions in the final ACPI table set | Attempts to relocate ACPI memory regions using heuristic analysis. | Attempts to rebase dynamically allocated ACPI memory regions to avoid address conflicts. This is an advanced workaround and is not recommended unless a specific issue requires it. Incorrect relocation can cause instability or boot failures. |
| **ResetHwSig** | `FACS` | Firmware ACPI Control Structure. Contains firmware data used for ACPI hardware coordination, including the hardware signature. | Resets the `Hardware Signature` field to `0`. This can work around hibernation-resume problems when the hardware signature changes between hibernation and resume. Generally unnecessary if hibernation is not used. |
| **SyncTableIds** | ACPI tables with modified OEM identifiers | Synchronizes OEM identifiers in the final ACPI table set. | Synchronizes the OEM Table ID and OEM Revision fields between the FADT and the DSDT it references. This helps keep their identifiers consistent when ACPI tables have been replaced or modified. It is not a Windows licensing fix for the `SLIC` table. |

For more information about ACPI tables, refer to the official [**ACPI specifications**](https://uefi.org/specifications).

> [!NOTE]
> 
> These quirks are workarounds, not general-purpose optimizations. Leave them disabled unless your hardware or a specific compatibility issue requires them. ACPI changes made by OpenCore can affect other operating systems as well.

## Credits

- Acidanthera for OpenCore and its [**Reference Manual**](https://dortania.github.io/docs/latest/Configuration.html).
- [**ACPI Specifications**](https://uefi.org/specifications) by UEFI.org.
