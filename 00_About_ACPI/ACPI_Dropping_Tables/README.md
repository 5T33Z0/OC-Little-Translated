# Dropping ACPI Tables
Sometimes ACPI Tables provided with your Firmware/BIOS might hinder some macOS funcionality or devices to work properly. 

For example on Z590 Boards, the presence of Reserved Memory Region(s) in the DMA Remapping Table (DMAR) in combination with disabled Vt-D and/or `DisableIOMapper` Kernel Quirk render the dreaded on-board Intel(r) I225-V Ethernet Controller useless in macOS Monterey. In this case, DMAR has to be modified, Vt-Enabled and `DisableIOMapper` unselected.

Therefore, you might consider dropping the DMAR table completely and/or replace it with a modified version.

## Example 1: dropping the DMAR Table
- Open maciASL
- Select "File" > "New from ACPI" 
- Pick `DMAR`
- Open the DMAR Table in maciASL and scroll down to the end
- Copy the table length (in this case, `168`):
	![](/Users/steezonics/Desktop/Tlength.png)
- Open your config and add new runle under ACPI > delete.
- Enter `444D4152` (HEX for "DMAR") in `TableSignature`. If you use OCAT, you can use the  ASCII to HEX comverter at the bottom of the app: 
	![](/Users/steezonics/Desktop/Drop.png)
- In TableLength enther the Length listed in the DMAR Table. In this case `168`.
- Save the Config.
- Reboot.

## Verifying that a Table is dropped/deleted
After rebooting, do the following:

- Open maciASL
- Select "File" > "New from ACPI" 
- If you dropped the table sucessfully, it shouldn't be listed. As you can see, it's not present: ![](/Users/steezonics/Desktop/nodmar.png) 
- The table has been dropped successfully.

**NOTE**: If the table is still present, you either did something wrong or a table of the same name is present in ACPI folder and is injected by OpenCore.

## Example 2: replacing a dropped DMAR with a modified one
1. Drop the original table as explained in "Example 1"
2. Modify the same Table
3. Inject it with OpenCore

### Modifying a table
- Opem the original DNAR Table
- In this case, we delete the Reserved Memory Regions Sections:
	![](/Users/steezonics/Desktop/Delmem.png)
- Save the file as `DMAR.aml`. It has a new table length now (104).
- Put it in the ACPI Folder of OpenCore and it it to your config.plist.
- Save, reboot.

## Verifying that a Table has been replaced
- Open maciASL
- Select "File" > "New from ACPI" 
- Pick `DMAR`. The file Should be 104 in length and should no longer contain Reserved Memory Regions:
	![](/Users/steezonics/Desktop/DMAR_nu.png)

## NOTES
- You should only import tables with maciASL if you know these are not patched ones. Otherwise dump the unpatched ACPI Tables from the Clover Bootmenu.