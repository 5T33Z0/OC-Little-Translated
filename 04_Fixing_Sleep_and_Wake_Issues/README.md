# Fixing Sleep and Wake issues

This section contains fixes for resolving common issues related to Sleep and Wake, occurring especially on but not limited to Laptops. The following areas are covered:

## [`PTSWAKTTS`](/04_Fixing_Sleep_and_Wake_Issues/PTSWAK_Sleep_and_Wake_Fix/README.md): Comprehensive Sleep and Wake fix

This SSDT is the center piece for fixing most sleep and wake issues and is used in conjunction with other patches in this section. It consists of binary renames and an ACPI Hotfix (SSDT).

### How the patch works

- The methods `_PTS` (Prepare To Sleep), `_Wak` (Wake) and `_TTS` (Transition to State) are renamed to something else via binary renames. 
- ***SSDT-PTSWAKTTS*** re-defines the original methods and if any of them  are triggered (either automatically by the sleep timer, by pressing the sleep/power button or via the  Menu), it fetches these events and takes care of sleep/wake (in conjunction with additional SSDTs).

> [!NOTE]
> 
> ***SSDT-PTSWAKTTS.aml*** has to be loaded prior to some of the other Hotpatches in this section. Details about each patch are provided in the `README` of the corresponding fix.

## Fixing [`PNP0C0E Sleep`](/04_Fixing_Sleep_and_Wake_Issues/PNP0C0E_Sleep_Correction_Method/README.md)

This patch is required if pressing the Power or Sleep button causes an instant reset or shutdown. In order for this to work, it must be used in conjunction with ***SSDT-PTSWAKTTS***.

## Fixing instant wake issues: [`0D/6D Patch`](/04_Fixing_Sleep_and_Wake_Issues/060D_Instant_Wake_Fix/README.md)

This patch is for fixing instant wake issues, where the system instantly wakes up which after entering sleep. This is usually caused by components/devices prohibiting the system to enter sleep/hibernation state.

## Fixing [`AOAC Sleep`](/04_Fixing_Sleep_and_Wake_Issues/Fixing_AOAC_Machines/README.md)

These patches are used for fixing sleep and standby issues on more recent Laptops utilizing **Always on always connected** (`AOAC`) technology.

## Configuring [`ASPM`](/04_Fixing_Sleep_and_Wake_Issues/Setting_ASPM_Operating_Mode/README.md)

**ASPM** (Active State Power Management), is a power link management scheme supported at system level. Under ASPM management, **PCI devices** attempt to enter power saving mode when they are idle. You can modify the Active Power State of peripherals like Bluetooth/WiFi or other devices if they interrupt sleep.

## Changing [Hibernation Modes](/04_Fixing_Sleep_and_Wake_Issues/Changing_Hibernation_Modes/README.md)

Guide for enabling/fixing Hibernation.

## Notes and further Resources
- Before applying any of these hotfixes, make sure that you are not using generic ACPI tables from Dortania or the OpenCore Package as provided, since they often contain additional devices, device names and paths to cover various scenarios at once (e.g. `SSDT-PLUG`). Instead, tailor them to your system's specific requirements or generate your own using [**SSDTTime**](https://github.com/corpnewt/SSDTTime). This alone can prevent sleep and wake issues.
- Check Dortania's Post-Install guide for additional info about [**Fixing Sleep Issues**](https://github.com/dortania/OpenCore-Post-Install/blob/master/universal/sleep.md)
- [**Fixing Power Management, Sleep and Hibernation**](https://github.com/zx0r/HackintoshBible/blob/main/PowerManagement/README.md) in macOS Sonoma and Sequoia (by zx0r).
- In-depth look into [**Darkwake**](https://www.insanelymac.com/forum/topic/342002-darkwake-on-macos-catalina-boot-args-darkwake8-darkwake10-are-obsolete/), what it does (and what it doesn't do).
- While researching how these fixes work, I found out that the SSDTs and binary renames used in this section are basically "reverse engineered" `DSDT` patches created by RehabMan included in maciASL's DSDT patching engine. They are also available on his "Laptop DSDT Patch" Repo:
	- **Sleep and Wake** fixes: https://github.com/RehabMan/Laptop-DSDT-Patch/tree/master/system
	- **0D/6D** fixes: https://github.com/RehabMan/Laptop-DSDT-Patch/tree/master/usb
	- **Lid** fixes: https://github.com/RehabMan/Laptop-DSDT-Patch/tree/master/misc
