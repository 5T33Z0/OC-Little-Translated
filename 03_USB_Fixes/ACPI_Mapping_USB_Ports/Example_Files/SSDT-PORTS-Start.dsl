/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLEP5h6g.aml, Fri Oct 28 13:20:11 2022
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000E7B (3707)
 *     Revision         0x02
 *     Checksum         0x85
 *     OEM ID           "ALASKA"
 *     OEM Table ID     "A M I "
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20091013 (537464851)
 */
DefinitionBlock ("", "SSDT", 2, "ALASKA", "A M I ", 0x00000000)
{
    External (_SB_.PC00.RP01.PXSX, DeviceObj)
    External (_SB_.PC00.RP05.PXSX, DeviceObj)
    External (_SB_.PC00.RP07.PXSX, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.HS01, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.HS02, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.HS03, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.HS04, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.HS05, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.HS06, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.HS07, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.HS08, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.HS09, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.HS10, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.HS11, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.HS12, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.HS13, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.HS14, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.SS01, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.SS02, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.SS03, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.SS04, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.SS05, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.SS06, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.SS07, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.SS08, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.SS09, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.SS10, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.USR1, DeviceObj)
    External (_SB_.PC00.XHCI.RHUB.USR2, DeviceObj)
    External (AMC1, UnknownObj)

    Method (GPLD, 2, Serialized)
    {
        Name (PCKG, Package (0x01)
        {
            Buffer (0x10){}
        })
        CreateField (DerefOf (PCKG [0x00]), 0x00, 0x07, REV)
        REV = 0x01
        CreateField (DerefOf (PCKG [0x00]), 0x40, 0x01, VISI)
        VISI = Arg0
        CreateField (DerefOf (PCKG [0x00]), 0x57, 0x08, GPOS)
        GPOS = Arg1
        Return (PCKG) /* \GPLD.PCKG */
    }

    Method (GUPC, 1, Serialized)
    {
        Name (PCKG, Package (0x04)
        {
            0x00, 
            0xFF, 
            0x00, 
            0x00
        })
        PCKG [0x00] = Arg0
        Return (PCKG) /* \GUPC.PCKG */
    }

    Name (USSD, Package (0x0A)
    {
        0x01, 
        0x01, 
        0x01, 
        0x01, 
        0x01, 
        0x00, 
        0x00, 
        0x00, 
        0x00, 
        0x00
    })
    Name (UHSD, Package (0x0E)
    {
        0x01, 
        0x01, 
        0x01, 
        0x01, 
        0x01, 
        0x00, 
        0x01, 
        0x01, 
        0x01, 
        0x01, 
        0x01, 
        0x01, 
        0x00, 
        0x00
    })
    Scope (\_SB.PC00.XHCI.RHUB.HS01)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (UHSD [0x00]), 0x01))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.HS02)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (UHSD [0x01]), 0x02))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.HS03)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (UHSD [0x02]), 0x03))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.HS04)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (UHSD [0x03]), 0x04))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.HS05)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (UHSD [0x04]), 0x05))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.HS06)
    {
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If (AMC1)
            {
                Return (0x0F)
            }
            Else
            {
                Return (0x00)
            }
        }

        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (AMC1))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (UHSD [0x05]), 0x06))
        }

        Device (PRT1)
        {
            Name (_ADR, 0x01)  // _ADR: Address
            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
            {
                Return (GUPC (0x00))
            }

            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
            {
                Return (GPLD (0x00, 0x00))
            }
        }

        Device (PRT2)
        {
            Name (_ADR, 0x02)  // _ADR: Address
            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
            {
                Return (GUPC (0x01))
            }

            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
            {
                Return (GPLD (0x01, 0x0F))
            }
        }

        Device (PRT3)
        {
            Name (_ADR, 0x03)  // _ADR: Address
            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
            {
                Return (GUPC (0x01))
            }

            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
            {
                Return (GPLD (0x01, 0x10))
            }
        }

        Device (PRT4)
        {
            Name (_ADR, 0x04)  // _ADR: Address
            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
            {
                Return (GUPC (0x01))
            }

            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
            {
                Return (GPLD (0x01, 0x11))
            }
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.HS07)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (UHSD [0x06]), 0x07))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.HS08)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (UHSD [0x07]), 0x08))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.HS09)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (UHSD [0x08]), 0x09))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.HS10)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (UHSD [0x09]), 0x0A))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.HS11)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (UHSD [0x0A]), 0x0B))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.HS12)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (UHSD [0x0B]), 0x0C))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.HS13)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (UHSD [0x0C]), 0x0D))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.HS14)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (UHSD [0x0D]), 0x0E))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.USR1)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x00))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (0x00, 0x00))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.USR2)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x00))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (0x00, 0x00))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.SS01)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (USSD [0x00]), 0x01))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.SS02)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (USSD [0x01]), 0x02))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.SS03)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (USSD [0x02]), 0x03))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.SS04)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (USSD [0x03]), 0x04))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.SS05)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x01))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (USSD [0x04]), 0x05))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.SS06)
    {
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If (AMC1)
            {
                Return (0x0F)
            }
            Else
            {
                Return (0x00)
            }
        }

        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (AMC1))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (USSD [0x05]), 0x06))
        }

        Device (PRT1)
        {
            Name (_ADR, 0x01)  // _ADR: Address
            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
            {
                Return (GUPC (0x00))
            }

            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
            {
                Return (GPLD (0x00, 0x00))
            }
        }

        Device (PRT2)
        {
            Name (_ADR, 0x02)  // _ADR: Address
            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
            {
                Return (GUPC (0x01))
            }

            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
            {
                Return (GPLD (0x01, 0x0F))
            }
        }

        Device (PRT3)
        {
            Name (_ADR, 0x03)  // _ADR: Address
            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
            {
                Return (GUPC (0x01))
            }

            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
            {
                Return (GPLD (0x01, 0x10))
            }
        }

        Device (PRT4)
        {
            Name (_ADR, 0x04)  // _ADR: Address
            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
            {
                Return (GUPC (0x01))
            }

            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
            {
                Return (GPLD (0x01, 0x11))
            }
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.SS07)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x00))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (USSD [0x06]), 0x00))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.SS08)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x00))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (USSD [0x07]), 0x00))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.SS09)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x00))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (USSD [0x08]), 0x00))
        }
    }

    Scope (\_SB.PC00.XHCI.RHUB.SS10)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (0x00))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (DerefOf (USSD [0x09]), 0x00))
        }
    }

    Scope (\_SB.PC00.RP01.PXSX)
    {
        Device (RHUB)
        {
            Name (_ADR, 0x00)  // _ADR: Address
            Device (SS01)
            {
                Name (_ADR, 0x01)  // _ADR: Address
                Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
                {
                    Name (UPCP, Package (0x04)
                    {
                        0x01, 
                        0x0A, 
                        0x00, 
                        0x00
                    })
                    Return (UPCP) /* \_SB_.PC00.RP01.PXSX.RHUB.SS01._UPC.UPCP */
                }

                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    Return (GPLD (0x01, 0x12))
                }
            }

            Device (SS02)
            {
                Name (_ADR, 0x02)  // _ADR: Address
                Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                {
                    Return (GUPC (0x00))
                }

                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    Return (GPLD (0x00, 0x00))
                }
            }

            Device (HS01)
            {
                Name (_ADR, 0x03)  // _ADR: Address
                Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
                {
                    Name (UPCP, Package (0x04)
                    {
                        0x01, 
                        0x0A, 
                        0x00, 
                        0x00
                    })
                    Return (UPCP) /* \_SB_.PC00.RP01.PXSX.RHUB.HS01._UPC.UPCP */
                }

                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    Return (GPLD (0x01, 0x12))
                }
            }

            Device (HS02)
            {
                Name (_ADR, 0x04)  // _ADR: Address
                Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                {
                    Return (GUPC (0x00))
                }

                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    Return (GPLD (0x00, 0x00))
                }
            }
        }
    }

    Scope (\_SB.PC00.RP05.PXSX)
    {
        Device (RHUB)
        {
            Name (_ADR, 0x00)  // _ADR: Address
            Device (SS01)
            {
                Name (_ADR, 0x01)  // _ADR: Address
                Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                {
                    Return (GUPC (0x01))
                }

                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    Return (GPLD (0x01, 0x13))
                }
            }

            Device (SS02)
            {
                Name (_ADR, 0x02)  // _ADR: Address
                Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                {
                    Return (GUPC (0x01))
                }

                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    Return (GPLD (0x01, 0x14))
                }
            }

            Device (HS01)
            {
                Name (_ADR, 0x03)  // _ADR: Address
                Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                {
                    Return (GUPC (0x01))
                }

                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    Return (GPLD (0x01, 0x13))
                }
            }

            Device (HS02)
            {
                Name (_ADR, 0x04)  // _ADR: Address
                Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                {
                    Return (GUPC (0x01))
                }

                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    Return (GPLD (0x01, 0x14))
                }
            }
        }
    }

    Scope (\_SB.PC00.RP07.PXSX)
    {
        Device (RHUB)
        {
            Name (_ADR, 0x00)  // _ADR: Address
            Device (SS01)
            {
                Name (_ADR, 0x01)  // _ADR: Address
                Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
                {
                    Name (UPCP, Package (0x04)
                    {
                        0x01, 
                        0x0A, 
                        0x00, 
                        0x00
                    })
                    Return (UPCP) /* \_SB_.PC00.RP07.PXSX.RHUB.SS01._UPC.UPCP */
                }

                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    Return (GPLD (0x01, 0x15))
                }
            }

            Device (SS02)
            {
                Name (_ADR, 0x02)  // _ADR: Address
                Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                {
                    Return (GUPC (0x01))
                }

                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    Return (GPLD (0x01, 0x16))
                }
            }

            Device (HS01)
            {
                Name (_ADR, 0x03)  // _ADR: Address
                Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
                {
                    Name (UPCP, Package (0x04)
                    {
                        0x01, 
                        0x0A, 
                        0x00, 
                        0x00
                    })
                    Return (UPCP) /* \_SB_.PC00.RP07.PXSX.RHUB.HS01._UPC.UPCP */
                }

                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    Return (GPLD (0x01, 0x15))
                }
            }

            Device (HS02)
            {
                Name (_ADR, 0x04)  // _ADR: Address
                Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                {
                    Return (GUPC (0x01))
                }

                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    Return (GPLD (0x01, 0x16))
                }
            }
        }
    }
}

