# CPU Power Management for legacy Intel CPUs (`SSDT-PM`)

## About
SSDT for enabling CPU Power Management on legacy Intel CPUs (Ivy Bridge and older). 

You can tell if the CPU Power Management is working correctly or not by monitoring the behavior of the CPU. You can use [Intel Power Gadget](https://www.intel.com/content/www/us/en/developer/articles/tool/power-gadget.html) to do so. If the CPU always runs at the same frequency and doesn't drop in idle or if does never reach the specified turbo frequency when performing cpu-intense tasks, then you have an issue with CPU Power Management at hand. Since this not only affects the overall performance but sleep/hibernation as well, it's mandatory to get it working properly. 

##  ACPI Power Management vs. XNU CPU Power Management
Up to Big Sur, macOS supports two plugins for handling CPU Power Management: 

- `ACPI_SMC_PlatformPlugin` (plugin-type=0) &rarr; For Ivy Bridge (3rd Gen) and older Intel CPUs
- `X86PlatformPlugin` (plugin-type=1) &rarr; Enables XCPM (= XNU CPU Power Management) on Haswell (4th Gen) and newer CPUs

### XCPM (= XNU CPU Power Management)

For Haswell and newer, you simple add [**`SSDT-PLUG`**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management_(SSDT-PLUG)) to enable `plugin-type 1` (aka the `X86PlatformPlugin`), which then takes care of CPU Power Management by using the `FrequencyVectors` provided by the selected SMBIOS (or more specifically, the board-id).

<details>
<summary><strong>Additional info</strong> (click to reveal)</summary>

Prior to macOS 10.13, the boot-arg `-xcpm` could be used to enable XCPM on unsupported CPUs. This stopped working after 10.12. Since then, SSDT-PLUG has to be used to enable it. Although the Ivy Bridge CPU family is capable of using XCPM it has been dropped from macOS. But you can [force-enable it](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Xtra_Enabling_XCPM_on_Ivy_Bridge_CPUs).

On macOS Monterey and newer, the `ACPI_SMC_PlatformPlugin` has been dropped completely and the `X86PlatformPlugin` is always loaded since Apple disabled the `plugin-type` check, so you don't even need `SSDT-PLUG` in this case. You also don't need`SSDT-PLUG` if you are using the CPUFriend and CPUFriendDataProvider.kext to modify the CPU Power Management since it enables the X86PlatformPlugin on its own.
</details>

### ACPI Power Management

For Ivy Bridge and older, you have to create an SSDT which includes the power and turbo states of the CPU which are then injected into macOS via ACPI so that the `ACPI_SMC_PlatformPlugin` has the correct data to work with. That's why this method is also referred to as "ACPI Power Management". You have to use [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) to generate this table, which is now called `SSDT-PM`. In the early days of hackintoshing when you had to use a patched DSDT to run macOS since hotpatching wasn't a thing yet, this table was simply named and referred to as "SSDT" since it usually was the only one injected into the system besides the DSDT.

Although ssdtPRGen supports Sandy Bridge to Kabylake CPUs, nowadays it's only used for 1st to 3rd Gen Intel CPUs.

## Prerequisites

- Mount your EFI folder
- Open your config.plist
- Under `ACPI/Delete`, enable the following drop rules (if they don't exist, copy them over from the `Sample.plist` included in the OpenCore Package):
	- `Delete CpuPm`
	- `Delete Cpu0Ist`
- Save and reboot.

## Instructions

- Open Terminal
- Enter the following command to download the ssdtPRGen Script: `curl -o ~/ssdtPRGen.sh https://raw.githubusercontent.com/Piker-Alpha/ssdtPRGen.sh/Beta/ssdtPRGen.sh`
- Next, enter `chmod +x ~/ssdtPRGen.sh` to make it executable
- Now, run the script: `sudo ~/ssdtPRGen.sh`
- The generated `SSDT.aml` will be located at `/Users/YOURUSERNAME/Library/ssdtPRGen`
- Rename it to `SSDT-PM.aml` 
- Copy it to `EFI/OC/ACPI` and list it in the `ACPI/Add` section of your config.plist
- Under `ACPI/Delete`, disable `Delete CpuPm` and `Delete Cpu0Ist`
- Save the config and reboot

Monitor the behavior of the CPU in Intel Power Gadget. Check if it is stepping though different frequencies. If the CPU is reacting to your usage of the system and if it reaches the defined lower and upper frequency limits, then CPU Power Management is working correctly. 

## NOTES

- ssdtPRGen includes lists with settings for specific CPU models sorted by CPU families. These can be found under /Users/YOURUSERNAME/Library/ssdtPRGen/Data. They are in .cfg format which can be viewed with TextEdit.
- If your CPU is listed in one of these .cfg files, you can generate a SSDT-PM for your specific CPU model. Enter: `sudo ~/ssdtPRGen.sh -p 'MODELNAME'` (for example `'i7-3630QM'`). The advantage of generating the SSDT-PM that it includes additional info and workarounds for the CPU
- ssdtPRGen also has additional modifiers which. Check the ["Help"](https://github.com/Piker-Alpha/ssdtPRGen.sh#help-information) section of his repo for details. You can experiment with those but make sure to have a working backup of you EFI folder on a FAT32 formatted USB flash drive at hand – just in case the system won't boot afterwards.

## Credits
- Intel for Intel Power Gadget
- Piker Alpha for ssdtPRGen
