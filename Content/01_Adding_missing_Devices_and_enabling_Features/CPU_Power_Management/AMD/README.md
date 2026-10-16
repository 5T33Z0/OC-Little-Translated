# AMD CPU/APU Power Management

## About

Unlike Intel systems (which rely on XCPM + SSDT-PLUG / CPUFriend), AMD systems on macOS have no native equivalent of full software power management. The traditional approach for monitoring is **SMCAMDProcessor** + **AMD Power Gadget**. For *adjusting* power limits (similar to what **Universal x86 Tuning Utility (UXTU)** does on Windows), the current recommended tools are **ZenMaster** (CLI) and **ZenTune** (TUI frontend).

> [!NOTE]
>
> This is a **temporary solution** for adjusting power limits, thermal targets, VRM currents, and related parameters on AMD Ryzen CPUs/APUs under macOS (Hackintosh).

---

## Prerequisites

Your system must correctly report AMD CPU information via `sysctl`. Verify with:

```bash
sysctl -a | grep "machdep.cpu"
```

Expected output example (values will differ depending on your CPU):

```
machdep.cpu.vendor: AuthenticAMD
machdep.cpu.brand_string: AMD Ryzen 5 4500U with Radeon Graphics
machdep.cpu.family: 23
machdep.cpu.model: 96
machdep.cpu.extmodel: 6
machdep.cpu.extfamily: 8
machdep.cpu.stepping: 1
```

**Required fields** for proper detection:
- `machdep.cpu.family`
- `machdep.cpu.model`
- `machdep.cpu.stepping`

> **Note**: Proper reporting relies on OpenCore quirks such as `ProvideCurrentCpuInfo`. Without correct CPUID information, detection will fail.

---

## Tools

| Tool | Type | Description | Link |
|------|------|-------------|------|
| **ZenMaster** | CLI / Library | Pure-Python tool to adjust SMU power limits, thermal targets, VRM currents, Curve Optimizer, etc. Drop-in style replacement for RyzenAdj. | [GitHub](https://github.com/HorizonUnix/ZenMaster) / [PyPI](https://pypi.org/project/zenmaster/) |
| **ZenTune** | TUI Frontend | Terminal UI built on top of ZenMaster. Provides presets (Eco / Balanced / Performance / Extreme), custom editor, automations, etc. | [GitHub](https://github.com/HorizonUnix/ZenTune) |
| **SMCAMDProcessor** | Kext + App | Monitoring + basic power management (temperature, power, frequency). Required for AMD Power Gadget. | [GitHub](https://github.com/trulyspinach/SMCAMDProcessor) |

---

## Installation & Usage (macOS / Hackintosh)

### 1. ZenMaster (CLI)

```bash
pip3 install zenmaster
```

**Two access paths are available:**

#### A. Full-function path (recommended)
- Install **DirectHW.kext** (from [joevt/directhw](https://github.com/joevt/directhw))
- Set `csr-active-config` to `03080000` (or equivalent that allows the kext)
- Add DirectHW.kext to your OpenCore `Kernel → Add` section

```bash
sudo zenmaster --info
sudo zenmaster --stapm-limit=15000 --fast-limit=20000 --slow-limit=18000 --tctl-temp=90
```

#### B. Kext-less path
Add the boot argument:

```
debug=0x144
```

Then force the IOPCIBridge path:

```bash
sudo zenmaster --iopci --info
sudo zenmaster --iopci --stapm-limit=15000 --fast-limit=20000 --tctl-temp=90
```

> The kext-less path supports **tuning only**. Full PM table / sensor reading requires DirectHW.

### 2. ZenTune (TUI)

```bash
curl -fsSL https://raw.githubusercontent.com/HorizonUnix/ZenTune/main/install.sh | bash
zentune
```

On first run the application will guide you through daemon setup and hardware detection.

**macOS notes:**
- Adaptive Mode and live Home-tab sensor graphs are currently **Linux-only**.
- Presets, custom tuning, and automations work on macOS.

---

## Common Tuning Parameters

| Parameter | Description | Unit |
|-----------|-------------|------|
| `--stapm-limit` | Sustained Power Limit (STAPM) | mW |
| `--fast-limit` | PPT Fast Limit | mW |
| `--slow-limit` | PPT Slow Limit | mW |
| `--tctl-temp` | Temperature Limit (Tctl) | °C |
| `--vrm-current` | VRM Current Limit (TDC) | mA |
| `--set-coper` | Curve Optimizer (per-core / CCD / CCX) | offset |

Example (45 W sustained, 90 °C limit):

```bash
sudo zenmaster --stapm-limit=45000 --fast-limit=45000 --slow-limit=45000 --tctl-temp=90
```

Run `zenmaster --help` (or `zenmaster --info`) to see the arguments actually supported by your detected CPU family.

---

## Relationship to SMCAMDProcessor

- **SMCAMDProcessor** + **AMD Power Gadget** → monitoring (temps, power, frequency) and basic P-State control.
- **ZenMaster / ZenTune** → *adjustment* of power limits, thermal targets, VRM currents, Curve Optimizer, etc. (the functionality users typically expect from UXTU on Windows).

Both can be used together.

---

## Credits & Sources

- Original suggestion & testing: [oxGorou](https://github.com/oxGorou) ([Issue #140](https://github.com/5T33Z0/OC-Little-Translated/issues/140))
- ZenMaster & ZenTune: [HorizonUnix](https://github.com/HorizonUnix)
- Inspired by / ported concepts from: [Universal x86 Tuning Utility (UXTU)](https://github.com/JamesCJ60/Universal-x86-Tuning-Utility) and [RyzenAdj](https://github.com/FlyGoat/RyzenAdj)
- DirectHW: [joevt/directhw](https://github.com/joevt/directhw)

---

## Disclaimer

Adjusting power limits can increase temperatures, power draw, and reduce hardware longevity if done carelessly. Always monitor temperatures and start with conservative values. Use at your own risk.
