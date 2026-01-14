# Adding the `DTGP` method via SSDT

## About

This SSDT injects the `DTGP` method. You only need it **if a patched SSDT explicitly references `DTGP` but does not define it itself**.

Look for this pattern:

```asl
External (DTGP, MethodObj)
```

If such an `External` reference exists and the SSDT later calls `DTGP`, for example:

```asl
DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
Return (Local0)
```

then you must either:

* add `SSDT-DTGP.aml`, **or**
* integrate the `DTGP` method directly into that SSDT

Examples of embedded implementations can be found in ***SSDT-I225V*** and ***SSDT-RX580***.

> [!TIP]
> 
> Most modern OpenCore setups do ***not*** require `DTGP`, as property injection is handled via `DeviceProperties` instead of ACPI `_DSM` methods.

## What `DTGP` actually is

`DTGP` is an **undocumented Apple-specific ACPI helper method** found in the DSDTs of real Macs.

It is **not part of the ACPI specification** and **has no officially defined meaning or acronym**. Any expansion such as “Device Temporary Got Power” is folklore and should be ignored.

In practice, `DTGP` exists solely to support **macOS-specific `_DSM` behavior**.

## Why macOS uses `DTGP`

macOS probes `_DSM` methods in a **non-standard way**:

1. It initially calls `_DSM` with **fewer arguments** than required by the ACPI specification
2. It expects the method to indicate:

   * whether `_DSM` is supported
   * how many function indices are available
3. Only if this probe succeeds will macOS accept and merge device properties supplied via `_DSM`

`DTGP` acts as a **gatekeeper** in this process. When macOS presents a specific Apple UUID, `DTGP` returns a buffer indicating that `_DSM` is supported and that function indices `0–2` are available (commonly returned as `0x03`).

**This behavior is required for legacy `_DSM`-based property injection to work correctly.**

## Method Signature

A canonical `DTGP` implementation looks like this:

```asl
Method (DTGP, 5, NotSerialized)
```

With the following arguments:

* `Arg0` – UUID provided by macOS
* `Arg1` – Function index
* `Arg2` – Sub-function index
* `Arg3` – Reserved
* `Arg4` – Result buffer (usually passed as `RefOf (Local0)`)

The returned buffer does **not** control power, device state, or runtime behavior. It merely signals `_DSM` compatibility.

## Relevance Today

* `DTGP` is **only relevant for legacy ACPI patches that rely on `_DSM`**
* OpenCore injects device properties independently of ACPI, making `DTGP` unnecessary in most cases
* Adding `DTGP` without an explicit reference provides **no benefit**

In modern OpenCore configurations, `DTGP` should be treated strictly as a **compatibility shim**, not a functional requirement.

## Bottom line

Add `DTGP` **only when an SSDT explicitly calls it**. Do not add it “just in case”. This keeps ACPI clean, maintainable, and aligned with how macOS actually works today.
