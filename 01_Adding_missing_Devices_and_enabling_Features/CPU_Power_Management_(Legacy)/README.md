# CPU Power Management for legacy Intel CPUs (`SSDT-PM`)

## About
SSDT for enabling CPU Power Management on legacy Intel CPUs (Ivy Bridge and older). 

You can tell if the CPU Power Management is working correctly or not by monitoring the behavior of the CPU. You can use [Intel Power Gadget](https://www.intel.com/content/www/us/en/developer/articles/tool/power-gadget.html) to do so. If the CPU always runs at the same frequency and doesn't drop in idle or if does never reach the specified turbo frequency when performing cpu-intense tasks, then you have an issue with CPU Power Management at hand. Since this not only affects the overall performance but sleep/hibernation as well, it's mandatory to get it working properly. 

##  ACPI Power Management vs. X86Platform Plugin
Up to Big Sur, macOS supports two plugins for handling CPU Power Management: 

- `ACPI_SMC_PlatformPlugin` (for Ivy Bridge (3rd Gen) and older Intel CPUs)
- `X86PlatformPlugin` (for Haswell (4th Gen) and newer)

For Haswell and newer, you simple add [**`SSDT-PLUG`**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management_(SSDT-PLUG)) to enable the `X86PlatformPlugin` which then takes care of CPU Power Management. 

On macOS Monterey and newer, the `ACPI_SMC_PlatformPlugin` has been dropped and the `X86PlatformPlugin` is always enabled since Apple disabled the `plugin-type` check, so you don't even need `SSDT-PLUG` nowadays.

On older platforms however, you have to create an SSDT which includes the power and turbo states of the CPU which are then injected into macOS via ACPI. That's why this method is also referred to as "ACPI Power Management". You have to use [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) to generate this table, which is now called `SSDT-PM`. Although ssdtPRGen supports Sandy Bridge to Kabylake CPUs, nowadays it's only used for 1st to 3rd Gen Intel CPUs.

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

## Notes

- ssdtPRGen includes lists with settings for specific CPU models sorted by CPU families. These can be found under /Users/YOURUSERNAME/Library/ssdtPRGen/Data. They are in .cfg format which can be viewed with TextEdit.
- If your CPU is listed in one of these .cfg files, you can generate a SSDT-PM for your specific CPU model. Enter: `sudo ~/ssdtPRGen.sh -p 'MODELNAME'` (for example `'i7-3630QM'`). The advantage of generating the SSDT-PM that it includes additional info and workarounds for the CPU
- ssdtPRGen also has additional modifiers which. Check the ["Help"](https://github.com/Piker-Alpha/ssdtPRGen.sh#help-information) section of his repo for details. You can experiment with those but make sure to have a working backup of you EFI folder on a FAT32 formatted USB flash drive at hand – just in case the system won't boot afterwards.
