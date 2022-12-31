# Enabling `XCPM` for Ivy Bridge CPUs
> By 5T33Z0. Compatibility: macOS Catalina (10.15.5+) to Ventura

## Background
Apple deactivated the `X86PlatformPlugin` support for Ivy Bridge CPUs in macOS a few years back. Instead, the `ACPI_SMC_PlatformPlugin` is used for CPU power management, although `XCPM` is supported by Ivy Bridge CPUs natively. But there isn't much info about how to re-enable it in OpenCore's documentation:

>Note that the following configurations are unsupported by XCPM (at least out of the box): Consumer Ivy Bridge (0x0306A9) as Apple disabled XCPM for Ivy Bridge and recommends legacy power management for these CPUs. `_xcpm_bootstrap` should manually be patched to enforce XCPM on these CPUs […].

So that's exactly what we are going to do: re-enable `XPCM` with a kernel patch and a modified Hotpatch (***SSDT-PM.aml*** or ***SSDT-PLUG.aml***) to use the `X86PlatformPlugin` (i.e. setting Plugin Type to `1`).

**NOTE**: I developed and tested this guide using a Laptop. If you're on a desktop you have to use a different System Definition – `iMac13,1`/`iMac13,2` for Ivy Bridge and `14,1` for Haswell, I guess.

## Requirements

* 3rd gen Intel CPU (Codename **Ivy Bridge**)
* SMBIOS supporting Ivy Bridge CPUs (like MacBookPro9,x or 10,x for Laptops and iMac13,1 for Desktops)
* Tools: Terminal, [ssdtPRGEN](https://github.com/Piker-Alpha/ssdtPRGen.sh), [ProperTree](https://github.com/corpnewt/ProperTree), [MaciASL](https://github.com/acidanthera/MaciASL), [IORegistryExplorer](https://github.com/khronokernel/IORegistryClone), [SSDTTime](https://github.com/corpnewt/SSDTTime), [CPUFriendFriend](https://github.com/corpnewt/CPUFriendFriend), [OpenCore Patcher GUI App](https://github.com/dortania/OpenCore-Legacy-Patcher/releases)

## How-To

### 1. Enable `XCPM` for Ivy Bridge:

- Mount the ESP
- Open `config.plist`
- Under `ACPI/Add`, disable `SSDT-PM.aml` (if present)
- Under `ACPI/Delete`, enable rules "Drop CpuPm" and "Drop Cpu0Ist"
- Add the Kernel Patch inside "XCPM_IvyBridge.plist" to your config and enable it 
- Under `Kernel/Quirks`, enable `AppleXcpmCfgLock` and `AppleXcpmExtraMsrs`
- Save your config and reboot

### 2. Generate a modified `SSDT-PM` for Plugin Type `1`

Next, we need to set the plugin type of SSDT-PM.aml to "1". To do this, we generate a new SSDT-PM with ssdtPRGen. Since it generates SSDTs without XCPM support by default, we have to modify the command line in terminal.

Terminal command for ssdtPRGen: `sudo /Users/YOUR_USERNAME/ssdtPRGen.sh -x 1`

The finished ssdt.aml and ssdt.dsl are located in `/Users/YOUR_USERNAME/Library/ssdtPRGen`

A look into the ssdt.aml file list a summary of all settings for the SSDT. If there is a "1" in the last line, everything is correct:

> Debug = "machdep.xcpm.mode.....: 1"

- Rename the newly generated `ssdt.aml` to `SSDT-XCPM.aml`
- Copy it to `EFI/OC/ACPI`
- Update your config.plist
- Disable `SSDT-PM.aml` or any equivalent thereof, if present.
- Reboot
- Enter in terminal: `sysctl machdep.xcpm.mode`

If the output is `1`, the `X86PlatformPlugin` is active, otherwise it is not.

## For mac Big Sur/Monterey Users
Since Big Sur+ requires `MacBookPro11,x` to boot, `ssdtPRGen` fails to generate SSDT-PM in this case, because it relies on Board-IDs containing data for Plugin-Type 0. As a workaround, you have 3 options:

- **Option 1:** Use `SSDTTime` to generate a `SSDT-PLUG.aml` and modify Frequency Vectors using CPUFriendFriend (requires a board-id cointaining Frequency Vectors) **or** 
- **Option 2**: Add a Board-ID spoof utilizing Big Sur's virtualization capabilities to spoof a different board-id to macOS than the one which the hardware uses. This is made possible by [Booter and Kernel Patches](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof) from OpenCore Legacy Patcher. Add them to your config in order to install macOS 11.3 and newer on unsupported SMBIOSes and install System Updates as well (Recommended) **or**
- **Option 3**. Stay on an Ivy Bridge SMBIOS but add `-no_compat_check` boot-arg

### PROS and CONS
Listed below are the advantages and disadvantages of options 2 and 3.

#### 1. Using `MacBookPro10,1` with Board-ID_VMM-Spoof
Advantages and disadvantages of using `MacBookPro10,1` (or equivalent iMac Board-ID supporting Ivy Bridge) with OCLP's Booter and Kernel Patches.

**PROS**:

- You can boot Big Sur 11.3 and newer with an SMBIOS designed for Ivy Bridge CPUs
- The CPU runs at lower clock speeds in idle since this SMBIOS was written for Ivy Bridge, while 11,x was written for Haswell CPUs. Therefore, the CPU produces less heat and the machine runs quieter.
- You can run ssdtPRGen and benefit form using `MacBookPro10,1` so you get the correct P-States and C-States for your CPU.
- System Updates work!

**CONS**:

- No major disadvantages. But read the [**VMM Usage Notes**](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/543#issuecomment-953441283) for more info.

#### 2. `MacBookPro10,1` with `-no_compat_check`
Advantages and disadvantages of using `MacBookPro10,1` (or equivalent iMac Board-ID supporting Ivy Bridge) with `-no_compat_check`.

**PROS**:

- You can boot Big Sur **and** use ssdtPRGen. 
- The CPU runs at lower clock speeds in idle since this SMBIOS was written for Ivy Bridge, while 11,x was written for Haswell CPUs. Therefore, the CPU produces less heat and the machine runs quieter.
- Another benefit of using `MacBookPro10,1` is that you get the correct P-States and C-States for your CPU from ssdtPRGen.

**CONS**:

- You won't be able to install System Updates because you won't be notified about them. But there's a simple `workaround`:

	- Change `SystemProductName` to `MacBookPro11,1`
 	- Set `csr-active-config` to `67080000`
 	- Reboot
 	- Reset NVRAM
 	- Boot macOS
 	- Check for and install Updates
 	- After the Updates are installed, revert to SMBIOS `MacBookPro10,1`
 	- Revert `csr-active-config` to the previous value
 	- Save and reboot  

## macOS Ventura and Ivy Bridge

With the release of macOS Ventura, Apple removed the actual `ACPI_SMC_PlatformPlugin` *binary* from the `ACPI_SMC_PlatformPlugin.kext` itself (previously located under `S/L/E/IOPlatformPluginFamily.kext/Contents/PlugIns/ACPI_SMC_PlatformPlugin.kext/Contents/MacOS/`), rendering SSDT-PM generated for 'plugin-type' 0 useless, since it can no longer attach to the now missing plugin. Therefore, CPU Power Management won't work correctly (no turbo states). 

So when switching to macOS Ventura, force-enabling XCPM and re-generating your `SSDT-PM` for 'plugin type' 1 is mandatory in order to get proper CPU Power Management.

You also need the following files and settings in order to install and run macOS Ventura on Ivy Bridge without major issues:

- [**OpenCore Patcher GUI App**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) to prepare a USB installer and install Intel HD4000 iGPU drivers
- [**Board-id VMM spoof**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof) to run macOS Ventura with an Ivy Bridge SMBIOS/board-id and install updates
- [**CryptexFixup.kext**](https://github.com/acidanthera/CryptexFixup) &rarr; required to be able to install macOS 13 at all
- [**RestrictEvents.kext**](https://github.com/acidanthera/RestrictEvents) and `revblock=media` boot-arg &rarr; Blocks `mediaanalysisd` service on Ventura+ which fixes issues on Metal 1 iGPUs. Firefox won't work without this.
- `ipc_control_port_options=0` boot-arg &rarr; Fixes crashes with Electron apps like Discord
- `amfi_get_out_of_my_way=1` boot-arg &rarr; Required to execute the Intel HD4000 iGPU driver installation with OpenCore Patcher App.

## Credits
- Acidanthera for OpenCore Legacy Patcher, CryptexFixup and RestrictEvents kexts.
