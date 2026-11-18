# Forcing states the backend won't give

Use this when the evidence needs an error code, an outage or an edge case the real API won't produce on demand.

1. Look for a built-in way first: dev settings, mock/sample data flavours, feature-flag overrides, a dev error-injection screen.
2. Otherwise add a **temporary, uncommitted** interceptor in a dev-only source set (not `main`):
   - Gate it on something you can flip from adb without rebuilding, e.g. a file in the app's `filesDir`. The file's content can carry a variable such as a message.
   - Wrap it **inside** the network inspector so the fake still shows in the evidence. With OkHttp, wrap the Chucker interceptor and delegate the chain: `Interceptor { chain -> chucker.intercept(object : Interceptor.Chain by chain { override fun proceed(r: Request) = fakeOrReal(r) }) }`.
   - Build a realistic response: status, message, protocol, **and headers**. Ktor won't parse a JSON body without a `Content-Type` header.
   - Only fake the hosts you mean to, e.g. the API, not the identity provider.
   - An instant fake response can beat lifecycle events (e.g. arrive before a screen resumes) and show timing problems real latency would hide. Add a delay if the timing matters, and say which you used.
3. Remove the fake and reinstall the clean build before the final run-without-crashing check (`git status` must be clean apart from intended changes).
4. In the PR, describe the fake in one or two sentences and say it isn't in the PR.

Anything odd the forced state turns up that isn't part of this change goes to the user as a follow-up (its own PR or ticket), not into this PR unasked.
