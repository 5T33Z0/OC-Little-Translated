# Enabling CPU Power Management (`SSDT-PLUG`)

## Description
`SSDT-PLUG` enables `X86PlatformPlugin` to utilize XCPM CPU Power Management on 4th Gen Intel Core CPUs and newer. Intel Alder Lake requires `SSDT-PLUG-ALT.aml` instead.

## Patching method 1: automated, using SSDTTime
The manual patching method described below is outdated, since the patching process can now be automated using **SSDTTime** which can generate the SSDT-PLUG for you by analyzing your system's `DSDT`.

### Instructions

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it
2. Press <kbd>D</kbd>, drag in your system's `DSDT` and hit and hit <kbd>Enter</kbd>
3. Generate all the SSDTs you need.
4. The SSDTs will be stored under `Results` inside the `SSDTTime-master` Folder along with `patches_OC.plist`.
5. Copy the generated SSDTs to `EFI/OC/ACPI`
6. Open `patches_OC.plist` and copy the included entries to the corresponding section(s) of your `config.plist`.
7. Save and Reboot.

## Patching method 2: manual

### Example 1
- Search results in `DSDT` for `Processor`, e.g.:
	```	asl 
      Scope (_PR)
      {
          Processor (CPU0, 0x01, 0x00001810, 0x06){}
          Processor (CPU1, 0x02, 0x00001810, 0x06){}
          Processor (CPU2, 0x03, 0x00001810, 0x06){}
          Processor (CPU3, 0x04, 0x00001810, 0x06){}
          Processor (CPU4, 0x05, 0x00001810, 0x06){}
          Processor (CPU5, 0x06, 0x00001810, 0x06){}
          Processor (CPU6, 0x07, 0x00001810, 0x06){}
          Processor (CPU7, 0x08, 0x00001810, 0x06){}
      }
	```
- Based on the search result, the `Processor` object is located in the Scope `_PR` and the name of the first core is `CPU0`, so select the injection file: ***SSDT-PLUG-_PR.CPU0***
- Add the SSDT to `EFI/OC/ACPI` and your config.plist
- Save and reboot
- Check if the X86PlatformPlugin is working

### Example 2
- Search results in `DSDT` for `Processor`, e.g.:
	```asl
      Scope (_SB)
      {
          Processor (PR00, 0x01, 0x00001810, 0x06){}
          Processor (PR01, 0x02, 0x00001810, 0x06){}
          Processor (PR02, 0x03, 0x00001810, 0x06){}
          Processor (PR03, 0x04, 0x00001810, 0x06){}
          Processor (PR04, 0x05, 0x00001810, 0x06){}
          Processor (PR05, 0x06, 0x00001810, 0x06){}
          Processor (PR06, 0x07, 0x00001810, 0x06){}
          Processor (PR07, 0x08, 0x00001810, 0x06){}
          Processor (PR08, 0x09, 0x00001810, 0x06){}
          Processor (PR09, 0x0A, 0x00001810, 0x06){}
          Processor (PR10, 0x0B, 0x00001810, 0x06){}
          Processor (PR11, 0x0C, 0x00001810, 0x06){}
          Processor (PR12, 0x0D, 0x00001810, 0x06){}
          Processor (PR13, 0x0E, 0x00001810, 0x06){}
          Processor (PR14, 0x0F, 0x00001810, 0x06){}
          Processor (PR15, 0x10, 0x00001810, 0x06){}
      }
	```
- Based on this search result example, the `Processor` object is located under `_SB` and the name of the first core is `PR00`, so select the injection file: ***SSDT-PLUG-_SB.CPU0***
- Add the SSDT to `EFI/OC/ACPI` and your config.plist
- Save and reboot
- Check if the X86PlatformPlugin is working

>[!IMPORTANT]
>
>If your search results **do not match** with any of the available SSDTs, please pick the `SSDT-PLUG.dsl` sample included in the OpenCore package since it covers all cases of possible CPU device names, modify it so that it matches the ACPI name and paths used in your system and export it as an .aml (ACPI Machine Language) file!

## Verifying
### Using IORegistryExplorer (recommended)
The easiest and most reliable way to verify that the `X86PlatformPlugin` is loaded and `XCPM` is working, is to use [**IORegistryExplorer**](https://github.com/khronokernel/IORegistryClone):

- Run the App
- Select `IOService` (default)
- Search for "X86Platform"
- If the plugin is loaded you will see something like this: <br> ![x86pp_loaded](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/15063cc9-4434-432e-879e-bb72fd8269c4)
- If the `X86PlatformPlugin` is not loaded, the legacy `ACPI_SMC_PlatformPlugin` is used instead <br>: ![ACPISMC](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/d065c904-8df2-41c4-8624-4055d05e1310)
- In this case you did something wrong.

### Using Terminal (deceiving)
Alternatively, you could use the following two commands in Terminal:

`sysctl -n machdep.xcpm.mode`

The output should be `1`. But output might return `1` even if the `X86PlatformPlugin` is **NOT** working – as you can see in the following screenshot:

![Terminal](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/a82d6826-a3bc-47c2-b440-81b4a8d83448)

In order to verify that the `X86PlatformPlugin` is *really* working, the output of the following command must also return `1`:

`sysctl -n machdep.xcpm.vectors_loaded_count`

Only if *both* commands return `1`, you can reliably say that `XCPM` is working correctly: 

![Terminal2](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/d8c6c9e1-964f-42c3-9c2a-67ff0d891ead)

**Conlucion**: If your CPU supports `XCPM`, always use IORegistryExplorer to verify the presence of the `X86PlatformPlugin`, because using Terminal command `sysctl -n machdep.xcpm.mode` alone is deceiving and insufficient!

## Testing
To test if SpeedStep and turbo states are working correctly, run [**Intel Power Gadget**](https://www.insanelymac.com/forum/files/file/1056-intel-power-gadget/) and monitor the frequency curve while running a CPU benchmark test in Geekbench. The CPU frequency range should reach all the way from the lowest possible frequency (before running the test) up to the max turbo frequency (as defined by the product specs).

Additionally, you could use [**CPUFriendFriend**](https://github.com/corpnewt/CPUFriendFriend) to inject modified frequency vectors into macOS to fine tune its performance.

You can use IORegistryExplorer to check the number of supported [**CPU states**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(SSDT-PLUG)/XCPM_PSTATES.png) as well as the available Frequency Vecors (under: X86PlatformPlugin/IOPlatformPowerProfile/FrequencyVectors).

## 11th Gen Intel and newer
Since Apple dropped Intel CPU support after 10th Gen Comet Lake, 11th Gen and newer Intel CPUs require ***SSDT-PLUG*** and a fake CPUID ("disguising" it as a Comet Lake CPU) in order to run macOS. Otherwise the system won't boot. 

Add the following data in the `Kernel/Emulate`section of your `config.plist`:

**`Cpuid1Data`**: `55060A00000000000000000000000000` </br>
**`Cpuid1Mask`**: `FFFFFFFF000000000000000000000000` </br>
**`MinKernel`**: `19.0.0`

Since the Comet Lake CPU family is only supported on macOS Catalina and newer, the minimum Darwin Kernel requirement is `19.0.0.` This also means that this fake CPUID is only applied for macOS Catalina and newer. Running older versions of macOS requires using a fake CPUID of an older CPU supported by the macOS version you want to use.

12th Gen Intel Core (Codename "Alder Lake") requires [***SSDT-PLUG-ALT***](https://github.com/5T33Z0/OC-Little-Translated/blob/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(SSDT-PLUG)/SSDT-PLUG-ALT.dsl) instead of ***SSDT-PLUG***. It's contained in the **Docs** folder of the OpenCore Package as well.

## What about AMD?
Since Apple designed macOS Leopard and newer around Intel CPUs, AMD CPUs cannot utilize the `X86PlatformPlugin`. Therefore, `AppleIntelCpuPowerManagement` has to be disabled. To do so, enable the `DummyPowerManagement` Quirk located in the `Kernel/Emulate` section of the `config.plist`.

In 2020, a new Kext called [**SMCAMDProcessor**](https://github.com/trulyspinach/SMCAMDProcessor) was introduced which enables CPU Power Management for AMD Ryzen CPUs. It  also allows using AMD Power Gadget and modifying P-States with AMD Power Tool. Follow the install instructions on the repo to use it.

For **B550** or **A520** mainboards, you also need [**SSDT-CPUR.aml**](https://github.com/dortania/Getting-Started-With-ACPI/blob/master/extra-files/compiled/SSDT-CPUR.aml).

AMD CPU families 15h, to 17h and 19h also require [**additional Kernel Patches**](https://github.com/AMD-OSX/AMD_Vanilla) to work in macOS. 

On macOS 12.3+, you also need [**AppleMCEReporterDisabler**](https://github.com/acidanthera/bugtracker/files/3703498/AppleMCEReporterDisabler.kext.zip) kext when using the following SMBIOSes: `iMacPro1,1`, `MacPro6,1` or `MacPro7,1`.

## Notes
- The `X86PlatformPlugin` is not available for 2nd (Sandy Bridge) and 3rd Gen (Ivy Bridge) Intel CPUs - they use the `ACPI_SMC_PlatformPlugin` instead. But you can use [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) to generate a [**`SSDT-PM`**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)#readme) for these CPUs instead to enable proper CPU Power Management.
- For **Intel Xeon**, a different approach is required if the CPU is not detected by macOS. See [**this guide**](https://www.insanelymac.com/forum/topic/349526-cpu-wrapping-ssdt-cpu-wrap-ssdt-cpur-acpi0007/) for reference.
- From **macOS 12.3 Beta 1** onward, Apple dropped the `plugin-type` check within the `X86PlatformPlugin`. This results in the X86 Platform Plugin being enabled by default. So you no longer need `SSDT-PLUG.aml` to enable it in macOS Monterey and newer. It also means that power management is broken on pre-Ivy Bridge CPUs as they don't have correct power management tables provided. More info [**here**](https://github.com/acidanthera/bugtracker/issues/2013).
- If you are using [**CPUFriend**](https://github.com/acidanthera/CPUFriend) to adjust CPU Power Management, you also don't need SSDT-PLUG – CPUFriend enables the X86PlatformPlugin on its own. In order to work properly, **CPUFriend** requires an additional CPUFriendDataProvider.kext which can be generated with [**CPUFriendFriend**](https://github.com/corpnewt/CPUFriendFriend).

## Credits
- Acidanthera for `SSDT-PLUG-ALT.dsl` for Intel Alder Lake (requires [**Fake CPUID**](https://chriswayg.gitbook.io/opencore-visual-beginners-guide/advanced-topics/using-alder-lake#kernel-greater-than-emulate)).
- Dortania for `SSDT-CPUR.aml` for AMD CPUs
- Trulypsinach for SMCAMDProcessor.kext
