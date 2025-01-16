/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20210331 (64-bit version)
 * Copyright (c) 2000 - 2021 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASL9uyS2W.aml, Thu Jan 16 20:11:00 2025
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000005B3 (1459)
 *     Revision         0x02
 *     Checksum         0xD3
 *     OEM ID           "5T33Z0"
 *     OEM Table ID     "IGPU"
 *     OEM Revision     0x00001000 (4096)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20210930 (539035952)
 */
DefinitionBlock ("", "SSDT", 2, "5T33Z0", "IGPU", 0x00001000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.GFX0, DeviceObj)

    Scope (\_SB.PCI0)
    {
        Scope (GFX0)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }

        Device (IGPU)
        {
            Name (_ADR, 0x00020000)  // _ADR: Address
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03                                             
                    })
                }

                If (_OSI ("Darwin 21"))    // if macOS Monterey
                {
                    Return (Package (0x24)
                    {
                        "AAPL,GfxYTile", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00 
                        }, 

                        "AAPL,ig-platform-id", 
                        Buffer (0x04)
                        {
                             0x05, 0x00, 0x3B, 0x19 
                        }, 

                        "agdpmod", 
                        Buffer (0x08)
                        {
                            "vit9696"
                        }, 

                        "device-id", 
                        Buffer (0x04)
                        {
                             0x12, 0x19, 0x00, 0x00
                        }, 

                        "complete-modeset", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00
                        }, 

                        "enable-hdmi20", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00
                        }, 

                        "force-online", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00 
                        }, 

                        "force-online-framebuffers", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00 
                        }, 

                        "framebuffer-con1-alldata", 
                        Buffer (0x0C)
                        {
                            /* 0000 */  0x01, 0x05, 0x09, 0x00, 0x00, 0x08, 0x00, 0x00, 
                            /* 0008 */  0xC7, 0x01, 0x00, 0x00 
                        }, 

                        "framebuffer-con1-enable", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00 
                        }, 

                        "framebuffer-con2-alldata", 
                        Buffer (0x0C)
                        {
                            /* 0000 */  0x02, 0x06, 0x0A, 0x00, 0x00, 0x08, 0x00, 0x00, 
                            /* 0008 */  0xC7, 0x01, 0x00, 0x00 
                        }, 

                        "framebuffer-con2-enable", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00 
                        }, 

                        "framebuffer-con3-alldata", 
                        Buffer (0x0C)
                        {
                            /* 0000 */  0x03, 0x04, 0x0A, 0x00, 0x00, 0x04, 0x00, 0x00,
                            /* 0008 */  0xC7, 0x01, 0x00, 0x00
                        }, 

                        "framebuffer-con3-enable", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00
                        }, 

                        "framebuffer-memorycount", 
                        Buffer (0x04)
                        {
                             0x03, 0x00, 0x00, 0x00 
                        }, 

                        "framebuffer-pipecount", 
                        Buffer (0x04)
                        {
                             0x04, 0x00, 0x00, 0x00
                        }, 

                        "framebuffer-portcount", 
                        Buffer (0x04)
                        {
                             0x04, 0x00, 0x00, 0x00 
                        }, 

                        "hda-gfx", 
                        Buffer (0x0A)
                        {
                            "onboard-1"
                        }
                    })
                }
                
                If (_OSI ("Darwin 22") || _OSI ("Darwin 23") || _OSI ("Darwin 24") || _OSI ("Darwin 25"))    // if macOS Ventura or newer
                {
                    Return (Package (0x30)
                    {
                        "AAPL,GfxYTile", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00
                        }, 

                        "AAPL,ig-platform-id", 
                        Buffer (0x04)
                        {
                             0x02, 0x00, 0x26, 0x59
                        }, 

                        "agdpmod", 
                        Buffer (0x08)
                        {
                            "vit9696"
                        }, 

                        "device-id", 
                        Buffer (0x04)
                        {
                             0x26, 0x59, 0x00, 0x00
                        }, 

                        "disable-agdc", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00
                        }, 

                        "enable-hdmi20", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00
                        }, 

                        "enable-hdmi-dividers-fix", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00
                        }, 

                        "force-online", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00
                        }, 

                        "framebuffer-con0-alldata", 
                        Buffer (0x0C)
                        {
                            /* 0000 */  0xFF, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00,
                            /* 0008 */  0x20, 0x00, 0x00, 0x00
                        }, 

                        "framebuffer-con0-enable", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00 
                        }, 

                        "framebuffer-con1-alldata", 
                        Buffer (0x0C)
                        {
                            /* 0000 */  0x01, 0x05, 0x09, 0x00, 0x00, 0x08, 0x00, 0x00, 
                            /* 0008 */  0x87, 0x01, 0x00, 0x00
                        }, 

                        "framebuffer-con1-enable", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00                         
                        }, 

                        "framebuffer-con2-alldata", 
                        Buffer (0x0C)
                        {
                            /* 0000 */  0x02, 0x06, 0x0A, 0x00, 0x00, 0x04, 0x00, 0x00, 
                            /* 0008 */  0x87, 0x01, 0x00, 0x00                           
                        }, 

                        "framebuffer-con2-enable", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00 
                        }, 

                        "framebuffer-con3-alldata", 
                        Buffer (0x0C)
                        {
                            /* 0000 */  0x03, 0x07, 0x0A, 0x00, 0x00, 0x04, 0x00, 0x00,
                            /* 0008 */  0x87, 0x01, 0x00, 0x00 
                        }, 

                        "framebuffer-con3-enable", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00 
                        }, 

                        "framebuffer-memorycount", 
                        Buffer (0x04)
                        {
                             0x03, 0x00, 0x00, 0x00 
                        }, 

                        "framebuffer-patch-enable", 
                        Buffer (0x04)
                        {
                             0x01, 0x00, 0x00, 0x00
                        }, 

                        "framebuffer-pipecount", 
                        Buffer (One)
                        {
                             0x03, 0x00, 0x00, 0x00 
                        }, 

                        "framebuffer-portcount", 
                        Buffer (One)
                        {
                             0x04, 0x00, 0x00, 0x00 
                        }, 

                        "framebuffer-unifiedmem", 
                        Buffer (0x04)
                        {
                             0x00, 0x00, 0xF0, 0xFF
                        }, 

                        "hda-gfx", 
                        Buffer (0x0A)
                        {
                            "onboard-1"
                        }, 

                        "model", 
                        Buffer (0x16)
                        {
                            "Intel HD Graphics 630"
                        }, 

                        "shikigva", 
                        Buffer (0x16)
                        {
                             0x80, 0x00, 0x00, 0x00 
                        }
                    })
                }

                Return (Zero)
            }
        }
    }
}

