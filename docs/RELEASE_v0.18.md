# MyBooth v0.18 Template Designer Foundation

## Release goal

Make MyBooth templates and borders editable per event instead of only selectable.

v0.18 introduces the foundation for event-ready border/template customization: editable text, honoree names, dates, subtitles, color palettes, 2x6/4x6 previews, and per-event template saving.

## Changed files

- `lib/branding/mybooth_brand.dart`
- `lib/screens/event_detail_screen.dart`
- `lib/screens/home_screen.dart`
- `lib/services/template_library_service.dart`
- `lib/widgets/dashboard_menu.dart`
- `server/README.md`
- `server/config/server_config.json`
- `server/mybooth_server/__init__.py`
- `server/mybooth_server/config.py`
- `server/mybooth_server/routes.py`
- `server/mybooth_server/services/asset_library_service.py`
- `server/requirements.txt`
- `server/tests/test_server_payloads.py`

## New files

- `lib/screens/template_designer_screen.dart`
- `docs/TEMPLATE_DESIGNER.md`
- `docs/RELEASE_v0.18.md`

## Folder changes

No major folder relocation. The existing app/server split remains:

```text
lib/
server/
docs/
```

## Features added

- New **Template Designer** screen.
- Live foundation preview for 2x6 strips and 4x6 prints.
- Editable template fields:
  - Event Title
  - Person / Honoree / Company Name
  - Subtitle / Age / Custom Line
- Per-event template save flow.
- Per-event palette selection.
- Per-event background pack selection.
- Green screen toggle integrated into the designer.
- Event Details now opens Template Designer.
- Dashboard now includes a Template Designer entry.
- Expanded starter template families:
  - Wedding Floral
  - Wedding Luxury
  - Baptism Classic
  - Baptism Angel
  - Birthday Confetti
  - Birthday Neon
  - Corporate Modern
  - Corporate Gala
  - Beach Party
- Added server designer metadata route:
  - `GET /assets/template-designer-plan`

## Guest delivery rule

The QR code and future Google Photos export should point to final bordered/composited outputs only. Raw Canon originals remain operator-only.

## What this release does not do yet

- It does not render final JPEG/PNG template files.
- It does not connect to Canon EOS R50.
- It does not print to the DNP DS-RX1HS.
- It does not upload to Google Photos.

## Testing checklist

Run Flutter checks:

```powershell
flutter clean
flutter pub get
flutter analyze
flutter run -d chrome
```

Test app flow:

- Open Dashboard.
- Confirm `Template Designer` appears.
- Open Template Designer from Dashboard.
- Change template family.
- Change color palette.
- Edit event title.
- Edit honoree/person/company name.
- Edit subtitle/custom line.
- Save template design.
- Confirm Event Details shows the updated template, palette, event title, honoree, subtitle, background, and green screen status.
- Confirm Booth Mode still opens.
- Confirm Theme Gallery still works.

Run server tests:

```powershell
cd server
py -m unittest discover tests
py -m mybooth_server
```

Test server routes:

```text
http://127.0.0.1:8080/assets/templates
http://127.0.0.1:8080/assets/template-designer-plan
```

## Git commit message

```powershell
git add .
git commit -m "Release MyBooth v0.18 template designer foundation"
git push origin feature/theme-engine
```
