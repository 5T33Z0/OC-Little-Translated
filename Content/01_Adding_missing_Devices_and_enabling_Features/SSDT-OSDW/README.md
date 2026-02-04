# Centralizing macOS Detection in ACPI: Using a Shared `OSDW` Helper Method

## About

In Hackintosh and OpenCore setups, multiple SSDTs often include OS-specific logic. Traditionally, many tables check for macOS using repeated calls to `_OSI("Darwin")`. While functional, this approach leads to duplicated logic, maintenance overhead, and potential inconsistencies.

A clean, scalable alternative is to centralize macOS detection in a single **helper method**, which all other SSDTs can reference. This article demonstrates that approach and the benefits it brings.

---

## The Problem: Repeated `_OSI("Darwin")` Checks

Consider a typical SSDT snippet:

```asl
Method (_PTS, 1, NotSerialized)
{
    If (_OSI("Darwin"))
    {
        \_SB.PCI9.TPTS = Arg0
        If (\_SB.PCI9.FNOK == One) { Arg0 = 0x03 }

        If (CondRefOf (EXT1)) { EXT1(Arg0) }
    }

    ZPTS(Arg0)
}
```

Here, every SSDT that needs macOS-specific logic repeats `_OSI("Darwin")`. Over time, this leads to:

* Code duplication
* Increased risk of inconsistencies
* Harder maintainability for large ACPI stacks

---

## The Solution: A Shared `OSDW` Helper

We create a dedicated SSDT called `SSDT-OSDW.aml` containing:

```asl
DefinitionBlock ("", "SSDT", 2, "OCLT", "OSDW", 0x00000000)
{
    Method (OSDW, 0, NotSerialized)
    {
        If (CondRefOf (\_OSI))
        {
            If (_OSI("Darwin"))
            {
                Return (One)
            }
        }
        Return (Zero)
    }
}
```

**Explanation:**

* Checks if `_OSI` exists (`CondRefOf`)
* Calls `_OSI("Darwin")`
* Returns `One` if macOS, `Zero` otherwise

This helper is *global*, *reusable*, and *avoids modifying `_OSI` itself*.

---

## Refactoring Existing SSDTs

Each SSDT that previously used `_OSI("Darwin")` now simply references `OSDW`:

```asl
External (OSDW, MethodObj)   // required in each SSDT

Method (_PTS, 1, NotSerialized)
{
    If (OSDW())
    {
        \_SB.PCI9.TPTS = Arg0
        If (\_SB.PCI9.FNOK == One) { Arg0 = 0x03 }

        If (CondRefOf (EXT1)) { EXT1(Arg0) }
    }

    ZPTS(Arg0)
}
```

**Advantages**:

* Removes repeated `_OSI("Darwin")` calls
* Consolidates OS detection
* Ensures consistent behavior across *all* SSDTs
* Keeps leaf methods (EXT1, EXT2, EXT3…) clean and generic

---

## Implementation Tips

1. **Load order matters**: `SSDT-OSDW.aml` must appear **before** all SSDTs that reference it. In OpenCore, place it at the top of `ACPI → Add`.
2. **External declaration**: Every SSDT using `OSDW()` must include `External (OSDW, MethodObj)`.
3. **Caller vs helper gating**: Decide whether OS checks should live in the caller (preferred) or inside EXT methods (optional defensive approach).

---

## Benefits

* **Maintainability**: One place to update OS detection
* **Safety**: No accidental calls on Windows/Linux
* **Scalability**: Easy to extend for multi-OS logic in the future
* **Clarity**: Centralized documentation and naming (`OSDW` → “OS = Darwin”)

---

## Summary

Centralizing macOS detection in a shared `OSDW` method is a clean, robust practice for Hackintosh ACPI stacks. It eliminates duplicated `_OSI("Darwin")` checks, reduces risk of errors, and improves maintainability — especially as SSDT complexity grows.

By adopting this approach:

* All SSDTs remain small, readable, and OS-agnostic
* Future changes to OS detection require modifying **only one helper**
* Sleep/wake and other macOS-specific features remain fully functional

This method represents best practice for OpenCore ACPI configurations and is recommended for anyone maintaining a multi-SSDT Hackintosh setup.

## Credits
@[BenBender](https://github.com/benbender/x1c6-hackintosh). I saw this the first time in his EFI
