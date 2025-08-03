DefinitionBlock ("", "SSDT", 2, "USBMAP", "USB_MAP", 0x00001000)
{
    External (_SB_.PCI0.EH01.HUBN, DeviceObj)
    External (_SB_.PCI0.EH02.HUBN, DeviceObj)
    External (_SB_.PCI0.EHC_.HUBN, DeviceObj)
    External (_SB_.PCI0.SHCI.RHUB, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB, DeviceObj)

    
    Scope (\_SB.PCI0.EH01.HUBN)  // `Scope` - referencing to the HUB in DSDT
    {
        Method (_STA, 0, NotSerialized)  
        {
            If (_OSI ("Darwin"))
            {
                Return (Zero) // Disable original RHUB/HUBN if macOS
            }
            Else
            {
                Return (0x0F) // Enable if other OS
            }
        }
    }
    
    
    /*
    
    ^ Adjust and duplicate if you have both.
    
        EH01:  Scope (\_SB.PCI0.EH01.HUBN)
        EH02:  Scope (\_SB.PCI0.EH02.HUBN)
        SHCI:  Scope (\_SB.PCI0.SHCI.RHUB)
        XHC:   Scope (\_SB.PCI0.XHC_.RHUB)
    
    */ 
    
    

    Device (\_SB.PCI0.EH01.HUBX) // We add a new Hub `Device`, since RHUB or HUBN status is disabled.
    {
        Name (_ADR, Zero)  // Re-adding the _ADR (Address) of the RHUB/HUBN under the XHC/EHC USB Controller. RHUB or HUBN always have it `Zero`.
        Method (_STA, 0, NotSerialized)  
        {
            If (_OSI ("Darwin"))
            {
                Return (0x0F) // Only enable if macOS
            }
            Else
            {
                Return (Zero) // Disabled for other OS
            }
        }
    }

    /*
    
    ^ Adjust and duplicate if you have both.
    
        EH01:  Device (\_SB.PCI0.EH01.HUBX)
        EH02:  Device (\_SB.PCI0.EH02.HUBX)
        SHCI:  Device (\_SB.PCI0.SHCI.XHUB)
        XHC:   Device (\_SB.PCI0.XHC_.XHUB)
    
    */ 

    Device (\_SB.PCI0.EH01.HUBX.PR01) // Under HUBX, we add the Port such as PR01
    {
        Name (_ADR, One)  // Each port has unique _ADR, please take their _ADR from the DSDT, and add them in each port under HUBX.
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            Return (Package (0x04)
            {
                0xFF, // PR01's active
                0xFF, // It's Internal
                Zero, 
                Zero
            })
        }
    }
    
    /*
    
    Append if there are another port:
    Such as:
		Device (\_SB.PCI0.EH01.HUBX.PR02) // for PR02
    		{
		Name (_ADR, 0x02) // _ADR of PR02
		...
		}
    */
    

    Device (\_SB.PCI0.EH01.HUBX.PR01.PR12) // It happens that some ports are also a HUB. In this case, PR01 is. So under PR01, we add a PR12
    {
        Name (_ADR, One) // _ADR of PR12
        Method (_UPC, 0, Serialized)       
        {
            Return (Package (0x04)
            {
                0xFF, // It's Active
                0x00, // It's USB 2.0
                Zero, 
                Zero
            })
        }
        /*
    
        Append if there are another port under this HUB port.
    
        */
    }
}
