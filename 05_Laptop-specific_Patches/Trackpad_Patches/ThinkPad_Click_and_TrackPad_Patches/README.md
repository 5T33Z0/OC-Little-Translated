# Special patches for ThinkPads

## Special Name Change
The `DSDT` of ThinkPad models may contain a `PNLF` field. Search for `PNLF` in the `DSDT`, and if it exists, you need to add the following rename to avoid conflicts:

```text
Find: 504E4C46
Replace: 584E4C46
Comment: Rename PNLF to XNLF
```

## Special Patches

### Brightness shortcut key fix: `SSDT-NBCF` 
On older ThinkPad models (3rd to 5th generation), the brightness shortcut keys (`_Q14` and `_Q15`) don't work due to `NBCF` being set to `0`. In the `DSDT`, search for `Name (NBCF,`. If it is set to `Zero` or `0x00` respectively, you need this Hotpatch!

It changes `NBCF` to `1` for macOS so the brightness shortcut keys work properly when using ACPI methods or the new [**BrightnessKeys.kext**](https://github.com/acidanthera/BrightnessKeys) (which is recommended).

### ThinkPad TouchPad property injection and TouchPoint anti-drift patch
ThinkPad's TouchPads and the TouchPoints Mouse pointer are ELAN type devices connected via SMBus using the `Synaptics` protocol. Recently, the Synaptics PS2 driver in VoodooPS2 was updated. This changes some of the properties which the driver looks for, and removes the need for the Clickpad/Trackpad SSDTs. These are still somewhat useful if you want to change trackpoint cursor and scroll speed, or want an example of setting properties for VoodooPS2.

Some older ThinkPad trackpads don't support Intertouch (Synaptic's term for operating over SMBus instead of PS/2), in which case VoodooPS2Trackpad is still useful.

**SSDT-ThinkPad_ClickPad**

If your TouchPad is one of the two shown below, then use this patch.

![](https://i.loli.net/2020/04/26/ceEyQfgikqzjapL.png) 

**SSDT-ThinkPad_TouchPad**

If your TouchPad is one of the two shown below, then use this patch.

![](https://i.loli.net/2020/04/26/FUxIp4nmAb2PSws.png)

----

The keyboard path for most ThinkPad machines is `\_SB.PCI0.LPC.KBD` or `\_SB.PCI0.LPCB.KBD`. The two patches provided use `_SB.PCI0.LPC.KBD` by default, please check the original LPC bus name and keyboard name against the DSDT and replace the ACPI path by yourself.

Both patches involve changes to the keyboard device's `RMCF` variable. If you also use the PS2 Map patch in the "PS2 Keyboard Mapping" section, you need to merge the `RMCF` variables manually, see **SSDT-ThinkPad_ClickPad+PS2Map-AtoZ** for a sample merge, this patch includes both the injection of the ThinkPad ClickPad property and the A -> Z of the PS2 Map mapping.

In addition, Rebhabman's VoodooPS2Controller is obsolete, and it is recommended to use acidanthera's [VoodooPS2](https://github.com/acidanthera/VoodooPS2) with [VoodooInput]( https://github.com/acidanthera/VoodooInput) to enable all TrackPad gestures on ThinkPads.

### Parameter Explanations
The following descriptions of the configurations in SSDT are provided by [@SukkaW](https://github.com/SukkaW) based on [README](https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller/blob/master/README.md) by Rehabman, the original maintainer of VoodooPS2Controller and its components.

- `DragLockTempMask`: temporary drag lock shortcut. Note that these are the original relationships mapped on the physical keyboard and are not affected by the function key order set in System Preferences.
- `DynamicEWMode`: Dynamic EW mode, where two-finger gestures (e.g. two-finger swipe) split the trackpad bandwidth equally. By enabling Dynamic EW mode, the trackpad will not be in EW mode all the time, thus improving the responsiveness of the ThinkPad ClickPad touchpad for two-finger scrolling.</br>**Note**: two-finger scrolling only requires two fingers to be on the trackpad at the same time, and then the trackpad only gives feedback on the direction and distance of one finger swipe, saving the bandwidth of the other finger). While dragging a file (note: one finger holds the trackpad and the other finger swipes) the ClickPad will be pressed down, and EW mode will still be enabled. This option has caused problems with a few trackpads, so it is disabled by default.
- `FakeMiddleButton`: Simulates a middle button click when tapping the trackpad with three fingers at the same time.
- `HWResetOnStart`: Some trackpad devices (especially the ThinkPad's trackpad and the little red dot) require this option to be enabled to work properly.
- `ForcePassThrough` and `SkipPassThrough`: PS2 input devices can send a special type of 6-byte packet called "Pass Through", which allows interleaved transmission of signals from the trackpad and the pointing stick (e.g. ThinkPad's Little Red Dot). VoodooPS2 has implemented automatic recognition of PS2 device type "Pass Through" packets, these two options are for debugging purposes only.
- `PalmNoAction` when Typing: Enable this option to avoid accidental contact with the touchpad when typing.
- `SmoothInput`: When this option is enabled, the driver will average every three sampling points to get a smooth movement track.
- UnsmoothInput: When this option is enabled, when input to the touchpad is stopped, the sampling average will be reversed and the position at which input is stopped will be used as the end position of the track. This is due to the fact that at the end of the track, sampling averaging can lead to large errors or even track reversals. By default this option is enabled at the same time as SmoothInput.
- `DivisorX` and `DivisorY`: Sets the touchpad edge width. The edge area will not provide any response.
- `MomentumScrollThreshY`: Use the trackpad to scroll with two fingers and continue scrolling after the finger leaves the trackpad, as if there is inertia. This option is enabled by default to mimic the trackpad experience on Mac devices as much as possible.
- `MultiFingerHorizontalDivisor` and MultiFingerVerticalDivisor: Some trackpads have a dedicated "slider" area on the far right and/or bottom of the trackpad. This area does not respond to multi-finger swipes by default, and these two options provide settings for the width of the unresponsive area. The default value is 1, which means that the entire trackpad is responsive to multi-finger swipes.
- Resolution: The touchpad "resolution" in pixels per inch, i.e. how many pixels will be crossed on the screen when the finger slides an inch on the touchpad.
- `ScrollDeltaThresh`: Fault tolerance value, used to avoid jitter when swiping with two fingers on macOS 10.9 Maverick. The default value is 10.
