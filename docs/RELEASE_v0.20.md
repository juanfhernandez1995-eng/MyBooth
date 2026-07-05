# MyBooth v0.20 Booth Session Review

## Release goals

Add the review and approval step that commercial photo booths need before final QR delivery and printing.

## Changed files

- `lib/screens/booth_mode_screen.dart`
- `lib/branding/mybooth_brand.dart`
- `server/config/server_config.json`
- `server/mybooth_server/config.py`
- `server/mybooth_server/routes.py`
- `server/tests/test_server_payloads.py`
- `server/README.md`
- `server/requirements.txt`

## New files

- `docs/BOOTH_SESSION_REVIEW.md`
- `docs/RELEASE_v0.20.md`

## Features

- Adds session review after photo processing.
- Adds Approve + Queue Print action.
- Adds Retake Last Photo action.
- Adds Start Over action.
- Adds print quantity controls.
- Adds skip-print option for digital-only sessions.
- Preserves QR behavior for final bordered/composited guest outputs only.
- Adds server route `/booth/session-review-plan`.

## Testing checklist

- `flutter clean`
- `flutter pub get`
- `flutter analyze`
- `flutter run -d chrome`
- Booth Mode → Start Session → countdown → processing → review
- Review → Retake Last Photo
- Review → Start Over
- Review → change print copies
- Review → Skip Print
- Review → Approve → QR screen
- `cd server`
- `py -m unittest discover tests`
- `py -m mybooth_server`
- Browser: `http://127.0.0.1:8080/booth/session-review-plan`

## Git commit

```powershell
git add .
git commit -m "Release MyBooth v0.20 booth session review"
git push origin feature/theme-engine
```
