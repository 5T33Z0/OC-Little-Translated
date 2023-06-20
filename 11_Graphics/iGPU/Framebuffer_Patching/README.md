Intel iGPU Framebuffer patching for connecting an external Monitor (Laptop)

warning: :construction: WORK IN PROGRESS… Don't use yet

**TABLE of CONTENTS**

- [About](#about)
	- [Supported Connections](#supported-connections)
- [Problem description](#problem-description)
- [Possible causes](#possible-causes)
- [Required Tools and Resources](#required-tools-and-resources)
- [Basic workflow outline](#basic-workflow-outline)
- [Preparations](#preparations)
- [Testing](#testing)
- [Verifying/adjusting the `AAPL-ig-platform-id`](#verifyingadjusting-the-aapl-ig-platform-id)
- [Adding Connectors](#adding-connectors)
	- [Gathering data for your framebuffer (Example 1)](#gathering-data-for-your-framebuffer-example-1)
	- [Gathering data for your framebuffer (Example 2)](#gathering-data-for-your-framebuffer-example-2)
	- [Gathering data for your framebuffer (Example 3)](#gathering-data-for-your-framebuffer-example-3)
	- [Translating the data into `DeviceProperties`](#translating-the-data-into-deviceproperties)
	- [I. Choosing the correct Framebuffer for macOS and your iGPU](#i-choosing-the-correct-framebuffer-for-macos-and-your-igpu)
	- [The "Patch" Section](#the-patch-section)
	- [The "Info" section](#the-info-section)
	- [II. Patching Connectors and enabling features: "Connectors" Section](#ii-patching-connectors-and-enabling-features-connectors-section)
		- [Excurse: Understanding Connector Patches in the Intel HD FAQs](#excurse-understanding-connector-patches-in-the-intel-hd-faqs)
		- [Connectors, BusIDs, Indexes, etc](#connectors-busids-indexes-etc)
	- [III. Step by Step guide](#iii-step-by-step-guide)
- [Credits and further resources](#credits-and-further-resources)


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
2. the handshake between the system and both displays takes a long time and both screens turn off and on several times during the handshake until a stable connection is established.

> **Note**: if you don't get a picture at all you could try a [fake ig-platform-id](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/iGPU/Framebuffer_Patching/Fake_IG-Platform-ID.md) to force the system into [VESA mode](https://wiki.osdev.org/VESA_Video_Modes) or follow CaseyJ's General Framebuffer Patching guide instead.

## Possible causes
- Using an incorrect or sub-optimal `AAPL,ig-platform-id` for your device/purpose 
- Misconfigured framebuffer patch with incorrect flags for the used connector

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
This it the tl;dr version of what we are going to do basically:

- Find CPU model details on Intel ARK
- Check used iGPU model
- Add default/recommended framebuffer for from OpenCore install guide for used iGPU       
- Check if you need to spoof a device-id
- Consult Intel HD FAQs for Framebuffer data and alternative AAPL,ig-platform-ids
- Verify/adjust the framebuffer patch
- Add Connectors, BusIDs and flags
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
4. The line highlighted in green (**Index 0**) represents your internal display (LVDS)
5. Now attach your external display to your notebook
6. Observe what happens:
	- In **Hackintool**:
		- If the monitor is detected, either **Index 1** or **Index 2** should turn red: <br>![](/Users/stunner/Desktop/display-red.png)
		- If it does turn red: take note of the **Index** (in this example: Index 2). We need it for configuring the framebuffer patch
		- If it doesn't turn red, you might have an incorrect `AAPL,ig-platform-id` to begin with
	- Observe the system's behavior:
		- **If your display turns on**, how long does the handshake take? 
			- **Short**: 
				- If it does turn on and the screens only take 2 to 3 cycles until a stable connection is established, then you're probably good. 
				- Connections between the same connector types (HDMI to HDMI, DP to DP) are negotiated faster than between 2 different types of connectors (HDMI to DP, HDMI to DVI, etc.)! 
				- If the handshake behaves similarly if the ext. display is already connected prior to booting then you're probably good as well.
			- **Long**: 
				- If it does turn on (late) and the handshake takes more than 3 or 4 cycles, then there's room for improvement.
		- **If your display does not turn on**:
			- Does your mouse start to lag? If your mouse pointer starts to lag the screen is most likely detected but the BusID and flags used for the connectors are possibly incorrect for the used connectors. 
			- Disconnect the external monitor for now so you can work with your Laptop again

## Verifying/adjusting the `AAPL-ig-platform-id`

1. Find the CPU used in your machine. If you don't know, you can enter in Terminal: 

	```
	sysctl machdep.cpu.brand_string
	```
2. Search your model number on https://ark.intel.com/ to find its specs. In my case it's an `i5-8265U`.

3. Take note of the the CPU family it belongs to (for example "Whisky Lake") and which type of on-board graphics it is using. In my case it does not list the actual model of the iGPU but only states "Intel® UHD Graphics for 8th Generation Intel® Processors" which doesn't help. In this case, use sites like netbookcheck.net or check in Windows Device Manager to find the exact model. In my case, it uses Intel UHD Graphics 620: <br> ![](/Users/stunner/Desktop/devmanigp.png)

4. Next, verify that you are using the recommended `AAPL,ig-platform-id` for your CPU and iGPU:
	- Find the recommended framebuffer for your mobile CPU family [in this list](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/iGPU/iGPU_DeviceProperties.md#framebuffers-laptopnuc) (based on data provided by OpenCore Install Guide)
	- Check if your iGPU requires a device-id to spoof a different iGPU model!
	- Compare the data with the `DeviceProperties` used in your config.plist

5. Make sure to cross-reference the default/recommended framebuffer for your iGPU against the ones listed in the [Intel HD Graphics FAQs](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#intel-hd-graphics-faqs). But keep in mind that the Intel HD FAQs uses [Big Endian instead of Little Endian](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/iGPU/Framebuffer_Patching/Big-Endian_Little-Endian.md) which is required for the config.plist.

6. If necessary, adjust the framebuffer patch (mainly `AAPL,ig-platform-id`) in the config.plist stored on your USB flash drive according to the data you gathered in steps 4 or 5. If you are already using the correct/recommended `AAPL,ig-platform-id`, then you can skip to the next chapter "Adding Connectors".

7. If you have to change the `AAPL,ig-platform-id` but your framebuffer patch already contains connector patches (everything with `framebuffer-con…`), disable the whole device property entry by placing `#` in front of the dictionary `#PciRoot(0x0)/Pci(0x2,0x0)` and create a new one: `PciRoot(0x0)/Pci(0x2,0x0)` to start with a clean slate. Then add the recommended data you found. If your system requires additional properties so that the internal display works correctly (like backlight register fixes, etc.), copy them over from your previous framebuffer patch.

8. Save your config and reboot from the USB flash drive. If the system boots and the internal display works, we can now add data for the external. If it doesn't boot, reset the system, boot from the internal disk and start over.

**NOTES**:

- The OpenCore Install Guide only provided the *basic* settings you need to get a signal from your primary display. It does not include additional connectors (except for Ivy Bridge Laptop).
-  In my case, the recommended framebuffer and device-id for the Intel UHD 620 differ: Dortania recommends AAPL,ig-platform-id `00009B3E` and device-id `9B3E0000` to spoof the iGPU as Intel UHD 630 while the Intel HD FAQs recommends AAPL,ig-platform-id `0900A53E` and device-id `A53E0000` to spoof it as Intel Iris 655 which worked better in the end.

## Adding Connectors
Now that we have verified that we are using the recommended framebuffer, we need to gather the connectors data associated with the selected framebuffer in the Intel HD FAQs. Since there are 2 different recommendations for my iGPU, I will look at both.

### Gathering data for your framebuffer (Example 1)
The recommended Framebuffer for my Intel UHD suggested by Dortania is AAPL,ig-platform-id `00009B3E`. Now we need to find the connector data for this framebuffer in the Intel HD FAQs:

1. Convert the value for framebuffer `00009B3E` into Big Endian. Here it': `0x3E9B0000`
2. Visit the [Intel HD Graphics FAQs](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md)
3. Press CMD+F to search within the site
4. Enter your framebuffer (converted to Big Endian, without the leading 0x): `3E9B0000`
5. You should find your value in a table with other framebuffers
6. Scroll down past the table until you see "Spoiler: … connectors". Click on it to reveal the data
7. Hit forward in the search function to find the next mach and then you will finally find the data belonging to your framebuffer ID!

**Here's the Data for ID: 3E9B0000**

```
ID: 3E9B0000, STOLEN: 57 MB, FBMEM: 0 bytes, VRAM: 1536 MB, Flags: 0x0000130B
TOTAL STOLEN: 58 MB, TOTAL CURSOR: 1 MB (1572864 bytes), MAX STOLEN: 172 MB, MAX OVERALL: 173 MB (181940224 bytes)
Model name: Intel HD Graphics CFL CRB
Camellia: CamelliaDisabled (0), Freq: 0 Hz, FreqMax: 0 Hz
Mobile: 1, PipeCount: 3, PortCount: 3, FBMemoryCount: 3

[0] busId: 0x00, pipe: 8, type: 0x00000002, flags: 0x00000098 - ConnectorLVDS
[1] busId: 0x05, pipe: 9, type: 0x00000400, flags: 0x00000187 - ConnectorDP
[2] busId: 0x04, pipe: 10, type: 0x00000400, flags: 0x00000187 - ConnectorDP

00000800 02000000 98000000
01050900 00040000 87010000
02040A00 00040000 87010000
```

The picture below lists the same data for the 3 connectors this framebuffer provides but with some additional color coding:

![](/Users/stunner/Desktop/FBADATA02.png)

<details>
<summary><strong>More Examples</strong> (click to reveal)</summary>

### Gathering data for your framebuffer (Example 2)
Since the Intel HD FAQs recommends a different framebuffer in certain cases you should double-check this, too. So look-up the data for your CPU family in the document and scroll down to where it says ***"Recommended framebuffers"***. In my case the Intel HD FAQs suggests 0x3EA50009 instead.

**Here's the Data for ID: 3E9B0000**
 
```
ID: 3EA50009, STOLEN: 57 MB, FBMEM: 0 bytes, VRAM: 1536 MB, Flags: 0x00830B0A
TOTAL STOLEN: 58 MB, TOTAL CURSOR: 1 MB (1572864 bytes), MAX STOLEN: 172 MB, MAX OVERALL: 173 MB (181940224 bytes)
Model name: Intel HD Graphics CFL CRB
Camellia: CamelliaV3 (3), Freq: 0 Hz, FreqMax: 0 Hz
Mobile: 1, PipeCount: 3, PortCount: 3, FBMemoryCount: 3

[0] busId: 0x00, pipe: 8, type: 0x00000002, flags: 0x00000098 - ConnectorLVDS
[1] busId: 0x05, pipe: 9, type: 0x00000400, flags: 0x000001C7 - ConnectorDP
[2] busId: 0x04, pipe: 10, type: 0x00000400, flags: 0x000001C7 - ConnectorDP

00000800 02000000 98000000
01050900 00040000 C7010000
02040A00 00040000 C7010000
```
### Gathering data for your framebuffer (Example 3)
In the end, I settled with framebuffer `0x3EA50004` instead and in the end you will understand why.

```
ID: 3EA50004, STOLEN: 57 MB, FBMEM: 0 bytes, VRAM: 1536 MB, Flags: 0x00E30B0A
TOTAL STOLEN: 58 MB, TOTAL CURSOR: 1 MB (1572864 bytes), MAX STOLEN: 172 MB, MAX OVERALL: 173 MB (181940224 bytes)
Model name: Intel Iris Plus Graphics 655
Camellia: CamelliaV3 (3), Freq: 0 Hz, FreqMax: 0 Hz
Mobile: 1, PipeCount: 3, PortCount: 3, FBMemoryCount: 3

[0] busId: 0x00, pipe: 8, type: 0x00000002, flags: 0x00000498 - ConnectorLVDS
[1] busId: 0x05, pipe: 9, type: 0x00000400, flags: 0x000003C7 - ConnectorDP
[2] busId: 0x04, pipe: 10, type: 0x00000400, flags: 0x000003C7 - ConnectorDP

00000800 02000000 98040000
01050900 00040000 C7030000
02040A00 00040000 C7030000`
```
</details>

Next, we need to translate this data into `DeviceProperties` for our config.plist so we can inject it into macOS.

### Translating the data into `DeviceProperties`

**Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

These entries you should have already – just with the values recommended for your iGPU:

Key | Type | Value| Notes
----|:----:|:----:|------
`AAPL,ig-platform-id`|Data| `00009B3E` |For Laptops with UHD 620
||||
`framebuffer-patch-enable`| Data | `01000000` | Enables Framebuffer patching via Whatevergreen
`framebuffer-stolenmem` | Data | `00003001` | Only needed if "About this Mac" section shows 7mb or less after patching 
`framebuffer-fbmem`| Data | `00009000` | Only needed if "About this Mac" section shows 7mb or less after patching 
||||
`device-id`|Data|`9B3E0000`| Device-ID is required for UHD 620

**And these we need for the Connectors:**

Key                    | Type | Value| Notes
-----------------------|:----:|:----:|------
`AAPL,slot-name` | String | Internal@0,2,0 | Internal location of the iGPU (optional). This lists the iGPU in the "Graphics" category of System Profiler
`device-id` | Data |  9B3E0000 |  For spoofing Intel UHD 620 as Intel UHD 630. Only add it if required for your iGPU model
`device_type` | String | VGA compatible controller | Optional
`disable-external-gpu` |Data| 01000000 | Optional. Only required if your Laptop has an incompatible dGPU
`framebuffer-con1-busid` |Data | 05000000 | BusID used to transmit data to the physical  port # 1 on your machine
`framebuffer-con1-enable` | Data | 01000000 | Enables Patching Connector #2 via Whatevergreen
`framebuffer-con1-flags` | Data | 87010000 | Default flags for connector 3
`framebuffer-con1-index` | Data | 01000000 | Connector 3 has Index 2
`framebuffer-con1-pipe`| Data| 09000000| Pipe 9
`framebuffer-con2-busid` | Data | 04000000 | BusID used to transmit data to physical port #2 of your machine
`framebuffer-con2-enable` | Data | 01000000 | Enables Patching Connector #3 via Whatevergreen
`framebuffer-con2-flags` | Data| 87010000 | Default flags for connector 3
`framebuffer-con2-index` | Data | 02000000 | Connector 3 has Index 2
`framebuffer-con2-pipe` | Data | 0A000000| Pipe 10, converted to hex = 0A
`framebuffer-patch-enable` | Data | 0100000| Enables Framebuffer patching via Whatevergreen
`model` | String | Intel UHD Graphics 620 | Optional

> **Note**: We don't add properties for `con0` since this is the internal display which should work fine with the correct framebuffer.

**This is how your config should look like after transferring the framebuffer data to your config.plist**:

![](/Users/stunner/Desktop/config.png)

## Testing Round 2






_____
### I. Choosing the correct Framebuffer for macOS and your iGPU
⚠️ **DISCLAIMER**: The values used in the given example are for an 8th Gen Whiskey Lake CPU. 

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
