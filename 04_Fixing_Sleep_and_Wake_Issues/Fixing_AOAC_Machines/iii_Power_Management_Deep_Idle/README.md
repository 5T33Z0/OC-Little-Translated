# Power Idle Management (`DeepIdle`)

## Description

This patch enables macOS'es own power idle management to extend the standby time in battery operation mode. **See**: [Debugging sleep issues](https://pikeralpha.wordpress.com/2017/01/12/debugging-sleep-issues/) by Pike R.Alpha.

## SSDT Patch

***SSDT-DeepIdle*** -- Power Idle Management Patch

## Caution

- ***SSDT-DeepIdle*** and `S3` sleep may have serious conflict, use ***SSDT-DeepIdle*** to avoid `S3` sleep, see "Disable S3 sleep
- ***SSDT-DeepIdle*** may cause difficulties in waking up the machine, this can be solved by a patch, see "AOAC Wakeup Patch".