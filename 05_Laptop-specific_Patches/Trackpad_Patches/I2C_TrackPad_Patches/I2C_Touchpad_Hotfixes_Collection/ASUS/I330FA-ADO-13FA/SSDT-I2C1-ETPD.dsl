// TPxx is my new's device
DefinitionBlock ("", "SSDT", 2, "_ASUS_", "Notebook", 0x01072009)
{
    External (_SB_.PCI0.I2C1, DeviceObj)
    External (_SB_.PCI0.I2C1.TPD0, DeviceObj)
    External (_SB_.TPIF, FieldUnitObj)
    External (GPHD, FieldUnitObj)

    If (_OSI ("Darwin"))
    {
        Scope (\)
        {
            _SB.TPIF = Zero
            GPHD = 0x02
        }

        Scope (_SB.PCI0.I2C1)
        {
            Device (TPXX)
            {
                Name (_ADR, One)  // _ADR: Address
                Name (_CID, "PNP0C50" /* HID Protocol Device (I2C bus) */)  // _CID: Compatible ID
                Name (_UID, One)  // _UID: Unique ID
                Name (_S0W, 0x03)  // _S0W: S0 Device Wake State
                Method (_HID, 0, NotSerialized)  // _HID: Hardware ID
                {
                    Return ("ELAN1204")
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

                        If ((Arg2 == One))
                        {
                            Return (One)
                        }
                    }

                    Return (Buffer (One)
                    {
                         0x00                                             // .
                    })
                }

                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }

                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (SBFB, ResourceTemplate ()
                    {
                        I2cSerialBusV2 (0x0015, ControllerInitiated, 0x00061A80,
                            AddressingMode7Bit, "\\_SB.PCI0.I2C1",
                            0x00, ResourceConsumer, , Exclusive,
                            )
                    })
                    Name (SBFG, ResourceTemplate ()
                    {
                        GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
                            "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                            )
                            {   // Pin list
                                0x001B
                            }
                    })
                    Return (ConcatenateResTemplate (SBFB, SBFG))
                }
            }
        }
    }
}

