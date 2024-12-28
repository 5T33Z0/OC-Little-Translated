# Disable Battery Indicator on Intel NUCs

## Problem description

When running macOS on Intel NUC Mini PCs, an entry for the Battery may be present in System Preferences under macOS because in the FACP table, the `PM Profile` is defined as `mobile`, as on this Intel NUC8i7HVK:

![facp-Nuc](https://github.com/user-attachments/assets/a52e4e74-bd65-4995-8fc8-1586570933ef)

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

![fiixnucbat](https://github.com/user-attachments/assets/c77b151f-92bb-45fc-a021-ec5bdb41805b)

