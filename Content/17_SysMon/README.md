# System Monitoring on Hackintosh: VirtualSMC vs. FakeSMC Plugins

**INDEX**

- [Introduction](#introduction)
- [Option 1: VirtualSMC](#option-1-virtualsmc)
  - [Official VirtualSMC Sensor Plugins](#official-virtualsmc-sensor-plugins)
  - [3rd Party Sensor Plugins](#3rd-party-sensor-plugins)
- [Option 2: FakeSMC3](#option-2-fakesmc3)
  - [Included Plugins](#included-plugins)
- [Compatible Monitoring Tools](#compatible-monitoring-tools)
- [Choosing the Right SMC Emulator](#choosing-the-right-smc-emulator)
- [Example Directory Structures](#example-directory-structures)
- [Conclusion](#conclusion)

---

## Introduction

Monitoring hardware values such as CPU temperature, fan speed, voltages, and battery status is essential for managing the performance and stability of any Hackintosh system. On genuine Apple hardware, these tasks are handled by the System Management Controller (SMC). On Hackintosh setups, this functionality is emulated through kernel extensions (kexts).

There are two primary approaches for SMC emulation and sensor monitoring:

1. **VirtualSMC** — the modern, actively maintained solution developed by the Acidanthera team
2. **FakeSMC3\_with\_plugins** — a modernized fork of the original FakeSMC, maintained by CloverHackyColor

This guide outlines the differences between the two approaches, explains the roles of their respective plugins, and helps you determine which setup is most appropriate for your system.

## Option 1: VirtualSMC

**GitHub**: [acidanthera/VirtualSMC](https://github.com/acidanthera/VirtualSMC)

VirtualSMC is the current standard for SMC emulation in OpenCore-based systems. It is modular, requires **Lilu.kext**, and supports all modern versions of macOS.

### Official VirtualSMC Sensor Plugins

Plugin | Purpose | macOS
-------|---------|-------
**SMCSuperIO.kext** | Adds support for Super I/O chip sensors (e.g., fan speed, temperature) | 10.6+
**SMCProcessor.kext** | Intel CPU temperature monitoring | 10.7+
**SMCLightSensor.kext** | Support for ambient light sensors (found in some laptops) | 10.6+
**SMCDellSensors.kext** | Adds fan monitoring and control for Dell laptops via EC/SMM | 10.7+
**SMCBatteryManager.kext** | Laptop battery status (charge level, cycles, etc.) | 10.4+

These plugins are loaded in addition to `VirtualSMC.kext` and must be enabled in `config.plist`.

### 3rd Party Sensor Plugins

In addition to the official plugins for VirtualSMC by Acidanthera, several community-developed sensor extensions provide support for AMD CPUs, Radeon GPUs, and other hardware not covered by the core project. These kexts typically require **Lilu.kext** and **VirtualSMC.kext** to function properly.

Plugin | Description | macOS
-------|-------------|-------
[**SMCAMDProcessor.kext**](https://github.com/trulyspinach/SMCAMDProcessor) | Temperature monitoring for AMD Ryzen and Threadripper CPUs | 10.13+
[**SMCRadeonSensorss**](https://github.com/ChefKissInc/SMCRadeonSensors) | AMD GPU temperature monitoring on macOS. No commercial use. | 10.14+

> [!NOTE]
> 
> These plugins are often used by AMD Hackintosh users or systems with modern dGPUs not supported by FakeSMC plugins.

## Option 2: FakeSMC3

**GitHub**: [CloverHackyColor/FakeSMC3\_with\_plugins](https://github.com/CloverHackyColor/FakeSMC3_with_plugins)

This fork of the original FakeSMC has been modernized to support macOS High Sierra through Tahoe. Unlike the original, it is fully modular and supports a wide variety of monitoring extensions, including some legacy sensor chips that VirtualSMC does not support.

FakeSMC3 does not require `Lilu.kext` and is often preferred on older systems, or where deeper low-level sensor access is required (via ACPI, SMI, or I/O chipsets).

### Included Plugins

Plugin | Purpose
-------|--------
**ACPIMonitor.kext** | Monitors temperatures and voltages using ACPI tables
**AmdCPUMonitor.kext** | CPU sensor support for AMD systems
**IntelCPUMonitor.kext** | CPU temperature and power monitoring for Intel processors
**RadeonMonitor.kext** | Sensor support for AMD Radeon GPUs
**SMIMonitor.kext** | Uses System Management Interrupt (SMI) to access hardware sensors
**F718x.kext** | Support for Fintek Super I/O chips (e.g., F71882, F71869)
**ITEIT87x.kext** | Adds support for ITE IT87xx series Super I/O sensors
**W836x.kext** | Supports Winbond W836xx series sensor chips
**VoodooBatterySMC.kext** | Battery monitoring for laptops (alternative to ACPIBatteryManager or SMCBatteryManager)

> [!NOTE]
>
> Only load the sensor kexts relevant to your hardware. Loading unnecessary plugins may lead to boot delays or conflicts.

## Compatible Monitoring Tools

| Tool | Freeware | Compatible with Hackintosh | Description|
| ---- | :------: | :------------------------: | ---------- |
| [**HWMonitorSMC2**](https://github.com/CloverHackyColor/HWMonitorSMC2)                    | Yes      | ✅                          | Free and open-source system monitor that supports both VirtualSMC and FakeSMC plugins                                                                                                                    |
| [**iStat Menus**](https://bjango.com/mac/istatmenus/)                                     | No       | ✅                          | Commercial app with advanced monitoring features for macOS (works with SMC plugins)                                                                                                                      |
| [**Intel Power Gadget**](https://www.techspot.com/downloads/7172-intel-power-gadget.html) | Yes      | ✅ (Intel only)             | Intel's official tool for real-time power and thermal data; installs a kext that can also be read by HWMonitorSMC2 (select in app settings). Only compatible up to 10th Gen Intel Core CPUs (Comet Lake) |
| [**Macs Fan Control**](https://crystalidea.com/macs-fan-control)                          | Yes      | ❌                          | Not compatible with Hackintosh systems; requires a real SMC device                                                                                                                                       |
| System Report *(in macOS)*                                                            | Yes      | ✅                          | Built-in macOS utility that shows SMC and sensor information under "Power" and "Hardware" sections                                                                                                       |

## Choosing the Right SMC Emulator

Use Case | Recommended Option
---------|--------------------
OpenCore setup with modern hardware | VirtualSMC
Older hardware requiring SMM/ACPI sensors | FakeSMC3
Need dGPU temperature monitoring | FakeSMC3 (experimental support)
Minimal setup without Lilu | FakeSMC3
Full Acidanthera compatibility | VirtualSMC

> \[!IMPORTANT]
> **Do not mix** VirtualSMC and FakeSMC. Only one SMC emulator should be used at a time.

## Example Directory Structures

**VirtualSMC Setup** (OpenCore)

```
EFI/OC/Kexts/
├── Lilu.kext
├── VirtualSMC.kext
├── SMCProcessor.kext
├── SMCSuperIO.kext
└── SMCBatteryManager.kext
```

**FakeSMC3 Setup** (OpenCore)

```
EFI/OC/Kexts/
├── FakeSMC.kext
├── ACPIMonitor.kext
├── IntelCPUMonitor.kext
├── RadeonMonitor.kext
├── SMIMonitor.kext
└── ITEIT87x.kext
```

## Conclusion

Both **VirtualSMC** and **FakeSMC3s** provide reliable solutions for emulating the SMC and accessing hardware sensor data on a Hackintosh. VirtualSMC is the official, Lilu-based solution recommended for most users, while FakeSMC3 may be preferable for systems requiring extended or legacy sensor support, especially if Lilu is to be avoided.

**Recommendation**:

- **VirtualSMC** is best for modern Hackintosh builds, especially laptops, due to its integration with Lilu-based kexts, robust battery management, and active development. It’s the recommended choice for OpenCore users and newer macOS versions but may lack some sensor support compared to FakeSMC3.
- **FakeSMC3** is Ideal for older hardware or systems requiring extensive sensor monitoring (e.g., GPU, fan speeds). It’s a stable choice for Clover-based setups but may face compatibility challenges with newer macOS versions and has less active development.

When used correctly and with compatible tools such as **HWMonitorSMC2**, either solution can provide full-featured, real-time monitoring of your Hackintosh system.
