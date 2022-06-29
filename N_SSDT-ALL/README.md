# Merging all SSDT Hotpatches into one file
You can use this guide to combine all of your SSDT Hotpatches into one big file. With this approach, you lose all the modularity which indvidual SSDTs provide – either *all* patches are active or *none*. You should only consider doing this if all your ACPI tables don't contain any errors and are working correctly.

In my tests, using a combined, unified SSDT slowed down boot times noticeably. It's also harder to troubleshoot errors this way. All in all, I am not a fan of this method but it exist and if you want to use it, this is how it's done.

## Preparations
- Download [**Xiasl**](https://github.com/ic005k/Xiasl/releases) and unzip it. We need it for batch convert `.aml` files to `.dsl`.
- Right-click on the App and select "Show Pachage Contents"
- Copy the `iasl` file located under `/Contents/MacOS/` to memory (CMD+C)
- In Finder, press `CMD+SHIFT+.` to show hidden files and folders.
- Navigate to `/usr/local/bin/` and paste the `iasl` file. We need it there for running iasl in Terminal
- Press `CMD+SHIFT+.` again, to mask hidden files and folders again.
- Mount your EFI partition and copy the `EFI/OC/ACPI` folder to your desktop
- Unmount your EFI so you don't accidentally ruin your working ACPI tables

## Batch decompiling .aml files
- Run Xiasl
- Open Preferences
- Check "Batch decompilation"
- Open one of the .aml files in the ACPI folder
- This will batch decompile all the files to `.dsl` automatically:</br>![xiasl01](https://user-images.githubusercontent.com/76865553/176115267-d5c224ba-58f4-4fb5-a317-d0029e7dc5a1.png)

**NOTE**: If someone knows if maciASL supports batch conversion, please let me know.

## Modifying the .dsl files
- Delete the `DefinitionBlock` (curly brackets of the 1st level included) from each table:</br>**Before**:</br>![xiasl02](https://user-images.githubusercontent.com/76865553/176115380-29d3cd77-eff8-45f0-863a-e22b25f0f8a7.png)</br>**After**:</br>![xiasl03](https://user-images.githubusercontent.com/76865553/176115472-5285e051-bf6b-4cf7-b6ec-533fef2c6136.png)
- Save the file(s) (CMD+S)

## Picking SSDTs to merge into one files
- Create a new file in Xiasl
- Paste the following Code into it:	
	```
	DefinitionBlock("", "SSDT", 2, "AUTHOR", "HACKSSDT", 0)
	{
    	#include "SSDT-.dsl"
	}
	```
- Change "Author" to a different name (ideally, use four letters only)
- Change the OEM Table ID ("HACKSSDT") to something else (ideally, use four letters only). I am using "T530" since this is my Laptop Model.
- List all the SSDTs which should be included in the new SSDT:</br>![xiasl04](https://user-images.githubusercontent.com/76865553/176115532-81d5fe93-70b7-485d-9b8e-d6bfb7b91d96.png)
- Save the file as `SSDT-ALL.dsl` to Desktop/ACPI

### :warning: The following SSDTs should be excluded from the List 
Don't merge the following tables into the SSDT-ALL file if you plan to share your EFI and Config online:

- SSDTs related to CPU Power Management, such as: `SSDT-PM` (for Sandy/Ivy Bridge) and `SSDT-PLUG` – especially if they contain Frequency Vectors for specific CPUs
- Any SSDT for 3rd party devices which are not part of the default configuration of Mainboard/Laptop
- Include these SSDTs as individual files

## Compiling the new, unified SSDT
1. Open Terminal
2. Enter `cd desktop/ACPI`
3. Next, enter `iasl SSDT-ALL.dsl`

This will merge all the listed files into a new `SSDT-ALL.aml` file, containing all the content of the included SSDTs:</br>![xiasl06](https://user-images.githubusercontent.com/76865553/176115651-a23562bd-8271-4490-965b-6521fd0abbe0.png)

## Adding SSDT-ALL.aml to EFI and Config
:warning: Have a working backup of your EFI folder on a FAT32 formatted USB flash drive just in case the system won't boot 

- Mount your EFI partition
- Add `SSDT-ALL.aml` to your ACPI folder anad config (in OCAT, you can just drag and drop it in the ACPI section)
- Deactivate all other `.aml` files which are included in SSDT-ALL already.
- Leave the ones enabled which are not included in SSDT-ALL (like SSDT-PLUG or SSDT-PM)
- Save and reboot

## Troubleshooting
In cases where you're getting compiler errors like "Existing object has invalid type for Scope operator (_SB.PCI0 [Untyped])", add it as an "External" reference as shown below:</br>![xiasl05](https://user-images.githubusercontent.com/76865553/176115716-3fd315ae-43ef-4f06-8dcf-a3ddf7a933bc.png)

## Credits
- [ic005k](https://github.com/ic005k) for Xiasl
- [dreamwhite](https://github.com/dreamwhite/dreamwhite) for the "#include" method and compiler instructions
