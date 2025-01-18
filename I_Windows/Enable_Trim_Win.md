# Trim

## How to check if TRIM is enabled on Windows

All Windows OSes post Windows 7 support TRIM for SSDs that support the feature. However, users can check if TRIM is enabled on the Windows OS for a particular computer by following these steps:

- Press Windows key + X, click Search.
- Type cmd in the Search box.
- Right-click Command Prompt.
- Select Run as administrator.
- Type the command fsutil behavior query DisableDeleteNotify.
- Press Enter.

There are two possible results of running the above command:

- `DisableDeleteNotify` = `1`, which means that TRIM is disabled on the SSD.
- `DisableDeleteNotify` = `0`, which means that TRIM is enabled on the SSD.

## Enabling Trim

If TRIM is disabled, it can be enabled by following these steps:

- Right-click the Windows icon, click Search.
- Type cmd in the Search box.
- Right-click Command Prompt.
- Select Run as administrator.
- Type the command fsutil behavior set DisableDeleteNotify 0.
- Press Enter.
