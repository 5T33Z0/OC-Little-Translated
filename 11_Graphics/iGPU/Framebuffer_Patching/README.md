# Intel iGPU Framebuffer patching for connecting an external Monitor (Laptop)

warning: :construction: WORK IN PROGRESS… Don't use yet

## About
This guide is for modifying framebuffers for Intel iGPUs and modifying `DeviceProperties` for connector types, so you can connect a secondary display to the `HDMI` or `DisplayPort` of your Laptop.

### Supported Connections
- **HDMI** &rarr; **HDMI**
- **DP** &rarr; **DP** (DisplayPort)
- **HDMI** &rarr; **DVI**
- **DP** &rarr; **DVI**

:warning: **Important**: You cannot use **VGA** or any other analog video signal with modern macOS for that matter. So if this was your plan, you can stop right here!

> **Note**: Although the example used throughout this guide is for getting the Intel UHD 620 to work in macOS since I recently acquired a new laptop where I had to do all of this as well. But the basic principle applies to any other iGPU model supported by macOS.

## Problem description
Your Laptop boots into macOS and the internal screen works, but:

1. if you connect a secondary monitor to your Laptop it won't turn on at all or 
2. the handshake beteen the system and both displays takes a long time and both screens turn off and on several times during the handshake until a stable connection is established.

> **Note**: if you don't get a picture at all you could try a [fake ig-platform-id](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/iGPU/Framebuffer_Patching/Fake_IG-Platform-ID.md) to force the system into [VESA mode](https://wiki.osdev.org/VESA_Video_Modes) or follow CaseyJ's General Framebuffer Patching guide instead.

## Possible causes
- Using an incorrect or sub-optimal `AAPL,ig-platform-id` for your device/purpose 
- Misconfigured frambuffer patch with incorrect flags for the used connector

## Required Tools and Resources
- A FAT32 formatted USB Flash drive
- External Monitor and a cable to connect it to your system (obviously)
- [**Hackintool App**](https://github.com/headkaze/Hackintool/releases) for creating/modifying framebuffer  properties
- [**ProperTree**](https://github.com/corpnewt/ProperTree) to copy over Device Properties to your config
- [**Intel Ark**](https://ark.intel.com/content/www/us/en/ark.html) (for researching CPU specs such as used on-board graphics and device-id)
- [**OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/) (for referencing default/recommended framebuffers)
- [**Intel HD Graphics FAQs**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#intel-uhd-graphics-610-655-coffee-lake-and-comet-lake-processors) for Framebuffers and Device-IDs and additional info.
- [**Big to Little Endian Converter**](https://www.save-editor.com/tools/wse_hex.html) to convert Framebuffers from Big Endian to Little Endian and vice versa
- Monitor cable(s) to populate the output(s) of your mainboard (usually HDMI an/or DisplayPort) 
- Lilu and Whatevergreen kexts enabled (mandatory)

## Basic workflow outline
This it the tl;dr version of what we are going to do basically.

- Find CPU model details on Intel ARK
- Check used iGPU model
- Add default/recommended frambuffer for from OpenCore install guide for used iGPU       
- Check if you need to spoof a device-id
- Consult Intel HD FAQs for Framebuffer data and alternative AAPL,ig-platform-ids
- Adjust the framebuffer patch
- Test
- Add finished fb patch to config on internal disk
- Done

## Preparations
Since we will have to do a lot of testing and rebooting, we will not work with the config.plist stored on the internal disk. Instead, we will work with a copy of the EFI folder and config stored on a FAT32 formatted USB flash drive. This way, we can ensure that the system always has a working config to boot from. Another benefit is that we don't need to mount the EFI partition every time we want to edit the config.plist since it's readily available on the USB flash drive which saves a lot of time.

**So do the following**:

- Mount your system's EFI partition 
- Copy your EFI folder to a FAT32 formatted USB flash drive
- Unmount the EFI partition again – from now on, We will work with the config stored on the USB flash drive!
- **Optional**: change the boot order of your drives in the BIOS temporarily so that the USB flash drives takes the first slot. Otherwise you have to select the USB flash drive manually after each reboot

## Testing
Before we do any editing we will run a basic test. You can skip this if you already know that your external display isn't working.

1. Open Hackintool
2. Click on the Tab "Patch", then on "Connectors" and then on the Eye icon
3. This will show the currently used Framebuffer. In this example it's **0x3E9B0000** (Big Endian), which is the recommended framebuffer for the Intel HD 620 by Dortania's OpenCore Install guide: <br> ![preps_01](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/0d39a616-3cae-4485-87c5-4cfd1ccee095)
4. The line highlited in green (**Index 0**) represents your internal display (LVDS)
5. Now attach your external display to your notebook
6. Observe what happens:
	- In **Hackintool**:
		- If the monitor is detected, either **Index 1** or **Index 2** should turn red: <br>![](/Users/stunner/Desktop/display-red.png)
		- If it does turn red: take note of the **Index** (in this example: Index 2). We need it for configuring the framebuffer patch
		- If it doesn't turn red, you might have an incorrect `AAPL,ig-platform-id` to begin with
	- Observe the system's behavior:
		- **If your display turns on**, how long does the handshake take? 
			- **Short**: 
				- If it does turn on and the screens only take 2 to 3 cylces until a stable connection is established, then you're probably good. 
				- Connections between the same connector types (HDMI to HDMI, DP to DP) are negotiated faster than between 2 different types of connectors (HDMI to DP, HDMI to DVI, etc.)! 
				- If the handshake behaves similarly if the ext. display is already connected prior to booting then you're probably good as well.
			- **Long**: 
				- If it does turn on (late) and the handshake takes more than 3 or 4 cycles, then there's room for improvement.
		- **If your display does not turn on**:
			- Does your mouse start to lag? If your mouse pointer starts to lag the screen is most likely detected but the busid and flags used for the connectors are possibly incorrect for the used connectors. 
			- Disconnect the external monitor for now so you can work with your Laptop again

## Verifying the `AAPL-ig-platform-id`

1. Find the CPU used in your machine. If you don't know, you can enter in Terminal: 

	```
	sysctl machdep.cpu.brand_string
	```
2. Search your model number on https://ark.intel.com/ to find its specs. In my case it's an `i5-8265U`.

3. Take note of the the CPU family it belongs to (for example "Whisky Lake") and which type of on-board graphics it is using. In my case it does not list the actual model of the iGPU but only states "Intel® UHD Graphics for 8th Generation Intel® Processors" which doesn't help. In this case use sites like netbookcheck.net or check in Windows Device Manager. In my case, it's using Intel Graphics UHD 620: <br> ![igpu](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/2f2449c0-1927-4699-aa3e-503f697bf063)

4. Next, verify that you are using the recommended `AAPL,ig-platform-id` for your CPU and iGPU:
	- Find the recommended framebuffer for your CPU family [in this list](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/iGPU/iGPU_DeviceProperties.md#framebuffers-laptopnuc) (based on data provided by OpenCore Install Guide)
	- Check if your iGPU requires a device-id to spoof a different iGPU model!
	- Compare the data with the `DeviceProperties` used in your config.plist

5. Mak sure to cross-reference the default/recommended framebuffer for your iGPU against the ones listed in the [Intel HD Graphics FAQs](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#intel-hd-graphics-faqs). But keep in mind that the Intel HD FAQs uses [Big Endian instead of Little Endian](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/iGPU/Framebuffer_Patching/Big-Endian_Little-Endian.md) which is required for the config.plist.

**NOTES**:

- The OpenCore Install Guide only provided the *basic* settings you need to get a signal from your primary display. It does not include additional connectors (except for Ivy Bridge Laptop).
-  In my case, the recommended framebuffer and device-id for the Intel UHD 620 differ: Dortania recommends AAPL,ig-platform-id `00009B3E` and device-id `9B3E0000` to spoof the iGPU as Intel UHD 630 while the Intel HD FAQs recommends AAPL,ig-platform-id `0900A53E` and device-id `A53E0000` to spoof it as Intel Iris 655 which worked better in the end.

## Technical Background
The picture below shows the basic Processor Display Architecture design of Intel iGPUs.

![](https://pikeralpha.files.wordpress.com/2013/08/processor-display-architecture.png)
**SOURCE**: [Processor Display Architecture](https://pikeralpha.wordpress.com/2013/08/02/appleintelframebufferazul-kext-part-ii/) by PikerAlpha

It shows the number of pipes (03) framebuffers (03) and DDI ports (03) – according to the  datasheet, it works as follows:

“The DDI (Digital Display Interface) ports B,C and D on the processor *can be configured to support DP/eDP/HDMI and DVI*. For desktop designs, DDI port D can be configured as eDPx4 (4 lanes) in addition to dedicated x2 (2 lanes) port for Intel FDI (Flexible Display Interface) for (analog) VGA." (VGA is no longer supported by macOS).

The next picture shows how these components are linked together:

![](https://www.tonymacx86.com/attachments/port-to-index-mapping-png.381014/)

**The takeaway from this is this**:

- There are fixed "Indexes" `0` to `3` (max). These are hard-coded with ports 05, 06 and 07 to the physcial connectors. We can ignore this since we can't change those anyway
- There "Pipes" to transport data internally
- There are "BusIDs" used to transport the graphics data to physical "Connectors" on the the outside 
- These connnectors can be of different "Types" (HDMI, DisplayPort, etc.) and require specific "Ports" to be declared in order to work. In macOS these are Ports are hardcoded in, so only specific BusIDs can be used. More on that later

## Instructions

### I. Choosing the correct Framebuffer for macOS and your iGPU
⚠️ **DISCLAIMER**: The values used in the given example are for an 8th Gen Whiskey Lake CPU


10th Gen Intel Core CPU (Comet Lake) which uses Intel UHD 630 on-board graphics. Don't use these values for your Framebuffer Patch!

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

### II. Patching Connectors and enabling features: "Connectors" Section

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

![busidsexpl](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/3938fedc-2227-4398-b1f1-bdfc3aa77a72)

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

## Credits and further resources
- [General Framebuffer Patching Guide](https://www.tonymacx86.com/threads/guide-general-framebuffer-patching-guide-hdmi-black-screen-problem.269149/) by CaseySJ
- AppleIntelFramebufferAzul.kext ([Part 1](https://pikeralpha.wordpress.com/2013/06/27/appleintelframebufferazul-kext/) and [Part 2](https://pikeralpha.wordpress.com/2013/08/02/appleintelframebufferazul-kext-part-ii/)) by Piker Alpha 
- [Patching connectors](https://dortania.github.io/OpenCore-Post-Install/gpu-patching/intel-patching/connector.html#patching-connector-types) and [Bus IDs](https://dortania.github.io/OpenCore-Post-Install/gpu-patching/intel-patching/busid.html#patching-bus-ids) by Dortania
- benbaker76 for [Hackintool](https://github.com/benbaker76/Hackintool/releases)
