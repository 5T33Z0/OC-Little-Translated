/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20210331 (64-bit version)
 * Copyright (c) 2000 - 2021 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLSDnV0D.aml, Sat Jan  8 09:37:06 2022
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000002E9 (745)
 *     Revision         0x02
 *     Checksum         0xBA
 *     OEM ID           "OCLT"
 *     OEM Table ID     "GPI0"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200925 (538970405)
 */
DefinitionBlock ("", "SSDT", 2, "OCLT", "GPI0", 0x00000000)
{
    External (_HID, FieldUnitObj)
    External (_SB_.PCI0.HIDD, MethodObj)    // 5 Arguments
    External (_SB_.PCI0.I2C0, DeviceObj)
    External (_SB_.PCI0.I2C0.TPDX, DeviceObj)
    External (_SB_.PCI0.I2CM, MethodObj)    // 3 Arguments
    External (_SB_.PCI0.I2CX, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.TP7D, MethodObj)    // 6 Arguments
    External (BADR, FieldUnitObj)
    External (GNUM, MethodObj)    // 1 Arguments
    External (GPDI, FieldUnitObj)
    External (HID2, FieldUnitObj)
    External (HIDG, FieldUnitObj)
    External (INT1, FieldUnitObj)
    External (INT2, FieldUnitObj)
    External (INUM, MethodObj)    // 1 Arguments
    External (SPED, FieldUnitObj)
    External (TP7G, FieldUnitObj)
    External (TPDB, FieldUnitObj)
    External (TPDH, FieldUnitObj)
    External (TPDS, FieldUnitObj)
    External (TPDT, FieldUnitObj)

    Scope (_SB.PCI0.I2C0)
    {
        Device (TPDX)
        {
            Name (HID2, Zero)
            Name (SBFB, ResourceTemplate ()
            {
                I2cSerialBusV2 (0x0000, ControllerInitiated, 0x00061A80,
                    AddressingMode7Bit, "NULL",
                    0x00, ResourceConsumer, _Y00, Exclusive,
                    )
            })
            Name (SBFG, ResourceTemplate ()
            {
                GpioInt (Level, ActiveHigh, ExclusiveAndWake, PullDefault, 0x0000,
                    "\\_SB.GPI0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x0000
                    }
            })
            Name (SBFI, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, ExclusiveAndWake, ,, _Y01)
                {
                    0x00000000,
                }
            })
            CreateWordField (SBFB, \_SB.PCI0.I2C0.TPDX._Y00._ADR, BADR)  // _ADR: Address
            CreateDWordField (SBFB, \_SB.PCI0.I2C0.TPDX._Y00._SPE, SPED)  // _SPE: Speed
            CreateWordField (SBFG, 0x17, INT1)
            CreateDWordField (SBFI, \_SB.PCI0.I2C0.TPDX._Y01._INT, INT2)  // _INT: Interrupts
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
                INT1 = GNUM (GPDI)
                INT2 = INUM (GPDI)
                _HID = "ELAN0709"
                HID2 = TPDH /* External reference */
                BADR = TPDB /* External reference */
                If ((TPDS == Zero))
                {
                    SPED = 0x000186A0
                }

                If ((TPDS == One))
                {
                    SPED = 0x00061A80
                }

                If ((TPDS == 0x02))
                {
                    SPED = 0x000F4240
                }
            }

            Name (_HID, "ELAN0709")  // _HID: Hardware ID
            Name (_CID, "PNP0C50" /* HID Protocol Device (I2C bus) */)  // _CID: Compatible ID
            Name (_S0W, 0x03)  // _S0W: S0 Device Wake State
            Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
            {
                If ((Arg0 == HIDG))
                {
                    Return (HIDD (Arg0, Arg1, Arg2, Arg3, HID2))
                }

                If ((Arg0 == TP7G))
                {
                    Return (TP7D (Arg0, Arg1, Arg2, Arg3, SBFB, SBFG))
                }

                Return (Buffer (One)
                {
                     0x00                                             // .
                })
            }

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

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Return (ConcatenateResTemplate (I2CM (I2CX (), BADR, SPED), SBFG))
            }
        }
    }

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            TPDT = Zero
        }
    }
}

