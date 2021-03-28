# OCI2C-TPXX Patch Method

## Description

This method provides a solution for implementing Hotpatch patches to I2C devices. This method does not cover the specific process and details of I2C patching. For more details on I2C, see.

- @penghubingzhou: [https://www.penghubingzhou.cn](https://www.penghubingzhou.cn)
- @神楽小白(GZ小白):[https://blog.gzxiaobai.cn/](https://blog.gzxiaobai.cn/)
- @神楽小白(GZ小白)'s TouchPad-Hotfix Example Library:[https://github.com/GZXiaoBai/Hackintosh-TouchPad-Hotpatch](https://github.com/GZXiaoBai/Hackintosh- TouchPad-Hotpatch)
- VoodooI2C official documentation: [https://voodooi2c.github.io/#GPIO%20Pinning/GPIO%20Pinning](https://voodooi2c.github.io/#GPIO%20Pinning/GPIO% 20Pinning)
- VoodooI2C Official Support Post [https://www.tonymacx86.com/threads/voodooi2c-help-and-support.243378/](https://www.tonymacx86.com/threads/ voodooi2c-help-and-support.243378/)
- Q-groups: `837538729` (1 group is full), `921143329` (2 groups)

## Patch principle and process

- Disable the original I2C device. Check "Binary renaming and preset variables" for details.

  ```
  /*
   * GPI0 enable
   */
  DefinitionBlock("", "SSDT", 2, "OCLT", "GPI0", 0)
  {
      External(GPEN, FieldUnitObj)
      // External(GPHD, FieldUnitObj)
      Scope (\)
      {
          If (_OSI ("Darwin"))
          {
              GPEN = 1
              // GPHD = 2
          }
      }
  }
  ```

- Create a new I2C device `TPXX` and port all the contents of the original device to `TPXX`.
- Fix `TPXX` related content.
  - Replace the original I2C device `name` with `TPXX` in its entirety.
  - **FIXED** `_STA` part to

    ```Swift
    Method (_STA, 0, NotSerialized)
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
    ```

  - **Corrected** the ``relevant content`` of the variables used when the original I2C device was disabled, so that they are logically related.
  - **Corrected** the ``relevant content'' of the operating system variable OSYS to make it logical.
- Exclude errors
- I2C patch

### Example (Dell Latitude 5480, device path: \_SB.PCI0.I2C1.TPD1`)

- Disable ``TPD1`` using the Preset Variable Method.

  ``Swift
  Scope (\)
  {
      If (_OSI ("Darwin"))
      {
          SDS1 = 0
      }
  }
  ```

- Create a new device `TPXX` and port all the contents of the original `TPD1` to `TPXX`.

  ``` Swift
  External(_SB.PCI0.I2C1, DeviceObj)
  Scope (_SB.PCI0.I2C1)
  {
      Device (TPXX)
      {
         Original TPD1 content
      }
  }
  ```

- Amend `TPXX` content:
  - All `TPD1` replaced with `TPXX`.
  - Replace the `_STA` part of the patch with
  
    ```Swift
    Method (_STA, 0, NotSerialized)
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
    ```
  
  - Look up `SDS1` (the variable used when `TPD1` is disabled) and change the original `If (SDS1...) ` to `If (one)`.  
  - Look up `OSYS` and remove (comment out) the following.
  
    ``Swift
    //If (LLess (OSYS, 0x07DC))
    //{
    // SRXO (GPDI, One)
    //}
    ```
  
    Note: I2C devices do not work when `OSYS` is less than `0x07DC` (`0x07DC` stands for Windows 8).
  
- Add external reference `External... ` to fix all errors.
- I2C patch (omitted)
