# AMD Graphics Support in macOS

AMD graphics hardware forms the backbone of macOS acceleration on Hackintosh systems due to long-standing native driver support from Apple. While Apple supported discrete architectures up to **RDNA 2 (Navi 21/23)**, the community has expanded this ecosystem to include **Ryzen APUs** as well as experimental bring-up drivers for **RDNA 3 and RDNA 4**.

## APU Support
For AMD Ryzen laptops, mini-PCs, and desktop APUs:

* [**AMD APU Setup Guide (NootedRed)**](/Content/11_Graphics/AMD/APU/README.md) — Prerequisites, BIOS settings, boot-args, and limitations for Vega-based APUs.

## GPU Support
For dedicated PCIe AMD graphics cards (Polaris, Vega, Navi):

* [**General info**](/Content/11_Graphics/AMD/GPU/README.md)
* [**AMD Discrete GPU Compatibility Reference**](/Content/11_Graphics/AMD/GPU/AMD_GPU_Compatibility.md)
* [**Enabling AMD Navi & Big Navi Cards**](/Content/11_Graphics/AMD/GPU/AMD_Navi/README.md)
* [**Enabling AMD Vega 56/64 Cards**](/Content/11_Graphics/AMD/GPU/AMD_Vega/README.md)
* [**Eneabling Undetected AMD GPUs (`SSDT-BRG0`)**](/Content/11_Graphics/AMD/GPU/GPU_undetected/README.md)
* [**AMD Radeon Tweaks & PowerPlay Tables**](/Content/11_Graphics/AMD/GPU/AMD_Radeon_Tweaks/README.md)
* [**GPU BAR Size in OpenCore**](/Content/11_Graphics/AMD/GPU/GPU-BAR_Size/README.md)
* [**Disabling HDMI/DisplayPort Audio (`AppleGFXHDA`)**](/Content/11_Graphics/AMD/GPU/Disabling_AppleGFXHDA/README.md)
* [**Legacy AMD Cards & macOS**](https://web.archive.org/web/20170814210930/http://www.rampagedev.com/guides/graphic-cards-injection/) (ATI 4000–7000 and AMD 200/300)

---

## 🛠️ Community & Next-Gen AMD Drivers

Beyond Apple's vanilla drivers, open-source community projects have introduced custom drivers and translation stacks to expand AMD hardware compatibility:

| Driver / Kext | Status | Architecture / Hardware | Description |
| :--- | :---: | :--- | :--- |
| [**Cobalt64**](https://github.com/Almosst-DEV/Cobalt64) | 🧪 Preview | **RDNA 4** *(Navi 48 / RX 9070 XT)* | Experimental native macOS GPU acceleration using a custom kernel driver and Mesa RADV Vulkan translation for Metal. Currently in preview. |
| [**AMD RDNA 3 Driver**](https://github.com/luuumi-dev/amd-rdna3-macos-driver) | 🚧 WIP | **RDNA 3** *(Navi 3x / RX 7000)* | Work-in-progress driver for AMD RDNA 3 GPUs aiming to establish Metal acceleration in macOS. |
| [**NootedRed**](https://github.com/ChefKissInc/NootedRed) | 🟢 Active | **Vega APUs** *(GCN 5)* | Patches Apple drivers to enable acceleration on Raven Ridge, Picasso, Renoir, Lucienne, Cezanne, and Barcelo APUs (macOS 11 to 26). |
| [**CarrizoRed**](https://github.com/CL0utM4N/CarrizoRed) | 🧪 Experimental | **GCN 3 APUs** *(GFX8)* | Experimental graphics support for older AMD GCN 3 APUs (Carrizo, Bristol Ridge, Stoney Ridge). |
| [**KaberiRed**](https://github.com/CL0utM4N/KaberiRed) | 🧪 Experimental | **GCN 2 APUs** *(Bonaire)* | Adapts Apple GCN 2 drivers for older AMD Kabini, Mullins, and Kaveri APUs. |
