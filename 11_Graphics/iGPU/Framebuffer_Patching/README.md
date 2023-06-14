# Patching Intel iGPU Framebuffers with Hackintool

:warning: :construction: WORK IN PROGRESS… Don't use yet

## About
This is a guide for modifying Framebuffer patches for Intel iGPUs and generating `DeviceProperties` for connector types with Hackintool, so you can connect a monitor to the `HDMI` or `DisplayPort` of your mainboard and operate it successfully. It's an updated version of CaseySJ's guide from 2019. Since then, Hackintool has changed quite a bit so using the old guide with the new software might be confusing. 
 
Although Dortania's OpenCore Install Guide provides an in-depth guide on [Patching Connector Types](https://dortania.github.io/OpenCore-Post-Install/gpu-patching/intel-patching/busid.html#parsing-the-framebuffer) for Framebuffer patches (`AAPL,ig-platform-id`) for various Intel CPU families, it does all of this manually. 

This guide helps to fix common framebuffer-related issues:

- Graphics acceleration not working: no transparency effects, only 7 MB of VRAM
- Monitor turning off after macOS has reached the Desktop/Login Screen
- HDMI 2.0 and Audio over HDMI are not working
- External Monitors not turning on (Laptops)

These issues can be addressed and resolve by injecting additional properties into the selected framebuffer.

### A note about Big Endian and Little Endian

When working with different sources of framebuffer data for your config.plist, you have to mind the byte order (or "Endianness") of Framebuffers and Device-IDs. 

An example: For 10th Gen Intel Core Desktop CPUs, the OpenCore Install Guide recommends Framebuffer `07009B3E`. But if you compare this value with Whatevergreen's Intel HD Graphics FAQ which is referenced in the guide, the recommended Framebuffer is `0x3E9B0007`. What happened here?

Although it's not obvious, both values represent the same framebuffer – just in a different manner. The first is Little Endian and the second Big Endian. Big-Endian is an order in which the "big end" (most significant value in the sequence) is stored first (at the lowest storage address). Little-endian is an order in which the "little end" (least significant value in the sequence) is stored first. 

If you split this sequence of digits into pairs of two (07 00 9B 3E) and re-arrange them by moving them from the back to the left/front until the first pair has become last and vice versa, you have converted it to Big Endian (3E 9B 00 07) (we omit the leading "0x").

Long story short: just keep in mind that whenever you work with values presented as `0x4321` it's in Big-endian so you have to convert it unless you use tools like Hackintool which does this automatically!

## Required Tools and Resources
- [**Hackintool App**](https://github.com/headkaze/Hackintool/releases) 
- A Plist Editor like [**ProperTree**](https://github.com/corpnewt/ProperTree) to copy over Device Properties to your config
- [**OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/) (for referencing framebuffers)
- [**Intel Ark**](https://ark.intel.com/content/www/us/en/ark.html) (for researching CPU specs such as used on-board graphics and device-id)
- [**Intel HD Graphics FAQs**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#intel-uhd-graphics-610-655-coffee-lake-and-comet-lake-processors) for Framebuffers and Device-IDs and additional info.
- [**Big to Little Endian Converter**](https://www.save-editor.com/tools/wse_hex.html) to convert Framebuffers from Big Endian to Little Endian and vice versa
- Monitor cable(s) to populate the output(s) of your mainboard (usually HDMI an/or DisplayPort) 
- Lilu and Whatevergreen kexts (mandatory)

<details><summary><strong>No picture at all?</strong> (click to reveal)</summary>

## Force-enabling graphics with a fake Platform-ID (optional)
⚠️ This is only for users who don't have graphics output at all. It's only a temporary solution to force-enable software rendering of graphics in macOS, so you can at least  follow the instructions on-screen to generate a proper framebuffer patch. If your display is working already, skip this step!

First try adding `-igfxvesa` boot-arg to the config.plist and reboot. This will enable VESA mode for graphics which bypasses any GPU and uses software rendering instead.

If this doesn't work, we can inject a non-existing `AAPL,ig-platform-id` via `DeviceProperties` into macOS, which in return will fall back to using the software renderer for displaying graphics since it can't find the Platform-ID.

Booting with this hack will take much longer (up to 2 minutes), only about 5 MB of VRAM will be available and everything will be running slow and sluggish – but at least you have a video signal. 

#### Enabling a fake Platform-ID in OpenCore
- Open your config.plist
- Under `DeviceProperties/Add`, create the Dictionary `PciRoot(0x0)/Pci(0x2,0x0)`
- Add the following Keys as children:</br>

	|Key Name                |Value     | Type
	-------------------------|----------|:---:
	AAPL,ig-platform-id      | 78563412 |Data
	framebuffer-patch-enable | 01000000 |Data
	
	The entry should look like this:</br>
![OC_fakeid](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/b9b77d6f-1caf-46d3-9616-0debc83f855d)

#### Enabling fake Platform-ID in Clover
- Open your config.plist in Clover Configurator
- Click on "Graphics"
- Enable `Inject Intel`
- In ig-platforrm-id, enter `0x12345678` (you can omit the `0x`)

	This is how it should look in Clover Configurator:</br>
![FakeID](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/6ee45bfd-7d20-4d09-a61e-8bc165eb0a93)

**NOTE**: Make sure to delete/disable the fake Platform-ID once you have generated your Framebuffer patch!
</details>

## Instructions

### I. Choosing the correct Framebuffer for macOS and your iGPU
⚠️ **DISCLAIMER**: The values used in the given example are for a 10th Gen Intel Core CPU (Comet Lake) which uses Intel UHD 630 on-board graphics. Don't use these values for your Framebuffer Patch!

Select the correct Framebuffer for your CPU's on-board Graphics as recommended by the OpenCore Install Guide and/or the Intel HD Graphics FAQs (mind the "Endianness").

1. Run Hackintool
2. In the menu bar, choose the "Framebuffer" type. Select either **≤ macOS 10.13** (High Sierra and older) or **≥ macOS 10.14** (Mojave and newer): </br> ![Menubar](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/3e425067-557c-4418-88d1-02c5f64c9aea)
3. Next, click on "Patch". You will be presented with the following window which can be a bit confusing since it's pretty convoluted:</br> ![Patch0](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/fff0b1f6-94d0-4f8b-b238-ed92424617ad)

### The "Patch" Section
The "Patch" section contains 5 sub-sections: **Info**, **VRAM**, **Framebuffer**, **Connectors** and a **Patch** tab. 

### The "Info" section 
"Info" lets you select the framebuffer you want to work on as well as a summary of the active Framebuffer. If you click the eye icon, the currently used Framebuffer will be selected which is practical if you want to edit it but cant remember which one it was. Since I wrote this guide on my Laptop, it's `0x01666004`.
4. From the dropdown menu "Intel Generation", select the CPU family your CPU belongs to (search your CPU model on Intel Ark if you are unsure):</br>![CPUFam](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/b586d468-a75b-4339-8984-27c186d81ec7)
	As you can see, "Comet Lake" is not in the list. That's because Comet Lake uses last-gen Coffee Lake Framebuffers.
5. Next, select the Platform-ID you want to work with. In this example, we use `AAPL,ig-platform-id`: `0x3E9B0007` as [recommended](https://dortania.github.io/OpenCore-Install-Guide/config.plist/comet-lake.html#deviceproperties) for 10th gen Intel CPUs. Below that you will see the summary for the selected Framebuffer.:</br> ![Patch1](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/f2795b76-3aa6-48a6-81b9-3364d48fd860)

### II. Patching Connectors and enabling features
Now that the correct Framebuffer is selected, we want to modify it, so we can route outputs of the iGPU to physical connectors on the back panel I/O of your mainboard. But before we do let's understand what makes up a connector patch.

#### Excurse: Understanding Connector Patches in the Intel HD FAQs

**iGPU**: Intel UHD 630 <br>
**Framebuffer**: `0x3E9B0007`

According the WhateverGreen's Intel [HD Graphics FAQs](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#intel-hd-graphics-faqs), this Framebuffer has the following specifications:

```
ID: 3E9B0007, STOLEN: 57 MB, FBMEM: 0 bytes, VRAM: 1536 MB, Flags: 0x00801302
TOTAL STOLEN: 58 MB, TOTAL CURSOR: 1 MB (1572864 bytes), MAX STOLEN: 172 MB, MAX OVERALL: 173 MB (181940224 bytes)

Model name: Intel UHD Graphics 630
Camellia: CamelliaDisabled (0), Freq: 0 Hz, FreqMax: 0 Hz

Mobile: 0, PipeCount: 3, PortCount: 3, FBMemoryCount: 3

[1] busId: 0x05, pipe: 9, type: 0x00000400, flags: 0x000003C7 - ConnectorDP
[2] busId: 0x04, pipe: 10, type: 0x00000400, flags: 0x000003C7 - ConnectorDP
[3] busId: 0x06, pipe: 8, type: 0x00000400, flags: 0x000003C7 - ConnectorDP
```

The screenshot below lists the same data for the 3 connectors this framebuffer provides but with some color coding applied:

![BUSIDS](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/e45d41a1-53a8-47c7-b803-5a356c56600e)

**In table form**:

|Coloe | Bit |Description | Value (example)|
| :--- | ------|:--- | :--- |
| green| Bit 1  |Port Number ("Index") | `01` |
| pink | Bit 2 |Bus ID | `05` |
| lavendar | Bit 3-4 |Pipe Number | `0900` |
| red |Bit 5-8 | Connector Type | `00040000` |
| blue |Bit 9-12 |Flags | `C7030000` |

Now that we got that out of the way, let's continue…

#### Connectors, BusIDs, Indexes, etc
The "Connectors" tab is where the *software* outputs of the iGPU for the selected framebuffer can be modified and routed to *physical* outputs:

- Each row in the list represents a software connector
- Depending on the chosen `AAPL,ig-platform-id` ("Platform-ID"), the number of available *physical* outputs may vary. 
- Signal flow is: `con` (software) &rarr; via `BusID` (# of the "Data Highway") &rarr; `Index` (physical connector).

The "Connectors" tab consists of a list with five columns:

|Parameter|Description|
|:-------:|-----------|
**Index**| An Index represents a physical output on the I/O panel of your mainboard. In macOS, up to 3 software connectors can be assigned (`con0` to `con2`) to 3 connectors (Indexes 1 to 3). Index `-1` has no physical connector:</br>![Connectors](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/38ab2a7f-c342-4f1a-81a0-72decf1d0b4d) </br>Framebuffers which only contain `-1` Indexes (often referred to as "headless" or "empty") are usually used in setups where a discrete GPU is used for displaying graphics while the iGPU performs computational tasks only, such as Platform-ID `0x9BC80003`:</br>![headless](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/00b0b232-0de7-4a1b-a01f-8c6fabb90753)|
|**BusID**|Every `con` must be assigned a *unique* `BusID` through which the signal travels from the iGPU to the physical ports. Unique means each BusID must only be used ones! But only certain combinations of BusIDs and connector Types are allowed.</br> </br> For **DisplayPort**: `0x02`, `0x04`, `0x05`, `0x06`</br>For **HDMI**: `0x01`, `0x02`, `0x04`, `0x06` (availabilty may vary)</br>For **DVI**: same as HDMI <br> For **VGA**: N/A|
**Pipe**| to do
|**Type**| Type of the physical connector (DP, HDMI, DVi, LVDS, etc) 
|**Flags**| A bitmask representing parameters set in "Flags" section for the selected connector:</br>![Flags](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/94aa0944-a3dc-4fb8-b68e-ba4c502c7bac)

### III. Step by Step guide

1. Keep your primary monitor connected at all times!
2. 
99. Once you're done configuring your Framebuffer Patch, click on "Generate Patch". A raw text version of the plist containing the DeviceProperties will be created:</br>![Generate](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/42718d67-be93-416a-83e6-d1334e504bb4)
101. Select the text (CMD+A) and copy it to the clipboard (CMD+C)
102. Open ProperTree
103. Paste in the text
104. Leave the window open
105. Mount your ESP partition
106. Open your config.plist
107. Copy over the Device Properties for `PCIPciRoot(0x0)/Pci(0x2,0x0)` and other PCI devices (if present) into your config in the same location 
108. Save your config and reboot

If anything was done correct your iGPU should work as supposed now. If not, start over.

## CREDITS & RESOURCES
- CaseySJ for his [General Framebuffer Patching Guide](https://www.tonymacx86.com/threads/guide-general-framebuffer-patching-guide-hdmi-black-screen-problem.269149/)
- Dortania for [Bus ID patching guide](https://dortania.github.io/OpenCore-Post-Install/gpu-patching/intel-patching/busid.html) 
- - Headkaze for Hackintool
- Acidanthera for OpenCore, Kexts and Intel Framebuffer Patching guide
