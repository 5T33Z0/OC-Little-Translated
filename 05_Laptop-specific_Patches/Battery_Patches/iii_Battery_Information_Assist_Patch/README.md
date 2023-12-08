# Battery Information Patch

## Overview

The latest ***VirtualSMC.kext*** and its plugin ***kexts*** provide an interface for displaying battery status information. By customizing the SSDT with the driver, you can display the `PackLotCode`, `PCBLotCode`, `Firmware Version`, `Hardware Correction` and `Battery Correction` of the battery, etc. This patch is from ***VirtualSMC.kext*** official patch with some adjustments. This patch has no master/slave relationship with the main `Battery` patch. This patch is applicable to all laptops.

### Patch Notes
- In the ACPI specification, `_BST` defines some battery information, which is injected in this patch via methods `CBIS` and `CBSS`. Please refer to the ACPI specification for details on the definition of `_BST`.

- In order to be able to use this patch on **machines which do not require the `Battery` patch**, the `B1B2` method has been added under the battery path of the sample patch

### SSDT-BATS-PRO13 Example

- `Battery` path: `_SB.PCI0.LPCB.H_EC.BAT1` Use to ensure that the original ACPI battery path is the same as the example battery path  

- `CBIS` Method:
  - Find the corresponding variable according to the content of `_BST` and write it to B1B2 by `Low Byte` and `High Byte`. e.g.:PKG1 [0x02]=B1B2 ( `FUSL`, `FUSH` ), if this variable is double byte, refer to the method of battery patch splitting data to split and redefine the data.
  - If you can't confirm the variable, you can check the battery related information under win or Linux [**unverified**] and fill in its content directly. For example: `Firmware version` is 123, make PKG1 [0x04] = B1B2 (0x23, 0x01)
- `CBSS` method

  Data filling method is the same as `CBIS` 
  
  **Note 1**: If you don't need to fill in anything, delete `PKG1 [Zero]=... ` to `PKG1 [0x06]=... `, see example  
  **Note 2**: The `CBSS` method cannot be deleted
