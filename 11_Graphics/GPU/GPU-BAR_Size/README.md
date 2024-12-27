# Adjusting GPU BAR Size in OpenCore

**TABLE of CONTENTS**

- [About PCI BAR Size](#about-pci-bar-size)
- [Quirks for setting GPU BAR size](#quirks-for-setting-gpu-bar-size)
  - [ResizeAppleGPUBars](#resizeapplegpubars)
  - [ResizeGPUBars](#resizegpubars)
  - [ResizeUsePciRbIo](#resizeusepcirbio)
- [How to enable Resizable BAR Support in OpenCore](#how-to-enable-resizable-bar-support-in-opencore)

---

## About PCI BAR Size
GPU BAR size refers to the Base Address Register size of a GPU. It is a feature that improves communication between your processor and graphics card. The BAR size depends on the card type. Resizable BAR is a term specific to NVIDIA’s GPUs, but AMD has its own version of the same technology called Smart Access Memory (SAM). With this feature activated, the CPU can access the entire “frame buffer” (another name for the GPU’s memory), which means it can quickly find and process the data it needs.

> While macOS *does* support this feature, it limits the supported BAR sizes by 1 GB and seems to be unstable with BARs above 256 MB. If both your GPU and your firmware support Resizable BAR, setting `ResizeAppleGpuBars` to `0` will update GPU registers to their defaults when booting macOS and fix the hangs on newer boards.
> 
> **Source**: [Dortania](https://dortania.github.io/hackintosh/updates/2021/11/01/acidanthera-november.html)

## Quirks for setting GPU BAR size
OpenCore features three quirks to control GPU BAR size on per-OS basis, namely `ResizeAppleGPUBars`, `ResizeGPUBars` and `ResizeUsePciRbIo`.

### ResizeAppleGPUBars
The `ResizeAppleGPUBars` quirk limits the GPU PCI BAR sizes for macOS up to the specified value or lower if it is unsupported. When the bit of Capabilities Set, it indicates that the Function supports operating with the BAR sized to (2^Bit) MB. `ResizeGpuBars` must be an integer value between `-1` to `19`.

:warning: **WARNING**
> Do not set `ResizeAppleGpuBars` to anything but `0` if you have resize bar enabled in BIOS. `9` and `10` will cause sleep wake crashes, and `8` will cause excessive memory usage on some GPUs without any useful benefit. It shall always be `0`. It does not matter which GPU you have, they all support this feature since early 2010s, just give no performance gain.
> 
> **Source**: [Vit9696](https://www.insanelymac.com/forum/topic/349485-how-to-opencore-074-075-differences/?do=findComment&comment=2770810)

**Formula**: 2^Bit = ApppleGPUBars Size in MB

| PCI BAR Size | VALUE in OC|
|-------------:|:----------:|
| Disabled|-1|
|1 MB|0|
| 2 MB|1|
| 4 MB|2| 
| 8 MB|3|
| 16 MB|4|
| 32 MB|5|
| 64 MB|6|
| 128 MB|7|
| 256 MB|8|
| 512 MB|9|
| 1 GB°|10°|
| 2 GB|11|
| 4 GB|12|
| 8 GB|13|
| 16 GB|14|
| 32 GB|15|
| 64 GB|16|
| 128 GB|17|
| 256 GB|18|
| 512 GB|19|

`°`Maximum for macOS.

### ResizeGPUBars
With the `ResizeGPUBars` UEFI Quirk you can change the GPU BAR Size of the system. ***This quirk shall not be used to workaround macOS limitation to address BARs over 1 GB.*** `ResizeAppleGpuBars` should be used instead. While this quirk can increase GPU PCI BAR sizes, this will not work on most firmware as is, because the quirk does not relocate BARs in memory, and they will likely overlap.
  
 **Formula**: 2^n = PCI BAR Size in MB
  
| PCI BAR Size | VALUE in OC|
|-------------:|:----------:|
| Disabled|-1|
| 1 MB|0|
| 2 MB|1|
| 4 MB|2| 
| 8 MB|3|
| 16 MB|4|
| 32 MB|5|
| 64 MB|6|
| 128 MB|7|
| 256 MB|8|
| 512 MB°|9°|
| 1 GB|10|
| 2 GB|11|
| 4 GB|12|
| 8 GB|13|
| 16 GB|14|
| 32 GB|15|
| 64 GB|16|
| 128 GB|17|
| 256 GB|18|
| 512 GB|19|

`°`Maximum for macOS IOPCIFamily.

### ResizeUsePciRbIo

OpenCore 0.8.9 introduced a new UEFI quirk called `ResizeUsePciRbIo` which is needed on older systems using a custom UEFI firmware which has been modified with [**ReBarUEFI**](https://github.com/xCuri0/ReBarUEFI#readme) to enable Resizable BAR on some mainboards which don't support it officially.

The quirk makes `ResizeGpuBars` and `ResizeAppleGpuBars` use PciRootBridgeIo instead of PciIo. This is needed on systems with a buggy PciIo implementation where trying to configure Resizable BAR results in a Capability I/O Error. Typically, firmwares prior to Aptio V are affected (Haswell and older). 

> **Disclamer**: Flashing a custom/modified BIOS/UEFI firmware involves risks and may potentially cause damage to your system. You are solely responsible for any actions taken with your device and for ensuring that the custom firmware is compatible with your mainboard. I will not be held liable for any damages or losses that may occur as a result of flashing a custom/modified BIOS/UEFI firmware.

## How to enable Resizable BAR Support in OpenCore

- Open config.plist
- In `Booter/Quirks` set `ResizeAppleGpuBars` to `0` &rarr; Allows macOS to boot with Resizable BAR enabled in BIOS
- In `UEFI/Quirks` set `ResizeGpuBars` to `-1` &rarr; Prevents OpenCore from injecting its ReBAR settings into Windows
- Save your config and reboot
- Enter BIOS
- Enable Resizable BAR in BIOS
- Save and reboot into macOS

> **Warning**:
>
>1. Before enabling this feature, ensure that your GPU supports Resizable BARs with tools like [**HWiNFO**](https://metager.de/meta/meta.ger3?eingabe=HWiNFO) in Windows. 
>2. Make sure you have a working backup of your EFI folder on a flash drive. Because if this is not working, the graphics output will get stuck at the progress bar while the system will be booting fine in the background. In this scenario you have to perform a hard reset, revert the changes in BIOS, boot from your EFI backup and then revert the changes in the main config as well!
