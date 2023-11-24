# Fixing Sleep and Wake issues

This section contains fixes for resolving common issues related to Sleep and Wake, occurring especially on but not limited to Laptops. The following areas are covered:

## [`PTSWAKTTS`](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PTSWAK_Sleep_and_Wake_Fix): Comprehensive Sleep and Wake fix

This is the center piece for fixing most sleep and wake issues and is used in conjunction with other patches in this section. It consists of two components: binary renames and an ACPI Hotfix (SSDT).

Basically, the `_PTS` (Prepare To Sleep), `_Wak` (Wake) and `_TTS` (Transition to State) methods are renamed to something else. And once any of these methods are triggered by entering sleep (either automatically, by pressing the sleep button or via the  Menu), ***SSDT-PTSWAKTTS*** fetches them and takes care of the rest (in conjunction with additional SSDTs).

> [!NOTE]
> 
> ***SSDT-PTSWAKTTS.aml*** has to be loaded prior to some of the other Hotpatches in this section. Details about each patch are provided in the `README` of the corresponding fix.

## Fixing [`PNP0C0E Sleep`](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PNP0C0E_Sleep_Correction_Method)

This patch is required if pressing the Power or Sleep button causes an instant reset or shutdown. In order for this to work, it must be used in conjunction with ***SSDT-PTSWAKTTS***.

## Fixing instant wake issues: [`0D/6D Patch`](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/060D_Instant_Wake_Fix)

This patch is for fixing instant wake issues, where the system instantly wakes up which after entering sleep. This is usually caused by components/devices prohibiting the system to enter sleep/hibernation state.

## Fixing [`AOAC Sleep`](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/Fixing_AOAC_Machines)

These patches are used for fixing sleep and standby issues on more recent Laptops utilizing **Always on always connected** (`AOAC`) technology.

## Configuring [`ASPM`](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/Setting_ASPM_Operating_Mode)

**ASPM** (Active State Power Management), is a power link management scheme supported at system level. Under ASPM management, **PCI devices** attempt to enter power saving mode when they are idle. You can modify the Active Power State of peripherals like Bluetooth/WiFi or other devices if they interrupt sleep.

## Changing [Hibernation Modes](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/Changing_Hibernation_Modes)

`pmset` commands for changing settings related to **system power management**, such as sleep/hibernation.

## Notes and further Resources
- Before applying any of these hotfixes, make sure that you are not using generic ACPI tables from Dortania or the OpenCore Package as provided, since they often contain additional devices, device names and paths to cover various scenarios at once (e.g. `SSDT-PLUG`). Instead, tailor them to your system's specific requirements or generate your own using [**SSDTTime**](https://github.com/corpnewt/SSDTTime). This alone can prevent sleep and wake issues.
- Check Dortania's Post-Install guide for additional info about [**Fixing Sleep Issues**](https://github.com/dortania/OpenCore-Post-Install/blob/master/universal/sleep.md)
- Acidanthera provides a kext which addresses issues with hibernation, called [**HibernationFixup**](https://github.com/acidanthera/HibernationFixup).
- In-depth look into [**Darkwake**](https://www.insanelymac.com/forum/topic/342002-darkwake-on-macos-catalina-boot-args-darkwake8-darkwake10-are-obsolete/), what it does (and what it doesn't do).
- While researching how these fixes work, I found out that the SSDTs and binary renames used in this section are basically "reverse engineered" `DSDT` patches created by RehabMan included in maciASL's DSDT patching engine. They are also available on his "Laptop DSDT Patch" Repo:
	- **Sleep and Wake** fixes: https://github.com/RehabMan/Laptop-DSDT-Patch/tree/master/system
	- **0D/6D** fixes: https://github.com/RehabMan/Laptop-DSDT-Patch/tree/master/usb
	- **Lid** fixes: https://github.com/RehabMan/Laptop-DSDT-Patch/tree/master/misc
