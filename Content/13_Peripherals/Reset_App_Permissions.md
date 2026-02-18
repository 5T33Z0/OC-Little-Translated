# How to Reset App Permissions on macOS

When an app asks for access to your camera, microphone, or screen and you accidentally click "Don't Allow," it can be frustrating — macOS won't ask again automatically. Fortunately, there's a simple Terminal command that lets you reset these permissions so the app will prompt you again.

## The `tccutil` Command

macOS manages app permissions through a system called **TCC** (Transparency, Consent, and Control). The `tccutil` command-line tool lets you reset these stored decisions from the Terminal.

The basic syntax is:

```bash
tccutil reset <Service>
```

This resets the permission for **all apps** that have ever requested access to that service.

## Available Services

| Service | What it controls |
|---|---|
| `Camera` | Access to the webcam |
| `Microphone` | Access to the microphone |
| `ScreenCapture` | Screen recording and sharing |
| `Accessibility` | Controlling your Mac via other apps |
| `Contacts` | Access to your contacts |
| `Calendar` | Access to your calendar |
| `Photos` | Access to your photo library |
| `Reminders` | Access to your reminders |
| `Location` | Access to your location |

### Examples

```bash
tccutil reset Camera
tccutil reset Microphone
tccutil reset ScreenCapture
```

## Resetting Permissions for a Specific App

If you only want to reset permissions for one particular app — without affecting all other apps — you can add the app's **bundle ID** to the command:

```bash
tccutil reset <Service> <BundleID>
```

### Common App Bundle IDs

| App | Bundle ID |
|---|---|
| Zoom | `com.zoom.us` |
| Microsoft Teams | `com.microsoft.teams` |
| Microsoft Teams (new) | `com.microsoft.teams2` |
| Slack | `com.tinyspeck.slackmacgap` |
| Google Chrome | `com.google.Chrome` |
| Safari | `com.apple.Safari` |
| FaceTime | `com.apple.FaceTime` |

### Examples

```bash
# Reset camera access for Zoom only
tccutil reset Camera com.zoom.us

# Reset microphone access for Microsoft Teams
tccutil reset Microphone com.microsoft.teams

# Reset screen capture for Slack
tccutil reset ScreenCapture com.tinyspeck.slackmacgap
```

## After Running the Command

1. **Quit and relaunch** the app if it's currently open.
2. The app will **prompt you again** for permission the next time it tries to access the service.
3. This time, click **Allow** or **OK** when the dialog appears.

## Finding an App's Bundle ID

If the app you need isn't listed above, you can find its bundle ID with this Terminal command:

```bash
osascript -e 'id of app "AppName"'
```

Replace `AppName` with the name of the app as it appears in your Applications folder. For example:

```bash
osascript -e 'id of app "Slack"'
# Returns: com.tinyspeck.slackmacgap
```

## Notes

- You may need to be an **administrator** on your Mac to run `tccutil`.
- On some macOS versions, resetting `ScreenCapture` permissions may require the app to be removed and re-added in **System Settings → Privacy & Security → Screen Recording**.
- These commands work on **macOS Mojave (10.14)** and later, when TCC was significantly expanded.
