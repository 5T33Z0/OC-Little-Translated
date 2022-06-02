# Add Intel Management Engine (`SSDT-IMEI`)
Adds Intel Management Engine (IMEI) to the device tree, if it does not exist in your system's `DSDT`. IMEI is required for proper hardware video decoding on Intel iGPUs. Adding IMEI is only required in two cases:

- Sandy Bridge CPUs running on 7-series mainboards or
- Ivy Bridge CPUs running on 6-series mainboards

In other words: adding this device is only necessary if you combine a 2nd Gen Intel Core CPU with a 3rd Gen mainboard or 3rd Gen CPU with a 2nd Gen mainboard!

## Instructions

In **DSDT**, search for:

`0x00160000`. If missing, add ***SSDT-IMEI*** to ACPI Folder and Config.

**CAUTION:** When using this patch, make sure that the device path of the low pin configuration bus (`LPC`/`LPCB`) is consistent with the one used in the original `DSDT`.
