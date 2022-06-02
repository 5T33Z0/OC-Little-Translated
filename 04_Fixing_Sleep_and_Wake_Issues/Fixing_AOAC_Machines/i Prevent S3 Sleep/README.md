# Disabling S3 Sleep

## Description

**Disable `S3` sleep** is used to solve the problem of **Sleep Failure** caused by some machines for some reasons. **Sleep Failure** means that the machine cannot be woken up normally after sleep, which is manifested as crashing, rebooting or shutting down after waking up, etc.

## Patch method

- **Rename**: `_S3 to XS3`

  ```text
  Comment: change _S3 to XS3
  Find: 5F53335F
  Replace: 5853335F
  ```
- **Patch**
  - ***SSDT-NameS3-disable***: applies when `ACPI` defines `S3` sleep as a `Name` type. Most machines fall in this category.
  - ***SSDT-MethodS3-disable*** : applies when `ACPI` defines `S3` sleep as a `Method`.

## Caution
Adjust the `S3` method in the SSDT hotpatch according to the machine's original `ACPI` description `S3` method.
