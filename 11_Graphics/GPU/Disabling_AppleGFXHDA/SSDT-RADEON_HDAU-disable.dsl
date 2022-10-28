/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20210331 (64-bit version)
 * Copyright (c) 2000 - 2021 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLomj0lu.aml, Fri Oct 28 19:03:12 2022
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000001F4 (500)
 *     Revision         0x02
 *     Checksum         0x25
 *     OEM ID           "_NICO_"
 *     OEM Table ID     "_RADEON_"
 *     OEM Revision     0x00900000 (9437184)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20210331 (539034417)
 */
DefinitionBlock ("", "SSDT", 2, "_NICO_", "_RADEON_", 0x00900000)
{
    External (_SB_.PCI0.PEG0.PEGP, DeviceObj)

    Scope (_SB.PCI0.PEG0.PEGP)
    {
        Device (EGP1)
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

            Method (DTGP, 5, NotSerialized)
            {
                If ((Arg0 == ToUUID ("a0b5b7c6-1318-441c-b0c9-fe695eaf949b") /* Unknown UUID */))
                {
                    If ((Arg1 == One))
                    {
                        If ((Arg2 == Zero))
                        {
                            Arg4 = Buffer (One)
                                {
                                     0x03                                             // .
                                }
                            Return (One)
                        }

                        If ((Arg2 == One))
                        {
                            Return (One)
                        }
                    }
                }

                Arg4 = Buffer (One)
                    {
                         0x00                                             // .
                    }
                Return (Zero)
            }

            Device (GFX0)
            {
                Name (_ADR, Zero)  // _ADR: Address
                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If ((Arg0 == ToUUID ("a0b5b7c6-1318-441c-b0c9-fe695eaf949b") /* Unknown UUID */))
                    {
                        Local0 = Package (0x06)
                            {
                                "AAPL,slot-name", 
                                Buffer (0x07)
                                {
                                    "Slot-1"
                                }, 

                                "built-in", 
                                Buffer (One)
                                {
                                     0x00                                             // .
                                }, 

                                "model", 
                                Buffer (0x0F)
                                {
                                    "AMD Radeon VII"
                                }
                            }
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }

                    Return (Zero)
                }
            }

            Device (HDAU)
            {
                Name (_ADR, One)  // _ADR: Address
                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If ((Arg0 == ToUUID ("a0b5b7c6-1318-441c-b0c9-fe695eaf949b") /* Unknown UUID */))
                    {
                        Local0 = Package (0x0A)
                            {
                                "AAPL,slot-name", 
                                Buffer (0x07)
                                {
                                    "Slot-1"
                                }, 

                                "built-in", 
                                Buffer (One)
                                {
                                     0x00                                             // .
                                }, 

                                "device-id", 
                                Buffer (0x04)
                                {
                                     0x00, 0x00, 0x00, 0x00                           // ....
                                }, 

                                "subsystem-id", 
                                Buffer (0x04)
                                {
                                     0x00, 0x00, 0x00, 0x00                           // ....
                                }, 

                                "subsystem-vendor-id", 
                                Buffer (0x04)
                                {
                                     0x00, 0x00, 0x00, 0x00                           // ....
                                }
                            }
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }

                    Return (Zero)
                }
            }
        }
    }
}

