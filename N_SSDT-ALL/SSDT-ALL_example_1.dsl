DefinitionBlock ("", "SSDT", 2, "Younix", "SAMPLE", 0x00002000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.LPCB, DeviceObj)
    External (_SB_.PCI0.XHC_, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.USR1, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.USR2, DeviceObj)
    
    If (_OSI ("Darwin"))
    {
        Scope (\_SB)
        {
            Scope (PCI0)
            {
                Scope (XHC)
                {
                    Scope (RHUB)
                    {
                        Name (USR1._STA, Zero)  // _STA: Status
                        Name (USR2._STA, Zero)  // _STA: Status
                    }
                }
            }
        }
    }
    
    External (_SB_.PCI0.PEG0, DeviceObj)
    External (_SB_.PCI0.PEG0.PEGP, DeviceObj)
    External (_SB_.PR00, ProcessorObj)
    External (STAS, IntObj)
    External (XPRW, MethodObj)    // 2 Arguments

    If (_OSI ("Darwin"))
    {
        Method (_INI, 0, NotSerialized)  // _INI: Initialize
        {
            STAS = One
        }

        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            Return (0x0F)
        }
        
        Scope (\_SB)
        {
            Method (GPRW, 2, NotSerialized)
            {
                If ((0x04 == Arg1))
                {
                    Return (XPRW (Arg0, 0x03))
                }

                Return (XPRW (Arg0, Arg1))
            }

            Scope (PR00)
            {
                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If (!Arg2)
                    {
                        Return (Buffer ()
                        {
                             0x03                                             // .
                        })
                    }

                    Return (Package ()
                    {
                        "plugin-type", 
                        One
                    })
                }
            }

            Scope (PCI0)
            {
                Device (DRAM)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                }

                Scope (LPCB)
                {
                    Device (EC)
                    {
                        Name (_HID, "ACID0001")  // _HID: Hardware ID
                    }
                }

                Scope (PEG0)
                {
                    Scope (PEGP)
                    {
                        Device (PBRG)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            Device (GFX0)
                            {
                                Name (_ADR, Zero)  // _ADR: Address
                            }

                            Device (HDAU)
                            {
                                Name (_ADR, One)  // _ADR: Address
                            }
                        }
                    }
                }

                Device (PGMM)
                {
                    Name (_ADR, 0x00080000)  // _ADR: Address
                }

                Device (THSS)
                {
                    Name (_ADR, 0x00140002)  // _ADR: Address
                }
            }

            Device (USBX)
            {
                Name (_ADR, Zero)  // _ADR: Address
                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If ((Arg2 == Zero))
                    {
                        Return (Buffer ()
                        {
                             0x03                                             // .
                        })
                    }

                    Return (Package ()
                    {
                        "kUSBSleepPowerSupply", 
                        0x13EC, 
                        "kUSBSleepPortCurrentLimit", 
                        0x0834, 
                        "kUSBWakePowerSupply", 
                        0x13EC, 
                        "kUSBWakePortCurrentLimit", 
                        0x0834
                    })
                }
            }
        }
    }
}

