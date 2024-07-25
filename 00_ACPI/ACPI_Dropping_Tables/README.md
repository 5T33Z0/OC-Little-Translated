# Dropping ACPI Tables
Sometimes ACPI Tables provided with your Firmware/BIOS might hinder some features or devices to work properly in macOS. Boot managers like Clover and OpenCore provide means to block certain tables from loading or to replace them. In order to do so, you need to know the Tables Signature, OEM Table ID and/or Table Length. Therefore, you need to extract ("dump") the ACPI tables from your BIOS/Firmware to analyze them.

**TABLE of CONTENTS**

- [Preparations: Dumping the ACPI Tables](#preparations-dumping-the-acpi-tables)
- [Method 1: Dropping Tables based on OEM Tabled ID](#method-1-dropping-tables-based-on-oem-tabled-id)
  - [Verifying that the table has been dropped](#verifying-that-the-table-has-been-dropped)
  - [Note: Dropping "internal" tables that load other tables](#note-dropping-internal-tables-that-load-other-tables)
- [Method 2: Dropping Tables based on Table Signature](#method-2-dropping-tables-based-on-table-signature)
  - [Example 1: dropping the `DMAR` Table](#example-1-dropping-the-dmar-table)
    - [Verifying that the table has been dropped/deleted](#verifying-that-the-table-has-been-droppeddeleted)
  - [Example 2: replacing the `DMAR` table by a modified one](#example-2-replacing-the-dmar-table-by-a-modified-one)
    - [Verifying that the `DMAR` Table has been replaced](#verifying-that-the-dmar-table-has-been-replaced)

## Preparations: Dumping the ACPI Tables
There are various ways of dumping ACPI Tables from your Firmware/BIOS. The most common way is to use either Clover or OpenCore:

- Using **Clover** (the easiest method): Hit `F4` in the Boot Menu. You don't even need a working configuration to do this. Just download the latest [**Release**](https://github.com/CloverHackyColor/CloverBootloader/releases) as a `.zip` file, extract it, put it on a FAT32 formatted USB flash drive and boot from it. The dumped ACPI Tables will be located in: `EFI/CLOVER/ACPI/origin`
- Using **OpenCore** (requires the Debug version and a working config): enable `Misc/Debug/SysReport` Quirk. The ACPI Tables will be dumped during next boot.

## Method 1: Dropping Tables based on OEM Tabled ID
This method is used to drop tables such as SSDTs and others which have a *distinct* OEM Table ID in the header to describe them. In this example we drop `CpuPm`.

- Open the Table you want to drop in maciASL and find its Table Signature and OEM Table ID:</br>
![Header](https://user-images.githubusercontent.com/76865553/140036308-a1abcdd2-ae38-49e7-9135-612e64e86ddf.png)
- Open your config.plist and a new rule under "ACPI" > "Delete"
- Add the discovered `TableSignature` (here "53534454" = "SSDT" in HEX) and `OEMTableID` (here "437075506D000000" = "CpuPm" in HEX) into the corresponding fields in HEX format. In OCAT, you can use the ASCII to HEX converter at the bottom of the app to do this:</br>
![DropCpuPM](https://user-images.githubusercontent.com/76865553/140036351-785f42b6-b0e6-43b3-9eb0-c6729c863a90.png)
- Enable the rule and save your config.plist.
- Reboot.

### Verifying that the table has been dropped
- Open maciASL
- Select "File" > "New from ACPI" 
- If you dropped the table successfully, "SSDT (CpuPm)" shouldn't be listed, unless you replaced it with a new table with the same OEM Table ID. If you created your own `SSDT-PM.aml` which is injected by OpenCore, this would be present, since it has the same OEM Table ID.

### Note: Dropping "internal" tables that load other tables
Some SSDTs are "internal" tables that will only provide data to the primary or parent table that references them. If you drop the primary table, then the referenced secondary table(s) will not be loaded. 

:bulb: Therefore, you don't need to create additional drop rules to drop these tables. If you still try to drop these "internal" tables which are not visible to the system – since they are not referenced in either the Root (`RSTD`) or Extended System Description Table (`XSTD`) – you will receive an error message from OpenCore:

```text
OC: Failed to drop ACPI … – Not Found
```
**Example**:

Sometimes, you can already guess by the name of the tables alone which ones are subsequent tables to others. Look at this screenshot:

![SubTables](https://user-images.githubusercontent.com/76865553/190889943-a3375ae1-a27f-4391-a21a-96cbdbf0a435.png)

`SSTD-4-CpuPM` is followed by `SSDT-x4_0…`, `SSDT-x4_1…` and `SSDT-x4_2…` which indicates some type of hierarchy in regards to `SSDT-4…`.

And if we have a look inside `SSTD-4-CpuPM`, you find the references:

```asl
Scope (\)
    {
        Name (SSDT, Package (0x0C)
        {
            "CPU0IST ",
            0xD3322018, 
            0x00000C31, 
            "APIST   ", // Reference to SSDT-x4_0-ApIst
            0xDAE3DA98, 
            0x00000303, 
            "CPU0CST ", // Reference to SSDT-x4_1-Cpu0Cst
            0xDAE3C018, 
            0x00000A01, 
            "APCST   ", // Reference to SSDT-x4_2-ApCst
            0xDAE3BD98, 
            0x00000119
        })
```
Find out more about "internal" tables [**here**](https://github.com/acidanthera/bugtracker/issues/969)

## Method 2: Dropping Tables based on Table Signature
For tables other than SSDTs, OEM Table ID isn't a reliable source to detect and drop a table by because (based on vendor) the OEM Table IDs may only contain some letters followed by a lot of blanks or underscores, for example `AMI____`. In this case, we use the `Table Signature` and `Table Length` instead to clearly identify the table.

### Example 1: dropping the `DMAR` Table
On some Z490/Z590 boards (e.g. Gigabyte), the presence of Reserved Memory Regions in the DMA Remapping Table (`DMAR`) in combination with disabled VT-d and/or `DisableIOMapper` Kernel Quirk render the dreaded on-board Intel(r) I225-V Ethernet Controller and PCIe Ethernet cards useless in macOS Monterey and newer. In this case, `DMAR` has to be modified, VT-d enabled in BIOS and `DisableIOMapper` disabled.

Therefore, you might consider dropping the `DMAR` table completely and/or replace it with a modified version. Here's how you do it:

- Open maciASL
- Select "File" > "New from ACPI"
- Pick `DMAR`
- Open the DMAR Table in maciASL and scroll to the end
- Copy the table length (in this case, `168`):</br>
	![Tlength](https://user-images.githubusercontent.com/76865553/139952797-38e332bc-3fed-450e-83fb-afa4a955a932.png)</br>
- Open your config and add a new rule under ACPI/Delete.
- Enter `444D4152` (HEX for "DMAR") in `TableSignature`. If you use OCAT, you can use the ASCII to HEX converter at the bottom of the app:</br>
	![Drop](https://user-images.githubusercontent.com/76865553/139952827-a745cf27-a1f6-416e-ba0a-0ccab3c45884.png)</br>
- In `TableLength`, enter the Length listed in the DMAR Table. In this case `168`.
- Save the Config.
- Reboot.

#### Verifying that the table has been dropped/deleted
After rebooting, do the following:

- Open maciASL
- Select "File" > "New from ACPI"
- If you dropped the table successfully, it shouldn't be listed. As you can see, it's not present:</br>
	![nodmar](https://user-images.githubusercontent.com/76865553/139952877-ef7d0f85-378d-4c6b-ac9a-efb7118ac4b6.png)</br>
- The DMAR table has been dropped successfully. If it's table is still present, you either did something wrong or a table of the same name is present in OpenCore's ACPI folder and is injected by OpenCore.

### Example 2: replacing the `DMAR` table by a modified one
- Dump the ACPI Tables as explained at the beginning
- Drop the OEM `DMAR` table as explained in [Example 1](#example-1-dropping-the-dmar-table)
- Modify the OEM `DMAR` Table:
	- Open it in maciASL
	- In this case we delete the `Reserved Memory Regions`:</br>
	![Delmem](https://user-images.githubusercontent.com/76865553/139952931-70611f4e-0773-43a9-a1c7-90faef51703b.png)</br>
- Save the file as `DMAR.aml`. It should have a new table length now (104).
- Put it in the `EFI/OC/ACPI` and add it to your `config.plist`.
- Save and reboot.

This will disable the OEM DMAR table and inject the modified one instead but we need to check if it worked. If you are scared editing the DMAR table yourself, you can also use SSDTTime for this now, too.

> [!IMPORTANT]
>
> I've noticed that macOS 14.2 crashes on my Z490 system if a Reserved Memory Region for the `XHCI` Controller is present in the OEM DMAR Table (cross-reference PCI paths to figure out which memory region is for what). In this case, drop and replace the OEM `DMAR` table by a modified one without reserved memory regions to resolve the issue!

#### Verifying that the `DMAR` Table has been replaced
- Open maciASL
- Select "File" > "New from ACPI"
- Pick `DMAR`. The file should be shorter in length than the original (in this case it's `104`) and should no longer contain Reserved Memory Regions (which it doesn't in this case):</br>
	![DMARnu](https://user-images.githubusercontent.com/76865553/148192464-230e64c0-7817-4a83-b54d-c7d1f3e7adb6.png)

## NOTES
- OpenCore 0.9.2 introduced a new Kernel Quirk called [`DisableIoMapperMapping`](https://github.com/acidanthera/bugtracker/issues/2278#issuecomment-1542657515) which can be used to address new connectivity issues in macOS 13.3+ (if they weren't present before).
- You should only import ACPI tables with maciASL if you know that they are unmodified by OpenCore. Otherwise, dump the OEM ACPI Tables using the debug version of OpenCore and enabling the `SysReport` Quirk and work with those.
