//
DefinitionBlock ("", "SSDT", 2, "Hack", "Matty", 0x00000000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.PEG0, DeviceObj)
    External (_SB_.PCI0.PEG0.PEGP, DeviceObj)
    External (OSDW, MethodObj)    // 0 Arguments

    Scope (\_SB)
    {
        Scope (PCI0)
        {
            Scope (PEG0)
            {
                Scope (PEGP)
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

                Device (EGP0)
                {
                    Name (_ADR, Zero)  // _ADR: Address
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

                    Device (EGP1)
                    {
                        Name (_ADR, Zero)  // _ADR: Address
                        Device (GFX0)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                            {
                                If ((Arg2 == Zero))
                                {
                                    Return (Buffer (One)
                                    {
                                         0x03                                             // .
                                    })
                                }

                                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                                {
                                    If (OSDW ())
                                    {
                                        Return (Package (0x02)
                                        {
                                            0x69, 
                                            0x03
                                        })
                                    }
                                    Else
                                    {
                                        Return (Package (0x02)
                                        {
                                            0x69, 
                                            0x03
                                        })
                                    }
                                }

                                Return (Package (0x14)
                                {
                                    "AAPL,slot-name", 
                                    Buffer (0x19)
                                    {
                                        "Slot-1@0,1,0/0,0/0,0/0,0"
                                    }, 

                                    "@0,ATY,EFIDisplay", 
                                    Buffer (0x04)
                                    {
                                        "DP1"
                                    }, 

                                    "ATY,EFIVersionB", 
                                    Buffer (0x10)
                                    {
                                        /* 0000 */  0x31, 0x31, 0x33, 0x2D, 0x44, 0x31, 0x38, 0x32,  // 113-D182
                                        /* 0008 */  0x30, 0x35, 0x30, 0x31, 0x2D, 0x31, 0x30, 0x31   // 0501-101
                                    }, 

                                    "@0,name", 
                                    Buffer (0x0B)
                                    {
                                        "ATY,Adder"
                                    }, 

                                    "@0,AAPL,boot-display", 
                                    Buffer (0x04)
                                    {
                                         0x01, 0x00, 0x00, 0x00                           // ....
                                    }, 

                                    "@0,av-signal-type", 
                                    Buffer (0x04)
                                    {
                                         0x10, 0x00, 0x00, 0x00                           // ....
                                    }, 

                                    "ATY,EFIEnabledMode", 
                                    Buffer (One)
                                    {
                                         0x01                                             // .
                                    }, 

                                    "ATY,EFIVersion", 
                                    Buffer (0x09)
                                    {
                                        /* 0000 */  0x30, 0x31, 0x2E, 0x30, 0x31, 0x2E, 0x31, 0x38,  // 01.01.18
                                        /* 0008 */  0x33                                             // 3
                                    }, 

                                    "ATY,copyright", 
                                    Buffer (0x31)
                                    {
                                        /* 0000 */  0x43, 0x6F, 0x70, 0x79, 0x72, 0x69, 0x67, 0x68,  // Copyrigh
                                        /* 0008 */  0x74, 0x20, 0x41, 0x4D, 0x44, 0x20, 0x49, 0x6E,  // t AMD In
                                        /* 0010 */  0x63, 0x2E, 0x20, 0x41, 0x6C, 0x6C, 0x20, 0x52,  // c. All R
                                        /* 0018 */  0x69, 0x67, 0x68, 0x74, 0x73, 0x20, 0x52, 0x65,  // ights Re
                                        /* 0020 */  0x73, 0x65, 0x72, 0x76, 0x65, 0x64, 0x2E, 0x20,  // served. 
                                        /* 0028 */  0x32, 0x30, 0x30, 0x35, 0x2D, 0x32, 0x30, 0x31,  // 2005-201
                                        /* 0030 */  0x39                                             // 9
                                    }, 

                                    "hda-gfx", 
                                    Buffer (0x0A)
                                    {
                                        "onboard-2"
                                    }
                                })
                            }
                        }

                        Device (HDAU)
                        {
                            Name (_ADR, One)  // _ADR: Address
                            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                            {
                                If ((Arg2 == Zero))
                                {
                                    Return (Buffer (One)
                                    {
                                         0x03                                             // .
                                    })
                                }

                                Return (Package (0x08)
                                {
                                    "AAPL,slot-name", 
                                    Buffer (0x19)
                                    {
                                        "Slot-1@0,1,0/0,0/0,0/0,1"
                                    }, 

                                    "model", 
                                    Buffer (0x14)
                                    {
                                        " Navi 10 HDMI Audio"
                                    }, 

                                    "hda-gfx", 
                                    Buffer (0x0A)
                                    {
                                        "onboard-2"
                                    }, 

                                    "layout-id", 
                                    Buffer (0x04)
                                    {
                                         0x01, 0x00, 0x00, 0x00                           // ....
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
}

