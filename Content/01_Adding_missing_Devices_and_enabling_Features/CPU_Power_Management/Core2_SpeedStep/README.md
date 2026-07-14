# Enabling Intel SpeedStep on Intel Core2 Processors

## About

This guide covers enabling Intel SpeedStep (dynamic frequency/voltage scaling) on pre-XCPM Mac models running Core2-era CPUs under OpenCore. Correctly configured, SpeedStep lowers idle temperatures, reduces fan noise, and improves power efficiency.

**Benefits of Intel SpeedStep:**

- Noticeably cooler CPU temperatures at idle and light load
- Better power efficiency
- Lower fan noise

## Requirements

- **Pre-XCPM SMBIOS**:
  - **Desktops:** `iMac4,1` to `iMac10,1`, or `MacPro3,1` (pick one closest to your CPU model)
  - **Laptops:** `MacBook1,1` to `MacBook7,1`, `MacBookPro1,x` to `MacBookPro5,x`
- Working **`AppleLPC`** Bus (see Step 1)
- Dropping and replacing the OEM `CpuPm`/`CpuCst` tables with modified SSDTs (see Steps 2–3)

## Step 1: Enabling `AppleLPC`

**What is AppleLPC?** LPC stands for **Low Pin Count**, a legacy low-bandwidth bus (the ISA bus's successor) used on PC chipsets to connect components like Super I/O chips, TPM, and BIOS flash. `AppleLPC.kext` is Apple's driver for the LPC controller device on the Southbridge/PCH.

On pre-XCPM systems, `AppleLPC` isn't just a bus driver — it's part of the power-management chain. It works alongside `AppleIntelCPUPowerManagement` to handle the chipset-level plumbing that the non-XCPM P-state/C-state path relies on. Without `AppleLPC` binding correctly, there's no valid platform driver for power management to hook into, so injected `CpuPm`/`CpuCst` tables won't be used even if they're present and correctly formatted.

Getting `AppleLPC` to load requires injecting the name property of the **ISA bridge** to match one of the LPC controllers included in `AppleLPC.kext`, located at `/System/Library/Extensions/AppleLPC.kext/Contents/Info.plist`. On Intel systems, the ISA bridge is usually located at `PciRoot(0x0)/Pci(0x1F,0x0)`. Verify with Hackintool if you're unsure of the exact path on your system.

**INSTRUCTONS**

1. Pick the LPC controller ID suitable for your chipset. The `IOName` property can be injected via SSDT, or via `config.plist` (**Device Properties → Add**), as shown below: <br>![AppleLPC device match](https://github.com/AppleBreak1/EP45-UD3P-Customac/assets/97265013/c6aaf4b1-4771-4da4-a1c1-16bcfaebcc30)
2. Reboot after adding the device property.
3. **Verify:** if the injection worked, `AppleLPC` will appear in IORegistryExplorer under the ISA bridge: <br> ![AppleLPC visible in IORegistryExplorer](https://github.com/AppleBreak1/EP45-UD3P-Customac/assets/97265013/79ead375-a9fe-4354-a89e-cb2115b6b8ce)

## Step 2: Modifying CpuPm and CpuCst Tables

There are two ways to do this.

### Option A — Let Clover Generate the Tables

Let the Clover bootloader generate the tables (no manual value-hunting required):

1. Boot with the Clover bootloader, with **Generate CState/Pstate** enabled in `config.plist`.
2. Confirm SpeedStep is working correctly under Clover first.
3. Open [MaciASL](https://github.com/acidanthera/MaciASL) → **Files → New from ACPI** → open the Clover-generated `CpuPm`/`CpuCst` tables and save them: <br>![Extracting tables in MaciASL](https://github.com/AppleBreak1/EP45-UD3P-Customac/assets/97265013/ad076779-5f39-473b-93c9-f517ab3378e0)
4. Add these tables to your OpenCore EFI and `config.plist` — done.
5. Reboot and verify functionality (&rarr; See Step 4)

### Option B — Hand-Build Tables via the "Vanilla SpeedStep" Method

Follow the classic [DSDT Vanilla SpeedStep (generic scope `_PR`) guide](https://www.insanelymac.com/forum/topic/181631-dsdt-vanilla-speedstep-generic-scope-_pr/).

> [!NOTE]
> 
> The generic scope from that guide can be injected via SSDT — no DSDT patching required. In testing, there's no measurable CPU benchmark difference between the Clover-generated tables and the generic scope. However, idle **temperature and fan RPM differ noticeably**: the generic scope runs cooler and quieter at idle. This appears to come down to how each approach implements the `_CST` method.

## Step 3: Drop Native Tables and Inject the Modified Ones

The native `CpuPm`/`CpuCst` tables must not coexist with your modified ones.

1. Either disable **C1E / C2 / C4 / CPU EIST** in BIOS, **or** drop all native `CpuPm`/`CpuCst` tables via `config.plist` (`ACPI → Delete`).
2. Add the modified tables (from Option A or B above) to `config.plist` under `ACPI → Add`, and make sure they load.

> [!CAUTION]
> 
> Leaving native and modified tables active at the same time will cause conflicts — SpeedStep may silently fail to engage, or the system may become unstable under load.

## Step 4: Verify SpeedStep Is Working

To verify that SpeedStep is active, you must use a sensor suite capable of reading the CPU's internal registers. On legacy systems (like Core 2 Duo/Quad), standard Apple-style monitoring does not report frequencies, so you must use **FakeSMC** and its plugins to "expose" these values to macOS.

**Required Files:**

- **Kexts:**
  - [**FakeSMC3**](https://github.com/CloverHackyColor/FakeSMC3_with_plugins) — The core SMC emulator.
  - **IntelCPUMonitor.kext** — (Included with FakeSMC3) The specific plugin required to report CPU frequencies and multipliers.
- **Apps:**
  - [**HWMonitorSMC2**](https://github.com/CloverHackyColor/HWMonitorSMC2) — The GUI tool to display the sensor data.
  - [**IORegistryExplorer**](https://github.com/utopia-team/IORegistryExplorer) — For inspecting the internal power management nodes.

**INSTRUCTIONS:**

1. **Install FakeSMC:** Replace VirtualSMC (if present) with **FakeSMC3.kext** and **IntelCPUMonitor.kext** in your EFI/OC/Kexts folder. Ensure they are enabled in your `config.plist`.
2. Save your `config.plist` and reboot
3. **Launch HWMonitorSMC2:** Open the application and look for the **"Core Frequencies"** or **"Multipliers"** section.
4. **Confirm Scaling:** Watch the frequencies while the system is idle, then perform a task (like opening a browser). You should see the frequencies and multipliers jump up and down dynamically. If they are "stuck" at one speed, SpeedStep is not working.   
	***Example of active P-States:***
      ![HWMonitor showing active P-states](https://github.com/AppleBreak1/EP45-UD3P-Customac/assets/97265013/64fb33ca-a7bd-4dd5-bc9f-82be1de45b11)
4. Run **IORegistryExplorer** and search for `AppleACPICPU`. Confirm the power-management nodes are populated under each CPU core. This indicates that macOS has successfully attached its power management driver to your processor.  
	***Example of healthy nodes:***
      ![IORegistryExplorer power management nodes](https://github.com/AppleBreak1/EP45-UD3P-Customac/assets/97265013/0ba3c796-7cac-4239-8a9c-229abff01951)

> [!TIP]
> **For OpenCore Users (Switching back to VirtualSMC):**
>
> While `FakeSMC` is superior for sensor reporting on *legacy* hardware, many OpenCore users prefer `VirtualSMC` for its modern codebase and closer emulation of real Mac hardware.
> 
> Once you have used the steps above to **confirm** that your frequency scaling is working correctly, you can switch back to VirtualSMC for daily use. Note that after switching back, your "Core Frequencies" in HWMonitorSMC2 will likely disappear or show as 0Hz. This is normal; as long as you verified the scaling with FakeSMC and the nodes are present in IORegistryExplorer, SpeedStep is still working in the background. 
> 
> **To switch back:** Replace `FakeSMC.kext` and `IntelCPUMonitor.kext` with `VirtualSMC.kext` and `SMCProcessor.kext` in your config.plist and EFI folder.

## Credits

- AppleBreak1 for the [original guide](https://github.com/AppleBreak1/EP45-UD3P-Customac/blob/main/7.%20Miscellaneous/Misc.md)

