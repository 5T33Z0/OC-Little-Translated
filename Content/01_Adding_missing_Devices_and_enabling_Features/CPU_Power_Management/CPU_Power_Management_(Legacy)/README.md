# CPU Power Management for legacy Intel CPUs (`SSDT-PM`)

**TABLE of CONTENTS**

- [About](#about)
- [Prerequisites](#prerequisites)
- [Instructions](#instructions)
	- [Modifiers](#modifiers)
- [Technical Background](#technical-background)
- [macOS Monterey](#macos-monterey)
- [Re-enabling ACPI Power Management in macOS 13 and newer](#re-enabling-acpi-power-management-in-macos-13-and-newer)
	- [Alternative Solution](#alternative-solution)
- [Notes](#notes)
- [Credits](#credits)

## About
SSDT for enabling CPU Power Management on legacy Intel CPUs using the `ACPI_SMC_PlatformPlugin` (plugin-type `0`), so mainly 2nd and 3rd Gen Intel Core/Xeon CPUs.

You can use [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) to generate this table, which is now called `SSDT-PM`. In the early days of hackintoshing, when people had to use a patched DSDT to run macOS on their PCs since hotpatching didn't exist yet, this table was simply referred to as "SSDT.aml" because it usually was the only SSDT injected into the system (besides the patched DSDT).

Although **ssdtPRGen** supports Sandy Bridge to Kabylake CPUs, it's only used for 2nd and 3rd Gen Intel CPUs nowadays since Haswell and newer support XCPM via the `X86PlatformPlugin` (plugin-type `1`). It might still be useful on Haswell and newer when working with unlocked, overclockable "k" variants of Intel CPUs which support the `X86PlatfromPlugin` to optimize performance (check the [Modifiers](#modifiers) section for details).

You can tell whether or not your system's CPU Power Management is working correctly by monitoring the behavior of the CPU. You can use [**Intel Power Gadget**](https://www.insanelymac.com/forum/files/file/1056-intel-power-gadget/) to do so. If the CPU always runs at the same frequency no matter waht's happening (idleing or performing cpu-intense tasks which would normally cause it to use different speed multipliers and turbo states) then you have an issue with CPU Power Management at hand. Since this not only affects overall performance and power consumption but sleep/hibernation as well, it's mandatory to get the CPU Power Management working properly to have an efficient system when running macOS. Another way to check if macOS has knowledge of the existing multipliers of a CPU is by using IORegistrExplorer and check for the presence of entries in the `PerformanceStateArray` located within the `ACPI_SMC_PlatformPlugin` as shown in this [example](https://raw.githubusercontent.com/5T33Z0/OC-Little-Translated/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)/P-States.png).

For Ivy Bridge(-E) and older, you have to create an SSDT containing the power and turbo states of the CPU which are then injected into macOS via ACPI so that the `ACPI_SMC_PlatformPlugin` has the correct data to work with. That's why this method is also referred to as "ACPI CPU Power Management". 

## Prerequisites
- Hardware Requirements: 3rd Gen Intel Core or older CPU (Ivy Bridge and older) 
- Mount your ESP
- Open your `config.plist`
- Under `ACPI/Delete`, enable the following drop rules (if they don't exist, copy them over from the `Sample.plist` included in the [**OpenCore Package**](https://github.com/acidanthera/OpenCorePkg/releases)):
	- `Delete CpuPm`
	- `Delete Cpu0Ist`
- Save and reboot

## Instructions
- Open Terminal
- Enter the following command to download the ssdtPRGen Script:
	```bash
	curl -o ~/ssdtPRGen.sh https://raw.githubusercontent.com/Piker-Alpha/ssdtPRGen.sh/Beta/ssdtPRGen.sh
	```
- Make it executable: 
	```bash
	chmod +x ~/ssdtPRGen.sh
	``` 
- Run the script: 
	```bash
	sudo ~/ssdtPRGen.sh
	```
- The generated `SSDT.aml` will be located at `~/Library/ssdtPRGen`
- Rename it to `SSDT-PM.aml` (optional, but good practice)
- Copy it to `EFI/OC/ACPI` and list it in the `ACPI/Add` section of your `config.plist`
- Under `ACPI/Delete`, disable `Delete CpuPm` and `Delete Cpu0Ist` again
- Save the config and reboot

Monitor the behavior of the CPU in [**Intel Power Gadget**](https://www.insanelymac.com/forum/topic/357902-intel-power-gadget/). Check if it is stepping though different frequencies by performing different tasks like browsing the web and watching a YT video for example. If the CPU is reacting to your usage of the system and if it reaches the defined lower and upper frequency limits, then CPU Power Management is working correctly.

### Modifiers
Besides simply generating the ssdt by running the script, you can add modifiers to the terminal command. Although the ssdtPRGen repo lists a bunch of [overrides](https://github.com/Piker-Alpha/ssdtPRGen.sh#help-information), it doesn't go into detail about how and when to use them.

Fortunately, you can enter `sudo ~/ssdtPRGen.sh -h` to display the "Help" menu which lists all the available commands. The actual letter(s) you have to enter to execute one of them are highlighted in **bold**.

Here's a table of modifiers which can be combined. Use [ark.intel.com](https://ark.intel.com/content/www/us/en/ark.html) to look-up the specs of your CPU model. 

Modifier | Description/Example
:-------:|--------------------
`-p 'CPU model'` | Add your CPU model if it is listed in the `.cfg` file located inside the `ssdtPRGen/Data` folder. The config files are organized by Intel CPU families and contain data like model, TDP and frequencies. The advantage of generating the SSDT-PM that it includes additional info and workarounds for the CPU. It's also useful for generating a SSDT-PM for someone else who uses a different CPU. You can also add missing CPU data to `User Defined.cfg` </br></br> **Example**: `sudo ~/ssdtPRGen.sh -p 'i7-3630QM'`
`-target X` | Target Intel CPU family, where `X` stands for a number from  0 to 5: </br></br> 0 = Sandy Bridge </br> 1 = Ivy Bridge </br> 2 = Haswell </br> 3 = Broadwell </br> 4 = Skylake </br> 5 = Kabylake</br></br> **Example**: `sudo ~/ssdtPRGen.sh -target 1`
`-c X` | Compatibility workarounds, where `X` must be a number between 0 to 3. </br></br> 0 = No workarounds </br> 1 = Inject extra (turbo) P-State at the top with maximum (turbo) frequency + 1 MHz</br> 2 = Inject extra P-States at the bottom</br> 3 = Both </br></br> **Example**: `sudo ~/ssdtPRGen.sh -c 3`
`-x Y`| Enables/Disables XCPM mode (Plugin Type), where `Y` can be:</br></br> `0` = XCPM disabled </br>`1` = XCPM enabled </br> </br> **Example**: `sudo ~/ssdtPRGen.sh -x 1`.
`-d X` | Debug output, where `X` must be a number from 0 to 3.</br></br> 0 = No debug injection/debug output</br> 1 = Inject debug statements in: ssdt_pr.dsl </br> 2 = Show debug output </br> 3 = Both</br></br> **Example**: `sudo ~/ssdtPRGen.sh -d 1`
`-lfm` | Sets the Low frequency mode in mHz. Describes the lowest frequency a CPU can clock down to. Very useful for laptops and saving energy in general. Add the corresponding frequency as a number as shown in the example. If you set the LFM too low, the system will crash on boot. In my experience, 900 mHz is a stable value, which is about 300 mHz lower than stock for the i7-3630QM I am using in my laptop. </br></br> **Example**: `sudo ~/ssdtPRGen.sh -lfm 900`
`-turbo` | Sets the Maximum Turbo Frequency supported by the CPU in mHz. Add the frequency to the command as shown in the example. If your CPU is included in one of the .cfg files, then you don't have to set this since it already contains the correct value. </br></br> **Example**: `sudo ~/ssdtPRGen.sh -turbo 3000`
`-bclk` | Sets the base clock (or bus frequency) in mHz of the CPU. The default is 100 mHz and you really shouldn't mess with this at all since it influences CPU multipliers and can cause instabilities of the system.</br></br>**Example**: `sudo ~/ssdtPRGen.sh -bclk 133`
`-f` | Sets the clock frequency of the CPU in mHz (the one before the turbo). You shouldn't really mess with that as well.</br></br> **Example**: `sudo ~/ssdtPRGen.sh -f 2333`
`-m` | Add model (Board-id). I guess this is useful when generating SSDTs for PluginType 1 which extracts the frequency vectors from the SMBIOS of the selected Mac model. </br></br>**Example**: `sudo ~/ssdtPRGen.sh -m MacBookPro10,1`
`-b` | Add specific Board-ID. Useful if you want to use frequency vectors from the SMBIOS of another MacModel (I guess). I've never used this.</br></br>**Example**: `sudo ~/ssdtPRGen.sh -b Mac-F60DEB81FF30ACF`
`-a` | Set the ACPI device name of the CPU. Usually unnecessary, since it should be auto-detected.</br></br> **Example**: `sudo ~/ssdtPRGen.sh -a CPU0`
`-t` | For manually setting your CPU's TDP (thermal design power), aka the maximum power consumption of your CPU in Watts. Only required if the CPU's specs are not present in the database already. </br></br> **Example**: `sudo ~/ssdtPRGen.sh -t 45`

**Example** for running ssdtPRGen with more than one modifier/override: 

```shell
sudo ~/ssdtPRGen.sh -p 'i7-3630QM' -c 3 -lfm 900 -x 1
``` 
&rarr; Generates an SSDT for an Intel i7 3630QM with compatibility workarounds, lowered idle CPU frequency (900 instead of the default 1200 mHz) and support for Plugin Type 1 (XCPM).

## Technical Background
`SSDT-PM` injects the following parameters:

- `APSS` (Apple Processor Sleep States) allows the CPU to enter low-power states to conserve energy while the system is idle. The processor can transition to different sleep states depending on the system's usage and power requirements. Each sleep state has a different power consumption and wake-up latency. This feature is specific to macOS and it is not part of the standard ACPI specification. APSS is used to provide more granular control over power management on macOS systems, and it can be used in conjunction with other power management features such as `APLF` and `APSN` to further reduce power consumption.

- `APSN` (Apple Processor Sleep Number) is used to specify the sleep state that the processor should enter when it is not needed. Processor sleep states are low-power modes that allow the processor to enter a dormant state in order to conserve power and extend battery life in portable devices.

	In general, the lower the sleep state number, the lower the power consumption and the longer the wake-up latency. So, the more aggressive sleep state is the one with the lower number. The operating system will choose the most appropriate sleep state depending on the system's usage and power requirements.

- `APLF` (Apple Low Frequency Mode) is used to enable or disable a low-frequency mode for the processor. When low-frequency mode is enabled, the processor's clock speed is reduced in order to conserve power and reduce heat generation. 
	
	MacOS uses APSN and APSS to configure the specific C-states that the processor can enter, and uses APLF to reduce the frequency of components such as the CPU and GPU.

- CPU Power Management Plugin: by default, plugin-type `0` is injected for using the `ACPI_SMC_PlatformPlugin`.

## macOS Monterey
With the release of macOS Monterey, Apple dropped the Plugin-Type check, so that the `X86PlatformPlugin` is loaded by default. For Haswell and newer this is great, since you no longer need `SSDT-PLUG` to enable Plugin-Type `1`. But for Ivy Bridge and older, you now need to select Plugin-Type `0`. If you've previously generated an `SSDT-PM` with ssdtPRGen, it's already configured to use Plugin-Type `0`, so ACPI CPU Power Management is still working. For macOS Ventura, it's a different story…

## Re-enabling ACPI Power Management in macOS 13 and newer
When Apple released macOS Ventura, they removed the actual `ACPI_SMC_PlatformPlugin` *binary* from the `ACPI_SMC_PlatformPlugin.kext` itself (previously located under S/L/E/IOPlatformPluginFamily.kext/Contents/PlugIns/ACPI_SMC_PlatformPlugin.kext/Contents/MacOS/), rendering `SSDT-PM` generated for Plugin-Type 0 useless since it cannot utilize a plugin which no longer exists. Instead, the `X86PlaformPlugin` is loaded by default. Therefore, CPU Power Management doesn't work correctly on legacy Intel CPUs out of the box (no turbo states, incorrect LFM frequency, higher average clock). Additionally, the AppleIntelCPUPowerManagement kexts that handle ACPI CPU Power Management were removed from macOS 13 as well. 

So when switching to macOS Ventura, you either have to:

- Re-enable ACPI CPU Power Management (**recommended**) or
- [**Force-enable XCPM**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/Content/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/Enabling_XCPM_on_Ivy_Bridge_CPUs) (Ivy Bridge only) (not recommended)

In order to re-enable and use ACPI CPU Power Management in macOS Ventura and newer, you have to do the following:

- Update OpenCore to 0.9.2 or newer (**Mandatory unless you can disable CFG Lock in BIOS!**)
- `Booter/Patch`: Add [**Booter Patches from OCLP**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof#booter-patches) to skip board-id check to run macOS on unsupported SMBIOS/Board-ids. Requires Darwin Kernel 20.4 (macOS 11.3+). So when upgrading from Catalina or older, you need to use a supported SMBIOS temporily to run the installer. Once the installation is done, you can revert to the SMBIOS best suited for your CPU.
- `Kernel/Add` (and EFI/OC/Kexts):
	- Add [**CrytexFixup** ](https://github.com/acidanthera/CryptexFixup) &rarr; required for installing/booting macOS Ventura an pre-Haswell systems
	- Add [**RestrictEvents.kext**](https://github.com/acidanthera/RestrictEvents) 
	- Add [**Kexts from OpenCore Legacy Patcher**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Misc):
		- `AppleIntelCPUPowerManagement.kext` (set `MinKernel` to 22.0.0)
		- `AppleIntelCPUPowerManagementClient.kext` (set `MinKernel` to 22.0.0)
		- `ASPP-Override.kext` (set `MinKernel` to `21.4.0`) (:warning: Sandy Bridge and older only!)
- `Kernel/Quirks`: 
	- Enable `AppleCpuPmCfgLock` (not needed if CFG Lock is disabled)
	- Disable `AppleXcmpCfgLock` and `AppleXcpmExtraMsrs` (if enabled)
- `Kernel/Patch`: Disable `_xcpm_bootstrap` (if enabled)
- Add **boot-args**:
	- `revpatch=sbvmm` &rarr; Enables `VMM-x86_64` Board-id which allows installing system updates on unsupported systems 
	- `revblock=media` &rarr; Blocks `mediaanalysisd` service on Ventura+ which fixes issues on Metal 1 iGPUs. Firefox won't work without this.
	- `ipc_control_port_options=0` &rarr; Fixes crashes with Electron apps like Discord
	- `amfi_get_out_of_my_way=1` (or `amfi=0x80`) &rarr; Required to re-install legacy drivers (iGPU, GPU, etc.) with the OpenCore Patcher App in Post-Install.
- Save and reboot

Once the 3 Kexts from OCLP are injected, ACPI Power Management will work in Ventura and you can use your `SSDT-PM` like before. For tests, enter in Terminal:

```shell
sysctl machdep.xcpm.mode
```
The output should be `0`, indicating that the `X86PlatformPlugin` is not loaded so ACPI CPU Power Management is used. To verify, run Intel Power Gadget and check the behavior of the CPU. Additionally, you could check if the 2 kext are loader:

```shell
kextstat | grep com.apple.driver.AppleIntelCPUPowerManagement
```
This should return something like this:

```
57    0 0xffffff800439a000 0x3e000    0x3e000    com.apple.driver.AppleIntelCPUPowerManagement (222.0.0) 20DD89B4-45CE-3E56-A484-15B74E79ACDD <9 8 7 6 3 1>
88    0 0xffffff80043d8000 0xf000     0xf000     com.apple.driver.AppleIntelCPUPowerManagementClient (222.0.0) B3E52B58-0634-333C-9A71-E99BE79F8283 <9 8 7 6 3 1>
```
> [!IMPORTANT] 
> 
> Prior to OpenCore 0.9.2, the necessary `AppleCpuPmCfgLock` Quirk to patch CFG Lock is [skipped in macOS 13 based on a kernel version check](https://github.com/acidanthera/OpenCorePkg/commit/77d02b36fa70c65c40ca2c3c2d81001cc216dc7c). This results in a kernel panic when attempting to inject the AppleIntelCPUPowerManagement kexts. So make sure to update OpenCore to the latest version where the quirk is working again. Otherwise you need to disable CFG lock in your UEFI/BIOS. And if the BIOS doesn't offer an to disable disabled it, you will have to flash a modified BIOS where CFG lock is disabled.
 
### Alternative Solution

Instead of injecting the required kexts to re-enable legacy CPU Power Management on Sandy and Ivy Bridge via OpenCore or Clover, it's also possible to install patched versions of the kexts under S/L/E. I haven't tested this and I wouldn't recommend doing this due to increased access restrictions to the system partitions since the release of macOS Catalina.

**Source**: [**OSX Latitude**](https://osxlatitude.com/forums/topic/18089-patched-aicpupm-kext-for-sandy-bridgeivy-bridge-cpu-power-management-in-macos-ventura/#comment-117988)

## Notes
- **ssdtPRGen** includes lists with settings for specific CPUs sorted by families. These can be found under `~/Library/ssdtPRGen/Data`. They are in .cfg format which can be viewed with TextEdit.
- **ssdtPRGen** does not work with Lynnfield and other 1st Gen Intel Core CPUs
- ⚠️ macOS Ventura users: you cannot install macOS Security Response Updates (RSR) on pre-Haswell systems. They will fail to install (more info [**here**](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/1019)).
- Check the **Configuration.pdf** included in the OpenCorePkg for details about unlocking the MSR 0xE2 register (&rarr; [Chapter 7.8](https://dortania.github.io/docs/release/Configuration.html#quirks-properties2): "AppleCpuPmCfgLock").

## Credits
- Acidanthera for OpenCore Legacy Patcher, Kexts, Booter- and Kernel Patches
- Intel for Intel Power Gadget
- Piker Alpha for ssdtPRGen
