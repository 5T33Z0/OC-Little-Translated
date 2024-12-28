# Disable Battery Indicator on Intel NUCs

## Problem description

When running macOS on Intel NUC Mini PCs, an entry for the Battery may be present in System Preferences under macOS because in the FACP table, the `PM Profile` is defined as `mobile`, as on this Intel NUC8i7HVK:

![](/Users/5t33y0/Desktop/facp-Nuc.png)

## Fix
Baio77 has created an ACPI patch to disable the Battery entry in macOS. Paste the following code to your `config.plist` under ACPI/Patch:

```xml
<dict>
    <key>Base</key>
    <string></string>
    <key>BaseSkip</key>
    <integer>0</integer>
    <key>Comment</key>
    <string>Rename PM Desktop NUC Profile (Battery was displayed in System Settings)</string>
    <key>Count</key>
    <integer>0</integer>
    <key>Enabled</key>
    <true/>
    <key>Find</key>
    <data>AAIJALIAAACgoQ==</data>
    <key>Limit</key>
    <integer>0</integer>
    <key>Mask</key>
    <data></data>
    <key>OemTableId</key>
    <data></data>
    <key>Replace</key>
    <data>AAEJALIAAACgoQ==</data>
    <key>ReplaceMask</key>
    <data></data>
    <key>Skip</key>
    <integer>0</integer>
    <key>TableLength</key>
    <integer>0</integer>
    <key>TableSignature</key>
    <data></data>
</dict>
```

**Screenshot**:

![](/Users/5t33y0/Desktop/fiixnucbat.png)
