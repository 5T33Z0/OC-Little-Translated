
# About WhateverGreen's Apple GuC firmware support

**INDEX**

- [Introduction](#introduction)
- [What is the GuC Firmware?](#what-is-the-guc-firmware)
- [What Does the GuC Firmware do in macOS?](#what-does-the-guc-firmware-do-in-macos)
- [Supported CPU Families and Chipsets](#supported-cpu-families-and-chipsets)
- [Differences Between GuC Firmware and RPS Control](#differences-between-guc-firmware-and-rps-control)
- [How to Enable GuC Firmware with WhateverGreen](#how-to-enable-guc-firmware-with-whatevergreen)
- [Tips for Testing](#tips-for-testing)
- [Known issues](#known-issues)
- [Additional Notes](#additional-notes)

---

## Introduction

The **WhateverGreen kext** is a widely used Lilu plugin for macOS Hackintosh systems that provides various patches for GPUs, including Intel integrated GPUs (iGPUs), to enable proper functionality, graphics acceleration, and advanced features like Apple's GuC firmware. 

This article will explain what the GuC firmware is, its purpose, supported CPU families and chipsets, and how it differs from RPS control, based on available information and technical context.

## What is the GuC Firmware?

**GuC (Graphics Micro Controller) firmware** is a binary firmware component developed by Intel for its integrated GPUs, used to offload certain graphics-related tasks from the CPU and GPU drivers to a dedicated microcontroller embedded in the GPU. In the context of macOS and Hackintosh systems, Apple’s GuC firmware is a specific implementation that WhateverGreen can load to enhance iGPU performance, power management, and feature support.

- **Purpose of GuC Firmware**:
  
  - **Power Management**: GuC handles dynamic frequency scaling and power-saving features, optimizing the iGPU’s performance and energy efficiency by adjusting clock speeds based on workload.
  
  - **Workload Scheduling**: It manages graphics workload scheduling, reducing the CPU’s involvement in certain graphics tasks, which can improve performance in tasks like video encoding/decoding (e.g., Quick Sync Video).
  
  - **DRM Support**: GuC firmware can help enable hardware-based Digital Rights Management (DRM) for applications like Safari, ensuring proper playback of protected content (e.g., Apple TV, Netflix).
  
  - **Enhanced Features**: It supports advanced graphics features, such as improved display handling, HDMI audio, and hardware acceleration for specific tasks.
  
  - **Stability and Compatibility**: In Hackintosh setups, loading Apple’s GuC firmware aims to make the iGPU behave more like a native macOS implementation, improving compatibility with macOS graphics frameworks.

- **How WhateverGreen Enables GuC**:<br>
  [WhateverGreen](https://github.com/acidanthera/WhateverGreen) provides a boot argument (`igfxfw=2`) to force-load Apple’s GuC firmware on supported Intel iGPUs. This is particularly useful for Hackintosh systems, as macOS does not natively load GuC firmware on non-Apple hardware. The kext modifies the iGPU’s behavior to mimic a real Mac’s graphics stack, enabling features like Intel Quick Sync Video (IQSV) and fixing issues like black screens or improper display output. ([More details](https://elitemacx86.com/threads/how-to-improve-igpu-performance-intel-graphics-on-macos.1059/))

## What Does the GuC Firmware do in macOS?

When enabled via WhateverGreen, GuC firmware provides the following benefits:

- **Improved iGPU Performance**: Enhances graphics performance by allowing the iGPU to dynamically adjust its frequency, potentially reaching higher clock speeds during intensive tasks (e.g., video rendering in Final Cut Pro or Compressor).([More details](https://github.com/acidanthera/bugtracker/issues/800#issuecomment-673606869))

- **Better Power Management**: Optimizes power consumption, which is critical for laptops, by adjusting iGPU frequency based on demand, reducing power usage during idle states.

- **Quick Sync Video (IQSV)**: Enables hardware-accelerated video encoding and decoding, crucial for tasks like video editing and streaming. This requires proper iGPU configuration and GuC firmware.

- **Fixing Display Issues**: Helps resolve issues like black screens, improper display output, or wake-from-sleep problems by improving framebuffer and connector handling.

- **DRM Compatibility**: Supports hardware-based DRM, enabling protected content playback in applications like Safari, which rely on Apple's graphics stack. (&rarr; refer to [Fixing DRM Support and iGPU performance](https://dortania.github.io/OpenCore-Post-Install/universal/drm.html) for more details and limititation in macOS 11+).

However, there are caveats:

- **Potential Issues**: GuC firmware loading can be unstable on some systems, leading to kernel panics, graphics errors, or the iGPU getting stuck at a high frequency (not dropping to idle). A sleep/wake cycle or restart may be required to reset the frequency.[](https://elitemacx86.com/threads/how-to-improve-igpu-performance-intel-graphics-on-macos.1059/)

- **Not Guaranteed to Work**: Even on supported hardware, GuC firmware loading is [not always successful](https://www.reddit.com/r/hackintosh/comments/i5kfuh/problem_with_igfxfw_apples_guc/), and compatibility depends on the chipset and CPU generation. If it fails, the system may still boot after retries but could lack graphics acceleration. 

## Supported CPU Families and Chipsets

GuC firmware support is limited to specific Intel CPU families and chipsets, particularly newer generations. Based on available data, the following are supported:

- **CPU Families**:
 
  - **Skylake (6th Gen)**: Supports GuC firmware, as it was one of the first generations where Intel moved graphics-related tasks to firmware.[](https://gist.github.com/Brainiarc7/aa43570f512906e882ad6cdd835efe57)
  
  - **Kaby Lake (7th Gen)**: Fully supported, with Apple’s GuC firmware being more reliable on these CPUs.[](https://github.com/acidanthera/WhateverGreen)[](https://www.reddit.com/r/hackintosh/comments/gbg5ms/oopencores_igfxfw_and_apples_guc/)
  
  - **Coffee Lake (8th/9th Gen)**: Supported, commonly used in Hackintosh builds with UHD Graphics (e.g., UHD 630).[](https://www.tonymacx86.com/threads/guide-intel-framebuffer-patching-using-whatevergreen.256490/page-58)
  
  - **Comet Lake (10th Gen)**: Supported, with similar iGPU configurations to Coffee Lake.[](https://www.reddit.com/r/hackintosh/comments/qzdbdm/whatevergreen_wtf_does_it_mean/)
  
  - **Ice Lake (10th Gen)** and later (e.g., Tiger Lake, Alder Lake): Supported, though newer generations may require additional configuration due to changes in Intel’s graphics architecture.[](https://github.com/acidanthera/WhateverGreen)[](https://gist.github.com/Brainiarc7/aa43570f512906e882ad6cdd835efe57)
  
  - **Unsupported Older Generations**:
  
    - **Haswell (4th Gen)** and earlier (e.g., Ivy Bridge, Sandy Bridge): GuC firmware is not supported, as these iGPUs rely on older driver architectures and lack the necessary microcontroller.
  
    - **Broadwell (5th Gen)**: Limited support; GuC firmware may work in some cases but is not guaranteed, as Apple’s drivers for Broadwell iGPUs (e.g., Iris Pro 6200) are less tested.

- **Chipsets**:
  
  - **300 Series and Newer**: Includes Z390, B360, H370, Q370, H310, etc. These chipsets are compatible with GuC firmware loading.
  
  - **Exceptions**:
  
    - **Z370 Chipset**: Despite being marketed as a 300-series chipset, it is technically a 200-series chipset (a rebranded Z270). GuC firmware is not supported on Z370 or older 200-series/100-series chipsets (e.g., Z270, H270, Z170).
  
    - **Older Chipsets (e.g., 100/200 Series, 22nm Process)**: Chipsets like Z170, H170, or earlier (e.g., 7-series for Sandy Bridge/Ivy Bridge) do not support GuC firmware due to hardware limitations.

> [!IMPORTANT]
>
> - GuC firmware loading is more reliable on laptops than desktops, as Apple’s firmware is tailored for mobile iGPUs. Desktop users may encounter issues, including failure to boot, and should have a backup EFI.
> 
> - Even with supported chipsets, firmware loading is not guaranteed ([example](https://www.reddit.com/r/hackintosh/comments/i5kfuh/problem_with_igfxfw_apples_guc/)) and may require trial and error. If it fails, users should remove the `igfxfw=2` boot argument or DeviceProperties entry to avoid issues.

## Differences Between GuC Firmware and RPS Control

**RPS (Render P-State) Control** is a feature in Intel iGPUs that manages the GPU’s frequency scaling to optimize performance and power consumption. It is part of the iGPU’s driver stack and does not rely on external firmware like GuC. WhateverGreen introduced RPS control improvements starting with version 1.4.1, allowing the iGPU to reach higher frequencies without requiring GuC firmware.

Here is a detailed comparison:

| **Aspect** | **GuC Firmware** | **RPS Control** |
|------------|------------------|-----------------|
| **Definition**           | A binary firmware loaded by the GPU to handle tasks like power management, scheduling, and DRM. | A driver-based mechanism for managing iGPU frequency scaling and performance.   |
| **Purpose**              | Offloads graphics tasks to a microcontroller, enabling advanced features like Quick Sync, DRM, and better power management. | Controls iGPU clock speeds directly via the driver, focusing on performance optimization. |
| **Implementation**       | Requires explicit loading via WhateverGreen (`igfxfw=2` boot-arg or DeviceProperties). | Enabled by default in WhateverGreen 1.4.1+; can be disabled with `igfxnorpsc=1`. |[](https://elitemacx86.com/threads/how-to-improve-igpu-performance-intel-graphics-on-macos.1059/)
| **Hardware Support**     | Skylake and newer (6th Gen+); 300-series chipsets or newer (except Z370).         | Broadly supported across Intel iGPUs, including older generations like Haswell. |
| **Performance Impact**   | Can significantly improve performance for tasks like video encoding/decoding and DRM playback, but may cause issues like frequency locking. | Improves iGPU frequency scaling, allowing higher clocks without firmware, but may not support advanced features like DRM. |[](https://elitemacx86.com/threads/how-to-improve-igpu-performance-intel-graphics-on-macos.1059/)[](https://elitemacx86.com/threads/how-to-improve-igpu-performance-intel-graphics-on-macos.1059/)
| **Stability**            | Can be unstable, leading to kernel panics or graphics errors if unsupported. Requires sleep/wake to reset frequency in some cases. | More stable, as it relies on driver-level control rather than external firmware. |[](https://elitemacx86.com/threads/how-to-improve-igpu-performance-intel-graphics-on-macos.1059/)
| **Use Case**             | Ideal for users needing full macOS compatibility (e.g., Quick Sync, DRM in Safari) on supported hardware. | Suitable for broader compatibility and performance tuning without firmware risks. |
| **Dependencies**         | Requires WhateverGreen and Lilu kexts; specific hardware support.                 | Requires WhateverGreen and Lilu; works with most Intel iGPUs.                   |

- **Key Differences**:
  - **Scope**: GuC firmware offloads tasks to a dedicated microcontroller, enabling advanced features like hardware DRM and Quick Sync, while RPS control is a simpler, driver-based approach focused on frequency scaling.[](https://elitemacx86.com/threads/how-to-improve-igpu-performance-intel-graphics-on-macos.1059/)
  - **Compatibility**: GuC is limited to newer hardware (Skylake+ and 300-series chipsets, excluding Z370), while RPS control works on a wider range of iGPUs, including older generations.[](https://elitemacx86.com/threads/how-to-improve-igpu-performance-intel-graphics-on-macos.1059/)[](https://www.reddit.com/r/hackintosh/comments/gbg5ms/oopencores_igfxfw_and_apples_guc/)
  - **Stability**: GuC can cause issues like kernel panics or frequency locking, especially on unsupported hardware, whereas RPS control is more reliable and less prone to errors.[](https://elitemacx86.com/threads/how-to-improve-igpu-performance-intel-graphics-on-macos.1059/)[](https://www.reddit.com/r/hackintosh/comments/i5kfuh/problem_with_igfxfw_apples_guc/)
  - **Feature Set**: GuC enables macOS-specific features (e.g., DRM, Quick Sync), making it closer to a native Mac experience, while RPS control focuses on performance without requiring firmware loading.[](https://dortania.github.io/OpenCore-Post-Install/universal/drm.html)[](https://dortania.github.io/OpenCore-Desktop-Guide/post-install/drm.html)

- **Practical Implications**:
  - If you’re using a supported CPU (e.g., Kaby Lake, Coffee Lake) and chipset (e.g., Z390), enabling GuC firmware with `igfxfw=2` can unlock better performance and macOS-specific features, but you should monitor for stability issues. Use Hackintool to verify firmware loading via kernel logs.[](https://elitemacx86.com/threads/how-to-improve-igpu-performance-intel-graphics-on-macos.1059/)
  - If GuC is unsupported (e.g., Z370 or older CPUs like Haswell), rely on RPS control, which can be enabled in WhateverGreen if needed. This provides performance improvements without the risks of firmware loading.[](https://elitemacx86.com/threads/how-to-improve-igpu-performance-intel-graphics-on-macos.1059/)
  - For users prioritizing stability or using older hardware, sticking with RPS control is safer, while GuC is better for those needing full macOS graphics compatibility on supported systems.

## How to Enable GuC Firmware with WhateverGreen

To enable GuC firmware:
1. **Add Required Kexts**:
   - Install **Lilu.kext** and **WhateverGreen.kext** in your EFI folder (EFI/OC/Kexts for OpenCore or EFI/Clover/Kexts/Others for Clover).[](https://elitemacx86.com/threads/how-to-enable-intel-hd-and-uhd-graphics-on-macos-intel-framebuffer-patching-guide.931/)
2. **Configure Boot Argument or DeviceProperties**:
   - **Boot Argument**: Add `igfxfw=2` to your `config.plist` under `NVRAM > Add > 7C436110-AB2A-4BBB-A880-FE41995C9F82 > boot-args`.[](https://elitemacx86.com/threads/how-to-improve-igpu-performance-intel-graphics-on-macos.1059/)
   - **DeviceProperties**: Add `PciRoot(0x0)/Pci(0x2,0x0)` with the property `igfxfw` set to `<02000000>` (data type) in `DeviceProperties > Add`. Do not use both methods simultaneously.[](https://www.reddit.com/r/hackintosh/comments/gbg5ms/oopencores_igfxfw_and_apples_guc/)
3. **Verify Loading**:
   - Use **Hackintool** to check kernel logs for successful GuC firmware loading. Look for entries indicating firmware initialization. If it fails, you may see errors or a lack of graphics acceleration.[](https://elitemacx86.com/threads/how-to-improve-igpu-performance-intel-graphics-on-macos.1059/)
4. **Fallback**:
   - If GuC loading causes issues (e.g., kernel panic, graphics errors), remove the `igfxfw=2` boot-arg or DeviceProperties entry and rely on RPS control.[](https://elitemacx86.com/threads/how-to-improve-igpu-performance-intel-graphics-on-macos.1059/)[](https://www.reddit.com/r/hackintosh/comments/i5kfuh/problem_with_igfxfw_apples_guc/)


## Tips for Testing
To evaluate the impact of patches like RPS control or Apple’s GuC firmware on iGPU performance, run Geekbench 5’s Metal test (under “Compute”) three times: once with your default framebuffer, once with RPS control enabled, and once with GuC firmware force-enabled. Compare the scores – higher values indicate better performance. Use the configuration with the best results. If GuC firmware causes issues in daily use, revert to RPS control.

## Known issues

- **Firefox** crashing while using Apple GUC (Generic USB Client) firmware is a known issue that has been reported by several users. In this case either use Safari or disable Apple GuC firmware injection.

## Additional Notes

- **Testing Caution**: Always have a backup EFI partition, as enabling GuC on unsupported hardware can prevent booting. Desktop users should be particularly cautious, as GuC is less reliable on desktop systems compared to laptops.

- **Alternative Tools**: For framebuffer patching and iGPU configuration, tools like **Hackintool** or **OpenCore Configurator** can simplify setting up `ig-platform-id`, `device-id`, and other properties needed for GuC or RPS control.

- **Community Resources**: Check forums like InsanelyMac, r/hackintosh or hackintosh-forum.de for user experiences with specific CPU/chipset combinations, as real-world results vary. 

- By understanding your hardware and the trade-offs between GuC firmware and RPS control, you can optimize your Hackintosh’s iGPU performance while maintaining stability.