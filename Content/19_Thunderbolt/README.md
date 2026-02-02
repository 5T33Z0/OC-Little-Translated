# Thunderbolt Support in macOS

:construction: **Work in Progress**

## Introduction

This section gathers useful resources for working with Thunderbolt on macOS. It’s intended as a starting point rather than a complete guide, providing links to firmware updates, patching tools, and utilities that can help manage or troubleshoot Thunderbolt functionality on Hackintosh or Mac systems.

Using non-Apple Thunderbolt controllers like **Alpine Ridge** or **Titan Ridge** in Hackintosh setups comes with several challenges. macOS does not natively support these controllers, so ports may fail to initialize or work only partially without third-party kexts or patchers. Most of the time, **flashing a compatible Apple or custom firmware is necessary** to make the controller fully functional. Firmware compatibility is crucial—without it, ports may not initialize, hot-plugging can fail, and features like DisplayPort Alt Mode, Power Delivery, Thunderbolt Networking, or Target Disk Mode may be unavailable. System updates can also break support, requiring updated tools or firmware to restore functionality.

## Resources

- **Thunderbolt Firmware**: [https://github.com/utopia-team/Thunderbolt](https://github.com/utopia-team/Thunderbolt) — Collection of Apple and custom TB firmware, required for proper device initialization and full macOS feature support.
- **Thunderbolt Reset** (kext): [https://github.com/osy/ThunderboltReset](https://github.com/osy/ThunderboltReset) → Disables the Intel Connection Manager on Alpine Ridge controllers so macOS can fully control the ports. It’s not just a “reset” in the generic sense—it’s a critical step for macOS to assume LC duties.
- **Thunderbolt Patcher**: [https://github.com/osy/ThunderboltPatcher](https://github.com/osy/ThunderboltPatcher) → modifies controller IDs or behavior for recognition in macOS.
