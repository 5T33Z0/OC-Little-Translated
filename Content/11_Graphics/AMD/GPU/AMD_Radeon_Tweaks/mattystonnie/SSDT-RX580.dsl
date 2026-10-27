//
DefinitionBlock ("", "SSDT", 1, "hack", "Matty", 0x00000000)
{
    External (_SB_.PCI0.PEG0, DeviceObj)
    External (_SB_.PCI0.PEG0.PEGP, DeviceObj)
    
    Scope (_SB.PCI0.PEG0)
    {
        Scope (PEGP)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Name (ATIB, Buffer (0x0100){})
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                Local0 = Package (0x16)
                    {
                        "built-in", 
                        Buffer (One)
                        {
                             0x00                                             // .
                        }, 

                        "@0,name", 
                        Buffer (0x0D)
                        {
                            "ATY,Orinoco"
                        }, 

                        "@0,AAPL,boot-display", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00                           // ....
                        }, 

                        "ATY,EFIVersionB", 
                        Buffer (0x10)
                        {
                            /* 0000 */  0x31, 0x31, 0x33, 0x2D, 0x43, 0x39, 0x34, 0x34,  // 113-C944
                            /* 0008 */  0x41, 0x31, 0x58, 0x54, 0x2D, 0x30, 0x31, 0x34   // A1XT-014
                        }, 

                        "ATY,Rom#", 
                        Buffer (0x0F)
                        {
                            /* 0000 */  0x31, 0x31, 0x33, 0x2D, 0x32, 0x45, 0x33, 0x34,  // 113-2E34
                            /* 0008 */  0x37, 0x30, 0x55, 0x2E, 0x53, 0x35, 0x58         // 70U.S5X
                        }, 

                        "PP_BootupDisplayState", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00                           // ....
                        }, 

                        "PP_PowerPlayEnabled", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00                           // ....
                        }, 

                        "model", 
                        Buffer (0x12)
                        {
                            "AMD Radeon RX 580"
                        }, 

                        "ATY,EFIVersion", 
                        Buffer (0x09)
                        {
                            /* 0000 */  0x30, 0x31, 0x2E, 0x30, 0x31, 0x2E, 0x31, 0x38,  // 01.01.18
                            /* 0008 */  0x33                                             // 3
                        }, 

                        "hda-gfx", 
                        Buffer (0x0A)
                        {
                            "onboard-2"
                        }, 

                        "AAPL,slot-name", 
                        Buffer (0x11)
                        {
                            "Slot-1@0,1,0/0,0"
                        }
                    }
                Return (Local0)
            }

            Return (0x80000002)
        }

        Device (HDAU)
        {
            Name (_ADR, Zero)  // _ADR: Address
            OperationRegion (HDAH, PCI_Config, Zero, 0x40)
            Field (HDAH, ByteAcc, NoLock, Preserve)
            {
                VID0,   16, 
                DID0,   16
            }

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                Local0 = Package (0x0E)
                    {
                        "built-in", 
                        Buffer (One)
                        {
                             0x00                                             // .
                        }, 

                        "AAPL,slot-name", 
                        Buffer (0x11)
                        {
                            "Slot-1@0,1,0/0,1"
                        }, 

                        "layout-id", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00                           // ....
                        }, 

                        "model", 
                        Buffer (0x16)
                        {
                            "AMD RX 580 HDMI Audio"
                        }, 

                        "device_type", 
                        Buffer (0x0D)
                        {
                            "Audio device"
                        }, 

                        "hda-gfx", 
                        Buffer (0x0A)
                        {
                            "onboard-2"
                        }
                    }
                Return (Local0)
            }

            Return (0x80000002)
        }
    }
}