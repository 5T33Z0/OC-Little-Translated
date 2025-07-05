# Fixig Sleep issues on AOAC machines

- [About AOAC Technology](#about-aoac-technology)
  - [How to determine if you have an `AOAC` Machine](#how-to-determine-if-you-have-an-aoac-machine)
- [AOAC Problems](#aoac-problems)
  - [Sleep Issues](#sleep-issues)
  - [Standby Issues](#standby-issues)
- [Fixing AOAC](#fixing-aoac)
- [AOAC Sleep, Wake](#aoac-sleep-wake)
- [AOAC Patches](#aoac-patches)

---

## About AOAC Technology

A new technology, namely *Always On/Always Connected* (AOAC) was introduced by Intel in the 2000s and is designed to maintain network connectivity and data transfer while the computer is in sleep or hibernation mode. Simply put, the introduction of `AOAC` makes laptops behave similar to Smartphones or Bluetooth Headsets.

### How to determine if you have an `AOAC` Machine

- Open [MaciASL](https://github.com/acidanthera/MaciASL/releases)
- Click on "File > New From ACPI" and select `FACP.aml` (if present)
- Search for `Low Power S0 Idle`. If it is set to `1`, you have an `AOAC` machine. For example:
  ```asl
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
- Adjust Power Idle Management
- Choose a better quality SSD: SLC>MLC>TLC>QLC (not sure)
- Update SSD firmware if possible to improve power management performance
- Enable APST (Autonomous Power State Transition) for SSDs using [`NVMeFix.kext`](https://github.com/acidanthera/NVMeFix/releases)
- Configure [`ASPM`](/Content/04_Fixing_Sleep_and_Wake_Issues/Setting_ASPM_Operating_Mode) (if you can't enable it in the BIOS/UEFI directly)

## AOAC Sleep, Wake

- `AOAC` Sleep – This scheme can put the machine to sleep. In essence, the system and hardware only enter an idle state, not a `S3` sleep in the traditional sense.
- `AOAC` Wakeup – Waking up a machine after it enters `AOAC` sleep can be difficult and usually requires pressing the power button to wake it up. Some machines may require the power button and `PNP0C0D` method to wake it up.

## AOAC Patches

- [Prevent S3 Sleep](/Content/04_Fixing_Sleep_and_Wake_Issues/Fixing_AOAC_Machines/i_Prevent_S3_Sleep)
- [Disabling Discrete GPUs](/Content/04_Fixing_Sleep_and_Wake_Issues/Fixing_AOAC_Machines/ii_AOAC_Disable_Discrete_GPU)
- [Deep Idle Power Management](/Content/04_Fixing_Sleep_and_Wake_Issues/Fixing_AOAC_Machines/iii_Power_Management_Deep_Idle)
- [AOAC Wakeup Method](/Content/04_Fixing_Sleep_and_Wake_Issues/Fixing_AOAC_Machines/iv_AOAC_wake-up_method)
- [Turning off Bluetooth and WIFI during Sleep](/Content/04_Fixing_Sleep_and_Wake_Issues/Fixing_AOAC_Machines/v_Sleep_automatically_turns_off_Bluetooth_WIFI)
- Fixing instant Wake issues &rarr; see [060D Patch](/Content/04_Fixing_Sleep_and_Wake_Issues/060D_Instant_Wake_Fix)
- Enabling `L1` power state &rarr; see [Configuring ASPM](/Content/04_Fixing_Sleep_and_Wake_Issues/Setting_ASPM_Operating_Mode)

> [!CAUTION]
>
>- The `AOAC` fix is a temporary solution. With the widespread use of `AOAC` technology, there may be a better solution in the future.
>- Since `AOAC` sleep/wake is different from `S3` sleep/wake, the following patches are not applicable:
>   - [PTSWAKTTS Patch](/Content/04_Fixing_Sleep_and_Wake_Issues/PTSWAK_Sleep_and_Wake_Fix)
>   - [PNP0C0E Sleep Fix](/Content/04_Fixing_Sleep_and_Wake_Issues/PNP0C0E_Sleep_Correction_Method)
>- For the same reason as above, `AOAC` sleep does not show the working status correctly, such as no breathing light blinks during sleep.
>- You can also try this method on non-AOAC machines.
