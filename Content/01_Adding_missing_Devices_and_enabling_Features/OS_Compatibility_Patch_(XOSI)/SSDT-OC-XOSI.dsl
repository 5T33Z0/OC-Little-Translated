/*
 * ACPI code can use the _OSI method (implemented by the ACPI host) to check
 * which Windows version it is running on. Most DSDT implementations will vary
 * the USB configuration depending on the version of Windows that is running.
 *
 * When running macOS, none of the checks DSDT might be doing for _OSI ("Windows
 * <version>") will return 'true' because it only responds to "Darwin". This is
 * the reason for having the "OS Check Fix" family of DSDT patches. By patching
 * DSDT to simulate a certain version of Windows when running Darwin, we obtain
 * behavior that'd normally happen when running that specific version of Windows.
 *
 * Normally, _OSI calls would be handled by macOS (the ACPI host), but via the
 * patch, _OSI calls are routed to XOSI so a particular version of Windows can 
 * be simulated. 
 */
// Instruction:
// 1. In DSDT, search for _OSI and check which version of Windows is supported
// 2. Uncomment the corresponding version in the "Arg0" section (remove the slashes in front of it)
// 3. Search for OSID and OSIF as well. If they are present, rename them as well (see below)
// 4. Add "change _OSI to XOSI" rename
// 5. Export file as SSDT-XOSI.aml, place in ACPI Folder and add it to your config.plist
//
// In ACPI/Patch, add rule "change OSID to XSID" (if present in DSDT)
// Find:     4F534944
// Replace:  58534944
//
// In ACPI/Patch, add rule "OSIF to XSIF" (if present in DSDT)
// Find:     4F534946
// Replace:  58534946
//
// In ACPI/Patch, add "change _OSI to XOSI"
// Find:     5F4F5349
// Replace:  584F5349
//
//
DefinitionBlock("", "SSDT", 2, "OCLT", "OC-XOSI", 0)
{
    Method(XOSI, 1)
    {
        If (_OSI ("Darwin"))
        {
            If (Arg0 == //"Windows 2009"  //  = win7, Win Server 2008 R2
                        //"Windows 2012"  //  = Win8, Win Server 2012
                        //"Windows 2013"  //  = win8.1
                        "Windows 2015"    //  = Win10
                        //"Windows 2016"  //  = Win10 version 1607
                        //"Windows 2017"  //  = Win10 version 1703
                        //"Windows 2017.2"//  = Win10 version 1709
                        //"Windows 2018"  //  = Win10 version 1803
                        //"Windows 2018.2"//  = Win10 version 1809
                        //"Windows 2019"  //  = Win10 version 1903
                        //"Windows 2020"  //  = Win10 version 2004
                        //"Windows 2021"  //  = Win11  
                        //"Windows 2022"  //  = Windows 11, version 22H2
                )
            {
                Return (Ones)
            }
            
            Else
            {
                Return (Zero)
            }
        }
        
        Else
        {
            Return (_OSI (Arg0))
        }
    }
}
//EOF
