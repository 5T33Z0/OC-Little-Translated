# Understanding Intel Wireless Firmware File Names

**TABLE of CONTENTS**

- [Overview](#overview)
- [Intel Wi-Fi Firmware (`iwlwifi`)](#intel-wi-fi-firmware-iwlwifi)
  - [Filename Structure](#filename-structure)
  - [`iwlwifi`](#iwlwifi)
  - [Firmware Family (`ty-a0`)](#firmware-family-ty-a0)
  - [Hardware Variant (`gf-a0`)](#hardware-variant-gf-a0)
  - [Firmware API Version (`68`)](#firmware-api-version-68)
  - [`.ucode`](#ucode)
- [Intel Bluetooth Firmware (`ibt`)](#intel-bluetooth-firmware-ibt)
  - [Bluetooth Filename Structure](#bluetooth-filename-structure)
  - [`ibt`](#ibt)
  - [Bluetooth Firmware Generation (`19`)](#bluetooth-firmware-generation-19)
  - [Firmware Revision (`0-3`)](#firmware-revision-0-3)
  - [`.sfi`](#sfi)
- [Example: Intel AX210](#example-intel-ax210)
  - [Wi-Fi](#wi-fi)
  - [Bluetooth](#bluetooth)
- [Relationship with OpenIntelWireless Projects](#relationship-with-openintelwireless-projects)
  - [Wi-Fi (`itlwm`)](#wi-fi-itlwm)
  - [Bluetooth (`IntelBluetoothFirmware`)](#bluetooth-intelbluetoothfirmware)
- [Updating Firmware](#updating-firmware)
  - [Wi-Fi](#wi-fi-1)
  - [Bluetooth](#bluetooth-1)
- [Firmware Sources](#firmware-sources)

---

## Overview

Intel wireless firmware files follow specific naming conventions depending on whether they are used for Wi-Fi or Bluetooth. These firmware blobs are distributed through the `linux-firmware` project and are mainly used by Linux kernel drivers:

* Wi-Fi → `iwlwifi`
* Bluetooth → Intel Bluetooth firmware (`ibt`)

The OpenIntelWireless Projects [**itlwm**](https://github.com/OpenIntelWireless/itlwm) and [**IntelBluetoothFirmware**](https://github.com/OpenIntelWireless/IntelBluetoothFirmware) reuse these firmware files and adapt them for macOS to enable Intel Wi-Fi/Bluetooth cards.

---

## Intel Wi-Fi Firmware (`iwlwifi`)

Intel Wi-Fi firmware files are located in:

```text
linux-firmware/
└── intel/
    └── iwlwifi/
        └── iwlwifi-*.ucode
```

**Example**:

```text
iwlwifi-ty-a0-gf-a0-68.ucode
```

### Filename Structure

```text
iwlwifi-ty-a0-gf-a0-68.ucode
│       │     │     │
│       │     │     └────── Firmware API version
│       │     └──────────── Hardware platform / revision
│       └────────────────── Firmware family
└────────────────────────── Intel Wireless firmware
```

### `iwlwifi`

`iwlwifi` identifies the firmware family used by Intel's Linux Wi-Fi driver.

It is not the firmware itself. It is the driver name responsible for loading the firmware into Intel wireless chips.

Firmware location:

```text
intel/
└── iwlwifi/
    └── iwlwifi-*.ucode
```

---

### Firmware Family (`ty-a0`)

The first identifier describes the Intel firmware family.

**Examples**:

| Identifier | Common Intel chips          |
| ---------- | --------------------------- |
| `cc-a0`    | Intel Wi-Fi 6 AX200 / AX201 |
| `ty-a0`    | Intel Wi-Fi 6E AX210        |
| `so-a0`    | Intel Wi-Fi 6E AX211        |

The firmware family must match the wireless chipset generation.

---

### Hardware Variant (`gf-a0`)

The second identifier describes the hardware platform or revision.

**Example**:

```text
iwlwifi-ty-a0-gf-a0-68.ucode
              ^^^^^
```

Different Intel platforms use different identifiers:

```text
ty-a0-gf-a0
so-a0-hr-b0
```

A firmware file from another hardware variant cannot simply be exchanged.

---

### Firmware API Version (`68`)

The final number before the file extension represents the firmware API version.

Example:

```text
iwlwifi-ty-a0-gf-a0-68.ucode
                    ^^
```

Examples:

```text
iwlwifi-ty-a0-gf-a0-68.ucode
iwlwifi-ty-a0-gf-a0-72.ucode
iwlwifi-ty-a0-gf-a0-89.ucode
```

A higher number generally indicates a newer firmware version.

However, the driver must support the corresponding firmware API.

**Example**:

```text
Driver supports API 68
        │
        ▼
Firmware API 89
        │
        ▼
Not necessarily compatible
```

---

### `.ucode`

The `.ucode` file contains the binary microcode uploaded into the Intel Wi-Fi controller.

The firmware handles tasks such as:

* Radio control
* Power management
* Calibration
* Wireless protocol functions
* Hardware-specific operations

---

## Intel Bluetooth Firmware (`ibt`)

Intel Bluetooth firmware uses a different naming scheme.

The files are located in:

```text
linux-firmware/
└── intel/
    └── ibt-*.sfi
```

**Example**:

```text
ibt-19-0-3.sfi
```

---

### Bluetooth Filename Structure

```text
ibt-19-0-3.sfi
│   │  │ │ │
│   │  │ │ └── File format
│   │  │ └──── Firmware revision
│   │  └────── Sub-generation
│   └──────── Firmware family generation
└──────────── Intel Bluetooth firmware
```

---

### `ibt`

`ibt` identifies Intel Bluetooth firmware.

Unlike `iwlwifi`, it is not a driver name but a firmware naming convention.

---

### Bluetooth Firmware Generation (`19`)

The first number identifies the Bluetooth firmware generation.

Examples:

| Firmware family | Typical devices                                                        |
| --------------- | ---------------------------------------------------------------------- |
| `ibt-17-*`      | Older Intel Bluetooth controllers                                      |
| `ibt-18-*`      | Intel Bluetooth 5.x controllers                                        |
| `ibt-19-*`      | Intel Bluetooth generation used with AX200 / AX201 / AX210 era devices |

---

### Firmware Revision (`0-3`)

The remaining numbers describe the firmware revision branch.

**Example**:

```text
ibt-19-0-3.sfi
    │  │ │
    │  │ └── Patch level
    │  └──── Sub-generation
    └─────── Firmware family
```

Unlike Wi-Fi firmware, this is not a firmware API version.

---

### `.sfi`

The `.sfi` extension stands for Secure Firmware Image.

It contains the binary firmware uploaded into the Intel Bluetooth controller.

Additional files may exist:

```text
ibt-*.sfi
ibt-*.ddc
```

The `.ddc` files contain device configuration data.

---

## Example: Intel AX210

### Wi-Fi

```text
iwlwifi-ty-a0-gf-a0-68.ucode
```

| Component | Meaning                     |
| --------- | --------------------------- |
| `iwlwifi` | Intel Wi-Fi firmware family |
| `ty-a0`   | AX210 firmware family       |
| `gf-a0`   | Hardware variant            |
| `68`      | Firmware API version        |
| `.ucode`  | Microcode firmware          |

### Bluetooth

```text
ibt-19-0-3.sfi
```

| Component | Meaning                       |
| --------- | ----------------------------- |
| `ibt`     | Intel Bluetooth firmware      |
| `19`      | Bluetooth firmware generation |
| `0-3`     | Firmware revision             |
| `.sfi`    | Secure Firmware Image         |

---

## Relationship with OpenIntelWireless Projects

### Wi-Fi (`itlwm`)

`itlwm` does not directly use the original Linux `.ucode` files.

The firmware is converted into a format suitable for embedding into the macOS kernel extension.

Workflow:

```text
Intel Wi-Fi firmware
        │
        ▼
linux-firmware
intel/iwlwifi/*.ucode
        │
        ▼
fw_gen.py
(OpenIntelWireless)
        │
        ▼
itlwm/firmware/
        │
        ▼
itlwm.kext
```

---

### Bluetooth (`IntelBluetoothFirmware`)

`IntelBluetoothFirmware.kext` uploads the firmware to the Intel Bluetooth controller and allows Apple's Bluetooth stack to communicate with it.

Workflow:

```text
Intel Bluetooth firmware
        │
        ▼
linux-firmware
intel/ibt/*.sfi
        │
        ▼
IntelBluetoothFirmware.kext
        │
        ▼
Intel Bluetooth controller
        │
        ▼
Apple Bluetooth stack
```

---

## Updating Firmware

A firmware update requires more than replacing the binary file.

### Wi-Fi

Required:

1. New `iwlwifi-*.ucode` firmware blob
2. Driver support for the corresponding firmware API

### Bluetooth

Required:

1. Matching `ibt-*.sfi` firmware
2. Support for the corresponding Bluetooth controller generation

A newer firmware file is only useful if the driver supports it.

---

## Firmware Sources

Both Wi-Fi and Bluetooth firmware originate from the same upstream project:

```text
linux-firmware/

intel/
├── iwlwifi/    → Intel Wi-Fi firmware
└── ibt/        → Intel Bluetooth firmware
```

When maintaining a fork:

* Wi-Fi → update `iwlwifi-*.ucode`
* Bluetooth → update `ibt-*.sfi` and `ibt-*.ddc`

The naming conventions are different because Intel Wi-Fi and Intel Bluetooth use different firmware architectures.
