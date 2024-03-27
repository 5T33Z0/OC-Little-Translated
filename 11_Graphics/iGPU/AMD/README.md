# Enabling AMD on-board graphics in macOS 

Until mid 2023, there was no way of running macOS on AMD systems with support for on-board graphics because macOS was never designed for working with AMD CPUs, so there were no drivers to support AMD iGPUs. But there 2 relatively new kexts in development by ChefKissInc who writes "Hackintosh tools that nobody bothered to make".

## AMD Vega iGPUs

The first kext is called **NootedRed** (formerly known as **WhateverRed**) and is the latest addition to the list of Lilu plugins. It's still in an early state of research and development so don't expect it to be working perfectly yet.

### Supported Models
Ryzen 1xxx (Athlon Silver/Gold) to 5xxx, and 7x30 series
### Instructions
- Please refer to the [**NootedRed**](https://github.com/NootInc/NootedRed) repo for instructions since I don't have an AMD system so I can't test this.

## AMD Legacy iGPUs

For legacy AMD on-board graphics, there's **LegacyRed**. The kext still in an early stage of development so it might not be 100% working yet.

### Supported Models

- Kaveri
- Kabini
- Mullins
- Carrizo and Stoney based iGPUs, aka GCN 2 and GCN 3.

### Instructions

- Please refer to the [**LegacyRed**](https://github.com/ChefKissInc/LegacyRed) repo for instructions since I don't have an AMD system so I can't test this.

## Further Resources
- [**How to Enable AMD Integrated Graphics (APU) on macOS**](https://elitemacx86.com/threads/how-to-enable-amd-integrated-graphics-apu-on-macos-clover-opencore.1156/) ​by EliteMacx86
