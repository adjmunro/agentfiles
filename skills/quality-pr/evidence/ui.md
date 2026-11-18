# UI evidence

- **Link the designs.** Find the Figma (or other design tool) frames in the ticket, its linked tickets or the code's doc comments. Link each frame by name (e.g. its screen code) next to the screenshots so reviewers can compare.
- Cover each brand/theme variant the design defines (e.g. brand A/B x light/dark) in **one table row**, labelled like "Brand A light". Capture them all the same way where you can, and say so if they differ.
- Screenshot **every state** the change touches: empty, loading, error, success, each dialog or variant. Add before/after pairs for bug fixes.
- Device-size variants only when the change touches layout.
- Switching theme: prefer an in-app setting. Otherwise change the device setting (`adb shell cmd uimode night yes|no`, or the simulator's `set_appearance`), note the original value first, and put it back afterwards.
- If you can't reach a state with real sign-in (accounts rejected, no access), look for the app's dev component/preview screens (or Compose `@Preview` renders via `android preview`) before giving up, and say in the PR that's where the capture came from.
- Note what the screenshots came from: app `versionName` (`versionCode`) and variant, device model and OS version (`adb shell dumpsys package <pkg> | grep version`, `adb shell getprop ro.build.version.release`) in the text, and the tree hash each image was built from in its label (see below). Record the tree (`git rev-parse --short HEAD^{tree}`) when you build, as pre-flight does. Local-only changes for forcing a state (not in the PR) don't change the hash you record; describe them in the text.
- If later code changes affect the screen, recapture; otherwise the evidence stands.
- Capture the real app on a device or simulator. Never screenshot test reports or logs; those go in the body as text.
- Wait for animations to settle before capturing. Check each image visually before using it.
- Resize to about 1000px tall (`sips -Z 1000 in.png --out out.png` on macOS) to keep uploads small.

## Layout in the PR

**Width budget: 960px.** That's the PR description's content width. Don't estimate it or derive it from anything else. Each table column costs its image width plus 27px (cell padding and border), so a row must satisfy `sum(width + 27) + 1 <= 960`.

**Rule: a table with each label directly above its image. Phone screenshots are always `width="210"`, at most 4 per row** (4 x 237 + 1 = 949). This applies to new tables and to every table you amend: resize any image that doesn't match.

Other images (tablet, landscape, desktop): pick one width for them that keeps the row within the budget, and use it for all of that kind in the PR.

Each header cell is the label, then the image's tree hash on a second line:

```
| Before<br><sub>tree `4e88be0841`</sub> | In session<br><sub>tree `4e88be0841`</sub> | Cold launch<br><sub>tree `4e88be0841`</sub> | Login<br><sub>tree `4e88be0841`</sub> |
|---|---|---|---|
| <img src="..." width="210" alt="Before"> | <img src="..." width="210" alt="In session"> | <img src="..." width="210" alt="Cold launch"> | <img src="..." width="210" alt="Login"> |
| **Chucker**<br><sub>tree `4e88be0841`</sub> | **Response**<br><sub>tree `4e88be0841`</sub> | | |
| <img src="..." width="210" alt="Chucker"> | <img src="..." width="210" alt="Response"> | | |
```

- **The tree hash is for traceability only.** An older hash than the PR head does not mean the image is invalid or needs recapturing. That depends only on whether a later change affected that screen.
- **Pixel widths only.** A percentage width inside a table cell resolves against a column sized by its content, so the image can collapse to nothing.
- More than 4 images: continue in the same table with a row of **bold** labels, then a row of images. Pad a short last row with empty cells.
- **One table per section.** Evidence captured later goes into the existing table, next to the image it relates to (e.g. "Cold launch + API msg" beside "Cold launch"), not into a new table. Replace an image only if the new capture invalidates it; otherwise keep both.
- Before/after pairs for bug fixes: put `Before` and `After` side by side, two pairs per row.

Platform how-to: `android.md` or `ios.md`.
