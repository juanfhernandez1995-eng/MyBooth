# MyBooth v0.12 Server App Skeleton

## Release Goal

Create the first laptop-side MyBooth Server project structure while keeping the Flutter app as the tablet/operator interface.

## New Files

```text
server/README.md
server/requirements.txt
server/config/server_config.json
server/mybooth_server/__init__.py
server/mybooth_server/__main__.py
server/mybooth_server/app.py
server/mybooth_server/config.py
server/mybooth_server/models.py
server/mybooth_server/routes.py
server/mybooth_server/services/__init__.py
server/mybooth_server/services/camera_service.py
server/mybooth_server/services/printer_service.py
server/mybooth_server/services/ai_service.py
server/mybooth_server/services/gallery_service.py
server/mybooth_server/services/event_storage_service.py
server/scripts/run_server.ps1
server/tests/test_server_payloads.py
server/storage/events/.gitkeep
server/storage/gallery/.gitkeep
docs/SERVER_APP.md
docs/RELEASE_v0.12.md
```

## Changed Files

```text
lib/branding/mybooth_brand.dart
lib/screens/local_connection_screen.dart
docs/ARCHITECTURE.md
docs/COMMUNICATION_PROTOCOL.md
docs/ROADMAP.md
```

## What This Release Adds

- Laptop-side server folder.
- Standard-library Python HTTP server skeleton.
- Server config foundation.
- `/health` endpoint.
- `/status` endpoint.
- `/modules` endpoint.
- `/pair` mock pairing endpoint.
- Service boundaries for Canon EOS R50, DNP DS-RX1HS, AI background engine, local gallery, and event storage.
- Server docs.
- App branding version updated to `v0.12`.

## What This Release Does Not Do Yet

- Does not control the Canon EOS R50.
- Does not control the DNP printer.
- Does not perform AI background replacement.
- Does not replace the Flutter mock handshake yet.
- Does not require a real private Wi-Fi network yet.

## Testing Checklist

```powershell
flutter clean
flutter pub get
flutter analyze
flutter run -d chrome
```

Also test the server skeleton:

```powershell
cd server
python -m unittest discover tests
python -m mybooth_server
```

Then open:

```text
http://127.0.0.1:8080/health
http://127.0.0.1:8080/status
```

## Git Commit

```powershell
git add .
git commit -m "Release MyBooth v0.12 server app skeleton"
git push origin feature/theme-engine
```
