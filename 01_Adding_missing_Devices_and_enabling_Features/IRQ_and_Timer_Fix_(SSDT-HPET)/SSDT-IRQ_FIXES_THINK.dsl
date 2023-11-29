/* 
 * Fixes HPET,RTC,TIMR and IPIC if both WNTF and WXPF preset variable are used 
 * to enable/disable HPET. This is usually the case on Lenovo ThinkPad up to 
 * 6th Gen Skylake.
 * NOTE: Adjust LPC/LPCB path and IPIC/PIC name according to the device names 
 * and paths used in your system's DSDT!
 */
DefinitionBlock ("", "SSDT", 2, "5T33Z0", "FixIRQs", 0x00000000)
{
    External (_SB_.PCI0.LPC_, DeviceObj)
    External (_SB_.PCI0.LPC_.HPET, DeviceObj)
    External (_SB_.PCI0.LPC_.PIC_, DeviceObj)
    External (_SB_.PCI0.LPC_.RTC_, DeviceObj)
    External (_SB_.PCI0.LPC_.TIMR, DeviceObj)
    External (WNTF, IntObj)
    External (WXPF, IntObj)

    //disable HPET
    Scope (_SB.PCI0.LPC.HPET)
    {
        If (_OSI ("Darwin"))
        {
            WNTF = One
            WXPF = Zero
        }
    }

    //disable RTC
    Scope (_SB.PCI0.LPC.RTC)
    {
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If (_OSI ("Darwin"))
            {
                Return (Zero)
            }
            Else
            {
                Return (0x0F)
            }
        }
    }

    //disable TIMR
    Scope (_SB.PCI0.LPC.TIMR)
    {
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If (_OSI ("Darwin"))
            {
                Return (Zero)
            }
            Else
            {
                Return (0x0F)
            }
        }
    }
    
    //disable PIC/IPIC
    Scope (_SB.PCI0.LPC.PIC)
    {
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If (_OSI ("Darwin"))
            {
                Return (Zero)
            }
            Else
            {
                Return (0x0F)
            }
        }
    }

    Scope (_SB.PCI0.LPC)
    {
        //Add Fake HPE0
        Device (HPE0)
        {
            Name (_HID, EisaId ("PNP0103") /* HPET System Timer */)  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (BUF0, ResourceTemplate ()
            {
                IRQNoFlags ()
                    {0,8}
                Memory32Fixed (ReadWrite,
                    0xFED00000,         // Address Base
                    0x00000400,         // Address Length
                    )
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                Return (BUF0) /* \_SB_.PCI0.LPC_.HPE0.BUF0 */
            }
        }
        //Add Fake RTC
        Device (RTC0)
        {
            Name (_HID, EisaId ("PNP0B00") /* AT Real-Time Clock */)  // _HID: Hardware ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                IO (Decode16,
                    0x0070,             // Range Minimum
                    0x0070,             // Range Maximum
                    0x01,               // Alignment
                    0x02,               // Length
                    )
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }
        //Fake TIMR
        Device (TIM0)
        {
            Name (_HID, EisaId ("PNP0100") /* PC-class System Timer */)  // _HID: Hardware ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                IO (Decode16,
                    0x0040,             // Range Minimum
                    0x0040,             // Range Maximum
                    0x01,               // Alignment
                    0x04,               // Length
                    )
                IO (Decode16,
                    0x0050,             // Range Minimum
                    0x0050,             // Range Maximum
                    0x10,               // Alignment
                    0x04,               // Length
                    )
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }
        //Add Fake IPIC
        Device (IPI0)
        {
            Name (_HID, EisaId ("PNP0000"))
            Name (_CRS, ResourceTemplate ()
            {
                IO (Decode16,
                    0x0020,
                    0x0020,
                    0x01,
                    0x02,
                    )
                IO (Decode16,
                    0x00A0,
                    0x00A0,
                    0x01,
                    0x02,
                    )
                IO (Decode16,
                    0x04D0,
                    0x04D0,
                    0x01,
                    0x02,
                    )
                // Remove IRQNoFlags
                /*
                 * IRQNoFlags ()
                 * {2}
                 */
            })          
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }
    }
}

