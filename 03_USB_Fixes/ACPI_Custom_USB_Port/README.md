## ACPI Custom USB Port

## Description

- This method customizes the USB port by modifying the ACPI file.
- This method requires drop of an ACPI file. In general, OpenCore **does not recommend** doing this, and the ***Hackintool.app*** tool is generally used to customize USB ports.
- This method is aimed at hobbyists.

## Scope of Application

- `XHC` and its `_UPC` exist in a separate ACPI file
- This method does not work with devices where `_UPC` is present in the `DSDT` (e.g. ASUS)

## `_UPC` Specification

	_UPC, Package ()
	{
   		xxxx,
    	yyyy,
    	0x00,
    	0x00
	}


### Explanation

1. **`xxxx`**
   - `0x00` means the port does not exist
   - Other values (usually `0x0F`) mean that the port exists

2. **`yyyy`**

   **`yyyy`** defines the type of the port, refer to the following table

   | **`yyyy`**   | Port Type | | |
   | :----------: | -----------|-----------| ------|
   | USB Type `A` |
   | `0x01`       | USB `Mini-AB` |
   | `0x02`       | USB Smart Card |
   | `0x03`       | USB 3 Standard Type `A` |
   | `0x04`       | USB 3 Standard Type `B` |
   | `0x05`       | USB 3 `Micro-B` |
   | `0x06`       | USB 3 `Micro-AB` |
   | `0x07`       | USB 3 `Power-B` |
   | `0x08`       | USB Type `C` **(USB 2 only)** |
   | `0x09`       | USB Type `C` **(with steering)** | `0x09` | USB Type `C` **(with steering)**
   | `0x0A` | USB Type `C` **(without steering)** | `0xFF` | USB Type `C` **(without steering)**
   | `0xFF` | Built-in |

   > If both sides of the USB-C are plugged into the same port on Hackintool, it means that the port has a steering device.
   >
   > Conversely, if both sides of the port are occupied by two ports, it means there is no steering

## USB Customization Process

- Clear patches, drivers, etc. for other customization methods.
- Drop ACPI file

  - Confirm `XHC` and include the ACPI file for `_UPC`
    > e.g. ***SSDT-2-xh_OEMBD.aml*** for dell5480  
    > e.g. ***SSDT-8-CB-01.aml*** for the Xiaoxin PRO13 (i5) (***SSDT-6-CB-01.aml*** for a machine without solo display)
  - In `config\ACPI\Delete\`, set `TableLength` (decimal) and `TableSignature`.
  
  **Examples**:
 
  - **Dell 5480:**`TableLength`** = `2001`; **`TableSignature`** = `53534454` (SSDT)
  - **Xiaoxin PRO13 (i5)**: **`TableLength`** = `12565`, **`TableSignature`** = `53534454` (SSDT)

- Customize SSDT patch file
  - Drag the original ACPI file that needs to be dropped to the desktop, **Recommendation:**
    - Save as `.asl / .dsl` format
    - Change the file name. For example: ***SSDT-xh_OEMBD_XHC.dsl***, ***SSDT-CB-01_XHC.dsl***
    - Change the `OEM Table ID` inside the file to a name of your choice.
    - Exclude errors.
    - Add the following code to the top of `_UPC` for all ports in the SSDT file.

    ```Swift
    Method (_UPC, 0, NotSerialized)
    {
        If (_OSI ("Darwin"))
        {
            Return (Package ()
            {
                xxxx,
                yyyy,
                0x00,
                0x00
            })
        }
        /* Here is the original content */
        ...
    }
    ```

  - Customize the USB port according to the `_UPC` specification. I.e., fix the values of xxxx, yyyy.

    - If the port does not exist
      - **`xxxx`** = `0x00`
      - **`yyyy`** = `0x00`
    - If the port exists
      - **`xxxx`** = `0xFF`
      - **`yyyy`**

    > Refer to the table above
  
  - Troubleshoot, compile, put patch file to `ACPI`, add patch list.

### Reference Examples

- ***SSDT-xh_OEMBD_XHC***
- ***SSDT-CB-01_XHC***
