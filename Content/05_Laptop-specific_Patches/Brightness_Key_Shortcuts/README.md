# Enabling Brightness Key Shortcuts

**TABLE OF CONTENTS**

- [About](#about)
- [Which approach should I use?](#which-approach-should-i-use)
- [New method: using `BrightnessKeys.kext`](#new-method-using-brightnesskeyskext)
- [Old method: SSDT + Binary Renames](#old-method-ssdt--binary-renames)
	- [I. Select the appropriate Hotpatch](#i-select-the-appropriate-hotpatch)
	- [II. Binary Renames](#ii-binary-renames)

---

## About

SSDT hotpatches to enable brightness key shortcuts for various laptop models (Asus, Lenovo, Xiaoxin, Dell, et al.). They must be paired with the corresponding binary renames listed in the `.dsl` files.

The included hotpatches are from [Daliansky's](https://github.com/daliansky) P-Little repo (originally for Clover), with `If (_OSI ("Darwin"))` guards added to restrict injection into macOS only.

> [!IMPORTANT]
>
> This `_OSI ("Darwin")` guard is essential. OpenCore injects ACPI tables system-wide (all OSes), whereas Clover only injects into macOS. Without this guard, brightness patches would affect Windows and Linux as well.

> [!NOTE]
>
> Some ASUS and Dell laptops only require `SSDT-OCWork-xxx` to enable `Notify (GFX0, 0x86)` and `Notify (GFX0, 0x87)` for brightness shortcut keys. See the [ASUS Machine Special Patch](/Content/05_Laptop-specific_Patches/Brand-specific_Patches/ASUS_Special_Patch) and [Dell Machine Special Patch](/Content/05_Laptop-specific_Patches/Brand-specific_Patches/Dell_Special_Patch) for details.

---

## Which approach should I use?

| Situation | Recommended approach |
|---|---|
| macOS Big Sur or newer (general case) | `BrightnessKeys.kext` (new method) |
| Older ThinkPad (3rd–5th gen) | `BrightnessKeys.kext` + `SSDT-NBCF.aml` |
| `BrightnessKeys.kext` doesn't work for your model | Old method: SSDT + binary renames |

---

## New method: using [`BrightnessKeys.kext`](https://github.com/acidanthera/BrightnessKeys)

Introduced by Acidanthera in late 2020, `BrightnessKeys.kext` replaces the previous SSDT + rename approach. Since brightness control is part of the Embedded Controller (EC) defined in the DSDT, applying binary renames to its methods is sub-optimal and can affect other OSes. A kext is a cleaner solution that confines all changes to macOS.

**Steps:**

1. Disable any existing binary renames and corresponding SSDT-Bkey hotpatches that previously handled brightness keys.
2. Add `BrightnessKeys.kext` to your `OC/Kexts` folder and `config.plist` (under `Kernel/Add`), with `Enabled` set to `true`.
3. Save and reboot.
4. Test the brightness shortcut keys. If they do not work, see the note below before falling back to the old method.

> [!NOTE]
>
> **Older ThinkPads (3rd–5th gen):** Check the "Special Cases" section of the BrightnessKeys repo to determine whether you need to change `NBCF` from `Zero` to `One` (i.e. `0x01`). If so, add `SSDT-NBCF.aml` rather than using a binary rename — ACPI is cleaner and the change remains macOS-only.

> [!NOTE]
>
> **VoodooPS2 and scan code capture (macOS Big Sur and newer):** There are known issues with VoodooPS2's scan code capture on Big Sur and later that can interfere with brightness key detection. See [VoodooPS2 scan code capture workarounds](/Content/05_Laptop-specific_Patches/Fixing_Keyboard_Mappings_and_Brightness_Keys/README.md) for community-discovered fixes before concluding the kext doesn't work for your system.

---

## Old method: SSDT + Binary Renames

Use this method only if `BrightnessKeys.kext` does not work for your laptop model.

Enabling brightness hotkeys this way consists of two stages:

1. Adding the correct SSDT for your laptop model
2. Renaming the existing EC methods for brightness keys to disable the originals (renames are listed in the corresponding `.dsl` files)

### I. Select the appropriate Hotpatch

Pick the SSDT matching your laptop model, export it as `SSDT-Bkey.aml`, and add it to your `ACPI` folder and `config.plist` (under `ACPI/Add`), with `Enabled` set to `true`.

| SSDT file | Target model |
|---|---|
| `SSDT-BKeyQ0EQ0F-A580UR` | Asus A580UR |
| `SSDT-BKeyQ04Q05-X210` | Lenovo X210 |
| `SSDT-BKeyQ11Q12-LenAir_IKB_IKBR_IWL` | Lenovo Xiaoxin (IKB/IKBR/IWL) |
| `SSDT-BKeyQ14Q15-TP` | Various ThinkPad models |
| `SSDT-BKeyQ64Q65-S2-2017` | ThinkPad S2 2017 |

> [!NOTE]
>
> Before using, verify that the PCI device names and paths in the SSDT match your `DSDT`:
>
> - Low Pin Count Bus: `LPC` or `LPCB`
> - Keyboard: `PS2K` or `KBD`
> - Embedded Controller: `EC` or `EC0`

### II. Binary Renames

Add the corresponding renames to `config.plist` under `ACPI/Patch`, with `Enabled` set to `true` for each entry. Listed below are binary rename examples for various Laptop Models

**Asus A580UR**

| Key | Value |
|---|---|
| Comment | change \_Q0E to XQ0E (A580UR) |
| Find | `5F 51 30 45` |
| Replace | `58 51 30 45` |

| Key | Value |
|---|---|
| Comment | change \_Q0F to XQ0F (A580UR) |
| Find | `5F 51 30 46` |
| Replace | `58 51 30 46` |

**Lenovo ThinkPads (general)**

| Key | Value |
|---|---|
| Comment | change \_Q14 to XQ14 (TP-up) |
| Find | `5F 51 31 34` |
| Replace | `58 51 31 34` |

| Key | Value |
|---|---|
| Comment | change \_Q15 to XQ15 (TP-down) |
| Find | `5F 51 31 35` |
| Replace | `58 51 31 35` |

**Lenovo ThinkPad X210**

| Key | Value |
|---|---|
| Comment | change \_Q04 to XQ04 |
| Find | `5F 51 30 34` |
| Replace | `58 51 30 34` |

| Key | Value |
|---|---|
| Comment | change \_Q05 to XQ05 |
| Find | `5F 51 30 35` |
| Replace | `58 51 30 35` |

**Lenovo ThinkPad S2 (2017)**

| Key | Value |
|---|---|
| Comment | change \_Q64 to XQ64 (TP-S2-2017-down) |
| Find | `5F 51 36 34` |
| Replace | `58 51 36 34` |

| Key | Value |
|---|---|
| Comment | change \_Q65 to XQ65 (TP-S2-2017-up) |
| Find | `5F 51 36 35` |
| Replace | `58 51 36 35` |

**Xiaoxin IKB/IKBR/IWL**

| Key | Value |
|---|---|
| Comment | change \_Q11 to XQ11 (LenAir/IKB/IKBR/IWL-down) |
| Find | `5F 51 31 31` |
| Replace | `58 51 31 31` |

| Key | Value |
|---|---|
| Comment | change \_Q12 to XQ12 (LenAir/IKB/IKBR/IWL-up) |
| Find | `5F 51 31 32` |
| Replace | `58 51 31 32` |
