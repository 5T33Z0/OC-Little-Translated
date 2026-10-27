# Intel Display Pipeline Fundamentals for macOS – Bridging the gap between Intel hardware datasheets and WhateverGreen patches

## Technical Background

The image below illustrates the core Processor Display Architecture design of Intel iGPUs. This diagram is the foundation for understanding how macOS (via WhateverGreen and Lilu) maps internal data streams to physical hardware ports.

![](https://pikeralpha.files.wordpress.com/2013/08/processor-display-architecture.png)

**SOURCE**: [Processor Display Architecture](https://pikeralpha.wordpress.com/2013/08/02/appleintelframebufferazul-kext-part-ii/) by PikerAlpha

The architecture defines the relationship between internal data streams and physical outputs. For a typical "Legacy" Intel configuration (Gen 4 through Gen 9), the system utilizes three pipes, three framebuffers, and three DDI ports. According to the Intel datasheet:

> “The DDI (Digital Display Interface) ports B, C, and D on the processor can be configured to support DP/eDP/HDMI and DVI. For desktop designs, DDI port D can be configured as eDPx4 (4 lanes) in addition to a dedicated x2 (2 lanes) port for Intel FDI (Flexible Display Interface) for (analog) VGA.” *(Note: VGA is no longer supported by macOS).*

### Core Architectural Takeaways:

* **Fixed "Indexes" (0–3):** In macOS, these are typically hard-coded to ports `05`, `06`, and `07`. While we cannot change these hardware mappings, tools like **Hackintool** use them to detect connectivity (green for internal, red for external).
* **Pipes:** These are the internal engines that process the visual data. Which pipe is used for a specific display is defined within the selected framebuffer.
* **BusIDs:** These are the "addresses" used to transport graphics data to the physical **Connectors** on the motherboard. Finding the correct BusID for a specific physical port is the most critical step in patching.
* **Connector Types:** Each physical port (HDMI, DisplayPort, etc.) must be declared with its correct type and specific "flags" (e.g., `<00 08 00 00>` for HDMI) so the macOS drivers initialize the signal correctly.

---

## Modern Nuances & Hardware Evolution

While the basic architecture has remained similar for years, Intel’s transition through newer CPU families has introduced specific challenges for the macOS environment.

### 1. The Ice Lake (Gen 11) Shift

With the arrival of **10th Gen Ice Lake (ICL)** processors, Intel introduced the Gen 11 graphics architecture. This was the final Intel generation natively supported by Apple.

* **Expansion:** Ice Lake iGPUs expanded support to **4 display pipes** and **4 DDIs** (A, B, C, and D).
* **Patching Tip:** When working with these chips, you must use the `ICLLP` (Ice Lake Low Power) framebuffer variants. These often require more complex mapping for laptops utilizing USB-C/Thunderbolt "Alt Mode" for display output.

### 2. The LSPCON "Bridge" (HDMI 2.0)

Most Intel iGPUs prior to the 11th Gen do not natively support HDMI 2.0 (4K @ 60Hz). To get around this, many motherboard manufacturers use an **LSPCON** (Level Shifter / Protocol Converter) chip to convert a DisplayPort signal into HDMI 2.0.

* **The Problem:** macOS often fails to recognize this converter, leading to a black screen.
* **The Fix:** You must "instruct" macOS to communicate with the chip by adding the `framebuffer-conX-has-lspcon` and `framebuffer-conX-preferred-lspcon-mode` properties to your configuration.

### 3. The "Pipe 12" (`0x12`) Reboot Fix

A common issue on 8th and 9th Gen laptops occurs when plugging in an external display: the system immediately reboots or freezes. 
*   **The Cause:** This is often a conflict in how the "Pipe" is assigned to a specific connector in the default macOS framebuffer.
*   **The Fix:** Changing the pipe value to `12` (Hex: `0C`) for the problematic connector often resolves these power-state/switching crashes.

### 4. The "Xe" Architecture Hard Wall (11th Gen and Newer)
It is vital to distinguish between the 10th Gen **Comet Lake** (supported) and 10th Gen **Ice Lake** (supported) versus the **11th Gen Tiger Lake** and newer.
*   **The Cut-off:** Starting with 11th Gen, Intel moved to the **Iris Xe (Gen 12)** architecture. 
*   **The macOS Reality:** Because Apple transitioned to their own "M-series" Silicon, they never wrote drivers for Intel Xe graphics. Consequently, **11th, 12th, 13th, and 14th Gen Intel iGPUs will not work with hardware acceleration in macOS.** They will be stuck in VESA mode (extremely slow, no transparency, no video scaling), making them unsuitable for Hackintosh use.

---

## Summary for Patching
To successfully patch a framebuffer, you are essentially translating the **Intel Physical Architecture** (Pipes and DDIs) into **macOS Logic** (Indexes and BusIDs). By matching the correct BusID to the physical port on your motherboard and ensuring the "Connector Type" matches the cable you are using, you bridge the gap between generic hardware and a functional Mac.
