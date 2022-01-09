# Enabling General-purpose I/O (`SSDT-GPIO`)
## Description

- If `GPI0` should be enabled, its `_STA` must `Return (0x0F)`.
- The sample is for reference only. Verify the presence of `GPEN` or `GPHD` in the `_STA` of the GPI0 device when using it. See Binary Renaming and Preset Variables for details.
