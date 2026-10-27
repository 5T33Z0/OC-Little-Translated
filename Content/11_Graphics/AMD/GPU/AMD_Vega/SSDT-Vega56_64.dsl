/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20210331 (64-bit version)
 * Copyright (c) 2000 - 2021 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLPiM4QN.aml, Fri Oct 28 19:02:53 2022
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000000C7 (199)
 *     Revision         0x02
 *     Checksum         0x6F
 *     OEM ID           "OCLT"
 *     OEM Table ID     "VEGA"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20210331 (539034417)
 */
DefinitionBlock ("", "SSDT", 2, "OCLT", "VEGA", 0x00000000)
{
    External (_SB_.PCI0.PEG0, DeviceObj)
    External (_SB_.PCI0.PEG0.PEGP, DeviceObj)

    Scope (\_SB.PCI0.PEG0)
    {
        Scope (PEGP)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (Zero)
                }
                Else
                {
                    Return (0x0F)
                }
            }
        }

        Device (EGP0)
        {
            Name (_ADR, Zero)  // _ADR: Address
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

            Device (EGP1)
            {
                Name (_ADR, Zero)  // _ADR: Address
                Device (GFX0)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                }
            }
        }
    }
}

