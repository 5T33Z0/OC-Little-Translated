## ACPI Custom USB Port

## Description

- This method customizes the USB port by modifying the ACPI file.
- It requires dropoing an ACPI file.
- This method is aimed at hobbyists.

## Scope of Application

- `XHC` and its `_UPC` exist in a separate ACPI file
- This method does not work with devices where `_UPC` is present in the `DSDT` (e.g. ASUS)

## `_UPC` Specification

```swift
_UPC, Package ()
	
	{
   		xxxx,
    	yyyy,
    	0x00,
    	0x00
	}
```

### Explanation

1. **`xxxx`**
   - if `0x00`: port does not exist
   - if `0x0F`: port exists

2. **`yyyy`**: defines the type of the port, refer to the following table

	According to the ACPI Specifications about [USB Port Capabilities](https://uefi.org/specs/ACPI/6.4/09_ACPI-Defined_Devices_and_Device-Specific_Objects/ACPIdefined_Devices_and_DeviceSpecificObjects.html#upc-return-package-values), the USB Types are declared by different bytes. Here are some common ones found on current mainboards:

	| yyyy   | Info                           | Comment |
|:------:|--------------------------------|---------|
|**0x00**| Type-A connector, USB 2.0-only | This is what macOS will default all ports to if no map is present. The pysical connector is usually colored black|
|**0x01**| USB `Mini-AB` | Used on older smart phones. Kind of outdated.
|**0x02**| USB Smart Card |
|**0x03**| Type-A connector, USB 2.0 and USB 3.0 combined | USB 3.0, 3.1 and 3.2 ports share the same Type. Usually colored blue (USB 2.0/3.0) or red (USB 3.2)|
| **0x04** | USB 3 Standard Type `B` |
| **0x05** | USB 3 `Micro-B` |
| **0x06** | USB 3 `Micro-AB` |
| **0x07** | USB 3 `Power-B` |
|**0x08**| Type C connector, USB 2.0 only | Mainly used in phones|
|**0x09**| Type C connector, USB 2.0 and USB 3.0 with Switch | Flipping the device does not change the ACPI port |
|**0x0A**| Type C connector, USB 2.0 and USB 3.0 w/o Switch |Flipping the device does change the ACPI port. generally seen on USB 3.1/3.2 mainboard headers|
|**0xFF**| Proprietary Connector | For Internal USB 2.0 ports like Bluetooth|

	We will need use these "Type" bytes to declare the USB Port types.

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

    ```swift
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
