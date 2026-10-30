# Intel iGPU Framebuffer Patching for External Displays (Laptop)

<details>
<summary><strong>TABLE OF CONTENTS</strong> (click to reveal)</summary><br>

- [About](#about)
	- [Problem Description](#problem-description)
	- [Possible Causes](#possible-causes)
	- [Solution](#solution)
	- [Supported Connection Types](#supported-connection-types)
	- [Workflow Overview](#workflow-overview)
- [1. Preparations](#1-preparations)
	- [Create a Bootable USB Flash Drive](#create-a-bootable-usb-flash-drive)
	- [Required Tools and Resources](#required-tools-and-resources)
- [2. Test Your Current Configuration](#2-test-your-current-configuration)
- [3. Verify / Adjust AAPL,ig-platform-id](#3-verify--adjust-aaplig-platform-id)
- [4. Understanding Framebuffer Parameters](#4-understanding-framebuffer-parameters)
	- [Connector Table Parameters](#connector-table-parameters)
	- [The framebuffer-conX-alldata Property](#the-framebuffer-conx-alldata-property)
	- [The framebuffer-unifiedmem Property](#the-framebuffer-unifiedmem-property)
- [5. Adding Connectors](#5-adding-connectors)
	- [Manual Method](#manual-method)
		- [Gather Data for Your Framebuffer (Example 1)](#gather-data-for-your-framebuffer-example-1)
		- [Gather Data for Your Framebuffer (Example 2)](#gather-data-for-your-framebuffer-example-2)
		- [Gather Data for Your Framebuffer (Example 3)](#gather-data-for-your-framebuffer-example-3)
		- [Translating the Data into DeviceProperties](#translating-the-data-into-deviceproperties)
	- [Semi-Automated Method Using Hackintool](#semi-automated-method-using-hackintool)
		- [Generating a Framebuffer Patch with Hackintool](#generating-a-framebuffer-patch-with-hackintool)
		- [Optional Properties](#optional-properties)
- [6. Testing and Modifying the Framebuffer Patch](#6-testing-and-modifying-the-framebuffer-patch)
	- [If Case 1 Occurs](#if-case-1-occurs)
	- [If Case 2 Occurs](#if-case-2-occurs)
	- [If Case 3 Occurs](#if-case-3-occurs)
	- [If Case 4 Occurs](#if-case-4-occurs)
- [7. Final Steps](#7-final-steps)
- [Credits and Further Resources](#credits-and-further-resources)

</details>

---

## About
This guide explains how to configure `DeviceProperties` for Intel iGPU display connectors so that a secondary display works properly via the **HDMI** or **DisplayPort (DP)** output of your laptop.

### Problem Description
Your laptop boots into macOS and the internal screen works, but:
1. Connecting an external display produces no signal (display does not turn on), or
2. The handshake between macOS and both displays takes an excessively long time, causing displays to cycle on and off multiple times before stabilizing.

> [!NOTE]
> If you get no display at all on the internal screen, consult a guide on using a [fake ig-platform-id](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/iGPU/Framebuffer_Patching/Fake_IG-Platform-ID.md) to force [VESA mode](https://wiki.osdev.org/VESA_Video_Modes). For desktop systems, refer to CaseySJ's [General Framebuffer Patching Guide](https://www.tonymacx86.com/threads/guide-general-framebuffer-patching-guide-hdmi-black-screen-problem.269149/).

### Possible Causes
- Using an incorrect or suboptimal `AAPL,ig-platform-id` for your iGPU.
- Misconfigured connector patches with incorrect `BusID`, mismatched connector `Type`, or wrong `Flags`.
- Conflicts caused by Apple Graphics Device Control (AGDC).

### Solution
- Adjust the framebuffer connector patches and flags for your specific iGPU platform.

### Supported Connection Types
- **HDMI** &rarr; **HDMI**
- **DP** &rarr; **DP** (DisplayPort)
- **HDMI** &rarr; **DVI**
- **DP** &rarr; **DVI**
- **VGA** (Skylake and newer only; requires disabling AGDC via `disable-agdc`)

> [!NOTE]
> - Although this guide uses the **Intel UHD 620** as a primary walkthrough example, the underlying logic applies to any Intel iGPU supported by macOS.
> - When using passive adapter cables (e.g., DP to HDMI or DP to DVI), macOS must usually be configured to treat the port type as **HDMI (`00080000`)**.

### Workflow Overview
1. Copy your working EFI to a FAT32-formatted USB flash drive and boot from it.
2. Identify your iGPU and determine the recommended `AAPL,ig-platform-id`.
3. Test your baseline configuration with the external display connected.
4. Add default connector patches for external ports.
5. If the monitor is not detected, cycle through valid `BusID` combinations.
6. Once detected, adjust connector `Flags` to optimize the handshake speed.
7. Transfer the finalized patch into the `config.plist` on your primary drive.

---

## 1. Preparations

### Create a Bootable USB Flash Drive
1. Mount your internal system's EFI partition.
2. Copy the entire `EFI` folder to the root of a FAT32-formatted USB flash drive.
3. Unmount the internal EFI partition. **From this point forward, edit only the `config.plist` on the USB flash drive.**
4. Reboot your system and set the USB flash drive as the first boot priority in your BIOS/UEFI settings.

*Why this matters:* Testing framebuffer configurations often requires multiple reboots. Editing the USB drive keeps your main installation safe and eliminates the need to mount the internal EFI partition each time.

### Required Tools and Resources
- **FAT32-formatted USB flash drive**
- **External display and appropriate video cable(s)**
- **Lilu.kext** and **WhateverGreen.kext** (properly injected in OpenCore)
- [**ProperTree**](https://github.com/corpnewt/ProperTree) — plist editor
- [**Hackintool**](https://github.com/headkaze/Hackintool/releases) — for inspecting connectors and generating patches
- [**Intel ARK**](https://ark.intel.com/) — for CPU and iGPU technical specifications
- [**Dortania OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/) — for baseline platform IDs
- [**WhateverGreen Intel HD FAQ**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md) — canonical list of framebuffers, flags, and device IDs
- [**Big-Endian to Little-Endian Converter**](https://www.save-editor.com/tools/wse_hex.html) — for byte swaps
- *(Optional)* [**OCToolbox**](https://github.com/webfalter/OCToolBox) — includes calculators for framebuffer and connector flags

---

## 2. Test Your Current Configuration

Before modifying your configuration, establish your baseline. Connect your external display, boot into macOS, open **Hackintool**, and navigate to **Patch &rarr; Connectors**.

| Ext. Display Turns On? | Detected in Hackintool? | Immediate Action |
|:----------------------:|:-----------------------:|:-----------------|
| **No** | **No** | 1. [Verify/adjust `AAPL,ig-platform-id`](#3-verify--adjust-aaplig-platform-id)<br>2. [Add connectors to framebuffer patch](#5-adding-connectors)<br>3. [Cycle BusIDs](#if-case-1-occurs) for `con1` and `con2` |
| **No** | **Yes** (Index turns red) | [Adjust connector flags](#if-case-3-occurs) for that connector index |

When an external monitor is detected by macOS, the corresponding connector row turns **red** in Hackintool:

![Hackintool detected display](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/f671908c-ae2f-4241-a782-f35ccaa6c918)

If the display turns on:

| Handshake Speed | Symptoms | Action |
|:---------------:|:---------|:-------|
| **Slow** | Mouse cursor lags, displays cycle on/off $>3$ times, or black screen lasts $>10$ seconds before picture displays | [Modify connector flags](#if-case-3-occurs) for the active connector index. |
| **Fast** | Display appears immediately and smoothly | No further patching needed! |

---

## 3. Verify / Adjust `AAPL,ig-platform-id`

1. Identify your exact CPU model. In Terminal:
   ```bash
   sysctl machdep.cpu.brand_string
   ```
2. Look up the processor on [Intel ARK](https://ark.intel.com/) to find its microarchitecture (e.g., Kaby Lake, Whiskey Lake, Comet Lake) and exact iGPU model (e.g., UHD Graphics 620).
3. Check the recommended `AAPL,ig-platform-id` and spoofing requirements (`device-id`) from the [WhateverGreen Intel HD FAQ](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md) and [Dortania Guide](https://dortania.github.io/OpenCore-Install-Guide/).
4. Remember that WhateverGreen documentation lists values in **Big-Endian** (human-readable), but OpenCore `config.plist` files require **Little-Endian** byte order:
   - *Example:* Big-Endian `0x3EA50009` $\rightarrow$ Little-Endian hex data `<09 00 A5 3E>`.
5. Open your USB's `config.plist` in ProperTree under `Root -> DeviceProperties -> Add -> PciRoot(0x0)/Pci(0x2,0x0)`.
6. If existing connector patches are unstable, rename `#PciRoot(0x0)/Pci(0x2,0x0)` to back it up and define a clean `PciRoot(0x0)/Pci(0x2,0x0)` block with only the verified platform ID, `framebuffer-patch-enable = <01 00 00 00>`, and any required backlight register fixes.
7. Save and reboot from the USB flash drive. Ensure the internal screen works reliably before moving on.

---

## 4. Understanding Framebuffer Parameters

### Connector Table Parameters

In macOS, framebuffer connectors are represented by software definitions (`con0`, `con1`, `con2`, etc.) that map to physical outputs on your motherboard.

| Parameter | Type | Description |
|:---------:|:----:|:------------|
| **Index** | Integer | Physical port index in the driver. `-1` (`FFFFFFFF`) disables the connector or indicates a headless compute-only port. Typically, `Index 0` is reserved for the internal laptop screen (`eDP` / `LVDS`), while `Index 1` (`con1`) and `Index 2` (`con2`) represent external ports. |
| **BusID** | Hex Data | The bus pathway used by the GPU to route signals to physical ports. **Every connector must have a unique BusID.**<br>• For **DisplayPort**: `0x02`, `0x04`, `0x05`, or `0x06`<br>• For **HDMI / DVI**: `0x01`, `0x02`, `0x04`, or `0x06`<br>• Internal (`con0`): almost always `0x00` |
| **Pipe** | Hex Data | Hardware pipeline converting raw graphics data into display signals (scaling, timing, color correction). Usually fixed per framebuffer (e.g., `8`, `9`, `10` or `18`, `19`, `1A`). |
| **Type** | Hex Data | The physical connector protocol:<br>• **DisplayPort (DP)**: `00040000`<br>• **HDMI**: `00080000`<br>• **DVI**: `00800000`<br>• **LVDS / eDP (Internal)**: `02000000`<br>*(Note: For DP-to-HDMI adapters, always specify `00080000`)* |
| **Flags** | Hex Data | Bitmask controlling driver features (hot-plug detect, audio, DP multi-stream, blit translation). The recommended generic modern flag value is **`C7030000`** (`0x000003C7`). |

### The `framebuffer-conX-alldata` Property
Instead of specifying index, busid, pipe, type, and flags individually for each connector, you can inject a single continuous byte sequence using `framebuffer-conX-alldata`. 
- Each connector definition occupies **12 bytes** (or **24 bytes** on Ice Lake platforms).
- OpenCore applies the sequence sequentially starting from connector `X`.

*Example (Intel HD 4000, Platform `0x01660004`):*
```text
02050000 00040000 07040000 03040000 00040000 81000000 04060000 00040000 81000000
```
This single entry writes connector values for `con1`, `con2`, and `con3` in one go.

### The `framebuffer-unifiedmem` Property
Allocates additional host RAM to the iGPU as shared VRAM. While WhateverGreen's defaults (1536 MB) are usually sufficient, allocating 2048 MB can resolve UI glitches in browsers or secondary 4K displays:

| Hex Value (`Data`) | Allocated VRAM |
|:------------------:|:--------------:|
| `00000040` | 1024 MB |
| `00000060` | 1536 MB (Default) |
| `00000080` | 2048 MB |
| `000000A0` | 2560 MB |
| `000000C0` | 3072 MB |
| `000000E0` | 3584 MB |
| `FFFFFFFF` | 4096 MB |

> [!IMPORTANT]
> - Do not use `framebuffer-stolenmem` and `framebuffer-unifiedmem` at the same time. If using `unifiedmem`, remove `stolenmem`.
> - Never set unified memory to an amount greater than physical RAM.

---

## 5. Adding Connectors

<details>
<summary><strong>Manual Method</strong> (click to reveal)</summary>

### Manual Method

#### Gather Data for Your Framebuffer (Example 1)
Using Dortania's default recommendation for Intel UHD 620: `AAPL,ig-platform-id` = `00009B3E` (Big-Endian `0x3E9B0000`).

From the WhateverGreen Intel FAQ:
```text
ID: 3E9B0000, STOLEN: 57 MB, FBMEM: 0 bytes, VRAM: 1536 MB, Flags: 0x0000130B
[0] busId: 0x00, pipe: 8,  type: 0x00000002, flags: 0x00000098 - ConnectorLVDS
[1] busId: 0x05, pipe: 9,  type: 0x00000400, flags: 0x00000187 - ConnectorDP
[2] busId: 0x04, pipe: 10, type: 0x00000400, flags: 0x00000187 - ConnectorDP

Raw Bytes:
00000800 02000000 98000000
01050900 00040000 87010000
02040A00 00040000 87010000
```

<details>
<summary><strong>More Reference Examples</strong></summary>

#### Gather Data for Your Framebuffer (Example 2)
Framebuffer `0x3EA50009`:
```text
ID: 3EA50009, STOLEN: 57 MB, FBMEM: 0 bytes, VRAM: 1536 MB, Flags: 0x00830B0A
[0] busId: 0x00, pipe: 8,  type: 0x00000002, flags: 0x00000098 - ConnectorLVDS
[1] busId: 0x05, pipe: 9,  type: 0x00000400, flags: 0x000001C7 - ConnectorDP
[2] busId: 0x04, pipe: 10, type: 0x00000400, flags: 0x000001C7 - ConnectorDP

Raw Bytes:
00000800 02000000 98000000
01050900 00040000 C7010000
02040A00 00040000 C7010000
```

#### Gather Data for Your Framebuffer (Example 3)
Framebuffer `0x3EA50004` (often superior for Coffee/Whiskey Lake because it uses `0x000003C7` flags natively):
```text
ID: 3EA50004, STOLEN: 57 MB, FBMEM: 0 bytes, VRAM: 1536 MB, Flags: 0x00E30B0A
[0] busId: 0x00, pipe: 8,  type: 0x00000002, flags: 0x00000498 - ConnectorLVDS
[1] busId: 0x05, pipe: 9,  type: 0x00000400, flags: 0x000003C7 - ConnectorDP
[2] busId: 0x04, pipe: 10, type: 0x00000400, flags: 0x000003C7 - ConnectorDP

Raw Bytes:
00000800 02000000 98040000
01050900 00040000 C7030000
02040A00 00040000 C7030000
```
</details>

#### Translating the Data into DeviceProperties
Under `Root -> DeviceProperties -> Add -> PciRoot(0x0)/Pci(0x2,0x0)`:

| Property Key | Type | Value | Purpose |
|--------------|:----:|:-----:|:--------|
| `AAPL,ig-platform-id` | Data | `00009B3E` | Platform ID (Little-Endian) |
| `device-id` | Data | `9B3E0000` | Spoofs UHD 620 as UHD 630 (if required) |
| `framebuffer-patch-enable` | Data | `01000000` | Enables WhateverGreen patching |
| `framebuffer-con1-enable` | Data | `01000000` | Enables patching for Connector 1 |
| `framebuffer-con1-index` | Data | `01000000` | Sets con1 to Index 1 |
| `framebuffer-con1-busid` | Data | `05000000` | Default BusID 0x05 for con1 |
| `framebuffer-con1-pipe` | Data | `09000000` | Pipe 9 |
| `framebuffer-con1-type` | Data | `00080000` | Sets connector to HDMI |
| `framebuffer-con1-flags` | Data | `87010000` | Baseline flags for con1 |
| `framebuffer-con2-enable` | Data | `01000000` | Enables patching for Connector 2 |
| `framebuffer-con2-index` | Data | `02000000` | Sets con2 to Index 2 |
| `framebuffer-con2-busid` | Data | `04000000` | Default BusID 0x04 for con2 |
| `framebuffer-con2-pipe` | Data | `0A000000` | Pipe 10 (`0x0A`) |
| `framebuffer-con2-type` | Data | `00080000` | Sets connector to HDMI |
| `framebuffer-con2-flags` | Data | `87010000` | Baseline flags for con2 |
| `framebuffer-con3-enable` | Data | `01000000` | Enables patching for Connector 3 |
| `framebuffer-con3-index` | Data | `FFFFFFFF` | Disables unused dummy con3 |

*(Note: We leave `con0` untouched as it controls the working internal display.)*

</details>

<details>
<summary><strong>Semi-Automated Method Using Hackintool</strong> (click to reveal)</summary>

### Semi-Automated Method Using Hackintool

#### Generating a Framebuffer Patch with Hackintool
1. Launch **Hackintool**.
2. In the top menu bar, go to **Framebuffer** and ensure **macOS 10.14+** is selected.
3. Select **Patch &rarr; Connectors**.
4. Set the **Intel Generation** dropdown to your CPU generation (e.g., Coffee Lake for 8th/9th Gen).
5. Choose your target **Platform ID** (e.g., `0x3E9B0000`).
6. Leave `Index 0` (Internal display) untouched.
7. Change the **Type** column for `Index 1` and `Index 2` to **HDMI** (or DisplayPort if your laptop has a native DP / USB-C DP port).
8. Adjust the **Flags** field for `Index 1` and `Index 2` to `0x000003C7` (`C7030000`).
9. Under **Patch &rarr; General**, verify **Disable eGPU** and **Apply Current Patches** are set appropriately.
10. Under **Patch &rarr; Advanced**, review your stolen memory and unified memory settings.
11. If your laptop routes HDMI 2.0 through an on-board Level Shifter / Protocol Converter (LSPCON), configure the **LSPCON** tab accordingly.
12. Click **Generate Patch** at the bottom right.
13. Select all generated XML in the output box (<kbd>Cmd</kbd>+<kbd>A</kbd>) and copy it (<kbd>Cmd</kbd>+<kbd>C</kbd>).
14. In ProperTree, paste the dictionary under `DeviceProperties -> Add`, then clean up unnecessary items:
    - Remove all `framebuffer-con0-*` entries (internal display works by default).
    - Remove `framebuffer-con3-*` entries unless you specifically need to disable a fourth connector.
    - If setting `framebuffer-unifiedmem`, delete `framebuffer-stolenmem`.

#### Optional Properties
| Key | Type | Value | Notes |
|---|:---:|:---:|---|
| `enable-backlight-registers-fix` | Data | `01000000` | Fixes black screen on wake/boot on Kaby Lake, Coffee Lake, and Ice Lake. |
| `enable-backlight-registers-alternative-fix` | Data | `01000000` | Alternative fix required on macOS 13.4 and newer. |
| `disable-agdc` | Data | `01000000` | Disables Apple Graphics Device Control to prevent black-screen handshakes with spoofed Board-IDs. |

</details>

---

## 6. Testing and Modifying the Framebuffer Patch

Always add `disable-agdc = <01 00 00 00>` if using a spoofed SMBIOS or device-id:

```xml
<key>disable-agdc</key>
<data>AQAAAA==</data>
```

Reboot from your USB flash drive with the monitor plugged in and check Hackintool (**Patch &rarr; Connectors**):

| Case | Ext. Display On? | Red Row in Hackintool? | Handshake | Action |
|:----:|:----------------:|:---------------------:|:---------:|:-------|
| **1** | **No** | **No** | None | Cycle through BusID pairs for `con1` and `con2`. |
| **2** | **No** | **Yes** | None | BusID is correct! [Adjust connector flags](#if-case-3-occurs). |
| **3** | **Yes** | **Yes** | **Slow / Flashing** | [Update flags to `C7030000`](#if-case-3-occurs). |
| **4** | **Yes** | **Yes** | **Fast / Stable** | Success. Move patch to your primary drive! |

---

### If Case 1 Occurs
When Hackintool does not detect the external display on any index, the `BusID` assigned to `con1` or `con2` does not match the physical trace on your laptop's motherboard.

Test the following combinations sequentially. Save your `config.plist` and reboot between each test:

| Test Run | `framebuffer-con1-busid` | `framebuffer-con2-busid` |
|:--------:|:------------------------:|:------------------------:|
| **Default** | `05000000` (Bus 0x05) | `04000000` (Bus 0x04) |
| **Run 1** | `01000000` (Bus 0x01) | `02000000` (Bus 0x02) |
| **Run 2** | `02000000` (Bus 0x02) | `01000000` (Bus 0x01) |
| **Run 3** | `04000000` (Bus 0x04) | `06000000` (Bus 0x06) |
| **Run 4** | `06000000` (Bus 0x06) | `05000000` (Bus 0x05) |

*(Remember: A BusID can only be used by one connector at a time.)*

---

### If Case 2 Occurs
If Hackintool highlights an index in **red**, macOS sees the port on that specific connector index, but the handshake fails to light up the display. Proceed directly to **Case 3** and modify the connector flags for the highlighted connector.

---

### If Case 3 Occurs
If the display turns on slowly or blinks repeatedly, replace the connector flags on both `con1` and `con2` with `C7030000` (`0x000003C7`):

| Property Key | Type | Value |
|---|:---:|:---:|
| `framebuffer-con1-flags` | Data | `C7030000` |
| `framebuffer-con2-flags` | Data | `C7030000` |

Save the `config.plist`, reboot from the USB drive, and test the handshake. The display should now initialize in a single clean switch.

---

### If Case 4 Occurs
Your patch is fully optimized. Proceed to [Final Steps](#7-final-steps).

---

## 7. Final Steps

1. Boot into macOS and open your working USB drive's `config.plist` in ProperTree.
2. Navigate to `Root -> DeviceProperties -> Add` and copy (<kbd>Cmd</kbd>+<kbd>C</kbd>) the `PciRoot(0x0)/Pci(0x2,0x0)` dictionary.
3. Mount the EFI partition of your **internal system drive**.
4. Open the internal disk's `config.plist` in ProperTree.
5. Under `Root -> DeviceProperties -> Add`, remove the old `PciRoot(0x0)/Pci(0x2,0x0)` dictionary and paste (<kbd>Cmd</kbd>+<kbd>V</kbd>) the tested version.
6. Save the file and safely unmount both the internal EFI and the USB flash drive.
7. Reboot into your BIOS/UEFI setup and restore your internal storage drive as the primary boot device.
8. Boot into macOS normally from the internal drive.

---

## Credits and Further Resources
- [WhateverGreen Intel HD FAQ](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md) by Acidanthera
- [Dortania OpenCore Post-Install: GPU Patching](https://dortania.github.io/OpenCore-Post-Install/gpu-patching/intel-patching/)
- [General Framebuffer Patching Guide](https://www.tonymacx86.com/threads/guide-general-framebuffer-patching-guide-hdmi-black-screen-problem.269149/) by CaseySJ
- [Hackintool](https://github.com/headkaze/Hackintool) by headkaze
- Special thanks to **deeveedee** from the InsanelyMac community.
