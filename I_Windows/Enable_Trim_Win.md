# Trim
Windows 7 and newer supports TRIM for SSDs (if the disk supports it)

## How to check if TRIM is enabled on Windows
To check if TRIM is enabled in Windows, follow these steps:

- Press <kbd>Windows</kbd> + <kbd>x</kbd>, click Search.
- Type `cmd` in the Search box.
- Right-click Command Prompt entry.
- Select "Run as administrator".
- Enter `fsutil behavior query DisableDeleteNotify`.
- Press Enter.

There are two possible outputs of running the above command:

- `DisableDeleteNotify` = `1`, which means that TRIM is disabled on the SSD.
- `DisableDeleteNotify` = `0`, which means that TRIM is enabled on the SSD.

## Enabling Trim

If TRIM is disabled, it can be enabled by following these steps:

- Right-click the Windows icon, click Search.
- Type cmd in the Search box.
- Right-click Command Prompt.
- Select "Run as administrator".
- Enter `fsutil behavior set DisableDeleteNotify 0`.
- Press Enter.
