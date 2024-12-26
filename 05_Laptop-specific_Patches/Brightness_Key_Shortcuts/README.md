# Enabling Brightness Key Shortcuts

- [About](#about)
- [New method: using `BrightnessKeys.kext`](#new-method-using-brightnesskeyskext)
- [Old method: SSDT + Binary Renames](#old-method-ssdt--binary-renames)
	- [I. Select the appropriate Hotpatch](#i-select-the-appropriate-hotpatch)
	- [II. Binary Renames](#ii-binary-renames)

---

## About
SSDT Hotpatches to enable Brightness Key Shortcuts for various Laptop models (Asus, Lenovo, Xiaoxin, Dell, et al.). They have to be paired with the corresonding binary renames mentioned in the .dsl files.

The included Hotpatches are from Dahllian Sky's P-Little Repo for Clover but I added `If (_OSI ("Darwin")` switches. This modification is important to ristrict the patches to macOS only because otherwise OpenCore injects these ACPI tables system-wide whereas Clover only injects them into macOS.

>[!NOTE]
>
> Some ASUS and Dell Laptops only require `SSDT-OCWork-xxx` to enable `Notify (GFX0, 0x86)` and `Notify (GFX0,0x87)`, so that the Brightness shorcut keys work. Please refer to the [ASUS Machine Special Patch](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05_Laptop-specific_Patches/Brand-specific_Patches/ASUS_Special_Patch) and [Dell Machine Special Patch](https://github.com/5T33Z0/OC-Little-Translated/blob/main/05_Laptop-specific_Patches/Brand-specific_Patches/Dell_Special_Patch) for instructions.

## New method: using [`BrightnessKeys.kext`](https://github.com/acidanthera/BrightnessKeys) 
In late 2020, Acidanthera introduced a new kext to handle Brightness Key Shortcuts which replaces the previous patching method.

Since the Brightness Control is part of the Embedded Controller (EC) defined in the DSDT, applying binary renames to its components is sub-optimal and might affect other OSes. Therefore, using a kext is a much cleaner approach since it limits any changes to macOS.

1. If present, disable any Binary Renames and corresponding SSDT Bkeys hotfix which handled Brightness Keys previously.
2. Add `BrightnessKeys.kext` to your OC/Kexts folder and `config.plist`
3. Save and reboot
4. Check if the Brightness Shortcut Keys are still working. If not, you can always revert the changes.

> [!NOTE]
> 
> If you have an older ThinkPad (3rd to 5th gen), read the Spoiler in the "Special Cases" section of the Brightness Keys repo to find out if you need to change `NBCF` form `Zero` to `One` resp. `0x01`. In this case, add `SSDT-NBCF.aml` instead of using a binary rename since using ACPI is cleaner and limited to macOS only.

## Old method: SSDT + Binary Renames
Enabling Brightness Hotkeys consists of two stages:

1. Choosing the correct SSDT for your Laptop model
2. Renaming existing methods for brightness keys to disable them (renames are listed in the `.dsl` files)

### I. Select the appropriate Hotpatch
Pick the corresponding SSDT for your Laptop model, export it as `SSDT-Bkey.aml` and inlude it in your ACPI folder and config.plist. 

- **SSDT-BKeyQ0EQ0F-A580UR** &rarr; For Asus A580UR
- **SSDT-BKeyQ04Q05-X210** → For Lenovo X210
- **SSDT-BKeyQ11Q12-LenAir_IKB_IKBR_IWL** → For Lenovo Xiaoxin
- **SSDT-BKeyQ14Q15-TP** → For various Thinkpad models
- **SSDT-BKeyQ64Q65-S2-2017** → ForThinkpad S2 2017

> [!NOTE]
> 
> Make sure the following PCI device names and paths are consistent with the ones used in the `DSDT`:
>
> - Low Pin Count Bus (`LPC`/`LPCB`)
> - Keyboard (`PS2K`/`KBD`) 
> - Embedded Controller (`EC`/`EC0`)

### II. Binary Renames
Add the corresponding renames listed in the `.dsl` file to your config.plist under `ACPI/Patch`.

- **Asus A580UR**:
	
	```
	Comment: 	change _Q0E to XQ0E (A580UR)
	Find: 		5F 51 30 45
	Replace:	58 51 30 45
	
	Comment: 	change _Q0F to XQ0F (A580UR)
	Find:		5F 51 30 46
	Replace:	58 51 30 46
	```
- **Thinkpad X210**:
	
	```
	Comment: 	change _Q04 to XQ04
	Find: 		5F 51 30 34
	Replace:	58 51 30 34
	
	Comment: 	change _Q05 to XQ05
	Find: 		5F 51 30 35
	Replace:	58 51 30 35
	```
- **Thinkpads**:

	```
	Comment: 	change _Q14 to XQ14 (TP-up)
	Find: 		5F 51 31 34
	Replace: 	58 51 31 34

	Comment: 	change _Q15 to XQ15 (TP-down)
	Find: 		5F 51 31 35
	Replace: 	58 51 31 35
	```
- **Thinkpad S2** (2017):

	```
	Comment:	change _Q64 to XQ64 (TP-S2-2017-down)
	Find: 		5F 51 36 34 
	Replace:	58 51 36 34
	
	Comment:	change _Q65 to XQ65 (TP-S22017-up)
	Find: 		5F 51 36 35
	Replace:	58 51 36 35
	```
- **Xiaoxin IKB/IKBR/IWL**:

	```
	Comment: 	change _Q11 to XQ11 (lenAir/IKB/IKBR/IWL-down)
	Find:		5F 51 31 31
	Replace:	58 51 31 31

	Comment: 	change _Q12 to XQ12 (lenAir/IKB/IKBR/IWL-up)
	Find: 		5F 51 31 32
	Replace: 	58 51 31 32
	```
