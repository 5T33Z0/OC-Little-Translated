# Enabling `XCPM` for Ivy Bridge CPUs
> **Compatibility**: macOS Catalina (10.15.5+) to Ventura

**TABLE of CONTENTS**

- [Background](#background)
- [Requirements](#requirements)
- [How-To](#how-to)
  - [1. Enable `XCPM` for Ivy Bridge](#1-enable-xcpm-for-ivy-bridge)
  - [2. Generate `SSDT-XCPM` for Plugin Type `1`](#2-generate-ssdt-xcpm-for-plugin-type-1)
- [Big Sur and Monterey](#big-sur-and-monterey)
  - [PROS and CONS](#pros-and-cons)
    - [1. Using Ivy Bridge SMBIOS with Board-ID\_VMM-Spoof](#1-using-ivy-bridge-smbios-with-board-id_vmm-spoof)
    - [2. Ivy Bridge SMBIOS with `-no_compat_check`](#2-ivy-bridge-smbios-with--no_compat_check)
- [macOS Ventura and Ivy Bridge](#macos-ventura-and-ivy-bridge)
- [Credits](#credits)

## Background
Apple deactivated the `X86PlatformPlugin` support for Ivy Bridge CPUs in macOS High Sierra. Instead, the `ACPI_SMC_PlatformPlugin` is used for CPU power management up to macOS Big Sur, although Ivy Bridge CPUs are capable of utilizing `XCPM`. Prior to macOS 10.12 you could just use `-xcpm` boot-arg to enable it.  But there isn't much info about how to re-enable it in newer versions of macOS in OpenCore's documentation:

>Note that the following configurations are unsupported by XCPM (at least out of the box): Consumer Ivy Bridge (0x0306A9) as Apple disabled XCPM for Ivy Bridge and recommends legacy power management for these CPUs. `_xcpm_bootstrap` should manually be patched to enforce XCPM on these CPUs […].

So that's exactly what we are going to do: re-enable `XPCM` with a kernel patch and an SSDT (***SSDT-XCPM.aml***) to use the `X86PlatformPlugin` (i.e. enabling 'plugin-type` `1`).

In macOS Monterey 12.3+, 2 changes happened:

1. Apple dropped the 'plugin-type' check within X86PlatformPlugin. This will load the plugin automatically so that `SSDT-PLUG` is no longer required. 
2. Apple also dropped the `ACPI_SMC_PlatformPlugin`, so that legacy ACPI CPU Power Management doesn't work correctly with SSDT-PMs with 'plugin-type' set to `0`

Since macOS Ventura removed the `ACPI_SMC_PlatformPlugin` binary completely, `SSDT-PM` tables generated for 'plugin-type' 0 can't attach to the missing plugin and therefore CPU Power management won't work correctly (no Turbo states). So when switching to macOS Ventura, re-generating you SSDT-PM with XCPM Support is mandatory!

**NOTE**: I developed and tested this guide using a Laptop. If you're on a desktop you have to use a different System Definition.

## Requirements

- **CPU**: Intel Ivy Bridge
- **Supported SMBIOS:** **iMac13,x** (for Desktops), **MacBookPo9,x/10,x** (for Notebooks), **Macmini6,x** (for NUCs) (Refer to OpenCore Install Guide for details)
- **Tools**: Terminal, [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh), [**ProperTree**](https://github.com/corpnewt/ProperTree), [**MaciASL**](https://github.com/acidanthera/MaciASL), [**IORegistryExplorer**](https://github.com/utopia-team/IORegistryExplorer) (optional), [**SSDTTime**](https://github.com/corpnewt/SSDTTime) (optional), [**CPUFriendFriend**](https://github.com/corpnewt/CPUFriendFriend) (optional)

## How-To

### 1. Enable `XCPM` for Ivy Bridge
- Mount the ESP
- Open `config.plist`
- Under `ACPI/Add`, disable `SSDT-PM.aml` (if present)
- Under `ACPI/Delete`, enable rules "Drop CpuPm" and "Drop Cpu0Ist" (If missing, copy them over from [XCPM_IvyBridge.plist](https://github.com/5T33Z0/OC-Little-Translated/blob/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/Enabling_XCPM_on_Ivy_Bridge_CPUs/XCPM_IvyBridge.plist))
- Under `Kernel/Patch`, enable "XCPM for Ivy Bridge" (copy it over from [XCPM_IvyBridge.plist](https://github.com/5T33Z0/OC-Little-Translated/blob/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/Enabling_XCPM_on_Ivy_Bridge_CPUs/XCPM_IvyBridge.plist))
- Optional: Adjust `MinKernel` to only enable XCPM for a specific version of macOS (for example Kernel 21.0.0 for Monterey and newer).
- Under `Kernel/Quirks`, enable `AppleXcpmCfgLock` and `AppleXcpmExtraMsrs`
- Save and reboot

After a successful reboot, run Terminal and enter: 

```shell
sysctl machdep.xcpm.mode
```
If the output is `1`, XCPM is working, if the output is `0`, it is not.

### 2. Generate `SSDT-XCPM` for Plugin Type `1`

Next, we generate a new SSDT containing the correct C-States and P-States but with plugin-type 1 enabled:

- Open Terminal
- Enter the following command to download the ssdtPRGen Script: `curl -o ~/ssdtPRGen.sh https://raw.githubusercontent.com/Piker-Alpha/ssdtPRGen.sh/Beta/ssdtPRGen.sh`
- Make it executable: `chmod +x ~/ssdtPRGen.sh` 
- Run the script: `sudo ~/ssdtPRGen.sh -x 1`
- The generated `SSDT.aml` will be located in `~/Library/ssdtPRGen`

The ssdt.aml file contains a summary of all the set parameters. If there is a "1" in the last line, everything is correct:

> Debug = "machdep.xcpm.mode.....: 1"

- Rename `ssdt.aml` to `SSDT-XCPM.aml`
- Copy it to `EFI/OC/ACPI` 
- Add the file to your config.plist in the `ACPI/Add` section
- Under `ACPI/Delete`, disable "Drop CpuPm" and "Drop Cpu0Ist"
- Save and reboot

Monitor the behavior of the CPU using Intel Power Gadget. If the CPU Power Management is working correctly, the CPU should step through the whole range of frequencies according to its specs – from the lowest (in idle) to its maximum (when running cpu-intense tasks).

## Big Sur and Monterey
Since Big Sur and newer usually require a newer SMBIOS to boot, `ssdtPRGen` fails to generate SSDT-XCPM in this case, because it relies on Board-IDs containing data for Plugin-Type 0. As a workaround, you have 2 options:

- **Option 1**: Add a Board-ID spoof utilizing Big Sur's virtualization capabilities to spoof a different board-id to macOS than the one which the hardware uses. This is made possible by [Booter and Kernel Patches](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof) from OpenCore Legacy Patcher. Add them to your config in order to install macOS 11.3 and newer on unsupported SMBIOSes and install System Updates as well (Recommended) **or**
- **Option 2**: Stay on an Ivy Bridge SMBIOS but add `-no_compat_check` boot-arg

### PROS and CONS
Listed below are the advantages and disadvantages of both options.

#### 1. Using Ivy Bridge SMBIOS with Board-ID_VMM-Spoof
Advantages and disadvantages of using `MacBookPro10,1` (or equivalent iMac Board-ID supporting Ivy Bridge) with OCLP's Booter and Kernel Patches.

**PROS**:

- You can boot Big Sur 11.3 and newer with an SMBIOS designed for Ivy Bridge CPUs
- The CPU runs at lower clock speeds in idle since this SMBIOS was written for Ivy Bridge.
- You can run ssdtPRGen and benefit form using the correct P-States and C-States for your CPU.
- System Updates will work!

**CONS**:

- No major disadvantages. But read the [**VMM Usage Notes**](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/543#issuecomment-953441283) for more info.

#### 2. Ivy Bridge SMBIOS with `-no_compat_check`
Advantages and disadvantages of using `MacBookPro10,1` (or equivalent iMac Board-ID supporting Ivy Bridge) with the `-no_compat_check` boot-arg. This is mainly required when using Clover since it cannot apply the Booter Patches OpenCore uses to bypass the board-id checks.

**PROS**:

- You can boot Big Sur and newer **and** use ssdtPRGen. 
- CPU runs at lower clock speeds in idle since this SMBIOS was written for Ivy Bridge, while 11,x was written for Haswell CPUs. Therefore, the CPU produces less heat and the machine runs quieter.
- Another benefit of using `MacBookPro10,1` is that you get the correct P-States and C-States for your CPU from ssdtPRGen.

**CONS**:

- You won't be able to install System Updates because you won't be notified about them. But there's a **Workaround**: [**Enable board-id VMM spoof**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof). This allows using the recommended SMBIOS for Ivy Bridge CPUs for optimal CPU Power Management, running macOS Monterey as well as installing macOS Updates.

**NOTE**: If you only need the **`VMM-x86_64`** board-id for fixing issues with System Updates, do the following:

- Add the Booter Patches mentioned in the board-id VMM spoofing guide to your config
- Add [**RestrictEvents.kext**](https://github.com/acidanthera/RestrictEvents) to `EFI/OC/Kexts` and config.plist
- Add boot-arg `revpatch=sbvmm`
- Save your config and reboot.

## macOS Ventura and Ivy Bridge

With the release of macOS Ventura, Apple removed the actual `ACPI_SMC_PlatformPlugin` *binary* from the `ACPI_SMC_PlatformPlugin.kext` itself (previously located under "S/L/E/IOPlatformPluginFamily.kext/Contents/PlugIns/ACPI_SMC_PlatformPlugin.kext/Contents/MacOS/"), rendering SSDT-PM generated for 'plugin-type' 0 useless, since it can no longer attach to the now missing plugin. Therefore, CPU Power Management won't work correctly (no turbo states). 

So when switching to macOS Ventura, force-enabling XCPM and re-generating your `SSDT-PM` for 'plugin type' 1 is mandatory in order to get proper CPU Power Management.

You also need the following files and settings in order to install and run macOS Ventura on Ivy Bridge without major issues:

- [**OpenCore Patcher GUI App**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) to prepare a USB installer and install Intel HD4000 iGPU drivers
- [**Board-id VMM spoof**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof) to run macOS Ventura with an Ivy Bridge SMBIOS/board-id and install updates
- [**CryptexFixup.kext**](https://github.com/acidanthera/CryptexFixup) &rarr; required to be able to install macOS 13 at all
- [**RestrictEvents.kext**](https://github.com/acidanthera/RestrictEvents) and `revblock=media` boot-arg &rarr; Blocks `mediaanalysisd` service on Ventura+ which fixes issues on Metal 1 iGPUs. Firefox won't work without this.
- `ipc_control_port_options=0` boot-arg &rarr; Fixes crashes with Electron apps like Discord
- `amfi_get_out_of_my_way=1` boot-arg &rarr; Required to execute the Intel HD4000 iGPU driver installation with OpenCore Patcher App.

## Credits
- Acidanthera for maciASL, OpenCore Legacy Patcher, CryptexFixup and RestrictEvents kexts.
- CorpNewt for ProperTree
- Piker Alpha for ssdtPRGen
- UtopiaTeam for IORegistryExplorer Mirror
