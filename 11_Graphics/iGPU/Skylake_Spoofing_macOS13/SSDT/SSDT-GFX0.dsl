DefinitionBlock ("", "SSDT", 2, "5T33Z0", "HD530", 0x00001000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.GFX0, DeviceObj)

    Scope (\_SB.PCI0)
    {
        Scope (GFX0)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }

        Device (IGPU)
        {
            Name (_ADR, 0x00020000)  // _ADR: Address
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03
                    })
                }

                If (_OSI ("Darwin 21"))    // = macOS Monterey
                {
                    Return (Package (0x24)
                    {
                        "device-id", 
                        Buffer (0x04)
                        {
                             0x12, 0x19, 0x00, 0x00
                        }, 

                        "AAPL,ig-platform-id", 
                        Buffer (0x04)
                        {
                             0x05, 0x00, 0x3B, 0x19
                        }
                    })
                }

                If (_OSI ("Darwin 22"))    // = macOS Ventura
                {
                    Return (Package (0x30)
                    {
                        "device-id", 
                        Buffer (0x04)
                        {
                             0x26, 0x59, 0x00, 0x00
                        }, 

                        "AAPL,ig-platform-id", 
                        Buffer (0x04)
                        {
                             0x02, 0x00, 0x26, 0x59
                        }
                    })
                }

                If (_OSI ("Darwin 23"))    // = macOS Sonoma
                {
                    Return (Package (0x30)
                    {
                        "device-id", 
                        Buffer (0x04)
                        {
                             0x26, 0x59, 0x00, 0x00
                        }, 

                        "AAPL,ig-platform-id", 
                        Buffer (0x04)
                        {
                             0x02, 0x00, 0x26, 0x59
                        }
                    })
                }

                If (_OSI ("Darwin 24"))    // = macOS Sequoia
                {
                    Return (Package (0x30)
                    {
                        "device-id", 
                        Buffer (0x04)
                        {
                             0x26, 0x59, 0x00, 0x00
                        }, 

                        "AAPL,ig-platform-id", 
                        Buffer (0x04)
                        {
                             0x02, 0x00, 0x26, 0x59
                        }
                    })
                }

                If (_OSI ("Darwin 25"))    // = macOS ???
                {
                    Return (Package (0x30)
                    {
                        "device-id", 
                        Buffer (0x04)
                        {
                             0x26, 0x59, 0x00, 0x00
                        }, 

                        "AAPL,ig-platform-id", 
                        Buffer (0x04)
                        {
                             0x02, 0x00, 0x26, 0x59
                        }
                    })
                }

                Return (Zero)
            }
        }
    }
}

