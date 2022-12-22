CPU Power Management for legacy Intel CPUs (`SSDT-PM`)

**TABLE of CONTENTS**

- [About](#about)
- [ACPI Power Management vs. XNU CPU Power Management](#acpi-power-management-vs-xnu-cpu-power-management)
	- [XCPM (= XNU CPU Power Management)](#xcpm--xnu-cpu-power-management)
	- [ACPI Power Management](#acpi-power-management)
- [Prerequisites](#prerequisites)
- [Instructions](#instructions)
	- [macOS Ventura and Ivy Bridge](#macos-ventura-and-ivy-bridge)
- [Modifiers](#modifiers)
- [Notes](#notes)
- [Credits](#credits)

## About
SSDT for enabling CPU Power Management on legacy Intel CPUs (Ivy Bridge and older). 

You can tell whether or not the CPU Power Management is working correctly by monitoring the behavior of the CPU. You can use [Intel Power Gadget](https://www.intel.com/content/www/us/en/developer/articles/tool/power-gadget.html) to do so. If the CPU always runs at the same frequency and doesn't drop in idle or if does never reach the turbo frequency specified for your CPU model when performing cpu-intense tasks, then you have an issue with CPU Power Management at hand. Since this not only affects the overall performance but sleep/hibernation as well, it's mandatory to get it working properly. 

## ACPI Power Management vs. XNU CPU Power Management
Up to Big Sur, macOS supports two plugins for handling CPU Power Management: 

- `ACPI_SMC_PlatformPlugin` (plugin-type=0) &rarr; For Ivy Bridge (3rd Gen) and older Intel CPUs
- `X86PlatformPlugin` (plugin-type=1) &rarr; Enables XCPM (= XNU CPU Power Management) on Haswell (4th Gen) and newer

### XCPM (= XNU CPU Power Management)

Prior to the release of macOS 10.13, boot-arg `-xcpm` could be used to enable XCPM for unsupported CPUs. Since then, the boot-arg does no longer work. So for Haswell and newer, you simple add [**`SSDT-PLUG`**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management_(SSDT-PLUG)) to enable `plugin-type 1` (aka the `X86PlatformPlugin`), which then takes care of CPU Power Management using the `FrequencyVectors` provided by the selected SMBIOS (or more specifically, the board-id).

Although the Ivy Bridge CPU family is totally capable of utilizing XCPM, it has been disabled in macOS for a long time (since OSX 10.11?). But you can [force-enable](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Xtra_Enabling_XCPM_on_Ivy_Bridge_CPUs) it. 

On macOS Monterey and newer, the `ACPI_SMC_PlatformPlugin` has been dropped completely. Instead, the `X86PlatformPlugin` is now always loaded automatically, since Apple disabled the `plugin-type` check, so you don't even need `SSDT-PLUG` for Haswell and newer.

### ACPI Power Management

For Ivy Bridge and older, you have to create an SSDT containing the power and turbo states of the CPU which are then injected into macOS via ACPI so that the `ACPI_SMC_PlatformPlugin` has the correct data to work with. That's why this method is also referred to as "ACPI CPU Power Management". 

You have to use [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) to generate this table, which is now called `SSDT-PM`. In the early days of hackintoshing, when you had to use a patched DSDT to run macOS since hotpatching wasn't a thing yet, this table was simply referred as "SSDT.aml" since it usually was the only SSDT injected into the system besides the DSDT.

Although **ssdtPRGen** supports Sandy Bridge to Kabylake CPUs, it's only used for 2nd and 3rd Gen Intel CPUs nowadays. It might still be useful on Haswell and newer when working with unlocked, overclockable "k" variants of Intel CPUs which support the `X86PlatfromPlugin` to optimize performance (&rarr; see "Modifiers" section for details).

## Prerequisites

- Mount your EFI folder
- Open your `config.plist`
- Under `ACPI/Delete`, enable the following drop rules (if they don't exist, copy them over from the `Sample.plist` included in the OpenCore Package):
	- `Delete CpuPm`
	- `Delete Cpu0Ist`
- Save and reboot.

## Instructions

- Open Terminal
- Enter the following command to download the ssdtPRGen Script: `curl -o ~/ssdtPRGen.sh https://raw.githubusercontent.com/Piker-Alpha/ssdtPRGen.sh/Beta/ssdtPRGen.sh`
- Make it executable: `chmod +x ~/ssdtPRGen.sh` 
- Run the script: `sudo ~/ssdtPRGen.sh`
- The generated `SSDT.aml` will be located at `/Users/YOURUSERNAME/Library/ssdtPRGen`
- Rename it to `SSDT-PM.aml` 
- Copy it to `EFI/OC/ACPI` and list it in the `ACPI/Add` section of your config.plist
- Under `ACPI/Delete`, disable `Delete CpuPm` and `Delete Cpu0Ist`
- Save the config and reboot

Monitor the behavior of the CPU in [**Intel Power Gadget**](https://www.intel.com/content/www/us/en/developer/articles/tool/power-gadget.html). Check if it is stepping though different frequencies. If the CPU is reacting to your usage of the system and if it reaches the defined lower and upper frequency limits, then CPU Power Management is working correctly.

### macOS Ventura and Ivy Bridge

With the release of macOS Ventura, Apple removed the actual `ACPI_SMC_PlatformPlugin` *binary* from the `ACPI_SMC_PlatformPlugin.kext` itself (previously located under `S/L/E/IOPlatformPluginFamily.kext/Contents/PlugIns/ACPI_SMC_PlatformPlugin.kext/Contents/MacOS/`), rendering SSDT-PM generated for 'plugin-type' 0 useless, since it can no longer attach to the now missing plugin. Therefore, CPU Power Management won't work correctly (no turbo states). 

So when switching to macOS Ventura, force-enabling XCPM and re-generating your `SSDT-PM` for 'plugin type' 1 is mandatory in order to get proper CPU Power Management. 

## Modifiers
Besides simply generating the ssdt by running the script, you can add modifiers to the terminal command. Although the ssdtPRGen repo lists a bunch of [overrides](https://github.com/Piker-Alpha/ssdtPRGen.sh#help-information), it doesn't go into detail about how and when to use them.

Fortunately, you can enter `sudo ~/ssdtPRGen.sh -h` to display the "Help" menu which lists all the available commands. The actual letter(s) you have to enter to execute one of them are highlighted in **bold**.

Here's a table of modifiers which can be combined. Use `ark.intel.com` to look-up the specs of your CPU.

Modifier | Description/Example
:-------:|--------------------
`-p 'CPU model'` | Add your CPU model if it is listed in the `.cfg` file located inside the `ssdtPRGen/Data` folder. The config files are organized by Intel CPU families and contain data like model, TDP and frequencies. The advantage of generating the SSDT-PM that it includes additional info and workarounds for the CPU. It's also useful for generating a SSDT-PM for someone else who uses a different CPU. You can also add missing CPU data to `User Defined.cfg` </br></br> **Example**: `sudo ~/ssdtPRGen.sh -p 'i7-3630QM'`
`-target X` | Target Intel CPU family, where `X` stands for a number from  0 to 5: </br></br> 0 = Sandy Bridge </br> 1 = Ivy Bridge </br> 2 = Haswell </br> 3 = Broadwell </br> 4 = Skylake </br> 5 = Kabylake</br></br> **Example**: `sudo ~/ssdtPRGen.sh -target 1`
`-c X` | Compatibility workarounds, where `X` must be a number between 0 to 3. </br></br> 0 = No workarounds </br> 1 = Inject extra (turbo) P-State at the top with maximum (turbo) frequency + 1 MHz</br> 2 = Inject extra P-States at the bottom</br> 3 = Both </br></br> **Example**: `sudo ~/ssdtPRGen.sh -c 3`
`-x Y`| Enables/Disables XCPM mode (Plugin Type), where `Y` can be:</br></br> `0` = XCPM disabled </br>`1` = XCPM enabled </br> </br> **Example**: `sudo ~/ssdtPRGen.sh -x 1`
`-d X` | Debug output, where `X` must be a number from 0 to 3.</br></br> 0 = No debug injection/debug output</br> 1 = Inject debug statements in: ssdt_pr.dsl </br> 2 = Show debug output </br> 3 = Both</br></br> **Example**: `sudo ~/ssdtPRGen.sh -d 1`
`-lfm` | Sets the Low frequency mode in mHz. Describes the lowest frequency a CPU can clock down to. Very useful for laptops and saving energy in general. Add the corresponding frequency as a number as shown in the example. If you set the LFM too low, the system will crash on boot. In my experience, 900 mHz is a stable value, which is about 300 mHz lower than stock for the i7-3630QM I am using in my laptop. </br></br> **Example**: `sudo ~/ssdtPRGen.sh -lfm 900`
`-turbo` | Sets the Maximum Turbo Frequency supported by the CPU in mHz. Add the frequency to the command as shown in the example. If your CPU is included in one of the .cfg files, then you don't have to set this since it already contains the correct value. </br></br> **Example**: `sudo ~/ssdtPRGen.sh -turbo 3000`
`-bclk` | Sets the base clock (or bus frequency) in mHz of the CPU. The default is 100 mHz and you really shouldn't mess with this at all since it influences CPU multipliers and can cause instabilities of the system.</br></br>**Example**: `sudo ~/ssdtPRGen.sh -bclk 133`
`-f` | Sets the clock frequency of the CPU in mHz (the one before the turbo). You shouldn't really mess with that as well.</br></br> **Example**: `sudo ~/ssdtPRGen.sh -f 2333`
`-m` | Add model (Board-id). I guess this is useful when generating SSDTs for PluginType 1 which extracts the frequency vectors from the SMBIOS of the selected Mac model. </br></br>**Example**: `sudo ~/ssdtPRGen.sh -m MacBookPro10,1`
`-b` | Add specific Board-ID. Useful if you want to use frequency vectors from the SMBIOS of another MacModel (I guess). I've never used this.</br></br>**Eample**: `sudo ~/ssdtPRGen.sh -b Mac-F60DEB81FF30ACF`
`-a` | Set the ACPI device name of the CPU. Usually unnecessary, since it should be auto-detected.</br></br> **Example**: `sudo ~/ssdtPRGen.sh -a CPU0`
`-t` | For manually setting your CPU's TDP (thermal design power), aka the maximum power consumption of your CPU in Watts. Only required if the CPU's specs are not present in the database already. </br></br> **Example**: `sudo ~/ssdtPRGen.sh -t 45`

**Example** for running ssdtPRGen with more than one modifier/override: 

```shell
sudo ~/ssdtPRGen.sh -p 'i7-3630QM' -c 3 -lfm 900 -x 1
``` 
&rarr; Generates an SSDT for an Intel i7 3630QM with compatibility workarounds, lowered idle CPU frequency (900 instead of the default 1200 mHz) and support for Plugin Type 1 (XCPM).

## Notes

- **ssdtPRGen** includes lists with settings for specific CPUs sorted by families. These can be found under `~/Library/ssdtPRGen/Data`. They are in .cfg format which can be viewed with TextEdit.
- macOS Ventura dropped the `AppleIntelCPUPowerManagement.kext`, so the CPU will be stuck in base frequency (no turbo states) if the SSDT is generated for PluginType 0. As a workaround, [**force-enable XCPM**](https://github.com/5T33Z0/Lenovo-T530-Hackintosh-OpenCore/tree/main/ACPI/Enable_XCPM) (Ivy Bridge only) and regenerate the SSDT for PluginType 1 and replace the exiting SSDT-PM.

## Credits
- Intel for Intel Power Gadget
- Piker Alpha for ssdtPRGen
