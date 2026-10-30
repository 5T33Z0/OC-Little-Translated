# Intel iGPU Framebuffer patching for external displays (Laptop)

<details>
<summary><strong>TABLE of CONTENTS</strong> (click to reveal)</summary><br>

**TABLE of CONTENTS**

- [About](#about)
	- [Problem description](#problem-description)
	- [Possible causes](#possible-causes)
	- [Solution](#solution)
	- [Supported Connection Types](#supported-connection-types)
	- [Workflow overview](#workflow-overview)
- [1. Preparations](#1-preparations)
	- [Create a bootable USB flash drive](#create-a-bootable-usb-flash-drive)
	- [Required Tools and Resources](#required-tools-and-resources)
- [2. Test your current configuration](#2-test-your-current-configuration)
- [3. Verify/adjust the `AAPL-ig-platform-id`](#3-verifyadjust-the-aapl-ig-platform-id)
- [4. Understanding the Parameters](#4-understanding-the-parameters)
	- [Understanding the `framebuffer-conX-alldata` property](#understanding-the-framebuffer-conx-alldata-property)
	- [Understanding the `framebuffer-unifiedmem` property](#understanding-the-framebuffer-unifiedmem-property)
- [5. Adding Connectors](#5-adding-connectors)
	- [Adding Connectors (Manual Method)](#adding-connectors-manual-method)
		- [Gather data for your framebuffer (Example 1)](#gather-data-for-your-framebuffer-example-1)
		- [Gather data for your framebuffer (Example 2)](#gather-data-for-your-framebuffer-example-2)
		- [Gathering data for your framebuffer (Example 3)](#gathering-data-for-your-framebuffer-example-3)
		- [Translating the data into `DeviceProperties`](#translating-the-data-into-deviceproperties)
	- [Semi-automated method using Hackintool](#semi-automated-method-using-hackintool)
		- [Generating a framebuffer patch with Hackintool](#generating-a-framebuffer-patch-with-hackintool)
		- [Optional Properties:](#optional-properties)
- [6. Testing and modifying the framebuffer patch](#6-testing-and-modifying-the-framebuffer-patch)
	- [If case 1 occurs](#if-case-1-occurs)
	- [If case 2 occurs](#if-case-2-occurs)
	- [If case 3 occurs](#if-case-3-occurs)
	- [If case 4 occurs](#if-case-4-occurs)
- [7. Final Steps](#7-final-steps)
- [Credits and further resources](#credits-and-further-resources)
</details>

## About
This guide is for modifying `DeviceProperties` for connector types on Intel iGPUs, so you can connect a secondary display to the `HDMI` or `DisplayPort` of your Laptop.

### Problem description
Your Laptop boots into macOS and the internal screen works, but:

1. If you connect a secondary monitor to your Laptop it won't turn on at all, or 
2. The handshake between the system and both displays takes a long time and both screens turn off and on several times during the handshake until a stable connection is established.

> [!NOTE]
> 
> If you don't get a picture at all you could try a [fake ig-platform-id](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/iGPU/Framebuffer_Patching/Fake_IG-Platform-ID.md) to force the system into [VESA mode](https://wiki.osdev.org/VESA_Video_Modes). For desktop systems, try CaseySJ's [General Framebuffer Patching guide](https://www.tonymacx86.com/threads/guide-general-framebuffer-patching-guide-hdmi-black-screen-problem.269149/) instead.

### Possible causes
- Using an incorrect or sub-optimal `AAPL,ig-platform-id` for your iGPU
- Misconfigured framebuffer patch with incorrect BusID and/or flags for the used cable/connector

### Solution
- Adjust the framebuffer patch for your iGPU

### Supported Connection Types
- **HDMI** &rarr; **HDMI**
- **DP** &rarr; **DP** (DisplayPort)
- **HDMI** &rarr; **DVI**
- **DP** &rarr; **DVI**
- **VGA** (Skylake and newer only)

> [!NOTE]
> 
> - :bulb: Although the examples used throughout this guide are for getting the Intel UHD 620 to work, the basic principle is applicable to any other iGPU model supported by macOS as well. Just make sure to use the framebuffer data required for your iGPU.
> - VGA supposedly works out of the box on Skylake and newer, but since I have no machine to test this you are on your own in this case. Disabling `AGDC` via device property `disable-agdc` seems to be required as well.

### Workflow overview
This is the tl;dr version of what we are going to do basically:

1. Copy working EFI to FAT32 formatted USB flash drive
2. Find a suitable Framebuffer
	- Find your iGPU
	- Add recommended `AAPL,ig-platform-id` to `DeviceProperties`
	- Add default Connector Data to config.plist
3. Test if ext. Monitor is working
4. Adjust/modify connector data to optimize handshake
5. Test again
6. Repeat steps 4 and 5 until you think it's optimal
7. Add framebuffer patch to the config.plist on system disk.

---

## 1. Preparations

### Create a bootable USB flash drive
- Mount your system's EFI partition 
- Copy your EFI folder to a FAT32 formatted USB flash drive
- Unmount the EFI partition again – from now on, we will work with the config stored on the USB flash drive!
- Reboot
- Change the boot order of your drives in the BIOS so that the USB flash drive takes the first slot. Otherwise you have to select the USB flash drive manually after each reboot

**Explanation**: Since we will probably have to do a lot of rebooting to test the framebuffer, we will not work with the config.plist stored on the internal disk because a) we don't want to mess up our working configuration and b) we don't have to mount the EFI partition every time to access the config.plist since it's stored on a flash drive. This really speeds up the workflow.

### Required Tools and Resources
- A FAT32 formatted USB Flash drive
- External Display and cable(s) to populate the output(s) of your mainboard (usually HDMI and/or DisplayPort)
- Lilu and WhateverGreen kexts enabled (mandatory)
- [**Hackintool App**](https://github.com/headkaze/Hackintool/releases) for creating/modifying framebuffer properties
- [**ProperTree**](https://github.com/corpnewt/ProperTree) to copy over Device Properties to your config
- [**Intel Ark**](https://ark.intel.com/content/www/us/en/ark.html) (for researching CPU specs such as used on-board graphics and device-id)
- [**OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/) (for referencing default/recommended framebuffers)
- [**Intel HD Graphics FAQs**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#intel-uhd-graphics-610-655-coffee-lake-and-comet-lake-processors) for Framebuffers and Device-IDs and additional info.
- [**Big to Little Endian Converter**](https://www.save-editor.com/tools/wse_hex.html) to convert Framebuffers from Big Endian to Little Endian and vice versa
- **Optional**: [**OCToolbox**](https://github.com/webfalter/OCToolBox) – includes calculators for Framebuffer and Connector flags (can also reverse checksums into the included flags) 

---

## 2. Test your current configuration
Before we do any editing we will run a basic test. You can skip this if you already know that your external display isn't working. Observe what happens after attaching the external display to your Laptop:

| Ext. Display turns On? | Ext. Display detected <br> in Hackintool? | Action(s) |
|:---------------------:|:---------------------------------------:|-----------|
| **No** | **No** | <ul><li>[Verify/adjust used `AAPL,ig-platform-id`](#3-verifyadjust-the-aapl-ig-platform-id)</li><li>[Add Connectors to framebuffer patch](#5-adding-connectors)</li><li>[Change BusIDs](#if-case-1-occurs) for both **`con1`** and **`con2`**</li></ul> |
| **No** | **Yes** (Index?) | [Adjust flags](#if-case-3-occurs) for the connector detected at Index X (X = con1 or con2) |

If the display is detected in Hackintool's "Patch" section, either **Index 1** or **Index 2** should turn red: 

![display-red](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/f671908c-ae2f-4241-a782-f35ccaa6c918)

If the display is detected and turns on:

| Ext. Display detected <br> in Hackintool? | Handshake | Symptoms | Action |
|:---------------------------------------:|:---------:|----------|--------|
| **Yes** (Index?) | Slow | <ul><li>Mouse cursor lagging</li><li>System feels unresponsive</li><li>Display turns on late after completing boot sequence</li><li>Displays turn on and off more than 3 times during handshake</li></ul> | Adjust connector flags for the connector at detected Index. In my case it's connected via **con2**. |
| **Yes** (Index?) | Fast | Everything feels normal | Congrats. Nothing to do! |

Take note of your test results. Depending on the results you might be able to skip sections.

---

## 3. Verify/adjust the `AAPL-ig-platform-id`

1. Find the CPU used in your Notebook. If you don't know, you can enter in Terminal: 

	```bash
	sysctl machdep.cpu.brand_string
	```
2. Search your model number on https://ark.intel.com/ to find its specs. In my case it's an `i5-8265U`.

3. Take note of the CPU family it belongs to (for example "Whiskey Lake").

4. Identify the iGPU model of the CPU. If the actual model of the iGPU is not specified (i.e. if it says "Intel® UHD Graphics for xth Generation Intel® Processors"), use sites like notebookcheck.net or check in Windows Device Manager to find the exact model. In my case, it's an Intel UHD Graphics 620: <br> ![devmanigp](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/1844b3a0-01fa-4655-9cf8-ab771388512f)

5. Next, verify that you are using the recommended `AAPL,ig-platform-id` for your CPU and iGPU:
	- Find the recommended framebuffer for your mobile CPU family [in this list](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/iGPU/iGPU_DeviceProperties.md#framebuffers-laptopnuc) (based on data from the OpenCore Install Guide).
	- Check if your iGPU requires a device-id to spoof a different iGPU model!
	- Compare the data with the `DeviceProperties` used in your `config.plist`.

6. Make sure to cross-reference the default/recommended framebuffer for your iGPU against the ones listed in the [Intel HD Graphics FAQs](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#intel-hd-graphics-faqs). Keep in mind that the Intel HD FAQs uses [Big Endian instead of Little Endian](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/iGPU/Framebuffer_Patching/Big-Endian_Little-Endian.md), which is required for the `config.plist`.

7. If necessary, adjust the framebuffer patch (mainly `AAPL,ig-platform-id`) in the `config.plist` stored on your USB flash drive according to the data you gathered in steps 5 or 6. If you are already using the correct/recommended `AAPL,ig-platform-id`, you can skip to chapter 5 ("Adding Connectors").

8. If you have to change the `AAPL,ig-platform-id` but your framebuffer patch already contains connector patches (entries containing `framebuffer-con…`), disable the whole device property entry by placing `#` in front of the dictionary `#PciRoot(0x0)/Pci(0x2,0x0)` and create a new clean entry: `PciRoot(0x0)/Pci(0x2,0x0)`.

9. Add the recommended data you found. If your system requires additional properties so that the internal display works correctly (like backlight register fixes, etc.), copy them over from your previous framebuffer patch.

10. Save your config and reboot from the USB flash drive. If the system boots and the internal display works, we can now add data to connect to an external display. If it doesn't boot, reset the system, boot from the internal disk, and start over.

> [!NOTE]
>
> - The OpenCore Install Guide only provides *basic* settings to enable your primary display. It does not include additional connectors (except for Ivy Bridge Laptops).
> - In my case, the recommended framebuffer and device-id for the Intel UHD 620 differ: Dortania recommends AAPL,ig-platform-id `00009B3E` and device-id `9B3E0000` to spoof the iGPU as Intel UHD 630, while Intel HD FAQs recommends AAPL,ig-platform-id `0900A53E` and device-id `A53E0000` to spoof it as Intel Iris Plus 655, which worked better for me in the end.
> - To resolve issues with HDMI handshakes, you may need to disable **Apple Graphics Device Control** (AGDC) via property `disable-agdc`, as it can cause conflicts when using a spoofed SMBIOS/Board-ID with non-native macOS versions!

---

## 4. Understanding the Parameters
Let's have a look inside Hackintool's "Connectors" tab to understand the parameters we are working with:

|Parameter|Description|
|:-------:|-----------|
|**Index**| An **Index** represents a *physical* graphics output on your Laptop. In macOS, up to 3 software connectors can be assigned (`con0` to `con2`) to 3 connectors (Indexes `1` to `3`). Index `-1` has no physical connector:</br>![Connectors](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/38ab2a7f-c342-4f1a-81a0-72decf1d0b4d) </br>Framebuffers which only contain `-1` Indexes (often referred to as "headless" or "empty") are used in setups where a discrete GPU is used for displaying graphics while the iGPU performs computational tasks only, e.g. Platform-ID `0x9BC80003`:</br>![headless](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/00b0b232-0de7-4a1b-a01f-8c6fabb90753)|
|**BusID**| **Screenshot**: (example)<br> <img width="472" height="130" alt="busid" src="https://github.com/user-attachments/assets/6c6a075c-8b30-4581-b0c9-9dc01a53d9c8" /> </br> The **Bus ID** is used to select the busses or pathways available for connecting displays. Every connector (`con`) must be assigned a *unique* `BusID` through which the signal travels from the iGPU to the physical port(s). Unique means each Bus ID can only be assigned to one connector at a time! And: only certain combinations of BusIDs and connector Types are allowed: <ul> <li> For **DisplayPort**: `0x02`, `0x04`, `0x05` or `0x06`</li><li>For **HDMI**: `0x01`, `0x02`, `0x04`, `0x06` (availability may vary)</li> <li> For **DVI**: same as HDMI</li> <li> For **VGA**: N/A</li></ul> |
|**Pipe**| Responsible for taking the graphics data from the iGPU and converting it into a format that can be displayed on a monitor or screen. It performs tasks such as scaling, color correction, and synchronization to ensure that the visual output appears correctly on the connected display. This is fixed for each framebuffer |
|**Type**| Type of the *physical* connector (DP, HDMI, DVI, LVDS, etc.). Each connector type has a specific value associated with it: <ul><li> **DP**: `00040000`</li> <li> **HDMI**: `00080000`</li> <li> **DVI**: `00800000`</li></ul>⚠️ When using cables that have _different_ connectors on each end (i.e. DisplayPort > DVI, etc.), you _must_ use `HDMI` as connector type! |
|**Flags**| A bitmask representing connector "Flags" for the selected connector. The recommended value for any connection is `C7030000`:</br>![Flags](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/94aa0944-a3dc-4fb8-b68e-ba4c502c7bac) <br> For a complete list of framebuffer and connector flags, [click here](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/iGPU/Framebuffer_Patching/Framebuffer_Connector_Flags.md) |

### Understanding the `framebuffer-conX-alldata` property

This is a special property which allows patching multiple connectors in sequence by putting them into a single string and specifying the index of the connector to start with. The string length should be a multiple of 12 bytes (the length of a single connector), or 24 bytes for ICL (Ice Lake). In other words, the `con-alldata` patch injects `Index`, `BusID`, `Pipe`, `Type` and `Flags` for numerous connectors in one go.

An example for the usage of this method of custom patching can be found in the framebuffer patch for Ivy Bridge Laptops with Intel HD 4000 graphics and a display panel with 1600x900 px or more using AAPL,ig-platform-id `0x01660004`, which only has one connector for the internal display:

```text
ID: 01660004, STOLEN: 32 MB, FBMEM: 16 MB, VRAM: 1536 MB, Flags: 0x00000000
TOTAL STOLEN: 16 MB, TOTAL CURSOR: 1 MB (1572864 bytes), MAX STOLEN: 16 MB, MAX OVERALL: 17 MB (18354176 bytes)
Camellia: CamelliaUnsupported (255), Freq: 1808 Hz, FreqMax: 1808 Hz
Mobile: 1, PipeCount: 3, PortCount: 1, FBMemoryCount: 1
[5] busId: 0x03, pipe: 0, type: 0x00000002, flags: 0x00000230 - ConnectorLVDS
05030000 02000000 30020000
```

To inject additional connectors, the ones from `0x01660003` (which is for standard def displays) can be used, which contains the following connectors:

```text
02050000 00040000 07040000
03040000 00040000 81000000
04060000 00040000 81000000
```

This results in the following string for `con1-alldata`:

`framebuffer-con1-alldata`: `02050000 00040000 07040000 03040000 00040000 81000000 04060000 00040000 81000000`

### Understanding the `framebuffer-unifiedmem` property
This device property can be used to allocate more RAM to the iGPU as VRAM. On laptops, the default usually is 1536 MB. With the `framebuffer-unifiedmem` property, you can increase the amount of VRAM to address graphical glitches or artifacts. On my Lenovo T530 for example, the scrollbar in Firefox becomes glitchy (pink horizontal stripes) if only 1536 MB of VRAM are allocated. Increasing the amount of VRAM to 2048 MB fixes this issue. 

Below you will find the hex values to allocate x MB of VRAM:

| HEX value | Allocated VRAM |
|:---------:|:--------------:|
| `00000040` | 1024 MB |
| `00000060` | 1536 MB |
| `00000080` | 2048 MB |
| `000000A0` | 2560 MB |
| `000000C0` | 3072 MB |
| `000000E0` | 3584 MB |
| `FFFFFFFF` | 4096 MB |

> [!IMPORTANT]
>
> - According to the WhateverGreen FAQ, using the `framebuffer-unifiedmem` property is not recommended unless necessary.
> - Don't assign more VRAM than physical RAM installed in your system!
> - Disable or delete the `framebuffer-stolenmem` property if you want to increase VRAM via `framebuffer-unifiedmem`. The properties `stolenmem` and `unifiedmem` should not be used together at the same time!

---

## 5. Adding Connectors

<details>
<summary><strong>Manual Method</strong> (click to reveal)</summary>

### Adding Connectors (Manual Method)

Now that we have verified that we are using the recommended framebuffer, we need to gather the connector data associated with the selected framebuffer in the Intel HD FAQs.

#### Gather data for your framebuffer (Example 1)
The recommended Framebuffer for my Intel UHD 620 suggested by Dortania is AAPL,ig-platform-id `00009B3E`. Now we find the connector data for this framebuffer in the Intel HD FAQs:

1. Convert the value for framebuffer to Big Endian. You can use Hackintool's calculator to do this. In my case it's `0x3E9B0000`.
2. Visit the [Intel HD Graphics FAQs](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md).
3. Press <kbd>CMD</kbd>+<kbd>F</kbd> to search within the page.
4. Enter your framebuffer (converted to Big Endian, without the leading `0x`), here: `3E9B0000`.
5. You should find your value in a table with other framebuffers.
6. Scroll down past the table until you see "Spoiler: … connectors". Click on it to reveal the data.
7. Hit forward in the search function to find the next match. This will be the connector data for your AAPL,ig-platform-id!

**This is the Data for ID: 3E9B0000:**

```text
ID: 3E9B0000, STOLEN: 57 MB, FBMEM: 0 bytes, VRAM: 1536 MB, Flags: 0x0000130B
TOTAL STOLEN: 58 MB, TOTAL CURSOR: 1 MB (1572864 bytes), MAX STOLEN: 172 MB, MAX OVERALL: 173 MB (181940224 bytes)
Model name: Intel HD Graphics CFL CRB
Camellia: CamelliaDisabled (0), Freq: 0 Hz, FreqMax: 0 Hz
Mobile: 1, PipeCount: 3, PortCount: 3, FBMemoryCount: 3

[0] busId: 0x00, pipe: 8,  type: 0x00000002, flags: 0x00000098 - ConnectorLVDS
[1] busId: 0x05, pipe: 9,  type: 0x00000400, flags: 0x00000187 - ConnectorDP
[2] busId: 0x04, pipe: 10, type: 0x00000400, flags: 0x00000187 - ConnectorDP

00000800 02000000 98000000
01050900 00040000 87010000
02040A00 00040000 87010000
```

The picture below lists the same data for the 3 connectors this framebuffer provides with additional color coding:

![FBADATA02](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/91a78db5-ec2a-4a1f-8eba-df6720787ed3)

<details>
<summary><strong>More Examples</strong> (click to reveal)</summary>

#### Gather data for your framebuffer (Example 2)
Since the Intel HD FAQs recommends a different framebuffer in certain cases, you should double-check this too. Look up the data for your CPU family and scroll down to ***"Recommended framebuffers"***. In my case the Intel HD FAQs suggests `0x3EA50009`.

**Here's the Data for ID: 3EA50009**
 
```text
ID: 3EA50009, STOLEN: 57 MB, FBMEM: 0 bytes, VRAM: 1536 MB, Flags: 0x00830B0A
TOTAL STOLEN: 58 MB, TOTAL CURSOR: 1 MB (1572864 bytes), MAX STOLEN: 172 MB, MAX OVERALL: 173 MB (181940224 bytes)
Model name: Intel HD Graphics CFL CRB
Camellia: CamelliaV3 (3), Freq: 0 Hz, FreqMax: 0 Hz
Mobile: 1, PipeCount: 3, PortCount: 3, FBMemoryCount: 3

[0] busId: 0x00, pipe: 8,  type: 0x00000002, flags: 0x00000098 - ConnectorLVDS
[1] busId: 0x05, pipe: 9,  type: 0x00000400, flags: 0x000001C7 - ConnectorDP
[2] busId: 0x04, pipe: 10, type: 0x00000400, flags: 0x000001C7 - ConnectorDP

00000800 02000000 98000000
01050900 00040000 C7010000
02040A00 00040000 C7010000
```

#### Gathering data for your framebuffer (Example 3)
In the end, I settled on framebuffer `0x3EA50004`:

```text
ID: 3EA50004, STOLEN: 57 MB, FBMEM: 0 bytes, VRAM: 1536 MB, Flags: 0x00E30B0A
TOTAL STOLEN: 58 MB, TOTAL CURSOR: 1 MB (1572864 bytes), MAX STOLEN: 172 MB, MAX OVERALL: 173 MB (181940224 bytes)
Model name: Intel Iris Plus Graphics 655
Camellia: CamelliaV3 (3), Freq: 0 Hz, FreqMax: 0 Hz
Mobile: 1, PipeCount: 3, PortCount: 3, FBMemoryCount: 3

[0] busId: 0x00, pipe: 8,  type: 0x00000002, flags: 0x00000498 - ConnectorLVDS
[1] busId: 0x05, pipe: 9,  type: 0x00000400, flags: 0x000003C7 - ConnectorDP
[2] busId: 0x04, pipe: 10, type: 0x00000400, flags: 0x000003C7 - ConnectorDP

00000800 02000000 98040000
01050900 00040000 C7030000
02040A00 00040000 C7030000
```
</details>

#### Translating the data into `DeviceProperties`

Now we need to translate this data into `DeviceProperties`.

**Target Address**: `PciRoot(0x0)/Pci(0x2,0x0)`

You probably have these baseline entries already:

| Key | Type | Value | Notes |
|---|:---:|:---:|---|
| `AAPL,ig-platform-id` | Data | `00009B3E` | For Laptops with UHD 620 |
| `framebuffer-patch-enable` | Data | `01000000` | Enables Framebuffer patching via WhateverGreen |
| `framebuffer-stolenmem` | Data | `00003001` | Only needed if "About this Mac" section shows 7 MB or less after patching |
| `framebuffer-fbmem` | Data | `00009000` | Only needed if "About this Mac" section shows 7 MB or less after patching |
| `device-id` | Data | `9B3E0000` | Device-ID spoof required for UHD 620 |

**And these entries are added for the Connectors:**

For now, we will leave every value as is, except connector type, since most modern systems use `HDMI` instead of `DisplayPort`:

| Key | Type | Value | Notes |
|---|:---:|:---:|---|
| `AAPL,slot-name` | String | `Internal@0,2,0` | Internal location of the iGPU (optional) |
| `device-id` | Data | `9B3E0000` | For spoofing Intel UHD 620 as Intel UHD 630 (if required) |
| `device_type` | String | `VGA compatible controller` | Optional cosmetic entry |
| `disable-external-gpu` | Data | `01000000` | Optional. Disables unsupported dGPU |
| `framebuffer-con1-busid` | Data | `05000000` | BusID used to transmit data to physical port #1 |
| `framebuffer-con1-enable` | Data | `01000000` | Enables Patching Connector #2 (con1) |
| `framebuffer-con1-flags` | Data | `87010000` | Default flags for connector 2 (con1) |
| `framebuffer-con1-index` | Data | `01000000` | Connector 2 has Index 1 |
| `framebuffer-con1-pipe` | Data | `09000000` | Pipe 9 |
| `framebuffer-con1-type` | Data | `00080000` | HDMI. If you have native DisplayPort use `00040000` |
| `framebuffer-con2-busid` | Data | `04000000` | BusID used to transmit data to physical port #2 |
| `framebuffer-con2-enable` | Data | `01000000` | Enables Patching Connector #3 (con2) |
| `framebuffer-con2-flags` | Data | `87010000` | Default flags for connector 3 (con2) |
| `framebuffer-con2-index` | Data | `02000000` | Connector 3 has Index 2 |
| `framebuffer-con2-pipe` | Data | `0A000000` | Pipe 10 (0x0A) |
| `framebuffer-con2-type` | Data | `00080000` | HDMI. If you have native DisplayPort use `00040000` |
| `framebuffer-con3-busid` | Data | `00000000` | BusID for dummy con3 |
| `framebuffer-con3-enable` | Data | `01000000` | Optional. Enables Patching Connector #4 (con3) |
| `framebuffer-con3-index` | Data | `FFFFFFFF` | Optional. Disables dummy con3 |
| `framebuffer-con3-pipe` | Data | `00000000` | Optional. Takes con3 offline |
| `framebuffer-patch-enable` | Data | `01000000` | Enables Framebuffer patching via WhateverGreen |
| `model` | String | `Intel UHD Graphics 620` | Optional cosmetic property |

**Optional Properties**:

| Key | Type | Value | Notes |
|---|:---:|:---:|---|
| `enable-backlight-registers-fix` | Data | `01000000` | Fixes backlight registers on Kaby Lake, Coffee Lake, and Ice Lake. |
| `enable-backlight-registers-alternative-fix` | Data | `01000000` | Same but for macOS 13.4+ |

> [!NOTE]
> We don't add properties for `con0` since this is the internal display which should work fine with the correct framebuffer.

**This is how the DeviceProperties for your iGPU should look now**:

![cfg-step1](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/760bd4d0-e2de-493b-8fb0-aee52caf15c0)
</details>

<details>
<summary><strong>Semi-automated method using Hackintool</strong> (click to reveal)</summary>

### Semi-automated method using Hackintool

#### Generating a framebuffer patch with Hackintool
1. Run Hackintool.
2. In the menu bar, choose the "Framebuffer" type. Select either **≤ macOS 10.13** (High Sierra and older) or **≥ macOS 10.14** (Mojave and newer, default): </br> ![Menubar](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/3e425067-557c-4418-88d1-02c5f64c9aea)
3. Next, click on "Patch".
4. Then click on "Connectors".
5. From the "Intel Generation" dropdown menu, select the CPU family your processor belongs to (e.g. Coffee Lake for 8th/9th Gen).
6. Next, specify the "Platform ID" to use (e.g. `0x3E9B0000`):</br>![start01](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/67f8c8a5-6474-4168-9fe7-7ae942743a8f)
7. The list below the "Connectors" tab shows the default configuration of the selected Framebuffer:<br>![start02](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/912181f0-5b68-4228-bfec-adf89cd0ea41)
8. Leave `Index 0` (= internal display) untouched!
9. If you are using HDMI to HDMI or HDMI to DVI, change the "Type" for `Index 1` and `Index 2` to HDMI:<br>![cons01](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/8df0d0a8-67da-43ba-8048-fb496cb1fa48)
10. Next, modify the connector "Flags" for `Index 1` and `Index 2`:<br>![cons02](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/238faa4b-ac61-4a1c-bbbb-b5dde21d3400)
11. We want the sum to be `0x000003C7` (`C7030000`), which includes:
	- `CNAlterAppertureRequirements`
	- `CNUnknownFlag_2`
	- `CNUnknownFlag_4` 
	- `CNDisableBlitTranslationTable`
	- `CNUnknownFlag_80`
	- `CNUnknownFlag_100`
12. Click on the "Patch" tab.
13. In the "General" section, enable the following settings:<br>![patch01](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/b58b1b6c-15d5-4cb6-8e75-81947c052100)
14. Under the "Advanced" tab, select the required settings:<br>![patch02](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/cc34a3b1-25bc-4201-a2d7-660abea2aca0)
15. If your iGPU supports HDMI 2.0 and is routed through an on-board converter chip, check the "LSPCON" tab. If uncertain, leave it on "Auto Detect":<br>![patch03](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/f337105e-b1de-48f7-b87a-73b5b3540a52)
16. Click "Generate Patch" at the bottom right. The black area will be filled with property keys:<br>![generate01](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/c8011839-6c8b-4dfe-9216-efe91655252d)
17. Press <kbd>CMD</kbd>+<kbd>A</kbd> inside the box and copy the text (<kbd>CMD</kbd>+<kbd>C</kbd>).
18. Open ProperTree.
19. Press <kbd>CMD</kbd>+<kbd>V</kbd> to paste:<br>![result01](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/077a94e9-330c-459d-a7dc-5231de7af0b0)
20. Perform cleanup on the pasted dictionary `PciRoot(0x0)/Pci(0x2,0x0)`:
	- Delete all **`framebuffer-con0-`** properties (internal screen defaults are already fine).
	- Delete all entries for **`framebuffer-con3-`** unless you need to disable a specific dummy connector.
	- Set `model` to your actual graphics model name (e.g. `Intel UHD Graphics 620`).
	- Delete `framebuffer-stolenmem` if using `framebuffer-unifiedmem`.
	- Add any platform-specific properties (e.g. `enable-backlight-registers-fix`).
21. After editing, your framebuffer patch will look similar to this:<br>![result02](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/b87abad1-3cb2-4db8-917a-60717b7007fa)
22. Copy the cleaned dictionary `PciRoot(0x0)/Pci(0x2,0x0)` to your USB flash drive's `config.plist` under `DeviceProperties/Add`.

#### Optional Properties:

| Key | Type | Value | Notes |
|---|:---:|:---:|---|
| `enable-backlight-registers-fix` | Data | `01000000` | Fixes backlight registers on Kaby Lake, Coffee Lake, and Ice Lake platforms. |
| `enable-backlight-registers-alternative-fix` | Data | `01000000` | Alternative fix for macOS 13.4+ |
</details>

---

## 6. Testing and modifying the framebuffer patch
Now that we have added connectors for the selected framebuffer, reboot from your USB flash drive and connect your external monitor. 

:warning: If you are using any kind of SMBIOS/board-id and/or device-id spoof, add the following key to your Framebuffer Patch:

| Key | Type | Value |
|---|:---:|:---:|
| `disable-agdc` | Data | `01000000` |

It disables **Apple Graphics Device Control** (AGDC), which often causes handshake black-screens with spoofed SMBIOS/Board-IDs.

Observe the behavior of the system when connecting an external display:

| Case | Ext. Display <br>ON? | Detected in <br> Hackintool | Handshake | Action |
|:---:|:--------------------:|:--------------------------:|:---------:|--------|
| **1** | **NO** | **NO** | – | Change the BusIDs for **con1** and **con2** and test again |
| **2** | **NO** | **YES** | – | Take note of the Index and BusID, adjust connector flags, and test again |
| **3** | **YES** | **YES** | **Slow** | Modify connector flags to `C7030000` and test again |
| **4** | **YES** | **YES** | **Fast** | You're done! Transfer the DeviceProperties to your main config.plist |

---

### If case 1 occurs
Since the external display has not been detected yet, it's most likely that the BusIDs for both connectors are incorrect.

- Possible BusIDs are: `0x01`, `0x02`, `0x04`, `0x05`, or `0x06`.
- The same BusID can only be used for one connector at a time!
- Work through the combinations below. Save your `config.plist` and reboot between tests:

**Original values**

| Key | Type | Value |
|---|:---:|:---:|
| `framebuffer-con1-busid` | Data | `05000000` |
| `framebuffer-con2-busid` | Data | `04000000` |

**Next test**

| Key | Type | Value | Tested BusIDs |
|---|:---:|:---:|:---:|
| `framebuffer-con1-busid` | Data | `01000000` | 5 |
| `framebuffer-con2-busid` | Data | `02000000` | 4 |

**Next test**

| Key | Type | Value | Tested BusIDs |
|---|:---:|:---:|:---:|
| `framebuffer-con1-busid` | Data | `02000000` | 5, 1 |
| `framebuffer-con2-busid` | Data | `01000000` | 4, 2 |

**Next test**

| Key | Type | Value | Tested BusIDs |
|---|:---:|:---:|:---:|
| `framebuffer-con1-busid` | Data | `04000000` | 5, 1, 2 |
| `framebuffer-con2-busid` | Data | `06000000` | 4, 2, 1 |

**Next test**

| Key | Type | Value | Tested BusIDs |
|---|:---:|:---:|:---:|
| `framebuffer-con1-busid` | Data | `06000000` | 5, 1, 2, 4 |
| `framebuffer-con2-busid` | Data | `05000000` | 4, 2, 1, 6 |

If the external display still is not detected, check your `AAPL,ig-platform-id` and video cable/adapter.

---

### If case 2 occurs
If the connector turns red in Hackintool, macOS detects the port. In this example, assume it is detected on **con1**:

Keep testing individual BusIDs on the detected connector until the display lights up:

| Key | Type | Value | Tested BusIDs |
|---|:---:|:---:|---|
| `framebuffer-con1-busid` | Data | `01000000` | 5 |
| `framebuffer-con1-busid` | Data | `02000000` | 5, 1 |
| `framebuffer-con1-busid` | Data | `04000000` | 5, 1, 2 |
| `framebuffer-con1-busid` | Data | `06000000` | 5, 1, 2, 4 |

*(Note: If assigning BusID `04` to `con1`, temporarily change `con2` to `05` to avoid conflicting BusIDs).*

---

### If case 3 occurs
Modify the connector flags for the connector(s):

| Key | Type | Value | Notes |
|---|:---:|:---:|---|
| `framebuffer-con1-flags` | Data | `C7030000` | Recommended for HDMI / DVI handshakes |
| `framebuffer-con2-flags` | Data | `C7030000` | Recommended for HDMI / DVI handshakes |

Save your `config.plist`, reboot from the USB flash drive, and test the handshake.

---

### If case 4 occurs
Congratulations. Continue with step 7.

---

## 7. Final Steps

Once you've found a framebuffer patch you are happy with:

- Open the `config.plist` on your USB flash drive with ProperTree.
- Copy the dictionary `PciRoot(0x0)/Pci(0x2,0x0)` to your clipboard (<kbd>CMD</kbd>+<kbd>C</kbd>).
- Mount your internal drive's EFI partition.
- Open your internal drive's `config.plist` with ProperTree.
- Go to `DeviceProperties/Add`.
- Delete the old `PciRoot(0x0)/Pci(0x2,0x0)` entry.
- Press <kbd>CMD</kbd>+<kbd>V</kbd> to paste the new tested patch.
- Save your `config.plist`.
- In BIOS, change the boot order so that the internal disk takes the first slot again.
- Save, exit BIOS, and boot macOS directly from your internal drive.

> [!NOTE]
>
> - You don't need to inject a property for a **`con`** if the parameter matches the driver default for that framebuffer!
> - Look into the Intel HD FAQs for better suited framebuffers. For UHD 620 laptops, for example, `0x3EA50004` is often better suited than `0x3E9B0000` because it already uses `C7030000` flags by default.

---

## Credits and further resources
- [General Framebuffer Patching Guide](https://www.tonymacx86.com/threads/guide-general-framebuffer-patching-guide-hdmi-black-screen-problem.269149/) by CaseySJ
- AppleIntelFramebufferAzul.kext ([Part 1](https://pikeralpha.wordpress.com/2013/06/27/appleintelframebufferazul-kext/) and [Part 2](https://pikeralpha.wordpress.com/2013/08/02/appleintelframebufferazul-kext-part-ii/)) by Pike R. Alpha 
- [Patching connectors](https://dortania.github.io/OpenCore-Post-Install/gpu-patching/intel-patching/connector.html#patching-connector-types) and [Bus IDs](https://dortania.github.io/OpenCore-Post-Install/gpu-patching/intel-patching/busid.html#patching-bus-ids) by Dortania
- [Hackintool](https://github.com/headkaze/Hackintool/releases) by headkaze
- Special thanks to **deeveedee** from the InsanelyMac forums for the help!
