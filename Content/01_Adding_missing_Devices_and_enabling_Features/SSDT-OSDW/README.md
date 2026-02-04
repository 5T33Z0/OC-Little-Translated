# Centralizing macOS Detection in ACPI: Using a Shared `OSDW` Helper Method

## Overview
In OpenCore Hackintosh configurations, multiple SSDTs often require OS-specific logic to ensure hardware features work correctly under macOS while remaining inactive under Windows or Linux. Traditionally, each SSDT includes its own `_OSI("Darwin")` check, leading to code duplication and maintenance challenges.

`SSDT-OSDW` introduces a centralized helper method that consolidates macOS detection into a single, reusable component. This approach improves code maintainability, reduces file sizes, and ensures consistent OS detection across your entire ACPI stack.

**Key Benefits:**

- Single source of truth for macOS detection
- Reduced code duplication across SSDTs
- Easier maintenance and debugging
- Smaller, cleaner SSDT files
- Consistent behavior across all ACPI patches

## The Problem: Repeated `_OSI("Darwin")` Checks

In a typical Hackintosh ACPI stack, macOS-specific code appears scattered across multiple SSDTs. Consider this common pattern:

```asl
Method (_PTS, 1, NotSerialized)  // Prepare To Sleep
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

When this pattern repeats across 5, 10, or even 20+ SSDTs, several issues emerge:

**Maintenance Challenges:**

- Changing OS detection logic requires editing every SSDT individually
- Inconsistencies can arise if some SSDTs are updated while others are not
- Debugging becomes tedious when the same check exists in multiple locations

**Code Inefficiency:**

- Each `_OSI("Darwin")` call adds overhead to ACPI execution
- Larger file sizes due to duplicated code
- More complex DSDT/SSDT compilation

## The Solution: `SSDT-OSDW`

Create a dedicated SSDT that provides a global helper method for macOS detection:

**File: `SSDT-OSDW.dsl`**

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

**How It Works:**

1. **Safety Check**: `CondRefOf (\_OSI)` verifies that the `_OSI` method exists before calling it
2. **Darwin Detection**: Calls `_OSI("Darwin")` to check if macOS is running
3. **Boolean Return**: Returns `One` (true) for macOS, `Zero` (false) for other operating systems

This method is globally accessible from any SSDT loaded after `SSDT-OSDW`.

|Working Principle of `SSDT-OSDW`|
|------|
|<img width="1536" height="1024" alt="SSDT-OSDW" src="https://github.com/user-attachments/assets/c1f32f2f-4e14-4037-b9b1-8b21f7ed4878" />|
|**Figure 1:** Centralized macOS detection using `SSDT-OSDW`. All SSDTs reference the shared helper, keeping ACPI patches modular and maintainable.|

## Refactoring Your SSDTs

To use `OSDW()` in existing SSDTs, make two simple changes:

### 1. Add External Declaration
At the top of each SSDT that needs macOS detection, declare the external method:

```asl
External (OSDW, MethodObj)
```

### 2. Replace `_OSI("Darwin")` with `OSDW()`

**Before:**
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

**After:**
```asl
External (OSDW, MethodObj)

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

Repeat this process for all SSDTs that contain macOS-specific logic.

## Implementation Guide

### Step 1: Add `SSDT-OSDW.aml`

- Download [**SSDT-OSDW.aml**](https://github.com/5T33Z0/OC-Little-Translated/raw/refs/heads/main/Content/01_Adding_missing_Devices_and_enabling_Features/SSDT-OSDW/SSDT-OSDW.aml)
- Add it to `EFI/OC/ACPI` 

### Step 2: Configure OpenCore
Edit your `config.plist` and add `SSDT-OSDW.aml` to `ACPI → Add`. **Critical:** Place it as the **first entry** in the list.

```
ACPI
  └─ Add
       ├─ SSDT-OSDW.aml ← Load first
       ├─ SSDT-EC.aml
       ├─ SSDT-PLUG.aml
       ├─ SSDT-PMC.aml
       └─ ...
```

**Why load order matters:** All SSDTs that reference `OSDW()` must load *after* `SSDT-OSDW.aml` has defined it. Loading order in OpenCore follows the sequence in `config.plist`.

### Step 3: Update Dependent SSDTs
For each SSDT that needs macOS detection:

1. Add `External (OSDW, MethodObj)` at the top
2. Replace all instances of `If (_OSI("Darwin"))` with `If (OSDW())`
3. Recompile the SSDT
4. Replace the `.aml` file in your `EFI/OC/ACPI` folder

### Step 4: Verify
Boot into macOS and check that all hardware features work correctly. Test:

- Sleep/wake functionality
- USB power management
- Brightness controls
- Battery status
- Any other macOS-specific features

Boot into Windows/Linux to confirm that macOS-specific patches remain inactive.

## Design Considerations

### Where Should OS Checks Live?

**Option 1: In the Caller (Recommended)**

```asl
External (OSDW, MethodObj)

Method (_PTS, 1, NotSerialized)
{
    If (OSDW())
    {
        If (CondRefOf (EXT1)) { EXT1(Arg0) }
    }
    ZPTS(Arg0)
}
```

**Advantages:**

- Clear separation between OS detection and functionality
- Helper methods (EXT1, EXT2, etc.) remain OS-agnostic
- Easier to reuse helper methods in different contexts

**Option 2: Inside Helper Methods (Defensive)**

```asl
Method (EXT1, 1, NotSerialized)
{
    If (OSDW())
    {
        // macOS-specific code
    }
}
```

**Advantages:**

- Extra safety if helper might be called from multiple locations
- Self-contained macOS logic

**Recommendation:** Use Option 1 (caller-side checks) for cleaner, more maintainable code. Use Option 2 only when a helper method must be callable from both SSDT and DSDT contexts where OS state isn't guaranteed.

## Benefits

### Maintainability
Change OS detection logic in **one location** instead of editing dozens of files. For example, if you need to add additional checks or logging, modify only `SSDT-OSDW.dsl`.

### Safety
The `CondRefOf (\_OSI)` check prevents errors on systems where `_OSI` might not be implemented. This defensive coding makes your ACPI stack more robust.

### Performance
- Single method call vs. repeated `_OSI` evaluations reduces ACPI overhead
- Smaller compiled SSDT files load faster
- Less memory consumption

Users may notice:

- Faster boot times
- Quicker sleep/wake transitions
- More responsive system behavior

### Scalability
Easily extend for future multi-OS scenarios:

```asl
Method (OSDW, 0, NotSerialized)
{
    If (CondRefOf (\_OSI))
    {
        If (_OSI("Darwin")) { Return (0x01) }      // macOS
        If (_OSI("Windows 2022")) { Return (0x02) } // Windows 11
        If (_OSI("Linux")) { Return (0x03) }        // Linux
    }
    Return (Zero)
}
```

Your SSDTs can then use:
```asl
If (OSDW() == 0x01) { /* macOS code */ }
If (OSDW() == 0x02) { /* Windows code */ }
```

## Comparison: OSDW vs. Direct `_OSI` Calls

| Aspect | OSDW Method | Direct `_OSI("Darwin")` |
|--------|-------------|-------------------------|
| **Code Duplication** | None | High (repeated in every SSDT) |
| **Maintainability** | Excellent (one file to update) | Poor (edit every SSDT) |
| **Consistency** | Guaranteed | Risk of inconsistencies |
| **Safety** | Defensive (`CondRefOf` check) | Assumes `_OSI` exists |
| **File Sizes** | Smaller SSDTs | Larger due to duplication |
| **Debugging** | Simple (single point of failure) | Complex (check each file) |
| **Performance** | Optimized (single method) | Overhead from repeated calls |
| **Organization** | Modular, centralized | Scattered across files |
| **Future Updates** | Easy (modify one helper) | Tedious (update all files) |
| **Reliability** | Higher (tested once, used everywhere) | Lower (each SSDT is a potential failure point) |

## Common Issues and Solutions

### Issue: Compilation Error "OSDW not found"
**Cause:** The SSDT referencing `OSDW()` doesn't have the external declaration.

**Solution:** Add `External (OSDW, MethodObj)` at the top of the SSDT.

### Issue: macOS-specific features don't work
**Cause:** `SSDT-OSDW.aml` loads *after* SSDTs that depend on it.

**Solution:** Move `SSDT-OSDW.aml` to the **top** of the `ACPI → Add` list in `config.plist`.

### Issue: Features work in macOS but also activate in Windows
**Cause:** `OSDW()` check is missing or returns incorrect value.

**Solution:** 
1. Verify `SSDT-OSDW.aml` is loaded (check IOReg)
2. Confirm all OS-specific code is wrapped in `If (OSDW())`
3. Test `OSDW()` return value in ACPI debugger

## Example: Complete Implementation

Here's a practical example showing a complete SSDT conversion:

**Before (SSDT-SLEEP.dsl):**

```asl
DefinitionBlock ("", "SSDT", 2, "HACK", "SLEEP", 0x00000000)
{
    External (_SB.PCI0.LPCB, DeviceObj)
    External (ZPTS, MethodObj)
    External (ZWAK, MethodObj)
    
    Scope (_SB.PCI0.LPCB)
    {
        Method (_PTS, 1, NotSerialized)
        {
            If (_OSI("Darwin"))
            {
                // macOS-specific sleep preparation
            }
            ZPTS(Arg0)
        }
        
        Method (_WAK, 1, NotSerialized)
        {
            If (_OSI("Darwin"))
            {
                // macOS-specific wake code
            }
            Return (ZWAK(Arg0))
        }
    }
}
```

**After (SSDT-SLEEP.dsl):**

```asl
DefinitionBlock ("", "SSDT", 2, "HACK", "SLEEP", 0x00000000)
{
    External (OSDW, MethodObj)
    External (_SB.PCI0.LPCB, DeviceObj)
    External (ZPTS, MethodObj)
    External (ZWAK, MethodObj)
    
    Scope (_SB.PCI0.LPCB)
    {
        Method (_PTS, 1, NotSerialized)
        {
            If (OSDW())
            {
                // macOS-specific sleep preparation
            }
            ZPTS(Arg0)
        }
        
        Method (_WAK, 1, NotSerialized)
        {
            If (OSDW())
            {
                // macOS-specific wake code
            }
            Return (ZWAK(Arg0))
        }
    }
}
```

**Changes:**

1. Added `External (OSDW, MethodObj)` at the top
2. Replaced `If (_OSI("Darwin"))` with `If (OSDW())`
3. No other functional changes required

## Advanced Usage

### Conditional Feature Loading
You can use `OSDW()` to conditionally define entire devices:

```asl
External (OSDW, MethodObj)

If (OSDW())
{
    Scope (_SB.PCI0)
    {
        Device (USBX)
        {
            Name (_ADR, Zero)
            Method (_DSM, 4, NotSerialized)
            {
                // USB power properties for macOS
            }
        }
    }
}
```

### Runtime OS Detection Logging
Add debug output to track OS detection:

```asl
Method (OSDW, 0, NotSerialized)
{
    If (CondRefOf (\_OSI))
    {
        If (_OSI("Darwin"))
        {
            // Optional: Add ACPI debug output
            // Requires SSDT-DEBUG.aml
            \DBG.DLOG("macOS Detected")
            Return (One)
        }
    }
    Return (Zero)
}
```

## Best Practices

1. **Always include the External declaration** in every SSDT that uses `OSDW()`
2. **Load SSDT-OSDW first** in your OpenCore configuration
3. **Test thoroughly** after refactoring, especially sleep/wake cycles
4. **Document your changes** in comments for future reference
5. **Keep a backup** of your working configuration before refactoring
6. **Verify in multiple OSes** to ensure proper gating of macOS-specific features

## Summary

Centralizing macOS detection through `SSDT-OSDW` represents a best practice for OpenCore ACPI configurations. This approach:

✅ Eliminates code duplication across SSDTs  
✅ Provides a single point of maintenance for OS detection  
✅ Improves performance through optimized ACPI execution  
✅ Ensures consistent behavior across your entire ACPI stack  
✅ Makes debugging significantly easier  
✅ Scales elegantly as your configuration grows  

By adopting this method, you create a cleaner, more maintainable Hackintosh that's easier to update and troubleshoot. The initial investment of refactoring your SSDTs pays dividends in long-term reliability and ease of maintenance.

## Credits

I stumbled over this approach while researching Thunderbolt patching in @BenBender's [EFI](https://github.com/benbender/x1c6-hackintosh). It seemed like a smart idea worth presenting to a broader audience.

## Additional Resources

- [ACPI Basics](/Content/00_ACPI/ACPI_Basics/README.md#acpi-basics)
- [ACPI Specification 6.4](https://uefi.org/specifications)

