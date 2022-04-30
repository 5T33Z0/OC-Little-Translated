/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLTLW99O.aml, Sat Apr 30 08:15:38 2022
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000004D (77)
 *     Revision         0x02
 *     Checksum         0x3C
 *     OEM ID           "OCLT"
 *     OEM Table ID     "NBCF"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200925 (538970405)
 */
DefinitionBlock ("", "SSDT", 2, "STZO", "NBCF", 0x00000000)
{
    External (NBCF, IntObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            NBCF = One    // For DSDT compiled with with older iasl use NBCF = 1 instead.
           
        }
    }
}

