# Debunking XCPM Kernel Patch Claims for Turbo Ratio and Power Limit Behavior

## Overview

This document examines claims originating from community discussions regarding [XCPM kernel patches](https://www.insanelymac.com/forum/topic/361989-universal-xcpm-patches-for-all-intel-cpus/) to lift Turbo Ratio and Power Limit restriction on Intel- and AMD-based Hackintosh systems running macOS.

Specifically, it addresses assertions that macOS enforces a hard CPU ratio limit (commonly described as `0x0F` / 15) and that modifying this limit via kernel patches improves turbo behavior or removes power restrictions.

The goal of this document is to evaluate whether these claims are reproducible on modern Intel systems and current macOS versions.

---

## Referenced Patches

### CPU Ratio Extension Patch

```xml
<dict>
    <key>Comment</key>
    <string>CPU Ratio Extension - All Intel CPUs All macOS versions</string>
    <key>Find</key>
    <data>83F80F7F</data>
    <key>Replace</key>
    <data>83F83C7F</data>
</dict>
```

#### What it does

XCPM enforces an internal ceiling on the maximum frequency multiplier (ratio) it will request. This patch raises that ceiling from `0x0F` (15 = 1500 MHz) to `0x3C` (60 = 6000 MHz).

#### How it works

The relevant code in the XNU kernel is a two-instruction sequence:

```nasm
83 F8 0F    cmp eax, 0x0F    ; compare ratio against limit of 15
7F xx       jg  <offset>     ; jump past throttle path if above limit
```

The patch changes only the immediate operand of the `cmp`:

```nasm
83 F8 3C    cmp eax, 0x3C    ; new ceiling: 60 = 6000 MHz
7F xx       jg  <offset>     ; unchanged
```

The `7F` is included in the Find pattern purely to narrow the match — it is not modified.

> [!NOTE]
> 
> **Where the InsanelyMac thread gets it wrong:** The thread describes the 4-byte find sequence `83 F8 0F 7F` as the single instruction `cmp eax, 0x7F0F`. This is not possible. Opcode `83` encodes arithmetic with a *sign-extended byte immediate* — exactly one byte operand. So `83 F8 0F` = `cmp eax, 0x0F`, full stop. The `7F` that follows is a separate `jg rel8` instruction. The prose explanation is wrong; the patch bytes themselves are correct.

---

### Power Limit Bypass Patch

```xml
<dict>
    <key>Comment</key>
    <string>Power Limit Bypass - All Intel CPUs All macOS versions</string>
    <key>Find</key>
    <data>7410</data>
    <key>Replace</key>
    <data>EB10</data>
</dict>
```

The find and replace values differ based on CPU Generation: 

| CPU Generation | Find | Replace |
|---|---|---|
| Coffee Lake (8th/9th Gen) | `740F` | `EB0F` |
| Comet Lake / Rocket Lake (10th/11th Gen) | `7411` | `EB11` |
| Alder Lake / Raptor Lake (12th/13th Gen) | `7410` | `EB10` |

#### What it does

XCPM enforces Intel's TDP-based power limits (PL1/PL2) by reading `MSR_PKG_POWER_LIMIT` and triggering CPU throttling when those limits are reached.

This patch modifies the conditional branch responsible for entering the throttling path by converting a conditional jump (`JE`) into an unconditional jump (`JMP`), effectively bypassing that code path.

**Intended effect:**

- Replaces a conditional branch (`JE`) with an unconditional jump (`JMP`)
- Prevents execution of the power-limit throttling path
- Bypasses enforcement of TDP-based power limits (PL1/PL2)

---

## Claim Under Investigation

The forum discussion suggests:

* macOS XCPM enforces a hard CPU ratio limit (`0x0F`)
* This limit may restrict turbo behavior or performance scaling
* The above patches remove or extend this limitation

---

## Test System

* CPU: Intel Core i7-9700T (Coffee Lake Refresh)
* macOS: modern XCPM-based Intel configuration
* Bootloader: OpenCore

---

## Methodology

An A/B test was performed:

1. System booted with patches enabled
2. System booted with patches disabled
3. CPU behavior compared under identical conditions
4. Synthetic load applied to force turbo scaling

### Monitoring tools:

```bash
sysctl machdep.xcpm.hard_plimit_max_100mhz_ratio
sudo powermetrics --samplers cpu_power
```

---

## Observations

### Reported CPU Ratio Limit

```text
machdep.xcpm.hard_plimit_max_100mhz_ratio: 43
```

* No change observed with or without patches
* Corresponds to 4.3 GHz turbo limit for this CPU
* No evidence of a 0x0F (1.5 GHz) cap

---

### Runtime Behavior

* Turbo behavior remained unchanged between configurations
* Maximum observed frequency: ~4.3 GHz
* No measurable performance difference detected

---

## Interpretation

Based on the observed data:

* No evidence of a functional 0x0F-based CPU ratio limitation was found
* The system already exposes full expected turbo behavior without modification
* The tested patches did not produce measurable changes on this hardware/software combination

This suggests the claimed limitation is likely:

* no longer present in modern XCPM implementations, or
* not applicable to Coffee Lake-class CPUs, or
* part of a legacy kernel path no longer used in current macOS versions

---

## Conclusion

The tested XCPM kernel patches do not show measurable effects on modern Intel Coffee Lake systems.

While these patches may have historical relevance or may apply to older configurations, they cannot be assumed to affect CPU turbo behavior or power limits on current macOS Intel platforms without explicit verification.

Therefore, the claim that macOS enforces a universal `0x0F` CPU ratio limit is not reproducible in this test environment.

---

## Final Note

Results may vary depending on CPU generation, macOS version, and system configuration. This document reflects empirical testing on a specific Coffee Lake system and should be interpreted accordingly.

If CPU power management (frequency scaling, turbo multipliers, or power limits) is not functioning correctly on a given system, these patches may be considered as a troubleshooting measure to restore expected behavior in legacy or misconfigured setups.

However, if CPU frequency scaling and turbo boost are already operating as expected, applying these patches is unnecessary and may have no measurable effect.

It is recommended to verify CPU behavior before applying any modifications using tools such as:

```bash
sysctl machdep.xcpm.hard_plimit_max_100mhz_ratio
sudo powermetrics --samplers cpu_power
```

