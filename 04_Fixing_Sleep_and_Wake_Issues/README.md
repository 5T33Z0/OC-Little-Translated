# Fixing Sleep and Wake issues

This section contains fixes for resolving common issues related to Sleep and Wake, occurring especially on but not limited to Laptops. The following areas are covered:

## [`PTSWAKTTS`](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PTSWAK_Sleep_and_Wake_Fix): Comprehensive Sleep and Wake fix

This is the center piece for fixing most sleep and wake issues and is used in conjunction with other patches in this section. It consists of two components: binary renames and an ACPI Hotfix (SSDT).

Basically, the `_PTS` (Prepare To Sleep), `_Wak` (Wake) and `_TSS` Methods are renamed to something else. And once any of these methods are triggered by entering sleep (either automatically, by pressing the sleep button or via the  Menu), ***SSDT-PTSWAKTTS*** fetches them and takes care of the rest (in conjunction with the additional SSDTs listed below).

## Fixing [`PNP0C0E Sleep`](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PNP0C0E_Sleep_Correction_Method)

This patch is required if pressing the Power or Sleep button causes an instant reset or shutdown. In order for this to work, `SSDT-PTSWAKTTS.aml` is required as well. Requires  ***SSDT-PTSWAKTTS***.

## Fixing instant wake issues: [`0D/6D Patch`](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/060D_Instant_Wake_Fix)

This patch is for fixing instant wake issues, where the system instantly wakes up which is usually caused by some device prohibiting the system to enter sleep/hibernation mode.

## Fixing [`AOAC Sleep`](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/Fixing_AOAC_Machines)

These patches are used for fixing sleep and standby issues on more recent Laptops utilizing **Always on always connected** (`AOAC`) technology.

## Configuring [`ASPM`](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/Setting_ASPM_Operating_Mode)

**ASPM** (Active State Power Management), is a power link management scheme supported at system level. Under ASPM management, **PCI devices** attempt to enter power saving mode when they are idle. You can modify the Active Power State of peripherals like Bluetooth/WiFi or other devices if they interrupt sleep.

## Changing [Hibernation Modes](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/Changing_Hibernation_Modes)

Terminal commanfs for changing settings related to **system power management**, such as  sleep/hibernation.

## :warning: Notes and further Resources
- Before applying any of these patches, ensure that you don't just use generic ACPI tables from Dortania or the OpenCore Package. Instead modify them to match your system requirements or generate tailor made ones for your system using [**SSDTTime**](https://github.com/corpnewt/SSDTTime). Doing this can prevent sleep and wake issues altogether. 
- Since sleep and wake issues are usually no singular, isolated but rather inter-related issues, these patches have to be combined to fix all the sources for issues. Therefore, the loading order of the SSDTs is important as well.
- ***SSDT-PTSWAKTTS.aml*** has to be loaded prior to other Hotpatches listed above. Further information on each patch are located in the `README` of each sub-folder of this section.
- Acidanthera also provides a kext which addresses issues with hibernation, called [**HibernationFixup**](https://github.com/acidanthera/HibernationFixup) you can try.
- In-depth look into [**Darkwake**](https://www.insanelymac.com/forum/topic/342002-darkwake-on-macos-catalina-boot-args-darkwake8-darkwake10-are-obsolete/), what it does (and what it doesn't).
- While researching how these fixes work, I found out that the SSDTs and binary renames used in this chapter are basically "reverse engineered" `DSDT` patches created by RehabMan included in maciASL's DSDT patching engine. They are also available on his "Laptop DSDT Patch" Repo:
	- **Sleep and Wake** fixes: https://github.com/RehabMan/Laptop-DSDT-Patch/tree/master/system
	- **0D/6D** fixes: https://github.com/RehabMan/Laptop-DSDT-Patch/tree/master/usb
	- **Lid** fixes: https://github.com/RehabMan/Laptop-DSDT-Patch/tree/master/misc
