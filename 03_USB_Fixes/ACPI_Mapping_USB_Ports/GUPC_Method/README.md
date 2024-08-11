# Mapping USB ports via ACPI without a replacement table

## About
As shown earlier in this chapter, writing a replacement USB port mapping table for macOS takes a lot of effort. 

But there's a simpler way to achieve the same: instead of rewriting the *whole* USB port mapping table, you can a use binary rename to reroute calls to the `GUPC` method to `XUPC` and add a `SSDT-GUPC` instead to disable ports and change port types in order to work around macOS' port limit of 15 ports.

## Explanation

Let's have a look at the original `GUPC` method:

```asl
Method (GUPC, 1, Serialized)
{
    Name (PCKG, Package (0x04)
    {
        Zero, // 1st packet. Determines if a port is on or off
        0xFF, // 2nd packet. Determines the type of port. 0xFF = Type: 255 = Internal Connector
        Zero, 
        Zero
    })
    PCKG [Zero] = Arg0
    Return (PCKG)
}
```

The `GUPC` method takes one argument (`Arg0`) and is serialized, meaning only *one* thread of execution can run it at a time. It creates a package (`PCKG`) with four elements (`0x04`), in this example: `Zero`, `0xFF`, `Zero`, and `Zero`, whereby the first packet is used to enable/disable a port (`One` or `Zero`), while 2nd packet sets the type of port – in the example above: `0xFF` for internal connector (as required for Bluetooth cards).

We can use the following SSDT to modify the availability of USB Ports as well as the port types:

```asl
DefinitionBlock ("", "SSDT", 2, "INTEL", "GUPC", 0x00000000)
{
    External (_SB.PCI0.XHC.RHUB, DeviceObj)
    External (_SB.PCI0.XHC.RHUB.XUPC, MethodObj)
    
    Scope (_SB.PCI0.XHC.RHUB)
    {
        Name (USBP, Zero)
        Method (GUPC, 1, Serialized)
        {
            If (_OSI ("Darwin"))
            {
                Name (PCKG, Package (0x04)
                {
                    0xFF, 
                    0x03, 
                    Zero, 
                    Zero
                })
                USBP += One
                If (((USBP == 0x04) || (Arg0 == Zero))) // Add Ports which should be disabled
                {
                    PCKG [Zero] = Zero // Return package 0 = disabled
                }

                If ((((USBP == 0x04) || (USBP == 0x05)) || (USBP == 0x06))) // Change Port type for the ports listed here
                {
                    PCKG [One] = 0xFF // Port Type: Internal (in this example) 
                }

                Return (PCKG) 
            }
            Else
            {
                Return (XUPC(Arg0)) // Uses the original values for any other OS
            }
        }
    }
}
```

**Explanation**

This SSDT contains a method named `GUPC` within the scope of `_SB.PCI0.XHC.RHUB`. Let's break it down:

- If the OS is Darwin (macOS), it creates a package (`PCKG`) with four elements: `0xFF`, `0x03`, `Zero`, and `Zero`.
- `USBP += One` increments the value of `USBP` by one. This is a port counter
- The "If" block checks conditions based on the value of `USBP` and the input argument (`Arg0`):
	- If `USBP` equals `0x04` or if `Arg0` is `zero`, it sets the first element of `PCKG` to zero. In other words: it disables the port
	- If `USBP` equals `0x04`, `0x05`, or `0x06`, it sets the second element of PCKG to `0xFF`, which changes the port to internal
   - Returns the package PCKG after the conditions are checked.
- `Else` Block: If the OS is not Darwin (macOS), it returns the result of `XUPC(Arg0)` – in other words: it uses the unmodified USB port mapping as defined in the systems ACPI layer.

With this, we now have means to enable/disable ports:

```asl
···               
If (((USBP == 0x04) || (Arg0 == Zero)))
{
	PCKG [Zero] = Zero
}
```
This segment checks if `USBP` equals `0x04` (= the forth port detected) or if `Arg0` is zero, and if so, it sets the first element of PCKG to `zero`, which disables the port. So if you want disable different ports you just add them to the the "If" expression, e.g.:

```asl
···               
If (((USBP == 0x01) || (USBP == 0x02) || (USBP == 0x03) (Arg0 == Zero))) // Disables ports 01, 02, 03 and ports where the value for Arg0 is 0
{
	PCKG [Zero] = Zero
}
...
```

The following part checks if `USBP` is `0x04`, `0x05`, or `0x06` and if so, it sets the second element of `PCKG` to `0xFF` (changes the USB port to internal):

```asl
··· 
If ((((USBP == 0x04) || (USBP == 0x05)) || (USBP == 0x06))) // Here we add the ports which should be enable (in this case Ports 4, 5 and 6)
	{
		PCKG [One] = 0xFF // 0xFF = internal
	}
···
```
The following values for USB port types are possible:

| Value  | Port Type |       
| :----: | ----------|
|**`0X00`**| USB Type `A` |
|**`0x01`**| USB `Mini-AB` |
|**`0x02`**| USB Smart Card |
|**`0x03`**| USB 3 Standard Type `A` |
|**`0x04`**| USB 3 Standard Type `B` |
|**`0x05`**| USB 3 `Micro-B` |
|**`0x06`**| USB 3 `Micro-AB` |
|**`0x07`**| USB 3 `Power-B` |
|**`0x08`**| USB Type `C` (USB 2 only) |
|**`0x09`**| USB Type `C` (with Switch) | 
|**`0x0A`**| USB Type `C` (w/o Switch) | 
|**`0xFF`**| Internal USB 2 port|

The most connector types nowadays are:

| Value  | Port Type |       
| :----: | ----------|
|**`0X00`**| USB 2, Type `A` |
|**`0x03`**| USB 3, Type `A` |
|**`0x09`**| USB Type `C` (with Switch) | 
|**`0x0A`**| USB Type `C` (w/o Switch) | 
|**`0xFF`**| Internal USB 2 port (for Bluetooth connectors)|

## Patching Principle

### 1. Prerequisites
- Backup your current EFI folder on a FAT32 formatted USB flash drive – just in case something goes wrong and your system wont boot.
- Disable previously used USB port patches, like:
	- Custom SSDTs containing a replacement USB port mapping table and the corresponding drop rule (located under `ACPI/delete`)
	- USBPort kexts

### 2. Prepare `SSDT-GUPC.aml`
- Copy the code for `SSDT-GUPC` from above into maciASL
- Modify the `USBP += One` section as indicated
- Export the file as `SSDT-GUPC.aml`
- Add it to `EFI/OC/ACPI` and config.plist under `ACPI/Add`

### 3. Add binary rename
-  Under `ACPI/Patch`, add the following rename:
	
	```
	Comment: USB GUPC to XUPC
	Find: 4755504309
	Replace: 5855504309
	```

## Notes and Credits
- In my tests, I couldn't get this guide work. But unitedastronomer has found [a working solution](https://github.com/unitedastronomer/miscellaneous-hackintosh-guides/tree/main/SSDT_USB_Mapping)
- Original [**Blog Post**](https://blog-gzxiaobai-cn.translate.goog/post/利用GUPC以热补丁定制USB端口?_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=de&_x_tr_pto=wapp) by [**GZXiaoBai**](https://github.com/GZXiaoBai)
- Original OC-Litte issue: **https://github.com/daliansky/OC-little/issues/18**
