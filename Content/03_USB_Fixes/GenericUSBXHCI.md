# GenericUSBXHCI and GUX-RyzenXHCIFix

## Overview

[**GenericUSBXHCI.kext**](https://github.com/RehabMan/OS-X-Generic-USB3) (GUX) is a generic XHCI driver for USB controllers that are not supported by Apple's built-in `AppleUSBXHCIPCI` driver. It was originally written by Zenith432 and later maintained by RehabMan.

Unlike [`XHCI-unsupported.kext`](05_xhci_unsupported.md), which is a codeless kext that only adds PCI ID entries so that `AppleUSBXHCIPCI` can attach to an otherwise-ignored controller, GUX replaces Apple's XHCI driver entirely for any controller it attaches to. This makes it significantly more invasive and limits its usefulness on modern macOS.

> [!CAUTION]
> 
> GUX is **not a drop-in replacement** for `XHCI-unsupported.kext`. On macOS 11 and later, GUX has known compatibility issues: USB mass storage and many composite devices (webcams, audio interfaces, etc.) may not work correctly even when GUX successfully attaches to the controller.

## When to Use GUX

GUX is only appropriate when `AppleUSBXHCIPCI` cannot attach to a controller at all — neither through its built-in PCI ID list nor through `XHCI-unsupported.kext`. This mainly affects older or obscure third-party XHCI chips (e.g. Fresco Logic, VIA) that Apple never supported and for which no IOKit personality entry exists.

**Always try `XHCI-unsupported.kext` first.** GUX should be a last resort.

| Situation | Solution |
|-----------|----------|
| Controller PCI ID not in Apple's list, but chipset is mainstream | `XHCI-unsupported.kext` |
| Controller not recognized at all, mainstream solutions don't work | `GenericUSBXHCI.kext` |
| Boot hangs during XHCI init on a Ryzen APU system | `GUX-RyzenXHCIFix` |
| No USB issues | Nothing needed |

> [!NOTE]
> 
> AMD systems generally do **not** need GUX. `AppleUSBXHCIPCI` already includes explicit AMD XHCI PCI ID matches. If USB is not working on an AMD system, check your USB map first.

## GUX-RyzenXHCIFix

[**GUX-RyzenXHCIFix**](https://github.com/RattletraPM/GUX-RyzenXHCIFix) is a fork of GUX that addresses a specific boot-hang affecting some Ryzen APU-based hackintoshes running macOS 11.0 and later. On affected systems, the XHCI controllers stall during early boot initialization due to an unresolved conflict with `AppleUSBXHCIPCI`.

The fork works by forcing GUX to exit its initialization routines early — which happens to resolve the conflict — and then allowing `AppleUSBXHCIPCI` to attach normally. The end result is that Apple's own driver handles the controller as usual, without the boot hang.

> [!IMPORTANT]
> 
> The root cause of the conflict is not fully understood. GUX-RyzenXHCIFix is a workaround, not a definitive fix. It was developed on a Picasso APU system. Newer Ryzen generations (Rembrandt, Phoenix) are not explicitly covered and may or may not benefit from it.

**This kext is only relevant if your system hangs during boot at XHCI initialization.** It is not a general USB fix and should not be added preemptively.

## Credits

- **GenericUSBXHCI.kext**: Zenith432 (original), RehabMan (maintenance)
- **GUX-RyzenXHCIFix**: RattletraPM
