# Understanding OpenCore’s `LauncherOption` parameter

## Overview

OpenCore provides the `Misc → Boot → LauncherOption` setting to control **how (and if) OpenCore registers itself with UEFI firmware** as a bootable operating system.

This setting is frequently misunderstood and often blamed for boot failures that are **actually caused by OEM firmware restrictions**, not OpenCore misconfiguration.

This article explains what each `LauncherOption` value really does, how firmware behaves in practice, and which option makes sense depending on your hardware.

---

## Why `LauncherOption` Exists

UEFI firmware maintains a list of boot entries (Boot####) stored in NVRAM. Each entry points to an EFI executable, such as:

* `EFI\Microsoft\Boot\bootmgfw.efi` (Windows)
* `EFI\OC\OpenCore.efi` (OpenCore)

`LauncherOption` controls whether OpenCore:

* Writes such an entry
* Modifies boot order
* Or stays completely hands-off

---

## The Three `LauncherOption` Modes

### `Disabled`

**What it does:**

* OpenCore does **not** create, modify, or delete any UEFI boot entries
* NVRAM is left untouched

**How OpenCore can be launched:**

* From USB media
* Via the UEFI fallback path `EFI\Boot\bootx64.efi`
* By chainloading (e.g. through Windows Boot Manager)

**Pros:**

* Maximum compatibility
* Immune to firmware that deletes or rewrites boot entries
* Ideal for OEM systems with locked or buggy UEFI

**Cons:**

* No native “OpenCore” entry in BIOS

**Recommended for:**

* Lenovo / HP / Dell laptops
* Systems where internal OpenCore entries fail or disappear

---

### `System`

**What it does:**

* OpenCore attempts to register itself as a UEFI boot option
* Does **not** force itself to the top of BootOrder
* Respects existing firmware defaults

**Intended purpose:**

* Coexist politely with other operating systems
* Avoid aggressive boot order changes

**Real-world behavior on OEM firmware:**

* Entry may appear but be ignored
* Entry may boot once, then vanish
* Entry may be silently rejected at execution time

**Important:**
If selecting the OpenCore entry results in a brief black screen and a return to the boot menu, this is **firmware rejection**, not a configuration error.

**Recommended for:**

* Well-behaved UEFI implementations
* Some desktop motherboards

---

### `Full`

**What it does:**

* Registers an OpenCore boot entry
* Actively sets it as the default boot option
* Attempts to persist across reboots

**Intended purpose:**

* Replace vendor boot managers
* Act as the primary system loader

**Common issues on OEM systems:**

* Firmware removes the entry on reboot
* Windows restores itself as first boot option
* Entry exists but execution is blocked

**Recommended for:**

* Custom-built desktops
* Clean, standards-compliant UEFI firmware

**Not recommended for:**

* Most laptops from major OEM vendors

---

## Why `LauncherOption` Often Does Not Fix Internal Boot Failures

A common scenario:

* OpenCore works perfectly from USB
* The same EFI copied to the internal disk does not boot
* Selecting it shows a black screen, then returns to BIOS

This is **not** influenced by `LauncherOption`.

The firmware is:

* Allowing the boot entry to exist
* But refusing to execute a non-Microsoft EFI loader from internal storage

Changing how politely OpenCore registers itself does not change firmware trust rules.

---

## The Practical Solution on OEM Firmware

On systems that aggressively favor Windows Boot Manager, the most reliable approach is:

* Set `LauncherOption = Disabled`
* Place OpenCore at `EFI\Boot\bootx64.efi`
* Chainload OpenCore via Windows Boot Manager if Windows is present

This avoids fragile NVRAM entries entirely and works *with* firmware behavior instead of against it.

---

## Summary

* `LauncherOption` controls **UEFI registration behavior**, not OpenCore functionality
* `Disabled` is the most robust choice on OEM hardware
* `System` and `Full` depend on firmware cooperation
* Instant return to boot menu usually means **firmware rejection**, not misconfiguration

Understanding this setting prevents wasted time chasing problems that cannot be solved in OpenCore itself.

