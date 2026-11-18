# Network evidence

Show the calls the change makes or depends on: a screenshot of the call in an on-device inspector, plus a table built from the captured data.

## Route

- **Chucker is in the debug build** (look for `ChuckerInterceptor` in the code, or a "Recording HTTP activity" notification):
  1. Make sure capture is enabled in the app's dev settings.
  2. Screenshot the list and the key call's Response tab. Open it from its notification: `adb shell cmd statusbar expand-notifications`, then tap "Recording HTTP activity". Chucker's activities aren't exported, so `am start` won't open them.
  3. Read the rows from its Room DB. It's in WAL mode, so pull all three files:
     ```
     for f in chucker.db chucker.db-wal chucker.db-shm; do adb exec-out run-as <pkg> cat databases/$f > $f; done
     sqlite3 chucker.db "SELECT time(requestDate/1000,'unixepoch','localtime'), method, host, path, responseCode, responseBody FROM transactions WHERE requestDate > <epoch-ms> ORDER BY id;"
     ```
     Useful columns: `tookMs`, `requestHeaders` (JSON, includes the bearer token), `requestBody`, `responseBody`.
- **No Chucker, but an HTTP logging interceptor** (OkHttp `HttpLoggingInterceptor`, Ktor `Logging`): read it from `adb logcat -d --pid=<pid>` and build the table from that. No inspector screenshot.
- **Neither:** say so in the PR and give the table from what you can observe (server logs the user shares, a proxy the user runs). Don't install a proxy CA or change device network settings yourself.

## Table

| Time | Call | Status | Body |
|---|---|---|---|
| hh:mm:ss | `METHOD /path` | 200 | trimmed JSON, or empty |

Add a Scenario column when the table covers several runs.

- Redact bearer tokens, refresh tokens, session tokens and anything personal. Dev account and record IDs are fine.
- Trim long bodies to the fields that matter.
- Shorten hosts (e.g. "SS", "Okta") when they're obvious from the context.
