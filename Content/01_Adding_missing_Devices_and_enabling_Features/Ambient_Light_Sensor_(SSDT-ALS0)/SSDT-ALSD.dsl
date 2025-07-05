//Enables native Ambient Light Sensor, if ALSD exists in DSDT. 

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
