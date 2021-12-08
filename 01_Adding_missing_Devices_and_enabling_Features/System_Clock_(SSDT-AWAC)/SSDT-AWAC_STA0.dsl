/*
 * For 300-series only. If you can't force enable Legacy RTC in BIOS GUI.
 * macOS does yet not support AWAC, so we have to force enable RTC. Do not use RTC ACPI patch.
 * 
 * Disable AWAC where SSDT-AWAC has no effect, check ioreg, AWAC must not be present.
 */

DefinitionBlock ("", "SSDT", 2, "ACDT", "AWAC", 0x00000000)
{
    External (_SB_.AWAC._STA, IntObj)

    Scope (\)
    {

        If (_OSI ("Darwin"))
        {
            \_SB.AWAC._STA = Zero
            
        }
    }
}

