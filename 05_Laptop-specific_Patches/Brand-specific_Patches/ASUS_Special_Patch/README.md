# ASUS Laptop Patch

## Requirements

- Check if the following `Method` and `Name` are present in ACPI, if not ignore the contents of this chapter.
  - `Name`: OSFG
  - `Method` : MSOS

## Special Rename
Some ASUS machines have the variable `PNLF` in the `DSDT`, which may conflict with the same name as the brightness patch, so use the above name change to avoid it.

```text
Comment: Change PNLF to XNLF
Find: 504E4C46
Replace: 584E4C46
```

## Special SSDT Patch

***SSDT-OCWork-asus***

  - The ``MSOS`` method is present on most Asus machines. The ``MSOS`` method assigns a value to `OSFG` and returns the current state value, which determines the machine's operating mode. 
  - For example, the ACPI brightness shortcut method works only when ``MSOS`` >= ``0x0100``. In the default state, `MSOS` is locked to `OSME`. 
  - **This patch** changes ``MSOS`` by changing ``OSME``. See DSDT's `Method (MSOS...` for details on the `MSOS` method.
    - `MSOS` >= `0x0100``, win8 mode, brightness shortcut works
  	- `MSOS` return value depends on the OS itself, in black apple state you must use **OS patch** or use **this patch** to meet specific requirements.
  
