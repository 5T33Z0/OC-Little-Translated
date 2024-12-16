# Re-enabling Bluetooth in macOS Sonoma+

**WORK IN PROGRESS**

## General information

In general, the kexts required kexts for enabling Bluetooth are listed in the chapter &rarr; [Kext Loading Sequence Examples](https://github.com/5T33Z0/OC-Little-Translated/tree/main/10_Kexts_Loading_Sequence_Examples). But for using Bluetooth in Sonoma and newer additional settings and kexts may be required.

## Prerequisites
Unless you are using a Wi-Fi/BT card that's supported by Apple out of the box (usually Broadcom or Atheros), you need to apply root patches with OCLP (either for "Modern" or "Legacy") in order to enable the card in macOS Sonoma and newer.

Since real Macs don't use Intel WiFi/BT cards, 

## Broadcom Cards

### Modern Broadcom Cards

Kext | Comment | MinKernel | MaxKernel
-----|---------|:---------:|:---------:
**`BlueToolFixup.kext`** | BT enabler for macOS 12 or newer. Contains Firmware Data. | 21.0.

**SCREENSHOT**:

![brcmwifi+bt](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/e4ba8edf-d8bc-4c7a-b095-d8c4ec05d142)

When using Broadcom WiFi/Bluetooth cards that are not natively supported by macOS, you have to be aware about the following:

1. Kexts have to be loaded in the correct order/sequence (otherwise boot crashes). When in doubt, create an OC Snapshot in ProperTree – it can fix the order if it's incorrect.
2. You have to make use of `MinKernel` and `MaxKernel` settings to control which kexts are loaded for different versions of macOS
3. `AirportBrcomFixup` is for enabling WiFi. It contains 2 additional kexts as Plugins (only one of them should be enabled at any time):
	- `AirPortBrcmNIC_Injector.kext` (compatible with macOS 10.13 and newer)
	- `AirPortBrcm4360_Injector.kext` (compatible with macOS 10.8 to 10.15)
4. For Bluetooth, various kexts and combinations are necessary:
	- `BlueToolFixup.kext`: For macOS 12 and newer. Contains Firmware Data (MinKernel 21.0).
	- `BrcmFirmwareData.kext`: contains necessary firmware. Required for macOS 10.8 to 11.x (MaxKernel 20.9.9)
	- `BrcmPatchRAM.kext`: For 10.10 or earlier
	- `BrcmPatchRAM2.kext`: For macOS 10.11 to 10.14
	- `BrcmPatchRAM3.kext`: For macOS 10.15 to 11.x. Needs to be combined with `BrcmBluetoothInjector.kext` in order to work.
5. With the release of macOS Sonoma Developer Preview (Darwin Kernel 23.0), Apple completely dropped support for Broadcom Cards! In order to re-enable Broadcom WiFi you have to adjust some settings (see [Example 10](#example-10-enabling-legacy-broadcom-wifi-cards-in-macos-14)), add additional kexts and apply root patches with OpenCore Legacy Patcher, [as explained here](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/WIiFi_Sonoma.md).

> [!CAUTION]
> 
> Don't add `BrcmFirmwareRepo.kext` to `EFI/OC/Kexts`! It cannot be injected via Boot Managers. It needs to be *installed* in `/System/Library/Extensions` (/Library/Extensions on 10.11 and later). In this case, `BrcmFirmwareData.kext`is not required. You can use [**Kext-Droplet**](https://github.com/chris1111/Kext-Droplet-macOS) to install kext in the system library directly.

## Intel Cards

Kext | Comment | MinKernel | MaxKernel
-----|---------|:---------:|:---------:
**`BlueToolFixup.kext`** | For macOS 12 and newer. Contains Firmware Data. |21.0.0 | -
|||

Todo…