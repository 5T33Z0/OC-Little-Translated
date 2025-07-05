# Add Intel Management Engine (`SSDT-IMEI`)
Adds **Intel Management Engine** (IMEI) to the device tree, if it does not exist in your system's `DSDT`. IMEI is required for proper hardware video decoding on Intel iGPUs. Adding IMEI is only required in two cases:

- Sandy Bridge CPUs running on 7-series mainboards or
- Ivy Bridge CPUs running on 6-series mainboards

In other words: adding this device is only necessary if you combine a 2nd Gen Intel Core CPU with a 3rd Gen mainboard or 3rd Gen CPU with a 2nd Gen mainboard!

## Prerequisites
To find out if you need this SSDT, do the following:

- Ensure you have Lilu and Whatevergreen kexts present and enabled.
- Enter `ioreg | grep IMEI` in Terminal to check if `IMEI` is present in IO Registry
- Terminal should report its device path and status, similar to this:</br>
	`| |   +-o IMEI@16  <class IOPCIDevice, id 0x100000200, registered, matched, active, busy 0 (26 ms), retain 10>`

In this case, you don't need `SSDT-IMEI`. But if Terminal just returns an empty line and you have a Sandy/Ivy Bridge CPU, then you need this SSDT!

## Instructions
In **DSDT**, search for:

`0x00160000`

If missing, add ***SSDT-IMEI*** to the `EFI/OC/ACPI` folder and `config.plist` (ACPI/Add).

> [!CAUTION]
> 
> Ensure that the ACPI path of the LPC Bus (`LPC` or `LPCB`) used in the SSDT is identical with the one used in your system's `DSDT`! 
