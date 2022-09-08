/* Combine with SSDT-IPIC.aml.
 *
 * Requires Binary Renames
 * 
 * Comment: HPET WNTF to XXXX
 * Find: 574E5446
 * Replace: 58585858
 * Base: \_SB.PCI0.LPC.HPET (adjust LPC bus path accordingly)
 *
 * Comment: HPET WXPF to YYYY
 * Find: 57585046
 * Replace: 59595959
 * Base: \_SB.PCI0.LPC.HPET (adjust LPC bus path accordingly)
 */

DefinitionBlock ("", "SSDT", 2, "OCLT", "HRTfix", 0x00000000)
{
    External (_SB_.PCI0.LPC_, DeviceObj)
    External (_SB_.PCI0.LPC_.RTC_, DeviceObj)
    External (_SB_.PCI0.LPC_.TIMR, DeviceObj)
    External (WNTF, IntObj)
    External (WXPF, IntObj)

    Scope (\)
    {
        Name (XXXX, One)
        Name (YYYY, Zero)
        If (!_OSI ("Darwin"))
        {
            XXXX = WNTF /* External reference */
            YYYY = WXPF /* External reference */
        }
    }

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

    Scope (_SB.PCI0.LPC)
    {
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
    }
}

