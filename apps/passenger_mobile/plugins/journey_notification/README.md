# Journey notification (Android)

App-local Flutter plugin, registered in foreground and FlutterFire background engines. It uses the Android system template, never `RemoteViews` or a foreground location service.

Call `setEnabled(true)` and `startSession(sessionId)` **only after an authenticated foreground start**. Background snapshots cannot enroll or switch a session. `update(snapshot)` ignores wrong-session, duplicate, stale, dismissed and disabled updates. `clear()` tombstones the enrolled session; `setEnabled(false)` also disables future messages until explicitly enabled.

Use `consumeOpenedBooking()` on startup/resume to consume a notification tap. The app must still authorize access when loading the booking.

Android 16 uses `Notification.ProgressStyle`; older versions use standard progress. A promoted-ongoing request is made when the runtime exposes that newer Android 16 API; promotion is controlled by the OS and user settings. Arrival is shown briefly before timeout; stopped or expired updates clear immediately.

Native vectors preserve the existing source paths:

- `journey_mark.xml` and monochrome small icon: `assets/auth/logo/light_mark.svg`.
- `journey_bus.xml`: `assets/ticket/results/bus.svg`.

The large icon uses the original color brand mark. The notification template determines logo placement; a full wordmark is not forced into a custom layout.

No iOS implementation is included.
