# Disabling Lenovo `DYTC` Lapmode (Cool-on-Lap) Throttling

**TABLE of CONTENTS**

- [1. About \& Context](#1-about--context)
  - [The Problem](#the-problem)
  - [Lapmode vs. BD-PROCHOT](#lapmode-vs-bd-prochot)
  - [Note on Lenovo's "Official" Fix for Linux](#note-on-lenovos-official-fix-for-linux)
- [2. How the Fix Works](#2-how-the-fix-works)
  - [The Three Pillars](#the-three-pillars)
  - [The ACPI Lapmode Implementation](#the-acpi-lapmode-implementation)
- [3. ACPI Patch (OpenCore)](#3-acpi-patch-opencore)
  - [OpenCore `config.plist -> ACPI -> Patch`](#opencore-configplist---acpi---patch)
    - [XML Snippet](#xml-snippet)
- [4. SSDT Template: `SSDT-NO-LAP.dsl`](#4-ssdt-template-ssdt-no-lapdsl)
- [5. Installation](#5-installation)
- [6. Verification](#6-verification)
  - [In macOS](#in-macos)
  - [In Linux](#in-linux)
- [7. Conclusion](#7-conclusion)
- [8. Notes](#8-notes)
- [9. Resources](#9-resources)
  - [Research \& References](#research--references)
  - [Upstream Driver Code \& Specifications](#upstream-driver-code--specifications)
  - [macOS ThinkPad Integration](#macos-thinkpad-integration)

---


## 1. About & Context

Modern Lenovo ThinkPads (primarily 8th to 11th Gen Intel Core series, including T480/T490/T14 Gen 1, X1 Carbon Gen 6–9, and P-series laptops) implement proprietary thermal management known as **DYTC (Dynamic Thermal Control)** within the Embedded Controller ACPI device (`\_SB.PCI0.LPCB.EC.HKEY`).

To comply with safety standards for skin contact temperatures, these machines incorporate an accelerometer / motion sensor to detect whether the laptop is sitting on a flat surface or resting on a user's lap. This subsystem is called Cool and Quiet on Lap (CQL), commonly referred to in the community as Cool-on-Lap or **Lapmode**.

### The Problem
* When motion or tilt is detected, the EC sets **Bit 17** (`DYTC_GET_LAPMODE_BIT` = `0x00020000`) in its status output.
* In **Linux**, the kernel driver `thinkpad_acpi` reads this bit and exposes `/sys/devices/platform/thinkpad_acpi/dytc_lapmode = 1`. User-space daemons (`power-profiles-daemon`, `systemd`) immediately throttle the CPU Package Power Limit (PL1) down to **11W–15W**, severely degrading performance even when temperatures are low.
* In **Windows**, the Lenovo Intelligent Cooling driver throttles the machine identically.
* In **macOS**, the operating system does not have a native DYTC driver and therefore does not enforce motion throttling. However, because OpenCore patches ACPI globally, injecting this SSDT prevents lapmode throttling when dual-booting Linux or Windows without interfering with macOS power management (`X86PlatformPlugin`) or profile switchers (`ReYogaSMC`).

### Lapmode vs. BD-PROCHOT
It is critical not to confuse **DYTC Lapmode** with the infamous ThinkPad **BD-PROCHOT** bug – a common point of confusion in the community (e.g., [Issue #44 on my T490 OpenCore EFI Repo](https://github.com/5T33Z0/Thinkpad-T490-Hackintosh-OpenCore/issues/44)). While both cause severe performance drops, they operate on completely different hardware layers and require separate fixes:

1. **DYTC Lapmode (ACPI / Firmware Level):**  
   An artificial power ceiling triggered by motion. The Embedded Controller (EC) reads the accelerometer and caps the CPU Package Power Limit (PL1) to **~11W–15W** to keep skin-contact temperatures low. The CPU can still ramp up clocks briefly, but it instantly throttles once it hits this aggressive power wall.  
   * **Solution:** The **DSDT rename + SSDT wrapper** documented in this guide.

2. **BD-PROCHOT (MSR / Hardware Level):**  
   Bi-Directional Processor Hot. A hardware flag asserted via MSR `0x1FC`—often misfired by the EC after sleep/wake cycles, under GPU load, or when using certain USB-C chargers. It hard-locks the CPU multiplier down to **400 MHz – 800 MHz** regardless of actual temperatures.  
   * **Solution:** Cleared during UEFI boot via `DisableProchot.efi` and re-applied after macOS sleep via `SimpleMSR.kext`.

These two fixes do not replace one another; they **complement** each other. `DisableProchot.efi` and `SimpleMSR.kext` ensure the CPU never gets clamped to 800 MHz, while this SSDT ensures your sustained boost targets (25W+) remain intact when the laptop is moved, tilted, or used off-desk.

### Note on Lenovo's "Official" Fix for Linux
Lenovo published [documentation](https://web.archive.org/web/20190926163900if_/https://forums.lenovo.com/lnv/attachments/lnv/Special_Interest_Linux/13642/1/Linux%20Thermal%20throttling.pdf) stating that Linux throttling was resolved in 2020. That update resolved a bug where ThinkPads booted permanently stuck in Lapmode. However, Lenovo retained dynamic motion throttling as an intentional compliance feature: picking up or moving the machine still demotes power profiles and caps TDP for 5–30 minutes. This SSDT eliminates that behavior entirely.

---

> [!WARNING]
> ### Safety & Thermal Disclaimer
>
> Lenovo's **Cool-on-Lap (CQL)** mechanism is an intentional safety feature designed to comply with international consumer electronics standards (**IEC/UL 62368-1**) governing skin-contact temperatures on portable devices.
>
> By applying this fix and disabling Lapmode, you acknowledge the following:
>
> 1. **Chassis Surface Temperatures Will Increase:**  
>    Because the machine will no longer throttle its CPU power limit (PL1) when it detects motion or tilt, the bottom plate and exhaust vents can become significantly hotter under sustained workloads (often reaching **45°C–55°C / 113°F–131°F**).
>
> 2. **Avoid Prolonged Bare-Skin Contact:**  
>    Do **not** place the laptop directly on bare skin or rest it on your lap for extended periods while running heavy computational loads (e.g., compilation, rendering, or gaming). Sustained contact with surfaces above 45°C can cause discomfort or minor low-temperature skin burns (*erythema ab igne*).
>
> 3. **Silicon Protection Remains Active:**  
>    This modification **does not** disable internal CPU thermal limits. Intel's built-in digital thermal sensors, TJMax thresholds (~95°C–100°C), and critical hardware `PROCHOT` shutdown routines remain fully functional. The processor will continue to protect itself against dangerous silicon temperatures.
>
> **You apply this modification entirely at your own risk. The author(s) assume no liability for personal discomfort, skin injury, or device degradation resulting from operating the hardware beyond factory thermal contact thresholds.**

---

## 2. How the Fix Works

To fully resolve Lenovo's multi-layered throttling bottlenecks, we must address three distinct hardware and software layers: disable the hardware `BD-PROCHOT` lock at boot, re-apply MSR power limits and flags after sleep, and neutralize the motion-triggered Cool-on-Lap (CQL) sensor at the ACPI level.

### The Three Pillars

| Component | Layer | Target OS | What it does |
| :--- | :--- | :--- | :--- |
| **1. `DisableProchot.efi`** | **UEFI Boot** | All OSes | Clears the `BD-PROCHOT` bit at the earliest possible stage to prevent the machine from booting with the CPU locked at **400 MHz – 800 MHz**. |
| **2. `SSDT-NO-LAP` + Rename** | **ACPI Firmware** | All OSes (primarily Linux & Windows) | Permanently blinds the OS to the accelerometer, preventing the 5–30 minute **11W–15W TDP cap** when picking up, tilting, or using the laptop off-desk. |
| **3. `SimpleMSR.kext`** | **macOS Kernel** | macOS | **1.** Re-clears `BD-PROCHOT` after S3 sleep/wake cycles.<br> **2.** Writes custom sustained power targets (PL1/PL2 to MSR `0x610`) so macOS can draw 25W–35W instead of defaulting to low wattage. |

### The ACPI Lapmode Implementation

While `DisableProchot.efi` and `SimpleMSR.kext` manage the CPU registers, **`SSDT-NO-LAP`** neutralizes the accelerometer-induced TDP wall at the firmware level through a three-stage ACPI approach:

1. **DSDT Rename:** The factory ACPI method `DYTC` in the DSDT is renamed to `XYTC` via OpenCore, freeing up the namespace for an override without triggering collisions.
2. **SSDT Query Mask:** The replacement `DYTC` method intercepts status queries (`DYTC_CMD_GET` = `0x02`) and masks out Bit 17 (`Local0 &= ~0x00020000`). The operating system is permanently told that the machine is resting on a desk (`0`).
3. **Firmware Reset at Boot:** A dedicated initialization device (`DLAP`) executes `XYTC (0x000F1001)` on boot, setting the EC's internal `VCQL` (Valid Cool-on-Lap) flag to `0` and instructing the firmware state machine to deactivate autonomous CQL throttling.

> [!NOTE]
> **YogaSMC / ReYogaSMC Compatibility:**  
> Setting performance profiles (Quiet, Balanced, Performance) in macOS via `ReYogaSMC.kext` or `YogaSMC.kext` uses command codes other than `0x02`. These commands pass through completely unmodified to the original `XYTC` method. This patch is **100% compatible** with ReYogaSMC.

---

## 3. ACPI Patch (OpenCore)

The factory DSDT method `DYTC` must be renamed to `XYTC` so that our SSDT can wrap it without triggering an `AE_ALREADY_EXISTS` collision.

### OpenCore `config.plist -> ACPI -> Patch`

| Key | Type | Value (ASCII) | Value (HEX / Base64) |
| :--- | :--- | :--- | :--- |
| **Comment** | String | `DYTC to XYTC Rename` | — |
| **Enabled** | Boolean | `True` | — |
| **Count** | Integer | `0` | — |
| **Limit** | Integer | `0` | — |
| **Skip** | Integer | `0` | — |
| **TableSignature** | Data | `DSDT` | `44534454` (`RFNEVA==`) |
| **Find** | Data | `DYTC` | `44595443` (`RFlUQw==`) |
| **Replace** | Data | `XYTC` | `58595443` (`WFlUQw==`) |

#### XML Snippet

Alternatively, you can copy/paste the patch below directly into the `ACPI -> Patch` array in ProperTree:

<details>
<summary>Click to view XML code</summary>

```xml
<dict>
    <key>Base</key>
    <string></string>
    <key>BaseSkip</key>
    <integer>0</integer>
    <key>Comment</key>
    <string>DYTC to XYTC Rename</string>
    <key>Count</key>
    <integer>0</integer>
    <key>Enabled</key>
    <true/>
    <key>Find</key>
    <data>RFlUQw==</data>
    <key>Limit</key>
    <integer>0</integer>
    <key>Mask</key>
    <data></data>
    <key>OemTableId</key>
    <data></data>
    <key>Replace</key>
    <data>WFlUQw==</data>
    <key>ReplaceMask</key>
    <data></data>
    <key>Skip</key>
    <integer>0</integer>
    <key>TableLength</key>
    <integer>0</integer>
    <key>TableSignature</key>
    <data>RFNEVA==</data>
</dict>
```
</details>

---

## 4. SSDT Template: `SSDT-NO-LAP.dsl`

Save and compile the following DSL code to `SSDT-NO-LAP.aml` using **MaciASL**:

```asl
/*
 * Disables Cool-on-Lap (CQL) / Lapmode throttling on Lenovo ThinkPads
 * Requires DSDT rename: DYTC -> XYTC
 *
 * NOTE: 
 * Verify the ACPI path to 'HKEY' in your original DSDT (search for "Device (HKEY)" or "Method (DYTC").
 * Common path variations:
 * - \_SB.PCI0.LPCB.EC.HKEY  (Standard Intel 8th-10th Gen: T480, T490, X1C6-8, etc.)
 * - \_SB.PC00.LPCB.EC.HKEY  (Intel 11th Gen+: T14 Gen 2, etc. using PC00 root bridge)
 * - \_SB.PCI0.LPCB.HKEY     (Some models where HKEY is located directly under LPCB)
 * - \_SB.PCI0.LPC0.EC0.HKEY (Alternative controller naming)
 *
 * If your path differs, adjust all references below accordingly before compiling!
 */

DefinitionBlock ("", "SSDT", 2, "OCLT", "NO-LAP", 0x00001000)
{
    // External references - adjust path if your system differs
    External (\_SB.PCI0.LPCB.EC.HKEY, DeviceObj)
    External (\_SB.PCI0.LPCB.EC.HKEY.XYTC, MethodObj)

    Scope (\_SB.PCI0.LPCB.EC.HKEY)
    {
        // Replacement DYTC method wrapper
        Method (DYTC, 1, Serialized)
        {
            // Call original renamed method
            Local0 = \_SB.PCI0.LPCB.EC.HKEY.XYTC (Arg0)

            // Check if query command: DYTC_CMD_GET (0x0002)
            Local1 = (Arg0 & 0x01FF)

            If (Local1 == 0x02)
            {
                // Mask out Bit 17 (DYTC_GET_LAPMODE_BIT = 0x00020000)
                // Ensures lapmode always reports 0 (desk mode) to the OS
                Local0 &= ~0x00020000
            }

            Return (Local0)
        }
    }

    // Dedicated initialization device to execute EC CQL reset at boot
    // Avoids colliding with HKEY's existing _INI method
    Scope (\_SB)
    {
        Device (DLAP)
        {
            Name (_HID, "DLAP0000")

            Method (_STA, 0, NotSerialized)
            {
                Return (0x0F) // Present, Enabled, Functioning, Show in UI
            }

            Method (_INI, 0, NotSerialized)
            {
                If (CondRefOf (\_SB.PCI0.LPCB.EC.HKEY.XYTC))
                {
                    // Command 0x000F1001: Set CQL Valid Flag (VCQL) to 0 in EC
                    \_SB.PCI0.LPCB.EC.HKEY.XYTC (0x000F1001)
                }
            }
        }
    }
}
```

---

## 5. Installation

1. Open `SSDT-NO-LAP.dsl` in **MaciASL**.
2. Click **File > Save As…**, select **ACPI Machine Language Binary (.aml)**, and save it as `SSDT-NO-LAP.aml`.
3. Copy `SSDT-NO-LAP.aml` to your `EFI/OC/ACPI/` directory.
4. Open your `config.plist` with **ProperTree**.
5. Add the table entry to `ACPI -> Add` (or run **OC Snapshot** via `Cmd + R` to add it automatically):
   ```xml
   <dict>
       <key>Comment</key>
       <string>Disable Lenovo DYTC Lapmode Throttling</string>
       <key>Enabled</key>
       <true/>
       <key>Path</key>
       <string>SSDT-NO-LAP.aml</string>
   </dict>
   ```
6. Add the `DYTC` to `XYTC` rename patch under `ACPI -> Patch`.
7. Save the `config.plist`, restart, and reset NVRAM once.

---

## 6. Verification

### In macOS
Open Terminal and run:
```bash
ioreg -p IODeviceTree -n DLAP
```
* **Result:** You should see `DLAP@0` with class `IOACPIPlatformDevice` and state `registered, matched`. This confirms that the table loaded cleanly and the boot initialization method ran.

### In Linux
Open a terminal and run:
```bash
watch -n 0.5 cat /sys/devices/platform/thinkpad_acpi/dytc_lapmode
```
* **Test:** Pick up the laptop, tilt it, and shake it gently.
* **Result:** The value should remain permanently at `0`. CPU package power (PL1) will not drop when running load tests (`s-tui` / `stress`).

---

## 7. Conclusion

For optimal performance on 8th–10th Gen Intel ThinkPads, these three tools work in tandem in chronological boot order:

1. [**`DisableProchot.efi`**](/Content/05_Laptop-specific_Patches/BDPROCHOT) (UEFI) prevents boot-time hardware clock locks (400–800 MHz).
2. **`SSDT-NO-LAP`** (ACPI) permanently removes the 15W motion/lapmode ceiling at the firmware layer for all booted OSes.
3. [**`SimpleMSR.kext`**](/Content/05_Laptop-specific_Patches/BDPROCHOT) (Kernel) keeps BD-PROCHOT disabled after macOS sleep and unlocks full PL1/PL2 package power targets.

---

## 8. Notes

* **Safety:** Disabling Lapmode does **not** disable critical CPU thermal protection. If the CPU reaches TJMax (~95°C–100°C), hardware PROCHOT throttling still occurs automatically to prevent physical damage. It only removes the artificial 15W TDP ceiling induced by the accelerometer.
* **Scope Differences:** On some older or unconventional ThinkPads, `HKEY` might be located under `\_SB.PCI0.LPCB.HKEY` (without `.EC.`). Verify your DSDT scope if compilation throws an unresolved external reference error.

---

## 9. Resources

### Research & References
* [virgilhem / linux-patches (`thinkpad-acpi-disable-lapmode.patch`)](https://github.com/virgilhem/linux-patches/blob/main/thinkpad-acpi-disable-lapmode.patch) – The original Linux kernel patch that inspired this ACPI implementation.
* [sylvainfaivre / ThinkPad CPU Throttling on Linux Gist](https://gist.github.com/sylvainfaivre/512fe8c171582caca3cabaed023188b4) – Community documentation and discussion detailing ThinkPad thermal throttling, DYTC behavior, and `acpi_call` workarounds.
* [Lenovo Whitepaper: Linux Thermal Throttling (PDF via WebArchive)](https://web.archive.org/web/20190926163900if_/https://forums.lenovo.com/lnv/attachments/lnv/Special_Interest_Linux/13642/1/Linux%20Thermal%20throttling.pdf) – Official Lenovo forum statement by Mark Pearson explaining DPTF, the DYTC interface, and the Cool-on-Lap baseline implementation.

### Upstream Driver Code & Specifications
* [Linux Kernel: `thinkpad_acpi.c`](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/platform/x86/thinkpad_acpi.c) – Mainline Linux kernel driver implementing ThinkPad ACPI, showing DYTC command structures (`DYTC_CMD_GET`, `DYTC_GET_LAPMODE_BIT`, etc.).
* [erpalma / throttled](https://github.com/erpalma/throttled) – Linux daemon for fixing MSR `0x1FC` (BD-PROCHOT) and overriding package power limits (PL1/PL2) on 8th–11th Gen ThinkPads.

### macOS ThinkPad Integration
* [hoaug-tran / ReYogaSMC](https://github.com/hoaug-tran/ReYogaSMC) – Modern fork of YogaSMC for ThinkPad/Yoga fan control, hotkeys, and DYTC performance profile management under macOS.
* [zhen-zen / YogaSMC](https://github.com/zhen-zen/YogaSMC) – The original macOS ACPI driver for Lenovo ThinkPad and Yoga series notebooks.
