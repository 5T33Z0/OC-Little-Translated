# Mapping USB ports via ACPI without a replacement Table

## About
In the previous chapter we replaced the original USB port mapping table by our own to enable and disable ports for macOS only. This approach requires to drop and replace the ordinal table and takes a lot of effort.

But there's a simpler method to achieve the same: instead of rewriting the whole USB port mapping table, we just use a binary rename to reroute calls to the `UPC` method to `XUPC` and add an SSDT to only modify the 2 relevant packets of the `UPC` for each port which are then 
handed over to the `GUPC` method inside the Root Hub to enable/disable a port and the type of connection it has.

## Explanation

Let's have a look at the original `GUPC` method:

```asl
Method (GUPC, 1, Serialized)
{
    Name (PCKG, Package (0x04)
    {
        Zero, // 1st packet. Determines if a port is on or off
        0xFF, // 2nd packet. Determines the type of port
        Zero, 
        Zero
    })
    PCKG [Zero] = Arg0
    Return (PCKG)
}
```
Now we modify this method. Since this method is serialized, we can add judgment statements to determine the state and type of each port by using the `USBP += One` operator:

```asl
 ···               
     If (((USBP == 0x04) || (Arg0 == Zero))) // Here we add the ports that should be disabled when macOS is running
     {
         PCKG [Zero] = Zero // Zero = disabled
     }

     If ((((USBP == 0x04) || (USBP == 0x05)) || (USBP == 0x06))) // Here we enter the ports which shuld be changed (in this case Ports 4, 5 and 6)
     {
         PCKG [One] = 0xFF // 0xFF = internal
     }
···
```

Then we combine both, add the If (_OSI ("Darwin")) method and catch calls to the `UPC` method and end up with this, called `SSDT-GUPC`:

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

                If ((((USBP == 0x04) || (USBP == 0x05)) || (USBP == 0x06))) // Change Port type for ports listed here
                {
                    PCKG [One] = 0xFF // Port Type: Internal (in this example) 
                }

                Return (PCKG) 
            }
            Else
            {
                Return (XUPC(Arg0))
            }
        }
    }
}
```

## Patching Principle
:warning: Before attempting this method, make sure to disable any previously created replacement USB tables and corresponding drop rules and USBPort.kexts!

### 1. Prepare SSDT-GUPC.aml
- Copy the code for SSDT-GUPC from above into maciASL
- Modify the `USBP += One` section as indicated
- Export the file as `SSDT-GUPC.aml`
- Add it to `EFI/OC/ACPI` and config.plist under `ACPI/Add`

### 2. Add binary rename
-  Under ACPI/Patch, add the following:
	
	```
	Comment: USB GUPC to XUPC
	Find: 47 55 50 43 09
	Replace: 58 55 50 43 09
	```

## Notes and Credits
- In my tests, I couldn't get this to work as intended. I don't understand how to address the different Port types (HS, SS and USR) that are present in my OEM USB Port Table. I don't have `USBP` in my table. Maybe it has to be replaced by rules/names that represent the port types, like: `NHSP` (for HS ports), `NSSP` (for SS) and `USRA` (for USR)? Anyway, if you find a solution, let me know.
- Original [**Blog Post**](https://blog-gzxiaobai-cn.translate.goog/post/利用GUPC以热补丁定制USB端口?_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=de&_x_tr_pto=wapp) by [**GZXiaoBai**](https://github.com/GZXiaoBai)