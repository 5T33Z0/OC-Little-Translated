# Enabling Brightness Shortcut Keys

SSDT Hotpatches to enable Brightness Shortcut Keys for various Laptop models (Asus, Lenovo, Xiaoxin, Dell, et al.). They have to be paired with the binary renames mentioned in the .dsl files.

The included Hotpatches are from Dahllian Sky's P-Little Repo for Clover but I added `OSI` switches required for OpenCore so the patches are restricted to macOS and don't affect other operating systems such as Windows. This change is important because OpenCore injects ACPI tables system-wide whereas Clover only injects them into macOS.

## Patching Method
Enabling Brightness Hotkeys consists of two stages:

1. Chose the correct SSDT for your Laptop model
2. Rename existing methods for brightness keys to disable them (renames are listed in the`.dsl` files)

## I. Select the appropriate Hotpatch
Pick the corresponding SSDT for your Laptop model, export it as `SSDT-Bkey.aml` and inlude it in your ACPI folder and config.plist. 

- **SSDT-BKeyQ0EQ0F-A580UR** &rarr; For Asus A580UR
- **SSDT-BKeyQ04Q05-X210** → For Lenovo X210
- **SSDT-BKeyQ11Q12-LenAir_IKB_IKBR_IWL** → For Lenovo Xiaoxin
- **SSDT-BKeyQ14Q15-TP** → For various Thinkpad models
- **SSDT-BKeyQ64Q65-S2-2017** → ForThinkpad S2 2017

**NOTE**: Make sure the following PCI device names and paths are consistent with the ones used in the `DSDT`:

- Low Pin Configuration Bus (`LPC`/`LPCB`)
- Keyboard (`PS2K`/`KBD`) 
- Embedded Controller (`EC`/`EC0`)

## II. Binary Renames
In ACPI > Patch, add the corresponding renames listed in the `.dsl` file.

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
