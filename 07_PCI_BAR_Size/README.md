# About PCI BAR Size
> Resizable BAR is a PCI specification feature which allows control of the amount of video memory visible from the CPU. While macOS does support this feature, it limits the supported BAR sizes by 1 GB and seems to be unstable with BARs above 256 MB. If both your GPU and your firmware support Resizable BAR, setting ResizeAppleGpuBars to 0 will update GPU registers to their defaults when booting macOS and fix the hangs on newer boards.
> 
> **Source**: [Dortania](https://dortania.github.io/hackintosh/updates/2021/11/01/acidanthera-november.html)

## Valid PCI BAR Sizes for PCI 2.0
OpenCore 0.7.5 introduced GPU Resize BAR quirks to reduce BARs on per-OS basis, namely `ResizeGPUBars` and `ResizeAppleGPUBars`.

### ResizeGPUBars
With this UEFI Quirk you change the the GPU BAR Size of the system. ***This quirk shall not be used to workaround macOS limitation to address BARs over 1 GB.*** `ResizeAppleGpuBars` should be used instead. While this quirk can increase GPU PCI BAR sizes, this will not work on most firmware as is, because the quirk does not relocate BARs in memory, and they will likely overlap.
 
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
| 512 MB*|9*|
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

`*`Maximum for macOS IOPCIFamily.

### ResizeAppleGPUBars
This quirk limits the GPU PCI BAR sizes for macOS up to the specified value or lower if it is unsupported. When the bit of Capabilities Set, it indicates that the Function supports operating with the BAR sized to (2^Bit) MB.

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
| 1 GB*|10*|
| 2 GB|11|
| 4 GB|12|
| 8 GB|13|
| 16 GB|14|
| 32 GB|15|
| 64 GB|16|
| 128 GB|17|
| 256 GB|18|
| 512 GB|19|

`*`Maximum for macOS.

## Note
Before you change any of these values, research if your GPU supports BAR Resize and check the supportedt size with tools like HWiNFO on PC.