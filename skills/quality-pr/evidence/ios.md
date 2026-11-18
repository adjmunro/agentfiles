# iOS simulator work

- Use the iOS Simulator tool: `attach` first so the user can watch, then `launch` the built `.app`.
- Navigate with `tap`/`text`/`swipe`/`press_key`. Capture evidence with `screenshot`.
- Toggle appearance with `set_appearance` only when the change affects light/dark.
- Simulator only. For a physical iPhone, build and run with the project's own tooling and ask the user for screenshots.
- Network evidence: see `network.md`. iOS projects may use a proxy or an in-app logger instead of Chucker.
