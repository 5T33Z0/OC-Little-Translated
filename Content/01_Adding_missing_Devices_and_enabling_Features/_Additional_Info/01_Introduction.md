# Enabling Devices and Features for macOS

## Introduction
Among the many `SSDT` (Secondary System Description Table) patches available in this repo, a significant number of them are for enabling devices, services or features in macOS. They can be divided into four main categories:

- **Virtual Devices**, such as Fake Embedded Controllers or Ambient Light Sensors, etc. These just need to be present, so macOS is happy and works as expected.
- **Devices which exist in the `DSDT` but are disabled by the vendor.** These are usually devices considered "legacy" under Windows but are required by macOS to boot. They are still present in the system's `DSDT` and provide the same functionality but are disabled in favor of a newer device. A prime example for this is the Realtime Clock (`RTC`) which is disabled in favor of the `AWAC` clock on modern Wintel machines, like 300-series mainboards and newer. SSDT Hotfixes from this category disable the newer device and enable its "legacy" pendent for macOS only by inverting their statuses (`_STA`). 
- **Devices which either do not exist in ACPI or use different names than expected by macOS in order to work**. SSDT hotpatches rename these devices/methods for macOS only, so they can attach to drivers and services in macOS but work as intended in other OSes as well, such as: USB and CPU Power Management, Backlight Control for Laptop Displays, ect. 
- **Patch combinations which work in stages to redefine a device or method so it works with macOS**. First, the original device/method is renamed so macOS doesn't detect it, like `_DSM` to `XDSM` for example. Then a replacement SSDT is written which redefines the device or method for macOS only. The redefined device/method is then injected back into the system, so it's working as expected in macOS. Examples: fixing Sleep and Wake issues or enabling Trackpads.

:bulb: OpenCore users should avoid using binary renames for enabling devices and methods since these renames will be applied system-wide which can break other OSes. Instead, ACPI-compliant SSDTs making use of the `_OSI` method to rename these devices/methods for macOS only should be applied. 

Clover users don't have to worry about this since binary renames and SSDT hotpatches are not injected into other OSes (unless you tell it to do so). But if you are a Clover user switching over to OpenCore, you have to adjust your SSDTs since they most likely don't contain the `_OSI` method!

> [!WARNING] 
> 
> Don't inject already known devices into macOS! Sometimes I come across configs which contain a lot of unnecessary `DeviceProperties` which Hackintool extracted for them. In other words: they inject the same, already known devices and properties back into the system where they came from. In most cases, this is completely unnecessary – there are no benefits in doing so – and it slows down the boot process as well.
>
> The only reason for doing this is to have installed PCIe cards listed in the "PCI" section of System Profiler. Apart from that, all detected devices will be listed in the corresponding category they belong in automatically. So there's really no need to do this.
>
>:bulb: You only need to inject `DeviceProperties` in case you need to modify parameters/properties of devices, features, etc. So don't inject the same, unmodified properties into the system you got them from in the first place!

[←**Back to Overview**](../README.md) | [**Next: Properties of Virtual Devices →**](02_Fake_Devices.md)
