# Populating the MMIO Whitelist

**TABLE of CONTENTS**

- [About MMIO and DevirtualiseMmio](#about-mmio-and-devirtualisemmio)
- [How DevirtualiseMmio and the MmioWhitelist actually work](#how-devirtualisemmio-and-the-mmiowhitelist-actually-work)
  - [What DevirtualiseMmio does](#what-devirtualisemmio-does)
  - [What the MmioWhitelist actually does](#what-the-mmiowhitelist-actually-does)
  - [The critical misconception](#the-critical-misconception)
  - [Reading the boot log](#reading-the-boot-log)
  - [Real-world example](#real-world-example)
- [Who needs this](#who-needs-this)
- [Instructions](#instructions)
  - [Step 1: Enable DevirtualiseMmio and switch to DEBUG OpenCore](#step-1-enable-devirtualisemmio-and-switch-to-debug-opencore)
  - [Step 2: Capture the boot log](#step-2-capture-the-boot-log)
  - [Step 3: Generate the MmioWhitelist entries](#step-3-generate-the-mmiowhitelist-entries)
  - [Step 4: Add entries to config.plist](#step-4-add-entries-to-configplist)
  - [Step 5: Test and tune](#step-5-test-and-tune)
  - [Step 6: Clean up](#step-6-clean-up)
- [Troubleshooting](#troubleshooting)

---

## About MMIO and DevirtualiseMmio

MMIO stands for **Memory-Mapped Input/Output**. It is the method by which a CPU communicates with hardware peripherals — device registers and buffers are mapped into the system's address space rather than accessed via separate I/O ports. At boot time, the UEFI firmware reserves blocks of the physical address space for these devices, marking them as MMIO regions in the memory map.

The problem: macOS uses **KASLR** (Kernel Address Space Layout Randomization) to randomly place the kernel in memory at boot. It selects a position using a `slide` value (0–255). On some systems, large MMIO reservations leave so little contiguous free memory that only a handful of valid slide positions remain — or none at all. This prevents macOS from booting.

`DevirtualiseMmio` is the OpenCore quirk that addresses this. It scans the firmware's MMIO regions and **reclaims** them as usable RAM during the OpenCore boot process, increasing the number of valid slide values macOS can choose from.

---

## How DevirtualiseMmio and the MmioWhitelist actually work

Understanding the mechanics here is essential. Most guides only describe *how to set this up*, which leads to a common and frustrating mistake.

### What DevirtualiseMmio does

When `DevirtualiseMmio` is enabled, OpenCore processes every MMIO region found in the firmware memory map and removes it from the reserved list, making that memory available to macOS. Each processed region appears in the debug boot log like this:

```
OCABC: MMIO devirt 0xFEC00000 (0x1 pages, 0x8000000000000001) skip 0
```

The fields are:

| Field | Meaning |
|---|---|
| `0xFEC00000` | Base address of the MMIO region |
| `0x1 pages` | Size in 4 KB pages (1 page = 4 KB) |
| `0x800000000000...` | EFI memory type and attribute flags |
| `skip 0` | Region **was** devirtualised (reclaimed) |
| `skip 1` | Region was **skipped** (left as-is) |

At the end of this pass, OpenCore reports the result:

```
OCABC: MMIO devirt end, saved 278668 KB
OCABC: Only 74/256 slide values are usable!
OCABC: Valid slides - 0-29, 136-179
```

The `saved` figure is the total memory reclaimed from MMIO regions. The slide count tells you how many valid KASLR positions macOS has to work with.

### What the MmioWhitelist actually does

The `MmioWhitelist` is an **exclusion list**. Entries you enable are *excluded from devirtualisation* — OpenCore leaves them in the firmware's reserved state and does not reclaim them.

This means the relationship is the **opposite** of what many people assume:

| Entry state | Effect on the region | Effect on slide count |
|---|---|---|
| `Enabled: false` | Region **is** devirtualised (`skip 0`) | More memory reclaimed → more slides |
| `Enabled: true` | Region is **not** devirtualised (`skip 1`) | Less memory reclaimed → fewer slides |

### The critical misconception

The name "whitelist" implies that you are *allowing* something. In reality you are *protecting* a region from being touched by OpenCore. You whitelist a region when devirtualising it causes a problem — not to improve performance or increase slides.

**Enabling entries in the MmioWhitelist will reduce your usable slide count.** On most systems this is harmless if only small regions are whitelisted. But on some systems, enabling the wrong entries will reduce slides to the point where macOS cannot boot at all.

### Reading the boot log

A healthy result with `DevirtualiseMmio` enabled and no whitelist entries active looks like this (from a Gigabyte Z490 / i9-10850K system):

```
OCABC: MMIO devirt 0xE0000000 (0x10000 pages, 0x800000000000100D) skip 0
OCABC: MMIO devirt 0xFC000000 (0x10 pages, 0x800000000000100D) skip 0
OCABC: MMIO devirt 0xFE000000 (0x11 pages, 0x8000000000000001) skip 0
OCABC: MMIO devirt 0xFEC00000 (0x1 pages, 0x8000000000000001) skip 0
OCABC: MMIO devirt 0xFEE00000 (0x1 pages, 0x8000000000000001) skip 0
OCABC: MMIO devirt 0xFF000000 (0x1000 pages, 0x800000000000100D) skip 0
OCABC: MMIO devirt end, saved 278668 KB
OCABC: Only 74/256 slide values are usable!
OCABC: Valid slides - 0-29, 136-179
```

All 6 regions have `skip 0` — all devirtualised. 278 MB reclaimed. 74 usable slides. This is a good baseline.

### Real-world example

On the same Z490 system, three entries (`0xFEC00000`, `0xFEE00000`, `0xFF000000`) were enabled in the MmioWhitelist to test the common advice of whitelisting APIC and firmware ROM regions. The result on the next boot:

```
OCABC: MMIO devirt 0xE0000000 (0x10000 pages, 0x800000000000100D) skip 0
OCABC: MMIO devirt 0xFC000000 (0x10 pages, 0x800000000000100D) skip 0
OCABC: MMIO devirt 0xFE000000 (0x11 pages, 0x8000000000000001) skip 0
OCABC: MMIO devirt 0xFEC00000 (0x1 pages, 0x8000000000000001) skip 1
OCABC: MMIO devirt 0xFEE00000 (0x1 pages, 0x8000000000000001) skip 1
OCABC: MMIO devirt 0xFF000000 (0x1000 pages, 0x800000000000100D) skip 1
OCABC: MMIO devirt end, saved 262276 KB
OCABC: Only 58/256 slide values are usable!
OCABC: Valid slides - 0-21, 136-171
```

The three whitelisted regions now show `skip 1`. Memory reclaimed dropped from 278,668 KB to 262,276 KB. Usable slides dropped from 74 to 58. The whitelist made things strictly worse on this board.

Testing the remaining three entries (`0xE0000000`, `0xFC000000`, `0xFE000000`) produced a prohibitory sign — macOS would not boot at all. On this Z490 system with an active iGPU, `0xE0000000` is the Intel UHD 630 framebuffer region, which macOS requires devirtualised to initialise the GPU. Whitelisting it meant macOS lost access to memory it needs before it can even reach the kernel.

**Conclusion for this system:** all 6 regions must remain devirtualised. The MmioWhitelist should stay empty (all entries `Enabled: false`). This is the correct outcome for many modern Intel systems.

---

## Who needs this

`DevirtualiseMmio` (and potentially the MmioWhitelist) is most commonly required on:

- **AMD Threadripper / TRX40 / WRX80** — large MMIO footprint from chipset and PCIe fabric
- **Intel Ice Lake** — unusual memory map layout
- **Intel Comet Lake (Z490/W480) and newer** — may have constrained slide counts depending on board
- **Systems reporting 0 or very few usable slides** in the boot log

It is generally not needed on Coffee Lake (Z370/Z390) and older Intel platforms with conventional memory maps, though it does not hurt to check.

---

## Instructions

> [!IMPORTANT]
> Back up your EFI folder to a FAT32 USB drive before making changes. If a wrong whitelist entry prevents booting, you will need to boot Windows or another OS to restore your config.

### Step 1: Enable DevirtualiseMmio and switch to DEBUG OpenCore

1. In your `config.plist`, set `Booter → Quirks → DevirtualiseMmio` to `true`
2. Enable debug logging:
   - Set `Misc → Debug → Target` to `67` (enables file logging)
   - Set `Misc → Debug → DisplayLevel` to `2147483648`
3. Switch to the DEBUG build of OpenCore. In OCAT: **Edit → OpenCore DEBUG** (enable checkmark)
4. Save your config and reboot

### Step 2: Capture the boot log

After rebooting, OpenCore writes a log file (`opencore-YYYY-MM-DD-HHMMSS.txt`) to the root of your EFI partition.

To retrieve it on macOS:

```bash
sudo diskutil mount disk0s1
ls /Volumes/EFI/
```

Copy the log file to your Desktop or another convenient location.

### Step 3: Generate the MmioWhitelist entries

Use [corpnewt's MmioDevirt script](https://github.com/corpnewt/MmioDevirt) to analyse the log and generate ready-to-paste plist entries:

```
python3 MmioDevirt.py
```

Point it at your boot log when prompted. It will output a `Booter → MmioWhitelist` array like this:

```xml
<key>MmioWhitelist</key>
<array>
    <dict>
        <key>Address</key>
        <integer>3758096384</integer>
        <key>Comment</key>
        <string>MMIO devirt 0xE0000000 (0x10000 pages - 256 MB)</string>
        <key>Enabled</key>
        <false/>
    </dict>
    <dict>
        <key>Address</key>
        <integer>4227858432</integer>
        <key>Comment</key>
        <string>MMIO devirt 0xFC000000 (0x10 pages - 64 KB)</string>
        <key>Enabled</key>
        <false/>
    </dict>
    ...
</array>
```

Note that all entries are generated with `Enabled: false`. **This is correct and intentional.** Do not enable any of them yet.

Alternatively, you can identify the regions manually by searching the boot log for lines matching:

```
OCABC: MMIO devirt 0x
```

### Step 4: Add entries to config.plist

Copy the generated array into your `config.plist` under `Booter → MmioWhitelist`. Leave all entries disabled (`<false/>`). Save the config.

### Step 5: Test and tune

Reboot and check the new boot log. Search for `MMIO devirt end` and note:

- How many KB were saved
- How many slide values are usable
- What your valid slide range is

If macOS boots normally and you have a reasonable slide count (above ~8), you are done. The whitelist entries can remain in your config disabled as documentation, or be removed entirely.

**Only enable an entry if you experience a specific problem** — boot instability, a hang, or a prohibitory sign that you can correlate with devirtualisation. In that case, enable entries one at a time, rebooting after each, and watch whether the slide count improves or worsens, and whether the problem resolves.

> [!WARNING]
> 
> Enabling a whitelist entry will always reduce your slide count. Enabling the wrong entry — particularly large regions or those used by an active iGPU — can prevent macOS from booting entirely. If you get a prohibitory sign after enabling entries, boot a different OS and set the affected entries back to `Enabled: false`.

If after testing you find that no entries need to be enabled, set your `slide=` boot argument to a value within the valid range reported in the log. For example, if the log reports `Valid slides - 0-29, 136-179`, a value of `slide=170` works well.

### Step 6: Clean up

Once you have confirmed a stable configuration:

1. In OCAT, select **Edit → OpenCore DEBUG** to uncheck it and switch back to RELEASE OpenCore
2. Set `Misc → Debug → Target` back to `3` (or `0` to disable logging entirely)
3. Delete the log files from your EFI partition if desired
4. Remove `slide=` from your boot-args if you prefer to let OpenCore choose automatically (acceptable when you have 8+ usable slides)

---

## Troubleshooting

**Prohibitory sign after enabling whitelist entries**
You have whitelisted a region that macOS needs devirtualised. Boot Windows or another OS, open your config.plist, and set the recently enabled entries back to `Enabled: false`. The most common culprit on Intel systems with an active iGPU is the large PCIe/framebuffer region (typically at `0xE0000000` or similar).

**Slide count decreased after enabling entries**
This is expected behaviour — enabling entries always reduces slides. If the new count is still above ~8 and macOS boots, it is acceptable. If you were hoping to *increase* slides, leave entries disabled.

**Very few or no usable slides even with DevirtualiseMmio enabled**
Your memory map may have additional constraints. Check that `ProvideCustomSlide` is enabled under `Booter → Quirks`. Without it, KASLR slide randomisation is not constrained to valid values and macOS may attempt to use an invalid position.

**macOS boots but is unstable**
Rarely, devirtualising a region that hardware actively uses during runtime (not just at boot) can cause instability. Try enabling the smallest regions first (`0x1 pages`) and observe whether stability improves.

**DevirtualiseMmio not needed?**
If your boot log shows `Only 256/256 slide values are usable` or a high count without `DevirtualiseMmio`, you do not need this quirk. Disable it and leave the MmioWhitelist empty.
