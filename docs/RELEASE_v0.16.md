# MyBooth v0.16 — Photo + Template + Capture + QR Foundation

## Release Goals

- Add photo storage foundation.
- Add editable event template / border foundation.
- Add background pack foundation for green screen workflows.
- Add interchangeable color palette support.
- Add per-event honoree/name/subtitle fields.
- Add countdown settings for future capture sessions.
- Add one-screen guest-facing Booth Mode foundation.
- Add final preview and QR delivery placeholder.
- Define that guest QR links point to final bordered/composited photos, not raw originals.
- Prepare server endpoints for template, background, photo storage, and QR gallery delivery plan metadata.

## New Flutter Files

- `lib/models/booth_asset.dart`
- `lib/providers/asset_library_provider.dart`
- `lib/services/template_library_service.dart`
- `lib/screens/asset_library_screen.dart`
- `lib/screens/booth_mode_screen.dart`

## Changed Flutter Files

- `lib/main.dart`
- `lib/branding/mybooth_brand.dart`
- `lib/models/event.dart`
- `lib/screens/create_event_screen.dart`
- `lib/screens/event_detail_screen.dart`
- `lib/screens/home_screen.dart`
- `lib/screens/settings_screen.dart`
- `lib/widgets/dashboard_menu.dart`

## New Server Files

- `server/mybooth_server/services/asset_library_service.py`
- `server/mybooth_server/services/photo_storage_service.py`

## Changed Server Files

- `server/config/server_config.json`
- `server/mybooth_server/__init__.py`
- `server/mybooth_server/config.py`
- `server/mybooth_server/routes.py`
- `server/mybooth_server/services/gallery_service.py`
- `server/tests/test_server_payloads.py`
- `server/README.md`

## New Server Routes

- `GET /assets/templates`
- `GET /assets/backgrounds`
- `GET /storage/photo-plan`
- `GET /gallery/qr-plan`

## Guest Booth Mode Flow

Booth Mode is the guest-facing one-screen experience foundation:

```text
Start Photo Session
→ Countdown
→ Capture placeholder photo 1
→ Countdown
→ Capture placeholder photo 2
→ Countdown
→ Capture placeholder photo 3 or 4
→ Processing placeholder
→ Final bordered preview placeholder
→ QR code placeholder
→ Start Next Session
```

The current v0.16 Booth Mode is a safe simulation. It does not connect to the Canon EOS R50 yet.

## QR Delivery Rule

Default guest QR behavior:

```text
Guest QR → final bordered/composited strip or grid
```

Operator storage still keeps:

```text
captures/original
captures/processed
captures/composited
captures/bordered
prints/strips
gallery/final
gallery/qr
logs
```

Raw/original photos are not the default guest download target.

## Starter Template Categories

- Weddings
- Baptisms
- Birthdays
- Corporate events
- Seasonal / Beach Party

## Starter Template Support

- 2x6 strips
- 4x6 prints
- editable title
- editable honoree/person name
- editable event date
- editable subtitle
- interchangeable color palettes
- future transparent PNG overlay support
- future green screen background support

## Google Photos Planning

Google Photos will be treated as a future export/delivery option, not the source of truth.

Planned rule:

```text
Google Photos album upload → final guest-ready bordered outputs only
Local MyBooth Server → originals + processed + final + logs
```

## Testing Checklist

Run Flutter:

```powershell
flutter clean
flutter pub get
flutter analyze
flutter run -d chrome
```

Test in the app:

- Dashboard opens.
- Booth Mode opens from the Dashboard when an event exists.
- Event Details opens.
- Start Booth Mode opens from Event Details.
- Booth Mode shows Start Photo Session.
- Countdown runs.
- Simulated photo captures advance.
- Processing screen appears.
- Final preview placeholder appears.
- QR placeholder appears.
- Start Next Session resets the one-screen flow.
- Templates + Assets screen opens.
- Wedding, baptism, birthday, corporate, and seasonal templates display.
- Create Event includes Person / Honoree Name.
- Create Event includes Template Subtitle.
- Create Event includes Border / Print Template selection.
- Create Event includes Template Colors.
- Create Event includes Background Pack.
- Create Event includes Green Screen toggle.
- Create Event includes Countdown settings.
- Event Details shows Template + Border Plan.
- Event Details shows Capture Countdown Plan.
- Event Details shows Photo Storage Plan.
- Theme Gallery still works.
- Server Pairing still works.

Run server tests:

```powershell
cd server
py -m unittest discover tests
py -m mybooth_server
```

Test server routes:

```text
http://127.0.0.1:8080/health
http://127.0.0.1:8080/status
http://127.0.0.1:8080/assets/templates
http://127.0.0.1:8080/assets/backgrounds
http://127.0.0.1:8080/storage/photo-plan
http://127.0.0.1:8080/gallery/qr-plan
```

## Git Commit

```powershell
git add .
git commit -m "Release MyBooth v0.16 photo template capture QR foundation"
git push origin feature/theme-engine
```
