# Networking

:construction: ***WORK in PROGRESS***

## LAN kexts

All current drivers provided by Apple _strictly require AppleVTD_ and cannot operate without it, as they no longer run in kernel-space but in user-space.

As fas as Hackintoshing is concerned, the following Ethernet kexts support **AppleVTD** in the current version (provided the motherboard cooperates), but can also operate without it:

- [**LucyRTL8125Ethernet**](https://github.com/Mieze/LucyRTL8125Ethernet)
- [**RealtekRTL8111**](https://github.com/Mieze/RTL8111_driver_for_OS_X)
- [**AtherosE2200Ethernet**](https://github.com/Mieze/AtherosE2200Ethernet)
- [**IntelLucy**](https://github.com/Mieze/IntelLucy)
- [**IntelMausiEthernet**](https://github.com/Mieze/IntelMausiEthernet/releases) (v2.5.5d0, recently updated to support AppleVTD)

Currently nor supporting **AppleVTD**:

- [**IntelMausi**](https://github.com/acidanthera/IntelMausi)
  
## Enabling AppleVTD
- Hardware Requirements: 