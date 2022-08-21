/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLgQc95e.aml, Wed Aug  3 13:14:13 2022
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000080 (128)
 *     Revision         0x02
 *     Checksum         0x1E
 *     OEM ID           "STZ0"
 *     OEM Table ID     "SATA"
 *     OEM Revision     0x00001000 (4096)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200925 (538970405)
 */
DefinitionBlock ("", "SSDT", 2, "5T33Z0", "SATA", 0x00001000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.SAT1, DeviceObj)

    If (_OSI ("Darwin"))
    {
        Scope (\_SB.PCI0)
        {
            Scope (SAT1)
            {
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (Zero)
                }
            }

            Device (SATA)
            {
                Name (_ADR, 0x001F0002)          // Check your DSDT to get the the actual Address!
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }
            }
        }
    }
}

