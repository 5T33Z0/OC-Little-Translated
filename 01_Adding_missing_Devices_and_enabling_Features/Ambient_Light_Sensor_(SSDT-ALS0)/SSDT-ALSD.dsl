//Enable ALSD if present in ACPI Origin. Native ambient light sensor.

DefinitionBlock ("", "SSDT", 2, "OCLT", "ALSD", 0)
{
    External (ALSE, IntObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            ALSE = 2
        }
    }
}

