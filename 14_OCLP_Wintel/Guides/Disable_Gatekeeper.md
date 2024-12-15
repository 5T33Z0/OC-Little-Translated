# How to disable Gatekeeper in macOS Sequoia

## Preface

After installing macOS Sequoia beta 3 on a new Volume, I wanted to run Corpnewt's MountEFI script to mount the ESP but it was blocked by Gatekeeper. Right-clicking the file and selecting "Open" does no longer work, which is new. So I decided to disable GateKeeper via Terminal, only to realize that this is no longer possible either:

```shell
sudo spctl --master-disable
Password:
This operation is no longer supported. To disable the assessment subsystem, please use configuration profiles.
```

So, config profiles it is…

## Sentinel-Method (preferred)

This will install a signed config profile to disable Gatekepper.

- Download [**Sentinel**](https://github.com/alienator88/Sentinel/releases) (use version 1.6, the newest one isn't working properly!)
- Unzip and run the app
- Click on "Install Profile"
- This will open the System Settings >> General >> Device Management window
- Double-click on the loaded Profile "Disable Gatekeeper"
- Click the "Install…" button to install the profile.

Afterwards Gatekeeper will be disabled

## Previous Method

This will also install a config profile to disable Gatekepper but it will be unsigned.

- Download [Disable.Gatekeeper.mobileconfig.zip](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/files/Disable.Gatekeeper.mobileconfig.zip) and unzip it
- Go to System Settings >> General >> Device Management and click the <kbd>+</kbd> button
- Navigate to the Disable.Gatekeeper.mobileconfig file and open it
- A new device called "Disable Gatekeeper" should appear:<br>![disablegk](https://github.com/user-attachments/assets/b76ed1c1-77d5-47d7-97f5-622ccf724451)

Afterwards, Gatekeeper will be disabled.

## Credits

- **dhinakg** for the mobileconfig file
- **miliuco** for the [explanations](https://www.insanelymac.com/forum/topic/359530-pre-release-macos-sequoia/?do=findComment&comment=2823334)
