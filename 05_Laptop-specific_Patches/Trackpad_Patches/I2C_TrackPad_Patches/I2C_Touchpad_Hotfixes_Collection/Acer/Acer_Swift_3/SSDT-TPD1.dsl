/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLJpRk9Y.aml, Fri Oct 28 13:17:17 2022
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000000E2 (226)
 *     Revision         0x02
 *     Checksum         0xF4
 *     OEM ID           "_null"
 *     OEM Table ID     "_tp"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200925 (538970405)
 */
DefinitionBlock ("", "SSDT", 2, "_null", "_tp", 0x00000000)
{
    External (_SB_.PCI0.I2C1.TPD0, DeviceObj)
    External (_SB_.PCI0.I2C1.TPD0.SBFB, IntObj)
    External (GPHD, FieldUnitObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
                GPHD = Zero
            }
        }
    }

    Scope (_SB.PCI0.I2C1.TPD0)
    {
        If (_OSI ("Darwin"))
        {
            Name (SBF2, ResourceTemplate ()
            {
                GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
                    "\\_SB.GPI0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x0055
                    }
            })
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Return (ConcatenateResTemplate (SBFB, SBF2))
            }
        }
    }
}

