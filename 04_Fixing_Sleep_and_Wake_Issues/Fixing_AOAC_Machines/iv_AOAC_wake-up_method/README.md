# AOAC Wakeup Method

## Description

The ***SSDT-DeepIdle*** patch can put the machine into a deep idle state thereby extending the standby time. However, it also makes waking up the machine more difficult and requires a special method. See "Power Idle Management" for more information on ***SSDTDeep-Idle***. **This method** resets the wake-up state via a custom patch.

## Wake-up Method: Power button

**Brief description of wake-up principle**

- Normally, the **Power Button** can wake up the machine. However, there are times when the machine is woken up in an incomplete state. It may not be able to **light up the screen** or to **update the power data**. In this case, you need to add the `_PS0` method under the `LPCB` device and add the **reset wake-up state** method in `_PS0`. Normally, the `_WAK` method [Arg0 = 3] includes **Light Screen** and **Update Power Data**.
- According to the ACPI specification, it is recommended to use both `_PS0` and `_PS3` methods.

## Patch Example

- ***SSDT-PCI0.LPCB-Wake-AOAC*** 

  ```asl
  ...
  Scope (_SB.PCI0.LPCB)
  {
      If (_OSI ("Darwin"))
      {
          Method (_PS0, 0, Serialized)
          {
              \_WAK(0x03) // Resume wakeup state
              //may require custom power data recovery methods
          }
          Method (_PS3, 0, Serialized)
          {
          }
      }
  }
  ...
  ```
## Addendum

- **Light up screen condition** 
  - `_LID` returns `One` . `_LID` is the current state of the `PNP0C0D` device
  - Execute `Notify(***.LID0, 0x80)`. `LID0` is `PNP0C0D` Device name

- **Update power data method** 

  If the power icon cannot be updated after waking up due to changing the power state during sleep (for example, unplugging or plugging in the power during sleep), refer to the following method.

  - Find the name and path of the power device (`_HID` = `ACPI0003`), search by power name, and record the `Method` that contains `Notify (*** Power Name, 0x80)`. Add this `Method` to `_PS0` in ***SSDT-PCI0.LPCB-Wake-AOAC***.
  - `Notify (***Power Name, 0x80)` may exist in more than one `Method`, which must be confirmed by the ACPIDebug method. **Confirm method**: The `Method` that responds to plugging or unplugging power is the one we need.
