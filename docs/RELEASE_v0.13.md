# MyBooth v0.13 Real Server Handshake

## Release Summary

MyBooth v0.13 connects the Flutter client to the laptop-side Python server skeleton for the first time.

The Local Connection screen now performs a real HTTP handshake against the MyBooth Server by calling `/health` and `/status`. Mock fallback remains available for demos and offline UI testing.

## Changed Files

```text
pubspec.yaml
lib/branding/mybooth_brand.dart
lib/models/local_connection.dart
lib/providers/local_connection_provider.dart
lib/services/local_connection_service.dart
lib/screens/local_connection_screen.dart
lib/screens/settings_screen.dart
lib/services/server_status_service.dart
lib/widgets/connection_status_card.dart
server/config/server_config.json
server/mybooth_server/config.py
server/requirements.txt
server/tests/test_server_payloads.py
docs/COMMUNICATION_PROTOCOL.md
docs/SERVER_APP.md
docs/ROADMAP.md
```

## New Files

```text
docs/RELEASE_v0.13.md
```

## Dependency Changes

```text
http: ^1.2.2
```

This is used by the Flutter client to call the local laptop server over HTTP.

## Functional Changes

- Added real HTTP calls from Flutter to the laptop server.
- Added `/health` request validation.
- Added `/status` request validation.
- Added server name/version display in Local Connection.
- Added module count and response-time diagnostics.
- Added localhost shortcut for laptop/browser testing.
- Added booth Wi-Fi shortcut for tablet deployment.
- Preserved mock fallback for demos/offline testing.
- Updated dashboard Local Connection card to show real server metadata.
- Updated server version to `v0.13`.

## Testing Checklist

### Flutter

```powershell
flutter clean
flutter pub get
flutter analyze
flutter run -d chrome
```

Confirm:

- Dashboard loads.
- Local Connection card appears.
- Local Connection screen opens.
- Use `127.0.0.1` shortcut works.
- Real Handshake succeeds while the Python server is running.
- Dashboard Local Connection card updates after handshake.
- Mock fallback still works when needed.
- Theme Gallery still works.
- Create Event still works.
- Continue Event still opens Event Details.

### Server

```powershell
cd server
py -m unittest discover tests
py -m mybooth_server
```

Open in browser:

```text
http://127.0.0.1:8080/health
http://127.0.0.1:8080/status
http://127.0.0.1:8080/modules
```

Confirm each endpoint returns JSON.

## Git Commit

```powershell
git add .
git commit -m "Release MyBooth v0.13 real server handshake"
git push origin feature/theme-engine
```

## Notes

This release still does not control camera, printer, AI, or gallery services. It proves that the Flutter tablet/client layer can reach the laptop server process through the local API boundary.
