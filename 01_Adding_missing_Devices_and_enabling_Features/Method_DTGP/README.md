# Adding DTGP Method

## About
This SSDT injects the `DTGP` method. It's rarely needed since OpenCore heavily relies on self-contained SSDT hotpatches to make devices work. But some SSDTs address this method (like tables for enabling Thunderbolt or SSDT-RX580). 

Whenever you see something like this in a SSDT you need to add SSDT-DTGP (unless the method itself is defined in the SSDT itself):

```swift
DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
Return (Local0)
```

## `DTGP` explained

In addition to `DeviceProperties`, you can also use the method `_DSM` (Device Specific Method) to do so. It contains properties for a device and makes use of the method `DTGP` which is universal for all devices. It is specified in the `DSDT` of real Macs. Its purpose is to inject custom parameters into some devices. Without this method, patched `DSDTs` would not work well. 

Basically, macOS won't actually read/merge device properties from ACPI unless a Buffer of `0x03` is returned when it asks for this property (`Arg0` = UUID, `Arg1` = 1 and `Arg2` = 0).

`DTGP` passes through calls to device-specific methods on various Device objects, unless a specific `UUID` is provided that indicates that macOS is calling the `_DSM`. macOS has a non-standard device enumeration behavior: it first probes each ACPI Device's `DSM` by passing over only 2 arguments (one of which is the `UUID`). macOS then expects the `_DSM` to return the number of additional arguments that can be used. It's fine if the device returns more arguments than expected, but not less, so it's best to return the maximum, which is three (`Arg0` to `Arg2`). 

macOS will call `_DSM` methods of Device objects with only two arguments at first. When this occurs, the method should return `3`. So all you need to do is check if `Arg2` exists (is non-zero). If it doesn't, return `3`. If it does, return whatever properties you want macOS to use for that device.

In other words, `store` is saving information you want to hand over to macOS as a local variable via the `DTGP` method. So its whole purpose is to handle macOS-specific behavior without breaking non-macOS behavior - like running Windows on real Macs (with Boot Camp) for example.
