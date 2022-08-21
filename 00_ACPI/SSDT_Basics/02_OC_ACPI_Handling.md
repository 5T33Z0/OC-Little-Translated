# ACPI Patches and OpenCore 
Before you beginn fiddling with SSDTs it's a probably a good idea to take a look at how OpenCore handles ACPI tables and patches in general. OpenCore applies ACPI changes globally to *every* operating system (unlike Clover) in the following order:

1. `Patch` is processed
2. `Delete` is processed
3. `Add` is processed
4. `Quirks` are processed

## ACPI patches integrated into OpenCore
OpenCore also offers a few integrated patches ("Quirk") to address and fix specific ACPI tables (besides the `DSDT.aml`). They are located in the `ACIPI/Quirks` section of the `config.plist`:

![ACPI_quirks](https://user-images.githubusercontent.com/76865553/166452836-80cf06a7-3337-4a32-88b1-ac822c5fb43d.png)

Quirk               | Affected Table(s) | Description | What it fixes
--------------------|-------------------|-------------|--------------
**FadtEnableReset** | **`FACP.aml`**    |Fixed ACPI Description Table (FADT). According to the [ACPI Specs](https://uefi.org/specs/ACPI/6.4/05_ACPI_Software_Programming_Model/ACPI_Software_Programming_Model.html#fixed-acpi-description-table-fadt), FADT defines various static system information related to configuration and power management.| If holding the **Power Button** does not invoke the "Restart, Sleep, Cancel, Shutdown" menu, enable this quirk. If this doesn't fix it, try adding [**SSDT-PMC.aml**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/PMC_Support_(SSDT-PMC)).</br> `Low Power S0 Idle` state. The **FACP.aml** form characterizes the machine type and determines the power management method. If `Low Power S0 Idle` = `1`, it's an `AOAC` (Always On Always Connected) system. See the [About AOAC](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/Fixing_AOAC_Machines) section for more details.
**NormalizeHeaders** | All Table Headers | Clear ACPI Header fields | Removes illegal characters from ACPI Headers. Only required for macOS 10.13
**ResetLogoStatus** |**`BGRT.aml`**      | Bootstrap graphics resource table | According to the [`ACPI Specs`](https://www.acpica.org/documentation), the `Displayed` item of the form should = `0`. However, some vendors have written non-zero data to the `Displayed` entry for some reason, which may cause the screen refresh to fail during the boot phase. The patch sets `Displayed` to `0`. **Note:** Not all machines have this table.
**RebaseRegions** | All Tables | Relocates ACPI Memory Regions | ACPI forms have memory regions with both dynamically allocated as well as fixed addresses. This quirk turns dynamically allocated addresses into fixed ones which can help with patched `DSDTs`. **Caution**: This patch is very dangerous and should not be chosen unless relocating memory regions solves boot crashes!
**ResetHwSig** | **`FACS.aml`**| Sets Hardware Signature to `0` | `Hardware Signature` is part of the **FACS.aml** table. It's calculated after the system has started based on the hardware configuration. If this value changes after the machine wakes up from a **Hibernate** state, the system will not recover correctly. **Note:** If the system has **Hibernation** disabled, you do not need to this quirk!
**SyncTableIds**| **`SLIC.aml`** | Microsoft Software Licensing table |Fixes `SLIC` table causing licensing issues in older Windows versions.
**DisableIoMapper** | **`DMAR.aml`** | Kernel Quirk to disable Vt-d and [dropping the DMAR table](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00_About_ACPI/).| Usually, only early Mac systems need this patch. But with the release of macOS Monterey this has become relevant again for getting some 2.5 and 10 gig Ethernet Cards to work.

**NOTE**: For more info about ACPI Tables in general, please refer to the official [ACPI Specs](https://uefi.org/specs/ACPI/6.4/05_ACPI_Software_Programming_Model/ACPI_Software_Programming_Model.html#acpi-system-description-tables).

Now that we got that out the way, we can be looking at [**SSDT Guidelines**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/00_ACPI/SSDT_Basics/03_SSDT_Guidelines.md)

## CREDITS & RESOURCES
- Acidanthera for OpenCore and its [**Documantaion**](https://dortania.github.io/docs/latest/Configuration.html)
- [**ACPI Specifications**](https://uefi.org/htmlspecs/ACPI_Spec_6_5_html/) by UEFI.org
