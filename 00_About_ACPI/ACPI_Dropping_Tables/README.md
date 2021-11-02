# Dropping ACPI Tables
Sometimes ACPI Tables provided with your Firmware/BIOS might hinder some macOS funcionality or devices to work properly. 

For example on Z590 Boards, the presence of Reserved Memory Region(s) in the DMA Remapping Table (DMAR) in combination with disabled Vt-D and/or `DisableIOMapper` Kernel Quirk render the dreaded on-board Intel(r) I225-V Ethernet Controller useless in macOS Monterey. In this case, DMAR has to be modified, Vt-Enabled and `DisableIOMapper` unselected.

Therefore, you might consider dropping the DMAR table completely and/or replace it with a modified version.

## Example 1: dropping the DMAR Table
- Open maciASL
- Select "File" > "New from ACPI" 
- Pick `DMAR`
- Open the DMAR Table in maciASL and scroll to the end
- Copy the table length (in this case, `168`):</br>
	![Tlength](https://user-images.githubusercontent.com/76865553/139952797-38e332bc-3fed-450e-83fb-afa4a955a932.png)</br>
- Open your config and add a new rule under ACPI > delete.
- Enter `444D4152` (HEX for "DMAR") in `TableSignature`. If you use OCAT, you can use the  ASCII to HEX converter at the bottom of the app:</br>
	![Drop](https://user-images.githubusercontent.com/76865553/139952827-a745cf27-a1f6-416e-ba0a-0ccab3c45884.png)</br>
- In TableLength enther the Length listed in the DMAR Table. In this case `168`.
- Save the Config.
- Reboot.

## Verifying that a Table is dropped/deleted
After rebooting, do the following:

- Open maciASL
- Select "File" > "New from ACPI" 
- If you dropped the table sucessfully, it shouldn't be listed. As you can see, it's not present:</br>
	![nodmar](https://user-images.githubusercontent.com/76865553/139952877-ef7d0f85-378d-4c6b-ac9a-efb7118ac4b6.png)</br>
- The table has been dropped successfully.

**NOTE**: If the table is still present, you either did something wrong or a table of the same name is present in ACPI folder and is injected by OpenCore.

## Example 2: replacing a dropped DMAR with a modified one
1. Drop the original table as explained in "Example 1"
2. Modify the same Table
3. Inject it with OpenCore

### Modifying a table
- Open the original DMAR Table
- In this case, we delete the Reserved Memory Regions Sections:</br>
	![Delmem](https://user-images.githubusercontent.com/76865553/139952931-70611f4e-0773-43a9-a1c7-90faef51703b.png)</br>
- Save the file as `DMAR.aml`. It has a new table length now (104).
- Put it in the ACPI Folder of OpenCore and it it to your config.plist.
- Save, reboot.

## Verifying that a Table has been replaced
- Open maciASL
- Select "File" > "New from ACPI" 
- Pick `DMAR`. The file Should be 104 in length and should no longer contain Reserved Memory Regions:</br>
	![DMAR_nu](https://user-images.githubusercontent.com/76865553/139952980-a4d5d68e-5809-4c15-9fc1-eae88ac29d5f.png)</br>

## NOTE
You should only import tables with maciASL if you know these are not patched ones. Otherwise dump the unpatched ACPI Tables from the Clover Bootmenu.
