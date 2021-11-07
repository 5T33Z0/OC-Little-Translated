# AOAC General Description

## About AOAC Technology

A new technology, namely *Always On/Always Connected* (AOAC) was introduced by Intel in the 2000s and is designed to maintain network connectivity and data transfer while the computer is in sleep or hibernation mode. Simply put, the introduction of `AOAC` makes laptops like our cell phones or Bluetooth Headsets.

### How to determine if you have an `AOAC` Machine

- Open [MaciASL](https://github.com/acidanthera/MaciASL/releases)
- Click on "File > New From ACPI" and select `FACP.aml`
- Search for `Low Power S0 Idle`. If it is = `1`, it is an `AOAC` machine. For example:

  ```swift
  Low Power S0 Idle (V5) : 1
  ```

For more information about `AOAC`, please refer to the search option of your choice and look for `AOAC`, `Lenovo AOAC`, `AOAC NIC`, etc.

## AOAC Problems

### Sleep Issues

- Due to the contradiction between `AOAC` and `S3` itself, machines with `AOAC` technology do not have `S3` sleep function, such as `Lenovo PRO13`. Such a machine will **Sleep Fail** once it enters `S3` sleep. **Sleep failure** is mainly manifested as: it cannot be woken up after sleep and appears to be dead, and can only be forced to shut down. The essence of **sleep failure** is that the machine stays in the sleep process and never sleeps successfully.
- See the ACPI Specification for `S3` sleep aspects.

### Standby Issues

Although **Disabling `S3` sleep** solves the **sleep failure** problem, the machine will no longer sleep which produces another problem: the absence of sleep reduced the standby time in battery-powered mode. For example, in the case of "menu sleep", "auto sleep", "box cover sleep", etc., the battery power consumption is about 5% to 10% higher per hour.

## Fixing AOAC

- Disable `S3` sleep
- Turn off the power supply of the solo display
- Power Idle Management
- Choose better quality SSD: SLC>MLC>TLC>QLC (not sure)
- Update SSD firmware if possible to improve power management performance
- Enable APST for SSDs using NVMeFix.kext
- Enable ASPM (if you can't enable it in the BIOS directly, see Chapter 16 to patch it in)

## AOAC Sleep, Wake

- `AOAC` Sleep
- The above scheme can make the machine sleep, this sleep is called `AOAC` sleep . The essence of `AOAC` sleep is that the system and hardware have entered an idle state, not `S3` sleep in the traditional sense.

- `AOAC` Wakeup

  Waking up a machine after it enters `AOAC` sleep can be difficult and usually requires the power button to wake it up. Some machines may require the power button + `PNP0C0D` method to wake up the machine.

## AOAC Patches

- [Prevent S3 Sleep](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/Fixing_AOAC_Machines/i%20Prevent%20S3%20Sleep)
- [Disabling Discrete GPUs](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/Fixing_AOAC_Machines/ii%20AOAC%20Disable%20Discrete%20GPU)
- [Power Idle Management](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/Fixing_AOAC_Machines/iii%20Power%20Management%20Deep%20Idle)
- [AOAC Wakeup Method](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/Fixing_AOAC_Machines/iiii%20AOAC%20wake-up%20method)
- [Turning off Bluetooth and WIFI during Sleep](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/Fixing_AOAC_Machines/iv%20Sleep%20automatically%20turns%20off%20Bluetooth%20WIFI)
- Fixing instant Wake issues &rarr; see [060D Patch](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/060D_Instant_Wake_Fix)
- Enabling Device LI &rarr; see [Configuring ASPM](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Setting_ASPM_Operating_Mode)

## Caution

- The `AOAC` fix is a temporary solution. With the widespread use of `AOAC` technology, there may be a better solution in the future.
- Since `AOAC` sleep/wake is different from `S3` sleep/wake, the following patches are not applicable:
  - [**PTSWAKTTS Patch**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PTSWAK_Sleep_and_Wake_Fix)
  - [**PNP0C0E Sleep Fix**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/PNP0C0E_Sleep_Correction_Method)
- For the same reason as above, `AOAC` sleep does not show the working status correctly, such as no breathing light blinks during sleep.
- You can also try this method on non-AOAC machines.
