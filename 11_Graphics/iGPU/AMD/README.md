# Enabling AMD Vega iGPUs

Until recently, there was no way of running macOS on Desktops and Laptops with AMD Vega iGPUs since macOS doesn't support AMD CPUs – so there are no drivers and setings to support it. But there is a new kext in development by NootInc who writes "Hackintosh tools that nobody bothered to make."

The kext is called **NootedRed** (formerly known as WhateverRed) and is the latest addition to the list of Lilu plugins. It's still in a state of research and development so don't expect it to be working perfectly right away.

## Supported Models
Fully functional for the following iGUs (Ryzen 3XXX series and older):  

- **Picasso**
- **Raven**
- **Raven2**

Partially working (Ryzen 4XXX series and newer):

- **Renoir** &rarr; Add `-nredfbonly` to your boot-args to enable "partial" acceleration.

## Instructions
- Please refer to the [**NootedRed**](https://github.com/NootInc/NootedRed) repo for instructions since I don't have an AMD system so I can't test this.

## Further Resources
- [**How to Enable AMD Integrated Graphics (APU) on macOS**](https://elitemacx86.com/threads/how-to-enable-amd-integrated-graphics-apu-on-macos-clover-opencore.1156/) ​by EliteMacx86
