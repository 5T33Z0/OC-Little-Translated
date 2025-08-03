DefinitionBlock ("", "SSDT", 2, "OCLT", "XHUB", 0x00000000)
{
    External (_SB_.PCI0.XHC_.RHUB, DeviceObj) // Reference to the USB Root Hub device in the ACPI namespace

    Scope (\_SB.PCI0.XHC.RHUB)
    {
        Method (_STA, 0, NotSerialized)  // _STA: Status, determines device presence
        {
            If (_OSI ("Darwin")) // Check if running macOS
            {
                Return (Zero) // Disable RHUB on macOS
            }
            Else
            {
                Return (0x0F) // Enable RHUB on other OSes
            }
        }
    }

    Device (\_SB.PCI0.XHC.XHUB)
    {
        Name (_ADR, Zero)  // _ADR: Address, XHUB is at address 0
        Method (_STA, 0, NotSerialized)  // _STA: Status, determines device presence
        {
            If (_OSI ("Darwin")) // Check if running macOS
            {
                Return (0x0F) // Enable XHUB on macOS
            }
            Else
            {
                Return (Zero) // Disable XHUB on other OSes
            }
        }

        Device (HS01)
        {
            Name (_ADR, 0x01)  // _ADR: Address, High-Speed port 1
            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
            {
                Return (Package (0x04)
                {
                    0xFF, // Connectable
                    Zero, // Type-A connector
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // Visible, default location
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   // Reserved
                    }
                })
            }
        }

        Device (HS02)
        {
            Name (_ADR, 0x02)  // _ADR: Address, High-Speed port 2
            Method (_UPC, 0, NotSerialized)
            {
                Return (Package (0x04)
                {
                    0xFF, // Connectable
                    Zero, // Type-A connector
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    }
                })
            }
        }

        Device (HS03)
        {
            Name (_ADR, 0x03)  // _ADR: Address, High-Speed port 3
            Method (_UPC, 0, NotSerialized)
            {
                Return (Package (0x04)
                {
                    Zero, // Not connectable
                    Zero, // Type-A connector
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    }
                })
            }
        }

        Device (HS04)
        {
            Name (_ADR, 0x04)  // _ADR: Address, High-Speed port 4
            Method (_UPC, 0, NotSerialized)
            {
                Return (Package (0x04)
                {
                    Zero, // Not connectable
                    Zero, // Type-A connector
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    }
                })
            }
        }

        Device (HS05)
        {
            Name (_ADR, 0x05)  // _ADR: Address, High-Speed port 5
            Method (_UPC, 0, NotSerialized)
            {
                Return (Package (0x04)
                {
                    0xFF, // Connectable
                    Zero, // Type-A connector
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    }
                })
            }
        }

        Device (HS06)
        {
            Name (_ADR, 0x06)  // _ADR: Address, High-Speed port 6
            Method (_UPC, 0, NotSerialized)
            {
                Return (Package (0x04)
                {
                    0xFF, // Connectable
                    Zero, // Type-A connector
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    }
                })
            }
        }

        Device (HS07)
        {
            Name (_ADR, 0x07)  // _ADR: Address, High-Speed port 7
            Method (_UPC, 0, NotSerialized)
            {
                Return (Package (0x04)
                {
                    Zero, // Not connectable
                    Zero, // Type-A connector
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    }
                })
            }
        }

        Device (HS08)
        {
            Name (_ADR, 0x08)  // _ADR: Address, High-Speed port 8
            Method (_UPC, 0, NotSerialized)
            {
                Return (Package (0x04)
                {
                    0xFF, // Connectable
                    Zero, // Type-A connector
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    }
                })
            }
        }

        Device (HS10)
        {
            Name (_ADR, 0x0A)  // _ADR: Address, High-Speed port 10
            Method (_UPC, 0, NotSerialized)
            {
                Return (Package (0x04)
                {
                    0xFF, // Connectable
                    0x0A, // USB-C connector without switch
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    }
                })
            }
        }

        Device (HS14)
        {
            Name (_ADR, 0x0E)  // _ADR: Address, High-Speed port 14
            Method (_UPC, 0, NotSerialized)
            {
                Return (Package (0x04)
                {
                    0xFF, // Connectable
                    0xFF, // Unknown connector type
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    }
                })
            }
        }

        Device (SS01)
        {
            Name (_ADR, 0x11)  // _ADR: Address, SuperSpeed port 1
            Method (_UPC, 0, NotSerialized)
            {
                Return (Package (0x04) // Note: Original code has incorrect package size (0x11)
                {
                    0xFF, // Connectable
                    0x03, // USB 3.0 Type-A connector
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    }
                })
            }
        }

        Device (SS02)
        {
            Name (_ADR, 0x12)  // _ADR: Address, SuperSpeed port 2
            Method (_UPC, 0, NotSerialized)
            {
                Return (Package (0x04) // Note: Original code has incorrect package size (0x12)
                {
                    0xFF, // Connectable
                    0x03, // USB 3.0 Type-A connector
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    }
                })
            }
        }

        Device (SS03)
        {
            Name (_ADR, 0x13)  // _ADR: Address, SuperSpeed port 3
            Method (_UPC, 0, NotSerialized)
            {
                Return (Package (0x04)
                {
                    0xFF, // Connectable
                    0x03, // USB 3.0 Type-A connector
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    }
                })
            }
        }

        Device (SS04)
        {
            Name (_ADR, 0x14)  // _ADR: Address, SuperSpeed port 4
            Method (_UPC, 0, NotSerialized)
            {
                Return (Package (0x04)
                {
                    0xFF, // Connectable
                    0x03, // USB 3.0 Type-A connector
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    }
                })
            }
        }

        Device (SS05)
        {
            Name (_ADR, 0x15)  // _ADR: Address, SuperSpeed port 5
            Method (_UPC, 0, NotSerialized)
            {
                Return (Package (0x04)
                {
                    0xFF, // Connectable
                    0x0A, // USB-C connector without switch
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    }
                })
            }
        }

        Device (SS06)
        {
            Name (_ADR, 0x16)  // _ADR: Address, SuperSpeed port 6
            Method (_UPC, 0, NotSerialized)
            {
                Return (Package (0x04)
                {
                    0xFF, // Connectable
                    0x0A, // USB-C connector without switch
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    }
                })
            }
        }

        Device (SS07)
        {
            Name (_ADR, 0x17)  // _ADR: Address, SuperSpeed port 7
            Method (_UPC, 0, NotSerialized)
            {
                Return (Package (0x04)
                {
                    0xFF, // Connectable
                    0x03, // USB 3.0 Type-A connector
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    }
                })
            }
        }

        Device (SS08)
        {
            Name (_ADR, 0x18)  // _ADR: Address, SuperSpeed port 8
            Method (_UPC, 0, NotSerialized)
            {
                Return (Package (0x04)
                {
                    0xFF, // Connectable
                    0x03, // USB 3.0 Type-A connector
                    Zero, // Not proprietary
                    Zero  // Reserved
                })
            }

            Method (_PLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    }
                })
            }
        }
    }
}