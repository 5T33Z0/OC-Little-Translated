/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLzkt3iC.aml, Mon Apr  4 23:55:53 2022
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000276 (630)
 *     Revision         0x02
 *     Checksum         0x7E
 *     OEM ID           "Hack"
 *     OEM Table ID     "TPDX"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200925 (538970405)
 */
DefinitionBlock ("", "SSDT", 2, "Hack", "TPDX", 0x00000000)
{
    External (_SB_.PCI0.I2C0, DeviceObj)
    External (GNUM, MethodObj)    // 1 Arguments
    External (GPI0, IntObj)
    External (SSD0, IntObj)
    External (SSH0, IntObj)
    External (SSL0, IntObj)
    External (TPAD, IntObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            TPAD = Zero //disable TPD1 DSDT Origin
        }

        Scope (_SB.PCI0.I2C0)
        {
            If (_OSI ("Darwin"))
            {
                Method (PKGX, 3, Serialized)
                {
                    Name (PKG, Package (0x03)
                    {
                        Zero, 
                        Zero, 
                        Zero
                    })
                    PKG [Zero] = Arg0
                    PKG [One] = Arg1
                    PKG [0x02] = Arg2
                    Return (PKG) /* \_SB_.PCI0.I2C0.PKGX.PKG_ */
                }
            }

            If (_OSI ("Darwin"))
            {
                Method (SSCN, 0, NotSerialized)
                {
                    Return (PKGX (SSH0, SSL0, SSD0))
                }
            }

            If (_OSI ("Darwin"))
            {
                Method (FMCN, 0, NotSerialized)
                {
                    Name (PKG, Package (0x03)
                    {
                        0x0101, 
                        0x012C, 
                        0x62
                    })
                    Return (PKG) /* \_SB_.PCI0.I2C0.FMCN.PKG_ */
                }
            }

            Device (TPDX)
            {
                Name (_ADR, One)  // _ADR: Address
                Name (_HID, "HTIX5288")  // _HID: Hardware ID
                Name (_CID, "PNP0C50" /* HID Protocol Device (I2C bus) */)  // _CID: Compatible ID
                Name (_UID, One)  // _UID: Unique ID
                Name (_S0W, 0x04)  // _S0W: S0 Device Wake State
                Name (_DEP, Package (0x02)  // _DEP: Dependencies
                {
                    GPI0, 
                    I2C0
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

                Name (SBFB, ResourceTemplate ()
                {
                    I2cSerialBusV2 (0x002C, ControllerInitiated, 0x00061A80,
                        AddressingMode7Bit, "\\_SB.PCI0.I2C0",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                })
                Name (SBFG, ResourceTemplate ()
                {
                    GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
                        "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0000
                        }
                })
                Name (SBFI, ResourceTemplate ()
                {
                    Interrupt (ResourceConsumer, Level, ActiveLow, ExclusiveAndWake, ,, )
                    {
                        0x00000000,
                    }
                })
                CreateWordField (SBFG, 0x17, INT1)
                Method (_INI, 0, NotSerialized)  // _INI: Initialize
                {
                    INT1 = GNUM (0x04010003)
                }

                Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
                {
                    Return (ConcatenateResTemplate (SBFB, SBFG))
                }

                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If ((Arg0 == ToUUID ("3cdff6f7-4267-4555-ad05-b30a3d8938de") /* HID I2C Device */))
                    {
                        If ((Arg2 == Zero))
                        {
                            If ((Arg1 == One))
                            {
                                Return (Buffer (One)
                                {
                                     0x03                                             // .
                                })
                            }
                            Else
                            {
                                Return (Buffer (One)
                                {
                                     0x00                                             // .
                                })
                            }
                        }
                        ElseIf ((Arg2 == One))
                        {
                            Return (0x20)
                        }
                        Else
                        {
                            Return (Buffer (One)
                            {
                                 0x00                                             // .
                            })
                        }
                    }
                }
            }
        }
    }
}

