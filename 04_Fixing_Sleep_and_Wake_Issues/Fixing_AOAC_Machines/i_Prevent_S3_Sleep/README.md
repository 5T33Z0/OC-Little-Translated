# Disabling S3 Sleep

## Description

This patch disables the `S3` sleep state. Useful in cases, where the system cannot return from sleep as expected, resulting in system crashes, reboots or shutdowns when trying to wake it.

## Patch method

- **Rename**: `_S3 to XS3`

  ```text
  Comment: change _S3 to XS3
  Find: 5F53335F
  Replace: 5853335F
  ```
- **Patch** (use either or)
  - ***SSDT-NameS3-disable***: applies when `ACPI` defines `S3` sleep as a `Name` type. Most machines fall in this category.
  - ***SSDT-MethodS3-disable*** : applies when `ACPI` defines `S3` sleep as a `Method`.

## :warning: Caution
Adjust the `S3` method in the SSDT hotpatch according to the machine's original `ACPI` description of the `S3` method.
