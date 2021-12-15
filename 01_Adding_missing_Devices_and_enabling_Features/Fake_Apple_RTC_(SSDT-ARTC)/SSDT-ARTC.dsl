//Add ARTC device
DefinitionBlock ("", "SSDT", 2, "Hack", "SsdtARTC", 0x00001000)
{
    External (_SB_.PCI0.LPCB, DeviceObj)

    Scope (\_SB.PCI0.LPCB)
    {
        Device (ARTC)
        {
            Name (_HID, "ACPI000E" /* Time and Alarm Device */)  // _HID: Hardware ID
            Method (_GCP, 0, NotSerialized)  // _GCP: Get Capabilities
            {
                Return (0x05)
            }
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
        }
    }
}

