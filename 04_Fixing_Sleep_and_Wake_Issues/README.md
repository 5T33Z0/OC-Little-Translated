# Fixing Sleep and Wake issues

This section contains fixes for resolving common issues related to Sleep and Wake, occurring especially on but not limited to Laptops. The following areas are covered:

## 1.[`PTSWAKTTS` Sleep and Wake fix](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues)

This is the center piece for fixing most sleep and wake issues and is mostly used in conjunction with other patches. It consists of two parts: binary renames and an ACPI Hotfix (SSDT).

Basically, the `_PTS` (Prepare To Sleep), `_Wak`(Wake) and `_TSS` Methods are renamed to something else. And once any of these methods are triggered by entering sleep (either automatically, by pressing a sleep button or via the  Menu), the system fetches these request and reroutes them to the associated Hotpatch, ***SSDT-PTSWAKTTS*** which takes care of the rest.

## 2. [Fixing `PNP0C0E` Sleep](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PNP0C0E_Sleep_Correction_Method)

This patch is required if pressing the Power or Sleep button causes an instant reset or shutdown. In order for this to work, `SSDT-PTSWAKTTS.aml` is required as well.

## 3. Fixing instant wake issues: [`0D/6D Patch`](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/060D_Instant_Wake_Fix)

This patch is for fixing instant wake issues, where the system instantly wakes up which is usually caused by some device prohibiting the system to enter sleep/hibernation mode.

## 4. [Fixing `AOAC` Sleep](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/Fixing_AOAC_Machines)

These patches are used for fixing sleep and standby issues on more recent Laptops using Always on always connected (`AOAC`) Technology.

## 5. Configuring [`ASPM` (Active State Power Management)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/Setting_ASPM_Operating_Mode)

ASPM (**Active State Power Management**), is a power link management scheme supported at system level. Under ASPM management, PCI devices attempt to enter power saving mode when they are idle. You can modify the Active Power State of peripherals like Bluetooth/WiFi or other devices if they interrupt sleep.

## Notes
- Before applying any of these patches, ensure that you don't just use generic ACPI tables from Dortania or the OpenCore Package but rather modify them to fit your system requirements or generate custom ones using [SSDTTime](https://github.com/corpnewt/SSDTTime) instead. Doing this can prevent the occurrence of sleep and wake issues altogether. 
- Since sleep and wake issues are usually no singular, isolated but rather inter-related issues, these patches have to be combined to fix all the sources for issues. Therefore, the loading order of the SSDTs is important as well.
- ***SSDT-PTSWAKTTS.aml*** has to be loaded prior to other Hotpatches listed above. Further information on each patch are located in the `README` of each sub-folder of this section.
