//
//GUPC Variant 1 with Arg0 for controlling port enabled/disabled and Arg1 for setting the USB Type:

Method (GUPC, 2, Serialized)
{
    Name (PCKG, Package (0x04)
    {
        0xFF, 
        0x03, 
        Zero, 
        Zero
    })
    PCKG [Zero] = Arg0
    PCKG [One] = Arg1
    Return (PCKG) /* \GUPC.PCKG */
    }
}

// Scope Variant 1A With Arg0 and Arg1:

Scope (\_SB.PCI0.XHC.RHUB.HS02)           // Adjust path according to what's used in your OEM SSDT
{
    Method (_UPC, 0, NotSerialized)       // _UPC: USB Port Capabilities
    {
        Return (GUPC (0xFF, 0x03))        // send 0xFF to Arg0 (port enabled) and 0x03 (USB 2.0/3.0) to Arg1
    }
                
// Scope Variant 1B With Arg0, Arg1 and OSI Switch for deavtivatiing a port in macOS:

Scope (\_SB.PCI0.XHC.RHUB.HS01)            //Adjust path according to what's used in your OEM SSDT
{
    Method (_UPC, 0, NotSerialized)        // _UPC: USB Port Capabilities
    {
        If (_OSI ("Darwin"))
        {
            Return (GUPC (Zero, Zero))     // Sets Arg0 and Arg1 to Zero = disabled
        }
        Else
        {
            Return (GUPC (0xFF, 0x03))     // If NOT macOS, use the orginal values.
        }
    )

// Scope Variant for deactivating USR Ports in general (can be combined with OSI method as well:

Scope (\_SB.PCI0.XHC.RHUB.USR1)
{
    Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
    {
        Return (GUPC (Zero, Zero))
    }

    Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
    {
        Return (GPLD (Zero, Zero))
    }
}
