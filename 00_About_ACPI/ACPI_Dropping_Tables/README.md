# Dropping ACPI Tables
Sometimes ACPI Tables provided with your Firmware/BIOS might hinder some features or devices to work properly in macOS. Boot managers like Clover an OpenCore provide means to prohibit certain tables from loading or to replace them. In order to do so, you need to know the Tables Signature, OEM Table ID and/or Table Length. Therefore, you need to dump the existing ACPI files from your BIOS/Firmware to be able to look inside them.

## Preparations: Dumping ACPI Tables
There are various ways of dumping ACPI Tables from your Firmware/BIOS. The most common way is to use either Clover or OpenCore:

- Using **Clover** (the easiest method): Hit `F4` in the Boot Menu. You don't even need a working configuration to do this. Just download the latest [**Release**](https://github.com/CloverHackyColor/CloverBootloader/releases) as a `.zip` file, extract it, put it on a FAT32 formatted USB flash drive and boot from it. The dumped ACPI Tables will be located in: `EFI\CLOVER\ACPI\origin`
- Using **OpenCore** (requires the Debug version and a working config): enable Misc > Debug > `SysReport` Quirk. The ACPI Tables will be dumped during next boot.

## Method 1: Dropping Tables based on OEM Tabled ID
This method is used to drop tables such as SSDTs and others which have a distinct OEM Table ID in the header to describe them. In this example we drop `CpuPm`.

- Open the Table you want to drop in maciASL and find its Table Signature and OEM Table ID:</br>
![Header](https://user-images.githubusercontent.com/76865553/140036308-a1abcdd2-ae38-49e7-9135-612e64e86ddf.png)
- Open your config.plist and a new rule under "ACPI" > "Delete"
- Add the discovered `TableSignature` (here "53534454" = "SSDT" in HEX) and `OEMTableID` (here "437075506D000000" = "CpuPm" in HEX) int the corresponding fields in HEX format. In OCAT, you can use the ASCII to HEX converter at the bottom of the app to do this:</br>
![DropCpuPM](https://user-images.githubusercontent.com/76865553/140036351-785f42b6-b0e6-43b3-9eb0-c6729c863a90.png)
- Enable the rule and save your config.plist.
- Reboot.

### Verifying that the table has been dropped
- Open maciASL
- Select "File" > "New from ACPI" 
- If you dropped the table successfully, "SSDT (CpuPm)" shouldn't be listed, unless you replaced it with a new table with the same OEM Table ID. If you created your own `SSDT-PM.aml` which is injected by OpenCore, this would be present, since it has the same OEM Table ID.

## Method 2: Dropping Tables based on Table Signature
For tables other than SSDTs, the OEM Table ID provided by the vendor isn't a reliable method to detect and drop a table because its OEM Table ID might contain a lot of blanks, for example `AMI____`. In this case, we use `Table Signature` and `Table Length` instead.

### Example 1: dropping the DMAR Table

On some Z490/Z590 boards (usually Gigabyte) for example, the presence of Reserved Memory Region(s) in the DMA Remapping Table (DMAR) in combination with disabled VT-d and/or `DisableIOMapper` Kernel Quirk render the dreaded on-board Intel(r) I225-V Ethernet Controller and PCIe Ethernet cards useless in macOS Monterey. In this case, DMAR has to be modified, VT-d enabled and `DisableIOMapper` disabled.

Therefore, you might consider dropping the DMAR table completely and/or replace it with a modified version.

- Open maciASL
- Select "File" > "New from ACPI"
- Pick `DMAR`
- Open the DMAR Table in maciASL and scroll to the end
- Copy the table length (in this case, `168`):</br>
	![Tlength](https://user-images.githubusercontent.com/76865553/139952797-38e332bc-3fed-450e-83fb-afa4a955a932.png)</br>
- Open your config and add a new rule under ACPI > delete.
- Enter `444D4152` (HEX for "DMAR") in `TableSignature`. If you use OCAT, you can use the ASCII to HEX converter at the bottom of the app:</br>
	![Drop](https://user-images.githubusercontent.com/76865553/139952827-a745cf27-a1f6-416e-ba0a-0ccab3c45884.png)</br>
- In `TableLength`, enter the Length listed in the DMAR Table. In this case `168`.
- Save the Config.
- Reboot.

### Verifying that the table has been dropped/deleted
After rebooting, do the following:

- Open maciASL
- Select "File" > "New from ACPI"
- If you dropped the table successfully, it shouldn't be listed. As you can see, it's not present:</br>
	![nodmar](https://user-images.githubusercontent.com/76865553/139952877-ef7d0f85-378d-4c6b-ac9a-efb7118ac4b6.png)</br>
- The table has been dropped successfully.

**NOTE**: If the table is still present, you either did something wrong or a table of the same name is present in ACPI folder and is injected by OpenCore.

### Example 2: replacing a dropped DMAR with a modified one
1. Drop the original table as explained in "Example 1"
2. Modify the same Table
3. Inject it with OpenCore

### Modifying a table
- Open the original DMAR Table
- In this case, we delete the Reserved Memory Regions Sections:</br>
	![Delmem](https://user-images.githubusercontent.com/76865553/139952931-70611f4e-0773-43a9-a1c7-90faef51703b.png)</br>
- Save the file as `DMAR.aml`. It has a new table length now (104).
- Put it in the ACPI Folder of OpenCore and add it to your `config.plist`.
- Save, reboot.

## Verifying that a Table has been replaced
- Open maciASL
- Select "File" > "New from ACPI"
- Pick `DMAR`. The file should be shorter in length than the original (in this case it's `104`) and should no longer contain Reserved Memory Regions:</br>
	![DMARnu](https://user-images.githubusercontent.com/76865553/148192464-230e64c0-7817-4a83-b54d-c7d1f3e7adb6.png)

## Note
You should only import tables with maciASL if you know these are not patched ones. Otherwise, dump the ACPI Tables from the Clover boot menu using `F4`.
