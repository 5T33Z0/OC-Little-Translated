//
DefinitionBlock ("", "SSDT", 2, "Hack", "Matty", 0x00000000)
{
    External (_SB_.PCI0.PEG0.PEGP.VEGA, DeviceObj)

    Device (_SB.PCI0.PEG0.PEGP.VEGA)
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
                        Return (Package (0x02)
                        {
                            0x69, 
                            0x03
                        })
                    }

                Return (Package (0x1A)
                {
                    "AAPL,slot-name", 
                    Buffer (0x07)
                    {
                        "Slot-1"
                    }, 

                    "@0,ATY,EFIDisplay", 
                    Buffer (0x04)
                    {
                        "DP1"
                    }, 

                    "ATY,EFIVersionB", 
                    Buffer (0x10)
                    {
                        /* 0000 */  0x31, 0x31, 0x33, 0x2D, 0x44, 0x30, 0x35, 0x30,  // 113-D050
                        /* 0008 */  0x30, 0x33, 0x30, 0x30, 0x2D, 0x31, 0x30, 0x31   // 0300-101
                    }, 

                    "ATY,EFIEnabledMode", 
                    Buffer (One)
                    {
                         0x01                                             // .
                    }, 

                    "ATY,Rom#", 
                    Buffer (0x11)
                    {
                        "113-D0500300-101"
                    }, 

                    "ATY,EFIVersion", 
                    Buffer (0x09)
                    {
                        /* 0000 */  0x30, 0x31, 0x2E, 0x30, 0x31, 0x2E, 0x31, 0x38,  // 01.01.18
                        /* 0008 */  0x33                                             // 3
                    }, 

                    "@0,name", 
                    Buffer (0x0D)
                    {
                        "ATY,Kamarang"
                    }, 

                    "@1,name", 
                    Buffer (0x0D)
                    {
                        "ATY,Kamarang"
                    }, 

                    "@2,name", 
                    Buffer (0x0D)
                    {
                        "ATY,Kamarang"
                    }, 

                    "@3,name", 
                    Buffer (0x0D)
                    {
                        "ATY,Kamarang"
                    }, 

                    "PP_PhmSoftWTTable", 
                    Buffer (0x7C)
                    {
                        /* 0000 */  0x58, 0x02, 0x4E, 0x03, 0xA7, 0x00, 0xF3, 0x01,  // X.N.....
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x4F, 0x03, 0x58, 0x0D,  // ....O.X.
                        /* 0010 */  0xA7, 0x00, 0xF3, 0x01, 0x01, 0x00, 0x00, 0x00,  // ........
                        /* 0018 */  0x3A, 0x02, 0x4E, 0x03, 0xF4, 0x01, 0x88, 0x0D,  // :.N.....
                        /* 0020 */  0x02, 0x00, 0x00, 0x00, 0x4F, 0x03, 0x58, 0x0D,  // ....O.X.
                        /* 0028 */  0xF4, 0x01, 0x58, 0x0D, 0x03, 0x00, 0x00, 0x00,  // ..X.....
                        /* 0030 */  0x3A, 0x02, 0x1F, 0x03, 0xA7, 0x00, 0xF3, 0x01,  // :.......
                        /* 0038 */  0x00, 0x00, 0x00, 0x00, 0x14, 0x03, 0x58, 0x0D,  // ......X.
                        /* 0040 */  0xA7, 0x00, 0xF3, 0x01, 0x01, 0x00, 0x00, 0x00,  // ........
                        /* 0048 */  0x3A, 0x02, 0x1F, 0x03, 0xF4, 0x01, 0x58, 0x0D,  // :.....X.
                        /* 0050 */  0x02, 0x00, 0x00, 0x00, 0x14, 0x03, 0x58, 0x0D,  // ......X.
                        /* 0058 */  0xF4, 0x01, 0x58, 0x0D, 0x03, 0x00, 0x00, 0x00,  // ..X.....
                        /* 0060 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0068 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0070 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0078 */  0x00, 0x00, 0x00, 0x00                           // ....
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
                    Buffer (0x07)
                    {
                        "Slot-1"
                    }, 

                    "model", 
                    Buffer (0x0E)
                    {
                        " Vega10 Audio"
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

