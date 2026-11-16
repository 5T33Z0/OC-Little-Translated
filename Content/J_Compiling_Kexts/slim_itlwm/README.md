# itlwm Slim Builder

Build `itlwm.kext` and `AirportItlwm.kext` that contain only the firmware your Intel Wi-Fi card needs.

## About

The stock itlwm kexts embed firmware for every supported Intel Wi-Fi card (about 32 MB in the source tree). Most systems need one or two of those files.

**itlwm Slim Builder** is an interactive Python script for the [laobamac/itlwm](https://github.com/laobamac/itlwm) source that:

1. Lets you pick your firmware by **searching** (firmware name or card model, e.g. `9560`, `AX210`, `iwm-9000-46`) or by listing all firmware. Several can be selected.
2. Lets you pick the build targets: `itlwm`, one or more `AirportItlwm-<macOS version>` targets, or all of them.
3. Copies the source tree to an isolated working directory, so your original checkout stays untouched.
4. Deletes all firmware files you did not select. `iwlwifi-*.ucode` and the matching `.pnvm` file are kept together.
5. Generates the firmware data with the project's `fw_gen` target and checks that it contains exactly the selected files.
6. Builds the selected targets with `xcodebuild` (Release) and saves them to `Builds/`.

It automates the manual steps of the [Slimming Intel Wi-Fi/BT Kexts](https://github.com/5T33Z0/OC-Little-Translated/blob/main/Content/J_Compiling_Kexts/Slimming_Intel_WiFI_BT_Kexts.md) guide for the Wi-Fi kexts.

> **Note:** Slimming only reduces the kext size. It does not improve performance or compatibility. If you keep the wrong firmware, Wi-Fi will not initialize.

## Requirements

- **macOS**
- **Python 3.9 or newer** (no third-party packages needed)
- **Xcode** (including the command line tools, so `xcodebuild` works)
- **itlwm source** from [laobamac/itlwm](https://github.com/laobamac/itlwm) (git clone or source ZIP)
- **MacKernelSDK**, cloned into the itlwm root

Lilu is **not** required: this fork's Xcode project does not reference it.

## Setup

Your itlwm root should look like this:

```
itlwm/
├── itlwm.xcodeproj
├── itlwm/firmware/        <- firmware files the script slims down
├── MacKernelSDK/          <- required
├── build-itlwm-slim.py    <- this script
└── ...
```

1. **Get the source**

   ```sh
   git clone https://github.com/laobamac/itlwm.git
   cd itlwm
   ```

2. **Add MacKernelSDK** and check out the commit the fork's README specifies for macOS Sequoia/Tahoe builds:

   ```sh
   git clone https://github.com/acidanthera/MacKernelSDK.git
   cd MacKernelSDK
   git checkout 3f750085caa17ec3a7880f11c11bf4f48cd6a164
   cd ..
   ```

3. **Copy the script** `build-itlwm-slim.py` into the itlwm root.

## Find your firmware

Before running the script, find out which firmware your card uses:

- Run [IORegistryExplorer](https://github.com/utopia-team/IORegistryExplorer/releases), search for `Airport` and note the `IOModel` value (e.g. `iwm-9000-46`). This only works with `AirportItlwm.kext`.
- With `itlwm.kext`, use the card table in the [guide](https://github.com/5T33Z0/OC-Little-Translated/blob/main/Content/J_Compiling_Kexts/Slimming_Intel_WiFI_BT_Kexts.md#11-identify-your-wi-fi-firmware).

The script shows card hints for some firmware, but treat them as hints and verify.

> **AX201 cards:** depending on the chip stepping, an AX201 may need `iwlwifi-Qu-b0-hr-b0` or `iwlwifi-Qu-c0-hr-b0` instead of `iwlwifi-QuZ-a0-hr-b0`. If Wi-Fi does not come up, rebuild with several candidates selected.

## Usage

Run the script from the itlwm root:

```sh
python3 build-itlwm-slim.py
```

1. **Select firmware**
   - `[1] Search`: enter part of a firmware name or card model. All words must match. Typing an exact firmware name adds it directly.
   - `[2] List all firmware`: shows every entry with its size.
   - Entries are chosen by number, several at once if you like (`2,5`). Chosen entries are marked with `*`.
   - `[3] Continue with selection` when done, `[4] Clear selection` to start over.
2. **Select targets** by number (comma-separated), or `a` for all targets.
3. **Choose whether to keep the slimmed working directory** after the build.
4. **Confirm** to start slimming and compiling.

The `AirportItlwm-*` targets are the native Wi-Fi interface for the matching macOS version. `itlwm` is the standalone kext and needs the [HeliPort](https://github.com/OpenIntelWireless/HeliPort) app to connect to networks.

## Output

| Item | Location |
| --- | --- |
| Finished kexts | `Builds/AirportItlwm-<macOS>-<firmware>.kext` and `Builds/itlwm-<firmware>.kext` (inside the itlwm root) |
| Working copy | `../itlwm-Slimmed` (next to the itlwm folder; removed afterwards unless you chose to keep it) |

If an output already exists, the script asks before replacing it. With more than two firmware groups selected, the file name uses the first group plus a count (e.g. `iwm-9000-46+2more`).

## Using the result

Copy the kext to `EFI/OC/Kexts`, replacing the existing one, and reboot. If Wi-Fi no longer works, the wrong firmware was most likely kept. Rebuild with the correct one, or go back to the pre-built kexts from the itlwm releases.

## Notes

- Run the script from the itlwm root. It aborts if `itlwm.xcodeproj`, `MacKernelSDK`, or the firmware folder is missing.
- Your source checkout is never modified; all slimming happens in the copy.
- Targets are built with `ARCHS=x86_64` and `CODE_SIGNING_ALLOWED=NO`.
- Bluetooth firmware is not handled: this repo does not contain `IntelBluetoothFirmware`.
