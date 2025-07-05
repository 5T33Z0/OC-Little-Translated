// TPxx is my new's device
DefinitionBlock ("", "SSDT", 2, "OCLT", "I2C-TPXX", 0x00000000)
{
    External (_SB_.CBID, MethodObj)    // 0 Arguments
    External (_SB_.GNUM, MethodObj)    // 1 Arguments
    External (_SB_.INUM, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.HIDD, MethodObj)    // 5 Arguments
    External (_SB_.PCI0.HIDG, IntObj)
    External (_SB_.PCI0.I2C1, DeviceObj)
    External (_SB_.PCI0.TP7D, MethodObj)    // 6 Arguments
    External (_SB_.PCI0.TP7G, IntObj)
    External (_SB_.SHPO, MethodObj)    // 2 Arguments
    External (GPDI, FieldUnitObj)
    External (SDM1, FieldUnitObj)
    External (SDS1, FieldUnitObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            SDS1 = Zero
        }
    }

    Scope (_SB.PCI0.I2C1)
    {
        Device (TPXX)
        {
            Name (HID2, Zero)
            Name (SBFB, ResourceTemplate ()
            {
                I2cSerialBusV2 (0x002C, ControllerInitiated, 0x00061A80,
                    AddressingMode7Bit, "\\_SB.PCI0.I2C1",
                    0x00, ResourceConsumer, , Exclusive,
                    )
            })
            Name (SBFI, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveLow, ExclusiveAndWake, ,, _Y00)
                {
                    0x00000000,
                }
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
            CreateWordField (SBFG, 0x17, INT1)
            CreateDWordField (SBFI, \_SB.PCI0.I2C1.TPXX._Y00._INT, INT2)  // _INT: Interrupts
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
                INT1 = GNUM (GPDI)
                INT2 = INUM (GPDI)
                If ((SDM1 == Zero))
                {
                    SHPO (GPDI, One)
                }

                If (One)
                {
                    If ((CBID () == 0x07A6))
                    {
                        _HID = "DLL07A6"
                    }

                    If ((CBID () == 0x07A7))
                    {
                        _HID = "DLL07A7"
                    }

                    If ((CBID () == 0x07A8))
                    {
                        _HID = "DLL07A8"
                    }

                    If ((CBID () == 0x07A9))
                    {
                        _HID = "DLL07A9"
                    }

                    If ((CBID () == 0x07D0))
                    {
                        _HID = "DLL07D0"
                    }

                    If ((CBID () == 0x07D1))
                    {
                        _HID = "DLL07D1"
                    }

                    HID2 = 0x20
                }
            }

            Name (_HID, "XXXX0000")  // _HID: Hardware ID
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
                Return (ConcatenateResTemplate (SBFB, SBFG))
            }
        }
    }
}

