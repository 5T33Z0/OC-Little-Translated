# Enabling `XCPM` for Ivy Bridge CPUs
> Compatibility: macOS Catalina (10.15.5+) to Big Sur (11.3 beta. By 5T33Z0

## Background: 
Apple deactivated the `X86PlatformPlugin` support for Ivy Bridge CPUs in macOS a few years back. Instead, the `ACPI_SMC_PlatformPlugin` is used for CPU power management, although `XCPM` is supported by Ivy Bridge CPUs natively. But there isn't much info about how to re-enable it in OpenCore's documentation:

> **Note 4:** Note that the following configurations are unsupported by XCPM (at least out of the box): Consumer Ivy Bridge (0x0306A9) as Apple disabled XCPM for Ivy Bridge and recommends legacy power management for these CPUs. `_xcpm_bootstrap` should manually be patched to enforce XCPM on these CPUs […].

So that's exactly what we are going to do: re-enable `XPCM` with a kernel patch and a modified Hotpatch (***SSDT-PM,aml*** or ***SSDT-PLUG.aml***) to use the `X86PlatformPlugin` (i.e. setting Plugin Type to `1`).

**NOTE**: I developed and tested this guide using a Laptop. If you're on a desktop you have to use a different System Definition – iMac13,1 for Ivy Bridge and 14,1 for Haswell, I guess.

## Requirements:

* 3rd gen Intel CPU (codename **Ivy Bridge**)
* Tools: Terminal, ssdtPRGEN, SSDTTime, Plist Editor, MaciASL (optional), IORegistryExplorer (optional), CPUFriendFriend (optional)
* SMBIOS that supports Ivy Bridge CPUs (like MacBookPro9,x or 10,x for Laptops and iMac13,1 for Desktops)

## How-To:

### 1. Enable `XCPM` for Ivy Bridge:

* Add the Kernel Patch inside of "XCPM_IvyBridge.plist" to your `config.plist`
* Enable `AppleXcpmExtraMsrs` under Kernel > Quirks.
* Save.

### 2. Generate a modified `SSDT-PM` for Plugin Type `1`

Next, we need to set the plugin type of SSDT-PM.aml to "1". To do this, we generate a new SSDT-PM with ssdtPRGen. Since it generatea SSDTs without XCPM support by default, we have to modify the command line in terminal.

Terminal command for ssdtPRGen: `sudo /Users/YOUR_USERNAME/ssdtPRGen.sh -x 1`

The finished ssdt.aml and ssdt.dsl are located in `/Users/YOUR_USERNAME/Library/ssdtPRGen`

A look into the ssdt.aml file list a summary of all settings for the SSDT. If there is a "1" in the last line, everything is correct:

> Debug = "machdep.xcpm.mode.....: 1"

- Rename the newly generated "ssdt.aml" to "SSDT-XCPM.aml"
- Copy it to EFI > OC > ACPI
- Update your config.plist
- Disable `SSDT-PM.aml`
- Reboot
- Enter in terminal: `sysctl machdep.xcpm.mode`

If the output is `1`, the `X86PlatformPlugin` is active, otherwise it is not.

## NOTE for Big Sur Users:
Since Big Sur requires `MacBookPro11,x` to boot, `ssdtPRGen` fails to generate SSDT-PM in this case, because it relies on Board-IDs containing data for Plugin-Type 0. As a workaround, you can either:

- use `SSDTTime` to generate a `SSDT-PLUG.aml` **or** 
- stay on `MacBookPro10,1` but add `-no_compat_check` to `boot-args`.

**Advantages** of using `MacBookPro10,1` with `-no_compat_check` are:

- You can boot Big Sur **and** use ssdtPRGen. 
- The CPU runs at lower clock speeds in idle since this SMBIOS was written for Ivy Bridge, while 11,x was written for Haswell CPUs. Therefore the CPU produces less heat and the machine runs quieter.
- Another benefit of using `MacBookPro10,1` is that you get the correct P-States and C-States for your CPU from ssdtPRGen.

**Disadvantages** of using `MacBookPro10,1` or equivalent iMac Board-ID supporting Ivy Bridge: 

- You won't be able to install System Updates because you won't be notified about them. But there's a simple `workaround`:

	- Change `SystemProductName` to `MacBookPro11,1`
 	- Set `csr-active-config` to `67080000`
 	- Reboot
 	- Reset NVRAM
 	- Boot macOS
 	- Check for and install Updates
 	- After the Updates are installed, revert to SMBIOS `MacBookPro10,1`
 	- Set `csr-active-config` to `FF070000` (For Catalina) 
