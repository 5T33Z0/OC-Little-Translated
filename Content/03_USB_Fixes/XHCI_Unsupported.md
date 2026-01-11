# USB 3.0: determining if you need `XHCI-unsupported.kext`

**TABLE of CONTENTS**

- [About](#about)
- [XHCI Controllers natively supported by macOS](#xhci-controllers-natively-supported-by-macos)
  - [Important technical notes](#important-technical-notes)
- [How to use this table](#how-to-use-this-table)
  - [Optional verification (recommended)](#optional-verification-recommended)
- [Which `XHCI-Unsupported.kext` to use?](#which-xhci-unsupportedkext-to-use)
  - [`XHCI-Unsupported.kext` by Rehabman](#xhci-unsupportedkext-by-rehabman)
  - [`XHCI-Unsupported.kext` by daliansky](#xhci-unsupportedkext-by-daliansky)
- [Final takeaway](#final-takeaway)

---

## About

`XHCI-unsupported.kext` is a **codeless** kext that enables macOS to recognize and use certain **Intel xHCI USB controllers** that are **not matched natively** by Apple’s USB driver, primarily to allow USB port mapping to work on those systems.

The question is: *when* exactly do you need it?

If you generate an EFI using tools like **OpenCore Simplify**, the kext is often added by default. However, to determine whether you *actually* need it, you must:

1. Identify the **Device ID** of your XHCI USB controller
2. Compare it against Apple’s **native matching rules**, specifically `IOPCIPrimaryMatch`


> [!NOTE]
> 
> AMD systems do **not** require `XHCI-unsupported.kext`, as AppleUSBXHCIPCI already includes explicit AMD XHCI matches.

## XHCI Controllers natively supported by macOS

The supported XHCI controllers are defined inside **IOUSBHostFamily.kext**, more specifically in:

```cmd
/System/Library/Extensions/IOUSBHostFamily.kext/Contents/PlugIns/AppleUSBXHCIPCI.kext/Contents/Info.plist
```

The table below is **derived directly from `IOPCIPrimaryMatch` entries** in `IOKitPersonalities_x86_64` of that `Info.plist` in macOS Tahoe. It represents **explicit, architecture-specific PCI ID matches** used by macOS on Intel systems:

| Personality | PCI IDs (Device:Vendor) | Vendor | Platform |
| ----------- | ----------------------- | :----: | -------- |
| **AppleAMDUSBXHCIPCI**      | `73A4:1002`, `73A6:1002`                           | AMD          | AMD USB XHCI               |
| **AppleASMedia1042USBXHCI** | `1142:1B21`                                        | ASMedia      | ASM1042                    |
| **AppleASMediaUSBXHCI**     | `****:1B21` (masked)                               | ASMedia      | Generic ASMedia XHCI       |
| **AppleIntelCNLUSBXHCI**    | `9DED:8086`, `A36D:8086`, `06ED:8086`              | Intel        | Cannon Lake / Coffee Lake  |
| **AppleIntelICLUSBXHCI**    | `38ED:8086`, `8A13:8086`                           | Intel        | Ice Lake                   |
| **AppleUSBXHCIAR**          | `15B6:8086`, `15C1:8086`, `15DB:8086`, `15D4:8086` | Intel        | Alpine Ridge (Thunderbolt) |
| **AppleUSBXHCIFL1100**      | `1100:1B73`                                        | Fresco Logic | FL1100                     |
| **AppleUSBXHCILPT**         | `9C31:8086`                                        | Intel        | Lynx Point (8-Series)      |
| **AppleUSBXHCILPTH**        | `8C31:8086`                                        | Intel        | Lynx Point-H               |
| **AppleUSBXHCILPTHB**       | `8CB1:8086`                                        | Intel        | Lynx Point-HB              |
| **AppleUSBXHCIPPT**         | `1E31:8086`                                        | Intel        | Panther Point (7-Series)   |
| **AppleUSBXHCISPT**         | `A12F:8086`, `A2AF:8086`, `A1AF:8086`              | Intel        | Sunrise Point (100-Series) |
| **AppleUSBXHCISPTLP**       | `9D2F:8086`                                        | Intel        | Sunrise Point-LP           |
| **AppleUSBXHCITR**          | `15E9:8086`, `15EC:8086`, `15F0:8086`, `0B27:8086` | Intel        | Titan Ridge (Thunderbolt)  |
| **AppleUSBXHCIWPT**         | `9CB1:8086`                                        | Intel        | Wildcat Point (9-Series)   |

### Important technical notes

* This table is **strictly `IOPCIPrimaryMatch`-based**
* Masked entries (e.g. ASMedia) match multiple devices
* Many Intel XHCI controllers are **explicitly listed** here (e.g. Coffee Lake `A36D`)
* Controllers **not listed here may still be supported** via `IOPCIClassMatch`
* `XHCI-unsupported.kext` exists **only** to add missing PCI matches — it does not add ports or improve performance

## How to use this table 

1. Get your **USB XHCI Device ID** from Hackintool → PCI:<br><img width="1385" height="488" alt="xhci01" src="https://github.com/user-attachments/assets/b9154d13-2315-4e9c-898f-6a808bdae2fb" />
2. Take Note of the Device-ID. Omit the `0x`. In this example it’s `A36D` 
3. Compare it against the **PCI ID column**
4. If your ID is **present** → **AppleUSBXHCIPCI will attach → `XHCI-unsupported.kext` is NOT needed** 
5. If your ID is **absent** →  Check whether `AppleUSBXHCIPCI` still attaches via `IOPCIClassMatch = 0x0c033000` (see note below)
6. **Only if neither primary match nor class match applies** → **`XHCI-unsupported.kext` IS required**

### Optional verification (recommended)

To confirm the result, open **IORegistryExplorer** and verify that your XHCI controller has `AppleUSBXHCIPCI` attached. If it does, `XHCI-unsupported.kext` is not required — regardless of EFI templates or tools.

**Example**:  

<img width="1518" height="663" alt="IOClassMatch" src="https://github.com/user-attachments/assets/9e618996-9320-49e2-b90e-c4e045c4a3c1" />

In this example, we have a primary match via the device id and an IOClass match, so XHCI-Unsupported is definitely not needed.

---

## Which `XHCI-Unsupported.kext` to use?

If you determined that you USB 3 is not working and that neither the Device-ID is supported by macOS nor attaching to the XHCI Controller via  IOClass is working, you need `XHCI-Unsupported.kext`. But which one? There are 2 versions.

###  `XHCI-Unsupported.kext` by Rehabman

The original `XHCI-unsupported.kext` by RehabMan dates back to 2018 and supports Intel chipsets available at the time (9-Series, X99, 200-/X299- and early 300-Series), as can be seen in its `Info.plist`. 

| Original XHCI-Unsupported (by [Rehabman](https://github.com/RehabMan/OS-X-USB-Inject-All)) | 
| --------------------------
| <img width="573" height="112" alt="rehabman" src="https://github.com/user-attachments/assets/4512348a-373a-4043-a2b7-f0075255e31d" />


This is the version you’ll be served when following Dortania’s OpenCore Install Guide. This version is **not helpful** for newer Intel chipsets released after 2019.

###  `XHCI-Unsupported.kext` by daliansky

If you are using **Intel 400-series or newer** (2020+), use the fork by **daliansky**, which adds support for newer chipsets, including 700-series:

| Updated XHCI-Unsupported (by [daliansky](https://github.com/daliansky/OS-X-USB-Inject-All))
| --------------------------
| <img width="552" height="193" alt="daliansky" src="https://github.com/user-attachments/assets/8b45760b-39bc-4382-992f-a65219a5fdbc" />

> [!TIP]
> 
> Since the XHCI-Unsupported version by daliansky supports old and current XHCI Controllers, I suggest you use this one.

## Final takeaway

Do **not** rely on EFI generators or default templates. The only correct way to decide whether `XHCI-unsupported.kext` is needed is to check **AppleUSBXHCIPCI’s matching rules**. If Apple already matches your controller, the kext is unnecessary — and should not be used.
