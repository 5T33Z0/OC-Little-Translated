# XCPM Kernel Patches for Turbo Ratio and Power Limit

## About

Two kernel patches for XCPM circulate  in the community currently, most notably documented in [this InsanelyMac thread](https://www.insanelymac.com/forum/topic/361989-universal-xcpm-patches-for-all-intel-cpus/). They target the XNU kernel binary directly — not ACPI tables — and are applied via `Kernel → Patch` in `config.plist`, the same way as any other OpenCore kernel patch.

**The patches work.** However, the technical explanation given in the thread for Patch 1 contains a factual error in its x86 instruction decoding. The corrected explanation is given below.

> [!NOTE]
> 
> These are optional fine-tuning patches. If your CPU runs at expected frequencies under load and you have no confirmed software throttling, you don't need them. Start with a proper XCPM setup (correct SMBIOS, `SSDT-PLUG`, relevant quirks) before reaching for kernel patches.

---

## Patch 1 — CPU Ratio Extension

### What it does

XCPM enforces an internal ceiling on the maximum frequency multiplier (ratio) it will request. This patch raises that ceiling from `0x0F` (15 = 1500 MHz) to `0x3C` (60 = 6000 MHz).

### How it works

The relevant code in the XNU kernel is a two-instruction sequence:

```nasm
83 F8 0F    cmp eax, 0x0F    ; compare ratio against limit of 15
7F xx       jg  <offset>     ; jump past throttle path if above limit
```

> [!NOTE]
>
> **Where the InsanelyMac thread gets it wrong:** The thread describes the 4-byte find sequence `83 F8 0F 7F` as the single instruction `cmp eax, 0x7F0F`. This is not possible. Opcode `83` encodes arithmetic with a *sign-extended byte immediate* — exactly one byte operand. So `83 F8 0F` = `cmp eax, 0x0F`, full stop. The `7F` that follows is a separate `jg rel8` instruction. The prose explanation is wrong; the patch bytes themselves are correct.

The patch changes only the immediate operand of the `cmp`:

```nasm
83 F8 3C    cmp eax, 0x3C    ; new ceiling: 60 = 6000 MHz
7F xx       jg  <offset>     ; unchanged
```

The `7F` is included in the Find pattern purely to narrow the match — it is not modified.

### config.plist entry

| Key | Value |
|---|---|
| Comment | `XCPM: Raise CPU ratio limit to 60` |
| Arch | `x86_64` |
| Identifier | `kernel` |
| Find | `83F80F7F` |
| Replace | `83F83C7F` |
| Count | `1` |
| MinKernel | *(leave empty)* |
| MaxKernel | *(leave empty)* |
| Enabled | `true` |

---

## Patch 2 — Power Limit Bypass

### What it does

XCPM enforces Intel's TDP-based power limits (PL1/PL2) by reading `MSR_PKG_POWER_LIMIT` and throttling the CPU when the limit is reached. This patch converts the conditional branch that triggers throttling into an unconditional jump, so the throttle path is always skipped.

### How it works

```nasm
74 xx    jz  <offset>    ; jump to throttle path if power limit hit
```

becomes:

```nasm
EB xx    jmp <offset>    ; always jump — throttle path never taken
```

`74` = `jz` (jump if zero/equal), `EB` = `jmp short` (unconditional). The offset byte (`xx`) differs by CPU generation:

| CPU Generation | Find | Replace |
|---|---|---|
| Coffee Lake (8th/9th Gen) | `740F` | `EB0F` |
| Comet Lake / Rocket Lake (10th/11th Gen) | `7411` | `EB11` |
| Alder Lake / Raptor Lake (12th/13th Gen) | `7410` | `EB10` |

> [!NOTE]
>
> **On the "universal" claim:** Despite the InsanelyMac thread's title, this patch is not universal — the correct bytes differ per CPU generation, as the thread itself acknowledges further down. Use the row for your CPU family only.

### config.plist entry (Alder/Raptor Lake example)

| Key | Value |
|---|---|
| Comment | `XCPM: Bypass PL1/PL2 power limit (Alder/Raptor Lake)` |
| Arch | `x86_64` |
| Identifier | `kernel` |
| Find | `7410` |
| Replace | `EB10` |
| Count | `1` |
| MinKernel | *(leave empty)* |
| MaxKernel | *(leave empty)* |
| Enabled | `true` |

> [!NOTE]
> 
> ⚠️ Set `Count` to `1` for both patches. The 2-byte find pattern for Patch 2 is short enough that false matches elsewhere in the kernel binary are a real possibility without this constraint.

---

## Notes

- **Kernel version stability:** These patches target specific byte sequences in the XNU kernel binary. Apple changes kernel internals between major releases. Re-verify after every major macOS update — a patch finding 0 matches is harmless; one landing on the wrong location is not.
- **Thermal responsibility:** Bypassing PL1/PL2 means macOS no longer enforces Intel's TDP envelope. Your cooling, VRM, and BIOS power settings become the only limits. Don't run Patch 2 unattended on a thermally constrained system.
- **Relation to `AppleXcpmForceBoost`:** Patch 2 removes the software throttle floor; `AppleXcpmForceBoost` forces maximum P-state at all times. These are different mechanisms — the quirk is more aggressive and not suitable for laptops or systems without adequate cooling.
- **The AMD patch in the original thread** does not belong there. XCPM is Intel-specific; Ryzen Hackintoshes use a different power management path entirely.
