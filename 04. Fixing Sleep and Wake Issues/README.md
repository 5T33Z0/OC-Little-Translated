# Fixing Sleep and Wake issues

This section contains ACPI Hotpatches for resolving common issues related to Sleep and Wake, especially on but not limited to Laptops. The following Patches/Methods are covered:

#### 1.`PTSWAKTTS` Sleep and Wake fix

This is the center piece for fixing most sleep and wake issues and is mostly used in conjunction with other patches. It consist of two parts: binary renames and  ACPI Hotfixes (SSDTs).

Basically, the `_PTS` (Prepare To Sleep), `_Wak`(Wake) and `_TSS` Methods are renamed to something else. And once these methods are triggered by entering sleep (either automatically or by pressing a sleep button or via the  Menu), the system fetches these request and reroutes them to the associated Hotpatch, ***SSDT-PTSWAKTTS*** which takes care of the rest. 

#### 2. Fixing `PNP0C0E` Sleep 

This patch is required if pressing the Power or Sleep button causes an instant reset or shutdown. In order for this to work, the SSDT-PTSWAKTTS fix is required as well.

#### 3. Fixing instant wake issues: `0D/6D Patch`

This patch is for fixing problem where the machine instantly wakes up after trying to go to sleep, which is usually caused by some device prohibits the system to enter sleep/hibernation mode.

#### 4.Fixing `AOAC` (Always On Alway Connected) Sleep

This patches is used for fixing sleep and standby issues on more recent Laptops using the `AOAC` Technology.

## NOTE 

Since the Sleep and Wake issues usually are no sinngular, isolated but rather inter-related issues, these patches have to be combined to fix all of the issues. In this case, the loading order of the Sequence is important as well and ***SSDT-PTSWAKTTS.aml*** has to be loaded prior to the other Hotpatches listed above. Further information on each patch are located in the `README` of each sub-folder of this section.
