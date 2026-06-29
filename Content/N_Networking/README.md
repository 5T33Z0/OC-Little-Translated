# Networking

## LAN kexts
All current drivers provided by Apple _strictly require AppleVTD_ and cannot operate without it, as they no longer run in kernel-space but in user-space.
As far as Hackintoshing is concerned, the following Ethernet kexts support **AppleVTD** in the current version (provided the motherboard cooperates), but can also operate without it:
- [**LucyRTL8125Ethernet**](https://github.com/Mieze/LucyRTL8125Ethernet)
- [**RealtekRTL8111**](https://github.com/Mieze/RTL8111_driver_for_OS_X)
- [**AtherosE2200Ethernet**](https://github.com/Mieze/AtherosE2200Ethernet)
- [**IntelLucy**](https://github.com/Mieze/IntelLucy)
- [**IntelMausiEthernet**](https://github.com/Mieze/IntelMausiEthernet/releases) (v2.5.5d0, recently updated to support AppleVTD)

Currently not supporting **AppleVTD**:
- [**IntelMausi**](https://github.com/acidanthera/IntelMausi)

## WiFi and Bluetooth kexts
Native macOS WiFi support requires a supported Apple/Broadcom chipset. Most Intel and other OEM cards found in laptops and desktop systems require third-party kexts.

> [!TIP]
> 
> Some WiFi and BT kexts need to be loaded in a specific order to work. Check the [Kexts Loading Sequences](/Content/10_Kexts_Loading_Sequence_Examples) section for additional info.

### Intel WiFi
- [**itlwm**](https://github.com/OpenIntelWireless/itlwm) – Full Intel WiFi driver using Apple's IOEthernet stack. Requires [HeliPort](https://github.com/OpenIntelWireless/HeliPort) as a menu bar UI replacement for the native WiFi menu. More stable, supports more chipsets.
- [**AirportItlwm**](https://github.com/OpenIntelWireless/itlwm) – Variant of itlwm that hooks into Apple's AirportIO stack, enabling the native WiFi menu and Location Services. **macOS version-specific** — a separate build is required per macOS release.

> [!NOTE]
> 
> `itlwm` + HeliPort is generally more stable across macOS updates. `AirportItlwm` is more convenient but breaks with every new macOS version until a new build is released.

> [!CAUTION]
> 
> Neither `itlwm` nor `AirportItlwm` support **AirDrop**, **Handoff**, **Continuity**, or **Sidecar** — these features require a natively supported Broadcom chipset.

### Broadcom WiFi
- [**AirportBrcmFixup**](https://github.com/acidanthera/AirportBrcmFixup) – Patches for non-native Broadcom cards (e.g. BCM94352Z, BCM94360CD). Required for cards pulled from real Macs or compatible OEM cards to function correctly with native AirPort stack.
  - Companion kexts (injected via OpenCore or present in EFI): `BrcmPatchRAM3`, `BrcmFirmwareData`, `BrcmBluetoothInjector` (from BrcmPatchRAM, see below)

> [!NOTE]
> 
> Certain Broadcom cards (e.g. BCM94360CD from a real Mac Pro/iMac) work natively with no additional kexts — they are fully supported by macOS out of the box and support all Continuity features.

### Bluetooth kexts
Bluetooth and WiFi are closely related on Hackintosh, especially for Continuity features.

- [**BrcmPatchRAM**](https://github.com/acidanthera/BrcmPatchRAM) – Required for most Broadcom Bluetooth chipsets. Includes:
  - `BrcmPatchRAM3` (macOS 10.15+)
  - `BrcmFirmwareData`
  - `BrcmBluetoothInjector` (macOS 12 and earlier; replaced by BlueToolFixup on Ventura+)
  - `BlueToolFixup` (macOS 12+, replaces BrcmBluetoothInjector)
- [**IntelBluetoothFirmware**](https://github.com/OpenIntelWireless/IntelBluetoothFirmware) – Firmware loader for Intel Bluetooth chipsets. Required alongside `itlwm`/`AirportItlwm` on Intel combo cards.
  - `IntelBTPatcher` – Companion fix for proper Bluetooth initialization on Intel cards (macOS Big Sur+)
  - `IntelBluetoothInjector` – Only needed on macOS Monterey and earlier

> [!NOTE]
> 
> On macOS Ventura and newer, `BlueToolFixup` (from BrcmPatchRAM) is also required for Intel Bluetooth alongside `IntelBluetoothFirmware`.

## Enabling AppleVTD
&rarr; See [How to enable AppleVTD](/Content/20_AppleVTD/)
