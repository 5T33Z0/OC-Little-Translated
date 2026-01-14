# Fixing Boot issues

## About

This guide explains how to make **macOS bootable from an internal disk** on systems where:

* The firmware does not show the macOS / OpenCore entry
* The system always boots straight into **Windows Boot Manager**
* Boot order changes in BIOS do not persist
* BootingOpenCore from USB flash drive works but not from internal SSD/NVMe

The method works by **chainloading OpenCore through Windows Boot Manager**, making Windows' behavior work *for* you instead of against you.

**This is especially useful on**:

* Laptops with locked or buggy UEFI
* OEM systems that rewrite NVRAM
* Dual-boot Windows + macOS (Hackintosh)

## How UEFI Boot Normally Works (Quick Overview)

**Typical boot flow**:

```
Firmware (UEFI)
 → BootOrder entry
   → EFI loader (.efi)
     → OS
```

**But on many systems**:

* **Windows** aggressively restores itself to **BootOrder #1**
* Custom entries (OpenCore) are ignored or deleted

## Core Idea of This Method

Instead of fighting Windows Boot Manager, we:

* Let **Windows Boot Manager stay first**
* Change what it actually loads

Result:

```
Firmware
 → Windows Boot Manager
   → OpenCore (via bootx64.efi)
     → macOS / Windows
```

## Requirements

* Working Windows installation (UEFI mode)
* macOS installed on an internal disk
* OpenCore already boots macOS (e.g. from USB)
* Access to Windows with administrator rights

## Step 1: Prepare the EFI Partition

1. Mount the EFI partition (from macOS or Windows)
2. Ensure OpenCore is installed at:

```
EFI/OC/OpenCore.efi
```

3. Copy OpenCore to the **fallback loader path**:

```
EFI/Boot/bootx64.efi
```

If the `Boot` folder does not exist, create it.

> Important: `bootx64.efi` is the UEFI fallback loader. Firmware and Windows both trust it.

---

## Step 2: (Recommended) Keep Windows Boot Manager Safe

Before changing anything, back up:

```
EFI/Microsoft/Boot/bootmgfw.efi
```

This allows easy recovery if needed.

---

## Step 3: Redirect Windows Boot Manager

Boot into Windows.

1. Open **Command Prompt** as Administrator
2. Run:

```
bcdedit /set {bootmgr} path \EFI\Boot\bootx64.efi
```

**What this does**:

* Windows Boot Manager remains first in boot order
* But it now launches `bootx64.efi` instead of Microsoft's loader

---

## Step 4: Reboot and Test

Reboot the system.

Expected result:

* System boots into **OpenCore**
* macOS internal disk is visible and bootable
* Windows remains bootable via OpenCore

If OpenCore loads, the method is successful.

## Why This Works When OpenCore Is Missing from BIOS

Many firmwares:

* Ignore non-Microsoft EFI entries
* Reset BootOrder on every reboot
* Hide APFS-based loaders

Windows Boot Manager:

* Is always respected
* Is always re-registered

By chaining OpenCore through it, you bypass firmware limitations entirely.

---

## What This Method Does NOT Do

* It does NOT stop Windows from taking BootOrder #1. In order to prevent this, consider enabling OpenCore's `LauncherOption` instead ([Instructions](/Content/07_BOOT_Folder/Understanding_OCs_LauncherOption.md)).
* It does NOT fix broken OpenCore configs
* It does NOT prevent major Windows updates from reverting the setting

It simply makes Windows' behavior harmless.

---

## Reverting to Default Windows Boot

If you want to undo this:

```
bcdedit /set {bootmgr} path \EFI\Microsoft\Boot\bootmgfw.efi
```

Or fully rebuild Windows boot files:

```
bcdboot C:\Windows /f UEFI
```

---

## When This Method Is Ideal

Use this method if:

* macOS internal disk does not appear in BIOS
* OpenCore only boots from USB
* Boot order changes do not stick
* Firmware is locked or buggy

---

## When to Consider Alternatives

Avoid this method if:

* Your firmware properly supports custom UEFI entries
* You can permanently set OpenCore first in BIOS
* You want a firmware-clean setup

In those cases, a native OpenCore boot entry is preferable.

---

## Final Notes

This is a **pragmatic workaround**, not a hacky shortcut. On problematic systems, it is often the **most reliable** way to dual-boot macOS and Windows from an internal disk. If Windows reverts the setting after a major update, simply re-run the command.
