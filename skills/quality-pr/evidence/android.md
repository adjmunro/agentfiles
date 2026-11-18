# Android device work

Prefer a physical device the user has connected (`adb devices -l`) over an emulator, and the debug variant of the dev flavour unless told otherwise. Install with `adb install -r` (or the Gradle `install<Variant>` task) so app data and sign-in survive.

## Seeing and driving the screen

### With the `android` CLI (preferred)

Load the `android-cli` skill and read its `references/interact.md` first.
- **See:** `android layout` returns the UI tree as JSON. It's far cheaper than screenshots. Use `--diff` for changes only. It can print extra lines after the JSON, so parse only the first line.
- **Act:** `android input tap|text|scroll|swipe|key <selector>`, e.g. `android input tap "text=Log in"`, `android input text "hello" "resource-id=email"`. If a selector matches several elements, use `--match=first` or fall back to coordinates.
- **Capture evidence:** `android screen capture -o x.png`. Use images only for evidence or when `layout` can't see something (WebViews, canvases).
- Also useful: `android install`/`android run` for faster deploys, and `android device` to mirror the screen.

### Without it (fall back to adb, and warn the user)

If `android` isn't on the PATH, tell the user it's missing (it's much cheaper for navigation) and offer the install command from the `android-cli` skill. Then use:
- See: `adb exec-out uiautomator dump /dev/tty` (XML with bounds).
- Act: `adb shell input tap X Y`, `adb shell input text '...'`, `adb shell input swipe x1 y1 x2 y2 ms` (equal points plus a duration is a long-press), `adb shell input keyevent KEYCODE_BACK`.
- Capture: `adb exec-out screencap -p > x.png`.

## Useful adb

- App data (debug builds): `adb exec-out run-as <pkg> cat <path>` and `adb shell run-as <pkg> touch|rm files/<flag>`.
- Launch: `adb shell am start -n <pkg>/<activity>`. Find the activity with `adb shell cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.LAUNCHER <pkg>`.
- Notification shade: `adb shell cmd statusbar expand-notifications`.
- Keep awake while plugged in: `adb shell svc power stayon usb`.
- App logs: `adb logcat -d --pid=$(adb shell pidof <pkg>)`.

## Sessions

- Backing up and restoring app data does **not** preserve a sign-in when the identity provider rotates refresh tokens: the restored token is already spent. Plan around logouts instead (see SKILL.md ground rules).
- Dev-only settings screens (e.g. extra error info) can add debug text to screenshots. Turn them off for evidence and restore them afterwards.

## Wireless adb on macOS

`adb mdns services` often finds nothing. Browse with `dns-sd -B _adb-tls-connect._tcp local.`, resolve with `dns-sd -L <instance> _adb-tls-connect._tcp local.`, then `adb connect ip:port`. The port changes when wireless debugging is toggled.

If the connection keeps dropping, macOS Local Network privacy is probably killing it. The adb server started from a short-lived agent shell loses its permission when that process exits. Run `adb kill-server` and let a long-lived app that has Local Network permission (e.g. Android Studio) restart it, then reconnect.
