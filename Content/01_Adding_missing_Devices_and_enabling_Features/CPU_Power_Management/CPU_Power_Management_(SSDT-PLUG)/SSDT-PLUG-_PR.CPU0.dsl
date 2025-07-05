/*
 * XCPM power management compatibility table.
 */
DefinitionBlock ("", "SSDT", 2, "OCLT", "CpuPlug", 0x00003000)
{
    External (_PR.CPU0, ProcessorObj)

    Scope (\_PR)
    {
        Scope (CPU0)
        {
            If (_OSI ("Darwin"))
            {
                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If ((Arg2 == Zero))
                    {
                        Return (Buffer (One)
                        {
                             0x03                                             // .
                        })
                    }

                    Return (Package (0x02)
                    {
                        "plugin-type", 
                        One
                    })
                }
            }
        }
    }
}

