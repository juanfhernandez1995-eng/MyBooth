# MyBooth v0.19 — Gallery + QR Page Foundation

## Summary

v0.19 adds the first real guest-gallery foundation. QR delivery is now represented as a proper guest gallery preview instead of only a QR placeholder. The release keeps the important product rule: guests see final bordered/composited outputs; raw Canon originals remain operator-only on the laptop server.

## Goals

- Add guest gallery preview screen.
- Add operator Gallery + QR screen.
- Make Booth Mode QR flow open the guest gallery preview.
- Prepare server routes for session gallery delivery.
- Document final-photo QR delivery rules.
- Keep Google Photos export as a future final-output-only delivery path.

## Changed Files

```text
lib/branding/mybooth_brand.dart
lib/screens/booth_mode_screen.dart
lib/screens/event_detail_screen.dart
lib/screens/home_screen.dart
server/config/server_config.json
server/mybooth_server/config.py
server/mybooth_server/routes.py
server/mybooth_server/services/gallery_service.py
server/README.md
server/requirements.txt
server/tests/test_server_payloads.py
```

## New Files

```text
lib/models/gallery_session.dart
lib/screens/gallery_screen.dart
lib/screens/guest_gallery_screen.dart
docs/GALLERY_QR.md
docs/RELEASE_v0.19.md
```

## App Features

- Dashboard Gallery button now opens a real Gallery + QR screen.
- Event Details includes a Guest Gallery + QR preview action.
- Booth Mode final QR step includes an **Open Guest Gallery Preview** button.
- Guest gallery preview shows:
  - event name
  - honoree/person name
  - event date
  - template summary
  - 2x6 strip or 4x6 grid placeholder
  - final guest output path
  - guest gallery URL
  - download/share placeholders
  - operator-only originals boundary

## Server Features

New/updated routes:

```text
GET /gallery/qr-plan
GET /gallery/session/demo
GET /gallery/session/<session_id>
```

The server returns session gallery planning JSON. Real image serving and generated gallery pages will come later.

## Storage Rule

```text
Guest QR = final bordered/composited photos
Operator storage = originals + processed + composited + print files + logs
Google Photos later = final guest-ready outputs only by default
```

## Testing Checklist

Run Flutter:

```powershell
flutter clean
flutter pub get
flutter analyze
flutter run -d chrome
```

Test app flow:

- Dashboard opens.
- Gallery button opens Gallery + QR screen.
- Create or continue an event.
- Event Details opens.
- Preview Guest Gallery + QR opens.
- Booth Mode opens.
- Countdown runs.
- Final QR step opens.
- Open Guest Gallery Preview works.
- Template Designer still opens.
- Template Library still opens.

Run server tests:

```powershell
cd server
py -m unittest discover tests
py -m mybooth_server
```

Test routes in browser:

```text
http://127.0.0.1:8080/health
http://127.0.0.1:8080/status
http://127.0.0.1:8080/gallery/qr-plan
http://127.0.0.1:8080/gallery/session/demo
```

## Git Commit

```powershell
git add .
git commit -m "Release MyBooth v0.19 gallery QR page foundation"
git push origin feature/theme-engine
```
