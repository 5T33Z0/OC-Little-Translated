/* 
 * ASUS Shutdown Fix. Combine with _PTS to ZPTS rename. Use either _PTS to ZPTS(1,N) or _PTS to ZPTS(1,S),
 * depending on the way _PTS is handled in your system's DSDT: either Serialized (1,S) or NotSerialized (1,N).
 * 
 * _PTS to ZPTS(1,N)
 * Find:     5F50545301
 * Replace:  5A50545301
 * 
 * _PTS to ZPTS(1,S)
 * Find:     5F50545309
 * Replace:  5A50545309
 */

DefinitionBlock ("", "SSDT", 2, "STZO", "Shut", 0x00000001)
{
    External (ZPTS, MethodObj)

    Method (_PTS, 1, NotSerialized) // _PTS: Prepare To Sleep
    {
        If ((_OSI ("Darwin")) && (Arg0 == 0x05)) {}
        Else
        {
            ZPTS (Arg0)
        }
    }
}

