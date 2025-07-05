# Merging SSDT Hotpatches into one file

## Overview
You can use this guide to merge all (or some) of your SSDT Hotpatches into one SSDT semi-automatically. With this approach, you lose all the modularity individual SSDTs provide – either *all* patches are active or *none*, which makes it harder to troubleshoot. So you should only consider doing this if your ACPI tables work correctly and don't contain any errors. 

But even then it's not guaranteed that the system will boot afterwards. In my tests, I got mixed results: the all-in-one SSDT worked fine on my Laptop but my Desktop wouldn't boot with it. Even disabling automatic Compiler "Optimizations" couldn't fix this. So this method has to be regarded as "experimental". I am not really a fan of it but it exists and if you want to try it, this is how it's done.

Before attempting this, you should also consider which SSDTs to merge together. It doesn't make much sense to include SSDTs for the CPU and 3rd party devices that are not part of the stock system configuration if you want to share your EFI folder with others!

## Preparations
- Download [**Xiasl**](https://github.com/ic005k/Xiasl/releases) and unzip it. We need it to automatically batch convert `.aml` into `.dsl` files.
- Right-click on the App and select "Show Package Contents"
- Copy the `iasl` file located under `/Contents/MacOS/` to memory (CMD+C)
- In Finder, press <kbd>CMD</kbd><kbd>Shift</kbd><kbd>.</kbd> to show hidden files and folders.
- Navigate to `/usr/local/bin/` and paste the `iasl` file. We need it there for running iasl in Terminal
- Press <kbd>CMD</kbd><kbd>Shift</kbd><kbd>.</kbd> again, to mask hidden files and folders again.
- Mount your EFI partition and copy the `EFI/OC/ACPI` folder to your desktop.
- Unmount your EFI so you don't accidentally ruin your working ACPI tables.

## Batch decompiling .aml files
- Run Xiasl
- Open Preferences
- Check "Batch decompilation"
- Open one of the .aml files in the ACPI folder
- This will batch decompile all the files to `.dsl` automatically:</br>![xiasl01](https://user-images.githubusercontent.com/76865553/176115267-d5c224ba-58f4-4fb5-a317-d0029e7dc5a1.png)

> [!NOTE]
> 
> If someone knows if maciASL supports batch conversion, please let me know.

## Modifying the .dsl files
- Delete the `DefinitionBlock` (curly brackets of the 1st level included) from each table:</br>**Before**:</br>![xiasl02](https://user-images.githubusercontent.com/76865553/176115380-29d3cd77-eff8-45f0-863a-e22b25f0f8a7.png)</br>**After**:</br>![xiasl03](https://user-images.githubusercontent.com/76865553/176115472-5285e051-bf6b-4cf7-b6ec-533fef2c6136.png)
- Save the file(s) (CMD+S)

## Picking SSDTs to merge into one file
- Create a new file in Xiasl
- Paste the following Code into it:	
	```asl
	DefinitionBlock("", "SSDT", 2, "AUTHOR", "HACKSSDT", 0)
	{
    	#include "SSDT-.dsl"
	}
	```
- Change "Author" to a different name (ideally, use four letters only)
- Change the OEM Table ID ("HACKSSDT") to something else (ideally, use four letters only). I am using "T530" since this is my Laptop Model.
- List all the SSDTs which should be included in the new SSDT:</br>![xiasl04](https://user-images.githubusercontent.com/76865553/176115532-81d5fe93-70b7-485d-9b8e-d6bfb7b91d96.png)
- Save the file as `SSDT-ALL.dsl` to Desktop/ACPI

:bulb: **Tip**: Select all `.aml` files in Finder, copy and paste them into the Editor to bring in the file names (avoids typos).

### :warning: Tables to exclude from the list 
Don't merge the following tables into the SSDT-ALL file if you plan to share your EFI and config online:

- SSDTs related to CPU Power Management, such as: `SSDT-PM` (for Sandy/Ivy Bridge) and `SSDT-PLUG` – especially if they contain Frequency Vectors for specific CPUs
- Any SSDT for 3rd party devices which are not part of the default configuration of the system
- Any other ACPI Table which is **NOT** an SSDT! These are separate entities!
- Add excluded SSDTs as separate, individual files to the `EFI/OC/ACPI` folder instead.

## Compiling the new, unified SSDT
1. Open Terminal
2. Enter `cd desktop/ACPI`
3. Next, enter `iasl SSDT-ALL.dsl` (to disable Compiler Optimizations, use `iasl -oa SSDT-ALL.dsl` instead).

This will merge all the listed files into a new `SSDT-ALL.aml` file, containing all the content of the included SSDTs:</br>![xiasl06](https://user-images.githubusercontent.com/76865553/176115651-a23562bd-8271-4490-965b-6521fd0abbe0.png)

## Adding `SSDT-ALL.aml` to EFI and Config
:warning: Have a working backup of your EFI folder on a FAT32 formatted USB flash drive just in case the system won't boot 

- Mount your EFI partition
- Add `SSDT-ALL.aml` to your ACPI folder and config (in OCAT, you can just drag and drop it in the ACPI section)
- Deactivate all other `.aml` files which are included in SSDT-ALL already.
- Leave the ones enabled which are not included in SSDT-ALL (like SSDT-PLUG or SSDT-PM)
- Save and reboot

## Troubleshooting
In cases where you're getting compiler errors like "Existing object has invalid type for Scope operator (_SB.PCI0 [Untyped])", add it as an "External" reference as shown below:</br>![xiasl05](https://user-images.githubusercontent.com/76865553/176115716-3fd315ae-43ef-4f06-8dcf-a3ddf7a933bc.png)

## Notes
- After merging your SSDTs into a new file, you may notice that the resulting table is not organized well in terms of the tree stucture. Manually edit the file to clean it up and reduce clutter.
- Maybe sorting the SSDTs based on their PCI paths prior to merging them results in a cleaner output.
- If you know a method to improve the merging process so that everything is organized perfectly, let me know.

## Credits & Resources
- [ASL Compiler User Reference](https://www.acpica.org/sites/acpica/files/aslcompiler_11.pdf) (PDF)
- [dreamwhite](https://github.com/dreamwhite/dreamwhite) for the suggesting the "#include" method and compiler instructions
- [ic005k](https://github.com/ic005k) for Xiasl
