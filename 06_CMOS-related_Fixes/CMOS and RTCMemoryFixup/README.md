# CMOS Memory and RTCMemoryFixup

## Description

- When a conflict occurs between **AppleRTC** and **BIOS**, try to use **RTCMemoryFixup** to emulate **CMOS** memory to avoid the conflict.
- Download **RTCMemoryFixup** at <https://github.com/acidanthera/RTCMemoryFixup>

## **CMOS** Memory

- **CMOS** memory holds important data such as date, time, hardware configuration information, auxiliary setup information, boot settings, hibernation information, etc.

- Some **CMOS** memory space definitions.

  - Date, time, hardware configuration: `00-0D` 
  - Hibernation information storage interval: `80-AB` 
  - Power management: `B0-B4` 
  - Other

## View COMS memory

- `EFI\OC\Tools` install ***RtcRw.efi*** 
- config add `items` of ***RtcRw.efi*** 
- boot screen to `Shell` [make sure ***OpenShell.efi*** is installed], go to the directory tools, type rtcrw read XX and enter. Where XX is the CMOS memory address. For example, rtcrw read 08 can view the current month. If this month is May, check the result as 0x05 (BCD code).


## Simulate **CMOS** memory

- Install **RTCMemoryFixup** to `OC\Kexts` and add the driver list.

- Boot **`boot-args`** Add `rtcfx_exclude=... `

   Format: `rtcfx_exclude=offset1,offset2,start_offset-end_offset,... ` For example: `rtcfx_exclude=0D`, `rtcfx_exclude=40-AF`, `rtcfx_exclude=2A,2D,80-AB`, etc.


## Caution

- Emulating **CMOS** memory will erase the originally defined functions, please **use with caution**. For example: `rtcfx_exclude=00-0D` will cause the date and time of the machine to stop updating during sleep.

## Appendix: **CMOS** Memory `00-3F` Definition

| address | description |
| ----- | ------------------------------------------------------------------------------- |
| `0` | seconds |
| `1` | second alarm |
| `2` | minutes |
|3` |minute alarm
| `4` | hour
|5` |Hour Alarm
| Day of the week
| Day
| month
|Year
| Status Register A
| Status Register B
| Status Register C
| `D` | Status Register D (0:battery disabled; 80:battery active) |
| `E` | Diagnostic Status Byte |
| `F` | Shutdown status byte (power-up diagnostic definition) |
| `10` | Floppy drive type (bits 7-4: A drive, bits 3-0: B drive 1-360KB; 2-1.2MB; 6-1.44MB; 7-720KB) |
| `11` | Reserved |
| `12` | Hard drive type (bits 7-4: C drive, bits 3-0: D drive) | `12` | Hard drive type (bits 7-4: C drive, bits 3-0: D drive)
| `13` | Reserved
| `14` | Device bytes (number of floppy drives, display type, coprocessor) |
| `15` | Basic memory low byte |
| `16` | Base memory high byte |
| `17` | Extended memory low byte |
| `18` | Extended Memory High Byte
| `19` | First Master Drive Type
| `1A` | First slave drive type |
| `1B-1C` | Reserved
| `1D-24` | First master drive's pillar, head, sector, etc. |
| `25-2C` | Columns, heads, sectors, etc. of the first slave drive
| `2D` | Reserved
| `2E-2F` | CMOS checksum (10-2D byte sum) |
| `30` | Expanded Memory Low Byte |
| `31` | Expanded Memory High Byte |
| `32` | Date century byte (19H:19th century) |
| `33` | message flag |
| `34-3F` | Reserved |
