# Additional Resources

## Essential Tools and Kexts

### USBInjectAll Kext
- [**USBInjectAll.kext**](https://github.com/daliansky/OS-X-USB-Inject-All/releases) by daliansky
  - Updated version with IOKit Personalities for the latest SMBIOSes and USB Controllers
  - Includes support for 400 to 700-series mainboards
  - Contains approximately 9,300 lines of code (vs. 6,800 in the original 2018 version by Rehabman)

### XHCI Support
- [**Determining if you need XHCI-Unsupported kext**](/Content/03_USB_Fixes/05_xhci_unsupported.md)

## Guides and Documentation

### Port Mapping Guides
- [**Hackintool Port Mapping Guide**](https://chriswayg.gitbook.io/opencore-visual-beginners-guide/step-by-step/install-postinstall/usb-port-mapping) by chriswayg
  - Comprehensive visual guide for USB port mapping
  - Note: Some information about `XhciPortLimit` Quirk and blocking ports via NVRAM may be outdated

## Specialized Kexts and Fixes

### USB Wake Issues
- [**USBWakeFixup**](https://github.com/osy/USBWakeFixup)
  - Kext and SSDT for fixing USB Wake issues
  - Resolves sleep/wake problems related to USB devices

### AMD Ryzen Systems
- [**GUX-RyzenXHCIFix**](https://github.com/RattletraPM/GUX-RyzenXHCIFix)
  - `GenericUSBXHCI.kext` variant for fixing USB 3 issues
  - Specifically for APU-based Ryzentoshes running macOS 11.0 or newer

## Advanced Topics

### USB-C and Type-C Controllers
- [**ACE: Apple Type-C Port Controller Secrets**](https://web.archive.org/web/20211023034503/https://blog.t8012.dev/ace-part-1/) (archived)
  - Deep dive into Apple's Type-C port controller implementation
  - Advanced technical information for USB-C troubleshooting

## Community Resources

For additional help and community support:
- Check the [Hackintosh subreddit](https://www.reddit.com/r/hackintosh/)
- Visit the [Dortania Discord](https://discord.gg/dortania)
- Browse [tonymacx86 forums](https://www.tonymacx86.com/)

---

[← Previous: XHCI Unsupported](05_xhci_unsupported.md) | [Back to Overview](./README.md)
