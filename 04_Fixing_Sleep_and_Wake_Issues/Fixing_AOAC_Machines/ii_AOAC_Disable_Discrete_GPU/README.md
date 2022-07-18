## AOAC – Disabling Discrete Graphics Card

## Description
The patch method in this article only applies to machines with `AOAC` technology. Ignore this method when using the `DeviceProperties` or `boot-args` to disable the discrete GPU. For Laptops with `AOAC` technology it is recommended to disable the discrete GPU in order to extend the battery life and standby time of the machine. 

## Example of `SSDT` patch
- Patch 1: ***SSDT-NDGP_OFF-AOAC***
  - Query the name and path of the Solo display to confirm the existence of the `_ON` and `_OFF` methods.
  - Refer to the example and change the name and path to match the query result.
- Patch 2: ***SSDT-NDGP_PS3-AOAC***
  - Query the name and path of the Solo display and confirm the existence of `_PS0`, `_PS3` and `_DSM` methods.
  - Refer to the example and change the name and path to match the query result
- **Notes**
  - When querying for the name and path of the Solo display and `_ON`, `_OFF`, `_PS0`, `_PS3` and `_DSM`, all `ACPI` files should be searched, which may exist in the `DSDT` file or other `SSDT` files of `ACPI`.
  - The above 2 examples are custom patches for Xiaoxin PRO13, use one of the two options. The name and path of the Solo is: `_SB.PCI0.RP13.PXSX` .

## Note
- If both ***SSDT-NDGP_OFF*** and ***SSDT-NDGP_PS3*** meet the usage requirements, priority will be given to ***SSDT-NDGP_OFF***
- Refer to "SSDT Shield Solo Display Method" for detailed shield solo display method
