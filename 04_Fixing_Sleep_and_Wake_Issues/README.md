# Fixing Sleep and Wake issues

This section contains ACPI Hotpatches for resolving common issues related to Sleep and Wake, especially on but not limited to Laptops. The following Patches/Methods are covered:

## 1.`PTSWAKTTS` Sleep and Wake fix

This is the center piece for fixing most sleep and wake issues and is mostly used in conjunction with other patches. It consist of two parts: binary renames and an ACPI Hotfix (SSDT).

Basically, the `_PTS` (Prepare To Sleep), `_Wak`(Wake) and `_TSS` Methods are renamed to something else. And once any of these methods are triggered by entering sleep (either automatically, by pressing a sleep button or via the  Menu), the system fetches these request and reroutes them to the associated Hotpatch, ***SSDT-PTSWAKTTS*** which takes care of the rest. 

## 2. Fixing `PNP0C0E` Sleep 

This patch is required if pressing the Power or Sleep button causes an instant reset or shutdown. In order for this to work, `SSDT-PTSWAKTTS.aml` is required as well.

## 3. Fixing instant wake issues: `0D/6D Patch`

This patch is for fixing instant wake issues, where the system instantly wakes up which is usually caused by some device prohibiting the system to enter sleep/hibernation mode.

## 4.Fixing `AOAC` Sleep

These patches are used for fixing sleep and standby issues on more recent Laptops using the Alway on always connected (`AOAC`) Technology.

## Notes

- Since sleep and wake issues are usually no singular, isolated but rather inter-related issues, these patches have to be combined to fix all of the sources for issues. Therefore, the loading order of the SSDTs is important as well.
- ***SSDT-PTSWAKTTS.aml*** has to be loaded prior to other Hotpatches listed above. Further information on each patch are located in the `README` of each sub-folder of this section.
