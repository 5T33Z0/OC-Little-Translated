DefinitionBlock ("", "SSDT", 2, "Younix", "SAMPLE", 0x00002000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.WMI1, DeviceObj)
    External (_SB_.PCI0.XHC_, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.USR1, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.USR2, DeviceObj)
    External (_SB_.PR00, ProcessorObj)
    External (_SB_.WFDE, DeviceObj)
    External (_SB_.WFTE, DeviceObj)
    External (_SB_.WFTF, DeviceObj)
    External (_SB_.WMIC, DeviceObj)
    External (_SB_.WMIO, DeviceObj)
    External (_SB_.WTBT, DeviceObj)
    External (_TZ_.FAN0, DeviceObj)
    External (_TZ_.FAN1, DeviceObj)
    External (_TZ_.FAN2, DeviceObj)
    External (_TZ_.FAN3, DeviceObj)
    External (_TZ_.FAN4, DeviceObj)
    
    If (_OSI ("Darwin"))
    {
        Scope (\_SB)
        {
            Scope (PCI0)
            {
                Name (WMI1._STA, Zero)  // _STA: Status
                Scope (XHC)
                {
                    Scope (RHUB)
                    {
                        Name (USR1._STA, Zero)  // _STA: Status
                        Name (USR2._STA, Zero)  // _STA: Status
                    }
                }
            }

            Name (WFDE._STA, Zero)  // _STA: Status
            Name (WFTE._STA, Zero)  // _STA: Status
            Name (WFTF._STA, Zero)  // _STA: Status
            Name (WMIC._STA, Zero)  // _STA: Status
            Name (WMIO._STA, Zero)  // _STA: Status
            Name (WTBT._STA, Zero)  // _STA: Status
        }

        Scope (\_TZ)
        {
            Name (FAN0._STA, Zero)  // _STA: Status
            Name (FAN1._STA, Zero)  // _STA: Status
            Name (FAN2._STA, Zero)  // _STA: Status
            Name (FAN3._STA, Zero)  // _STA: Status
            Name (FAN4._STA, Zero)  // _STA: Status
        }
    }
    
    External (_SB_.PCI0.LPCB, DeviceObj)
    External (_SB_.PCI0.PEG0, DeviceObj)
    External (_SB_.PCI0.PEG0.PEGP, DeviceObj)
    External (_SB_.PCI0.SBUS, DeviceObj)
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
                    Device (DMAC)
                    {
                        Name (_HID, EisaId ("PNP0200") /* PC-class DMA Controller */)  // _HID: Hardware ID
                        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                        {
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x20,               // Length
                                )
                            IO (Decode16,
                                0x0081,             // Range Minimum
                                0x0081,             // Range Maximum
                                0x01,               // Alignment
                                0x11,               // Length
                                )
                            IO (Decode16,
                                0x0093,             // Range Minimum
                                0x0093,             // Range Maximum
                                0x01,               // Alignment
                                0x0D,               // Length
                                )
                            IO (Decode16,
                                0x00C0,             // Range Minimum
                                0x00C0,             // Range Maximum
                                0x01,               // Alignment
                                0x20,               // Length
                                )
                            DMA (Compatibility, NotBusMaster, Transfer8_16, )
                                {4}
                        })
                    }

                    Device (EC)
                    {
                        Name (_HID, "ACID0001")  // _HID: Hardware ID
                    }

                    Device (FWHD)
                    {
                        Name (_HID, EisaId ("INT0800") /* Intel 82802 Firmware Hub Device */)  // _HID: Hardware ID
                        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                        {
                            Memory32Fixed (ReadOnly,
                                0xFF000000,         // Address Base
                                0x01000000,         // Address Length
                                )
                        })
                    }

                    Device (PMCR)
                    {
                        Name (_HID, EisaId ("APP9876"))  // _HID: Hardware ID
                        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                        {
                            Memory32Fixed (ReadWrite,
                                0xFE000000,         // Address Base
                                0x00010000,         // Address Length
                                )
                        })
                    }
                }

                Scope (PEG0)
                {
                    Scope (PEGP)
                    {
                        Name (_CID, "pci-bridge")  // _CID: Compatible ID
                        Device (PBRG)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            Name (_CID, "pci-bridge")  // _CID: Compatible ID
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

                Scope (SBUS)
                {
                    Device (BUS0)
                    {
                        Name (_ADR, Zero)  // _ADR: Address
                        Name (_CID, "smbus")  // _CID: Compatible ID
                        Device (BLC0)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            Name (_CID, "smbus-blc")  // _CID: Compatible ID
                        }
                    }
                }

                Device (TSUB)
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

