# The Boot Process, KASLR, and Slides Explained

This document explains what happens between pressing the power button and macOS handing control to the login screen — with a focus on the memory-related concepts that matter for OpenCore configuration, particularly `slide` values, `ProvideCustomSlide`, and `DevirtualiseMmio`.

---

**TABLE of CONTENTS**

- [The UEFI Boot Process](#the-uefi-boot-process)
- [How OpenCore Fits Into the Boot Chain](#how-opencore-fits-into-the-boot-chain)
- [The Physical Memory Map](#the-physical-memory-map)
- [What KASLR Is and Why macOS Needs It](#what-kaslr-is-and-why-macos-needs-it)
- [What Slides Are and How They Work](#what-slides-are-and-how-they-work)
  - [The `slide=` boot argument](#the-slide-boot-argument)
- [Why Some Systems Have Constrained Slide Counts](#why-some-systems-have-constrained-slide-counts)
- [How `ProvideCustomSlide` and `DevirtualiseMmio` Address This](#how-providecustomslide-and-devirtualisemmio-address-this)
  - [`ProvideCustomSlide`](#providecustomslide)
  - [`DevirtualiseMmio`](#devirtualisemmio)
  - [The `MmioWhitelist`](#the-mmiowhitelist)
- [Putting It All Together](#putting-it-all-together)

---

## The UEFI Boot Process

When you press the power button, control passes through several distinct phases before macOS ever runs:

**1. Power-On Self Test (POST)**
The motherboard firmware initialises the CPU, RAM, and core chipset. Memory is tested and a basic hardware inventory is built.

**2. UEFI firmware initialisation**
The UEFI firmware takes over and constructs a **physical memory map** — a table describing every region of the system's address space: which ranges are usable RAM, which are reserved for hardware devices, which hold the firmware itself, and so on. This memory map is the authoritative record of what exists in the system's address space and who owns it.

**3. Boot device selection**
The UEFI firmware scans for bootable devices according to its boot order. On a Hackintosh, it finds OpenCore's `BOOTx64.efi` (or `OpenCore.efi`) on the EFI partition.

**4. Boot manager execution**
The selected boot manager (OpenCore, in our case) is loaded into memory and begins executing. At this point the UEFI firmware is still running alongside it, providing runtime services.

**5. OS handoff**
The boot manager loads the operating system kernel, passes it the memory map and other system tables, and hands over control. The OS takes ownership of the hardware.

---

## How OpenCore Fits Into the Boot Chain

OpenCore is a **UEFI boot manager and environment patcher**. It sits between the UEFI firmware and the macOS kernel, performing several tasks:

- Presenting a boot picker (the OpenCore GUI or text menu)
- Injecting ACPI tables (SSDTs) into the firmware's ACPI namespace
- Applying kernel patches and kext injections before the kernel loads
- Manipulating the memory map to make it suitable for macOS
- Passing the modified environment to the macOS bootloader (`boot.efi`)

Crucially, OpenCore can **modify the memory map** that gets handed to macOS. This is the mechanism behind `DevirtualiseMmio` and related quirks — OpenCore edits the map before macOS ever sees it.

The boot sequence on a Hackintosh therefore looks like this:

```
Power on
  └─ UEFI POST and firmware init
       └─ UEFI finds OpenCore on EFI partition
            └─ OpenCore loads
                 ├─ Injects SSDTs, applies patches
                 ├─ Modifies memory map (DevirtualiseMmio, etc.)
                 └─ Loads boot.efi
                      └─ boot.efi loads XNU kernel
                           └─ Kernel initialises hardware, mounts root volume
                                └─ launchd → login screen
```

---

## The Physical Memory Map

Before going further, it helps to understand what the memory map looks like. On a typical desktop system with 32 GB of RAM and a Z490 chipset, the map contains dozens of entries. A simplified version might look like this:

| Address range | Type | Description |
|---|---|---|
| `0x00000000` – `0x0009FFFF` | Conventional | Low conventional RAM (640 KB) |
| `0x000A0000` – `0x000FFFFF` | Reserved | Legacy VGA / option ROM area |
| `0x00100000` – `0x7FFFFFFF` | Conventional | Main system RAM |
| `0xE0000000` – `0xEFFFFFFF` | MMIO | PCIe / iGPU framebuffer region |
| `0xFEC00000` – `0xFEC00FFF` | MMIO | IOAPIC |
| `0xFEE00000` – `0xFEE00FFF` | MMIO | Local APIC (LAPIC) |
| `0xFF000000` – `0xFFFFFFFF` | MMIO | Firmware ROM shadow |

The MMIO regions (Memory-Mapped I/O) are address ranges the firmware has reserved for hardware devices. They are not usable RAM — they are windows into device registers and buffers. Some of these regions carry an `EFI_MEMORY_RUNTIME` attribute, meaning the UEFI firmware expects to be able to access them even after handing control to the OS.

The total size of these MMIO reservations matters a great deal — and this is where KASLR enters the picture.

---

## What KASLR Is and Why macOS Needs It

**KASLR** stands for Kernel Address Space Layout Randomisation. It is a security feature present in all modern operating systems, including macOS (since OS X Mountain Lion).

Without KASLR, the kernel and its data structures are always loaded at the same fixed memory addresses. This makes it trivial for an attacker to craft exploits that reference known memory locations — a technique called **return-oriented programming** or similar. With KASLR, the kernel is placed at a randomised address on every boot, so an attacker cannot predict where any given function or data structure will be in memory.

macOS implements KASLR by selecting a random **slide value** at boot time and offsetting the kernel's load address by a corresponding amount. The kernel, its extensions (kexts), and associated data structures are all shifted by the same offset, maintaining their relative positions while randomising their absolute addresses.

This is not optional. macOS requires KASLR to boot — it cannot be disabled. If no valid slide position can be found, macOS will not boot.

---

## What Slides Are and How They Work

A **slide** is an integer from 0 to 255. Each value corresponds to a specific memory offset:

```
load_address = base_address + (slide × 0x200000)
```

Each increment of 1 in the slide value shifts the kernel's load address by **2 MB** (0x200000 bytes). With 256 possible values, the kernel can be placed anywhere within a 512 MB window (256 × 2 MB).

Before selecting a slide, `boot.efi` checks each candidate position against the memory map. A slide value is **valid** only if the entire kernel image fits into a contiguous region of free conventional memory at that position — it cannot overlap with reserved regions, MMIO windows, firmware data, or anything else already in the map.

On a system with a clean memory map, most or all 256 slide values are valid:

```
OCABC: Only 256/256 slide values are usable!
```

On a system with large or numerous MMIO reservations fragmenting the address space, many positions will overlap with reserved regions and be invalid:

```
OCABC: Only 74/256 slide values are usable!
OCABC: Valid slides - 0-29, 136-179
```

As long as at least one valid slide exists, macOS can boot. In practice, having fewer than ~8 usable slides starts to become a concern, and having 0 prevents booting entirely.

### The `slide=` boot argument

If you add `slide=N` to your boot-args, you are manually specifying which slide value to use rather than letting `boot.efi` pick randomly. This is useful when:

- You want a reproducible, stable boot position
- You are debugging memory-related boot issues
- `ProvideCustomSlide` is active and you want to override its selection

The value must fall within the valid range reported in your boot log. For example, if your log reports `Valid slides - 0-29, 136-179`, then `slide=170` is valid but `slide=100` would not be.

---

## Why Some Systems Have Constrained Slide Counts

The number of usable slides is directly determined by how much of the address space in the 512 MB KASLR window is occupied by non-free memory regions.

Several factors reduce the available slide count:

**Large MMIO reservations**
Chipsets with large PCIe implementations (AMD Threadripper, Intel HEDT platforms, Intel 400-series and newer) often have correspondingly large MMIO windows. A single 256 MB MMIO region for PCIe/iGPU space can eliminate a large portion of the KASLR window.

**Firmware data and runtime services**
The UEFI firmware itself occupies memory for its code, data, and runtime service mappings. These are marked as reserved in the memory map and cannot be used as slide positions.

**Memory above 4 GB**
On systems with more than 4 GB of RAM, the physical memory layout becomes more complex. The region between approximately 3.5 GB and 4 GB is typically occupied by MMIO (the so-called **PCI hole**), pushing RAM above the 4 GB boundary. This creates fragmentation in the address space that can eliminate slide positions.

**Board-specific firmware behaviour**
Some firmware implementations reserve more memory than strictly necessary, or place reservations in locations that happen to collide with the KASLR window. This is board- and BIOS-version-specific.

---

## How `ProvideCustomSlide` and `DevirtualiseMmio` Address This

OpenCore provides two complementary mechanisms to deal with constrained slide counts.

### `ProvideCustomSlide`

**Location:** `Booter → Quirks → ProvideCustomSlide`

Without this quirk, `boot.efi` picks a slide value completely at random from 0–255. If most of those values are invalid, there is a high probability of picking a bad one, causing a boot failure.

With `ProvideCustomSlide` enabled, OpenCore intercepts the slide selection process. It analyses the memory map, builds the list of valid slide values, and ensures `boot.efi` only selects from that valid set. If you have 74 usable slides, OpenCore ensures the random pick is one of those 74 — not one of the 182 invalid ones.

This quirk does not increase the number of valid slides. It only ensures the selection is always a valid one. Think of it as making the random draw cheat-proof rather than enlarging the pool.

> [!NOTE]
> `ProvideCustomSlide` requires the `slide=` value to not be hardcoded in boot-args, or if it is, it must already be within the valid range. OpenCore will warn in the log if a hardcoded `slide=` value is invalid.

### `DevirtualiseMmio`

**Location:** `Booter → Quirks → DevirtualiseMmio`

This quirk addresses the root cause rather than the symptom. It scans the memory map for MMIO regions and removes their EFI runtime virtual address mappings, converting them from reserved regions back into memory that macOS can use. This directly increases the number of valid slide positions by reducing how much of the address space is occupied by reserved regions.

The boot log shows the result of each region processed:

```
OCABC: MMIO devirt 0xE0000000 (0x10000 pages, 0x800000000000100D) skip 0
```

`skip 0` means the region was devirtualised (reclaimed). `skip 1` means it was left alone — either because it is in the MmioWhitelist, or because OpenCore determined it cannot safely be touched.

After processing, OpenCore reports the total memory reclaimed and the resulting slide count:

```
OCABC: MMIO devirt end, saved 278668 KB
OCABC: Only 74/256 slide values are usable!
```

Unlike `ProvideCustomSlide`, `DevirtualiseMmio` actively improves the situation by giving macOS more usable address space.

### The `MmioWhitelist`

When `DevirtualiseMmio` is enabled, some MMIO regions may need to be excluded from devirtualisation — specifically those where the UEFI firmware's runtime services need to retain direct hardware access after macOS boots. The `MmioWhitelist` in `Booter` serves this purpose: entries you enable are excluded from devirtualisation, preserving their runtime virtual mappings.

For a full explanation of how the MmioWhitelist works and how to configure it, see [Populating the MMIO Whitelist](../12_MMIO_Whitelist/README.md).

---

## Putting It All Together

The relationship between all these concepts:

```
UEFI firmware builds memory map
  │
  ├─ Large MMIO regions fragment the address space
  │    └─ Fewer valid slide positions for KASLR
  │
OpenCore loads and modifies the memory map
  │
  ├─ DevirtualiseMmio reclaims MMIO regions
  │    └─ More address space available → more valid slides
  │         └─ MmioWhitelist protects regions firmware needs at runtime
  │
  └─ ProvideCustomSlide ensures boot.efi only picks valid slides
       └─ slide= boot-arg pins a specific valid value if desired
  │
boot.efi selects a slide value
  └─ Kernel loaded at base_address + (slide × 2 MB)
       └─ macOS boots
```

On a well-configured system the boot log should show a healthy slide count and a `saved` figure confirming that `DevirtualiseMmio` is doing useful work. If your system boots reliably, you have enough valid slides, and your `slide=` value (if set) falls within the valid range, your configuration is correct.
