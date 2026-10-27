# Intel Framebuffer Patching Reference Guide

Based on Info extracted from: [https://github.com/acidanthera/WhateverGreen/blob/master/Manual/IntelFramebuffer.bt](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/IntelFramebuffer.bt)

## 1. Connector Types

| Hex Value | Name | Description | Common Use |
|-----------|------|-------------|------------|
| 0x0 | ConnectorZero | Zero/disabled | Unused connectors |
| 0x1 | ConnectorDummy | Dummy connector | Sometimes works as VGA |
| 0x2 | ConnectorLVDS | LVDS/eDP | Built-in laptop displays |
| 0x4 | ConnectorDigitalDVI | Digital DVI | DVI-D ports (NOT eDP) |
| 0x8 | ConnectorSVID | S-Video | Legacy video output |
| 0x10 | ConnectorVGA | VGA | Analog VGA ports |
| 0x400 | ConnectorDP | DisplayPort | DisplayPort outputs |
| 0x800 | ConnectorHDMI | HDMI | HDMI ports (enables digital audio) |
| 0x2000 | ConnectorAnalogDVI | Analog DVI | DVI-A/DVI-I ports |

**Important Notes:**

- Connector type is less critical on newer hardware (Skylake+)
- VGA can work via DP on Kaby Lake
- Index 0 (LVDS) gets special treatment as built-in display

---

## 2. BusID Values (GMBUS IDs)

| BusID | Linux Name | Description | Typical Use |
|-------|------------|-------------|-------------|
| 0x00 | Special | Internal display | Built-in laptop displays |
| 0x02 | GMBUS_PIN_VGADDC | VGA DDC | VGA ports (pre-Skylake) |
| 0x04 | GMBUS_PIN_DPC | HDMIC | HDMI/DP port C |
| 0x05 | GMBUS_PIN_DPB | SDVO/HDMIB | HDMI/DP port B, DVI via SDVO |
| 0x06 | GMBUS_PIN_DPD | HDMID | HDMI/DP port D |

**Best Practices:**

- Use 4, 5, 6 for arbitrary HDMI/DisplayPort displays
- BusID 5 supports SDVO (can handle DVI)
- Skylake+ uses SDVO for VGA instead of dedicated pin

---

## 3. Connector Flags

| Hex Value | Flag Name | Effect | When to Use |
|-----------|-----------|--------|-------------|
| 0x1 | CNAlterAppertureRequirements | Removes aperture memory requirement | Special configurations |
| 0x8 | CNConnectorAlwaysConnected | Marks connector as always connected | Built-in displays (LVDS) |
| 0x40 | CNDisableBlitTranslationTable | Disables blit translation | Special cases |
| 0x80 | CNUseMiscIoPowerWell | Activates MISC IO power well | Additional power requirements |
| 0x100 | CNUsePowerWell2 | Activates Power Well 2 | **Fixes HDMI audio issues** |
| 0x800 | CNIncreaseLaneCount | Increases lane count to 30 (vs 20) | High bandwidth displays |

**Common Values:**

- `0x00000000` - Standard external display
- `0x00000008` - Built-in display (always connected)
- `0x00000108` - External display with HDMI audio fix

---

## 4. Framebuffer Flags

### Critical Flags for Patching

| Hex Value | Flag Name | Effect |
|-----------|-----------|--------|
| 0x1 | FBAvoidFastLinkTraining | Disables fast link training (450MHz vs 540MHz) |
| 0x2 | FBFramebufferCommonMemory | Stolen memory counts all FBs at once (not per-FB) |
| 0x4 | FBFramebufferCompression | Enables framebuffer compression |
| 0x8 | FBEnableSliceFeatures | Enables slice features (Slice SD, EU SD, Dynamic Slice) |
| 0x10 | FBDynamicFBCEnable | Enables dynamic framebuffer compression |
| 0x20 | FBUseVideoTurbo | Enables GPU turbo frequency (default: 14) |
| 0x40 | FBForcePowerAlwaysConnected | Forces power reset on always-connected displays |
| 0x80 | FBDisableHighBitrateMode2 | Limits DP to 8.64 Gbit/s (HBR1 vs HBR2) |
| 0x100 | FBBoostPixelFrequencyLimit | Boosts pixel clock to 540MHz |
| 0x200 | FBLimit4KSourceSize | Limits source size to 4096×4096 |
| 0x400/0x800 | FBAlternatePWMIncrement | Changes backlight PWM (for laptops only) |
| 0x1000 | FBDisableFeatureIPS | Disables Intermediate Pixel Storage |
| 0x4000 | FBAllowConnectorRecover | Allows connector recovery (Camellia v2) |
| 0x200000 | FBEnableDynamicCDCLK | Enables dynamic CD clock |
| 0x800000 | FBSupport5KSourceSize | Enables 5K support (5120×5120) |

---

## 5. Memory Calculations

### Stolen Memory Formula (Haswell/Broadwell)
```
TotalStolen = 0x100000 (1 MB base)
+ (FBFramebufferCommonMemory ? StolenMemorySize : StolenMemorySize × FBMemoryCount)
+ FramebufferMemorySize
```

### Stolen Memory Formula (Skylake+)
```
TotalStolen = 0x100000 (1 MB base)
+ (FBFramebufferCommonMemory ? StolenMemorySize : StolenMemorySize × FBMemoryCount)
+ (FBFramebufferCompression ? FramebufferMemorySize : 0)
```

### Additional Memory
```
CursorMemory = PipeCount × 0x80000
MaxStolen = (StolenMemorySize × FBMemoryCount) + FramebufferMemorySize + 0x100000
MaxOverall = CursorMemory + MaxStolen + (PortCount × 0x1000)
```

**BIOS Setting:** `TotalStolen` must be ≤ DVMT Pre-Allocated memory in BIOS

---

## 6. Connector Structure (Standard)

| Offset | Size | Field | Description |
|--------|------|-------|-------------|
| 0x00 | 1 byte | index | Connector index (0-3, or 0xFF for disabled) |
| 0x01 | 1 byte | busId | GMBUS ID (see BusID table) |
| 0x02 | 1 byte | pipe | Pipe number |
| 0x03 | 1 byte | pad | Padding (must be 0) |
| 0x04 | 4 bytes | type | Connector type (see Connector Types) |
| 0x08 | 4 bytes | flags | Connector flags |

**Total Size:** 12 bytes per connector

### Ice Lake Connector Structure (Wide Format)
| Offset | Size | Field |
|--------|------|-------|
| 0x00 | 4 bytes | index |
| 0x04 | 4 bytes | busId |
| 0x08 | 4 bytes | pipe |
| 0x0C | 4 bytes | pad |
| 0x10 | 4 bytes | type |
| 0x14 | 4 bytes | flags |

**Total Size:** 24 bytes per connector

---

## 7. Common Patching Scenarios

### Enable HDMI Audio
**Problem:** No audio through HDMI/DP  
**Solution:** Set connector flag `0x100` (CNUsePowerWell2)

### Disable Unused Connectors
**Problem:** Too many connectors detected  
**Solution:** Set connector index to `0xFF` (255)

### Fix 4K Display Support
**Problem:** 4K display won't work  
**Solution:** 
- Set flag `0x800000` (FBSupport5KSourceSize)
- Or remove flag `0x200` (FBLimit4KSourceSize)

### Fix Internal Display (Laptop)
**Problem:** Built-in display not detected  
**Solution:**
- Set connector type to `0x2` (LVDS)
- Set connector flag to `0x8` (CNConnectorAlwaysConnected)
- Set index to `0x0`
- Set busId to `0x0`

### Increase Stolen Memory
**Problem:** Graphics glitches, insufficient VRAM  
**Solution:** Increase `fStolenMemorySize` value (must match/be under BIOS DVMT setting)

---

## 8. Generation-Specific Default IDs

| Generation | Default Platform ID | Note |
|------------|---------------------|------|
| Sandy Bridge | Model-dependent | See board-id mapping |
| Ivy Bridge | Various | No universal default |
| Haswell | Various | No universal default |
| Broadwell | Various | No universal default |
| Skylake | 0x19120000 | Without AAPL,ig-platform-id |
| Kaby Lake | 0x59160000 | Without AAPL,ig-platform-id |
| Coffee Lake | 0x3EA50000 | Without AAPL,ig-platform-id |
| Cannon Lake | 0x5A520000 | Without AAPL,ig-platform-id |
| Ice Lake | 0x8A520000 (Real) | 0xFF050000 for simulator |

---

## 9. Port Type Conversion (Skylake+)

| Connector Index | Connector Type | Resulting fPortType |
|-----------------|----------------|---------------------|
| 0 (any type) | Any | 3 (Internal) |
| 1-3 | ConnectorHDMI (0x800) | 1 (HDMI) |
| 1-3 | Other types | 2 (DisplayPort-like) |

---

## 10. Quick Reference: Common Hex Patches

### Connector Example (Hex Format)
```
Index BusID Pipe Pad  Type      Flags
01    05    09   00   00040000  00000000
```
Represents: Index 1, BusID 5, Pipe 9, DVI type, no flags

### Disable Connector
```
FF    00    00   00   00000000  00000000
```

### HDMI with Audio
```
01    06    09   00   00080000  00010000
```
Index 1, BusID 6, Pipe 9, HDMI, with Power Well 2

### Internal Display
```
00    00    00   00   00020000  00000008
```
Index 0, BusID 0, Pipe 0, LVDS, always connected

---

## Notes
- All values are little-endian in actual patches
- Framebuffer patches require `WhateverGreen.kext`
- Always backup original kext before patching
- BIOS DVMT settings must accommodate stolen memory requirements
