// For ASUS X51GT
//
// Required Renames:
//
// Change _OSI to XOSI 
// Find: 5F4F5349
// Replace: 584F5349
//
// Change I2C TPD0 to TPDX
// Find: 54504430
// Replace: 54504458

DefinitionBlock ("", "SSDT", 2, "hack", "TPDX", 0x00000000)
{
    External (_SB_.GNUM, MethodObj)    // 1 Arguments
    External (_SB_.INUM, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.HIDD, MethodObj)    // 5 Arguments
    External (_SB_.PCI0.HIDG, BuffObj)
    External (_SB_.PCI0.I2C0, DeviceObj)
    External (_SB_.PCI0.I2CM, MethodObj)    // 3 Arguments
    External (_SB_.PCI0.TP7D, MethodObj)    // 6 Arguments
    External (_SB_.PCI0.TP7G, BuffObj)
    External (_SB_.SHPO, MethodObj)    // 2 Arguments
    External (GPDI, FieldUnitObj)
    External (SDS0, FieldUnitObj)
    External (TPDB, FieldUnitObj)
    External (TPDH, FieldUnitObj)
    External (TPDM, FieldUnitObj)
    External (TPDT, FieldUnitObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            TPDT = 0x05
            TPDM = Zero
            GPDI = 0x1B
        }
    }

    Scope (_SB.PCI0.I2C0)
    {
        Name (I2CN, Zero)
        Name (I2CX, Zero)
        Method (_INI, 0, NotSerialized)  // _INI: Initialize
        {
            I2CN = SDS0 /* External reference */
            I2CX = Zero
        }

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
                GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
                    "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x0000
                    }
            })
            Name (SBFI, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveLow, ExclusiveAndWake, ,, _Y01)
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
                If ((TPDM == Zero))
                {
                    SHPO (GPDI, One)
                }

                _HID = "ELAN1200"
                HID2 = TPDH /* External reference */
                BADR = TPDB /* External reference */
                SPED = 0x00061A80
            }

            Name (_HID, "ELAN1200")  // _HID: Hardware ID
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

                Return (Zero)
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Return (ConcatenateResTemplate (I2CM (I2CX, BADR, SPED), SBFG))
            }
        }
    }
}

