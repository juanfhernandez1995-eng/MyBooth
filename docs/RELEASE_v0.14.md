# MyBooth v0.14 Server Pairing Polish

## Release Goal

MyBooth v0.14 polishes the tablet-to-laptop pairing experience before real router/tablet testing.

The core v0.13 real handshake remains in place, but the Local Connection screen now feels closer to a production booth setup flow.

## Highlights

- Renamed the flow from Local Connection to Server Pairing.
- Added clearer Laptop Test and Booth Router presets.
- Added a stronger connected/failed status presentation.
- Added endpoint copy support.
- Added clearer troubleshooting messages.
- Added booth router setup notes directly in the app.
- Improved dashboard connection card copy.
- Updated server version to v0.14.
- Updated Python server binding to `0.0.0.0` so the laptop server can accept local network requests.
- Kept browser/laptop testing available through `127.0.0.1`.

## Changed Files

```text
lib/branding/mybooth_brand.dart
lib/models/local_connection.dart
lib/providers/local_connection_provider.dart
lib/screens/local_connection_screen.dart
lib/services/local_connection_service.dart
lib/widgets/connection_status_card.dart
server/config/server_config.json
server/mybooth_server/app.py
server/mybooth_server/config.py
server/README.md
server/requirements.txt
server/tests/test_server_payloads.py
README.md
docs/COMMUNICATION_PROTOCOL.md
docs/ROADMAP.md
docs/SERVER_APP.md
```

## New Files

```text
docs/RELEASE_v0.14.md
```

## Folder Changes

No new folders were added in this release.

## Testing Checklist

### Flutter Client

```powershell
flutter clean
flutter pub get
flutter analyze
flutter run -d chrome
```

Confirm:

- App opens with splash screen.
- Dashboard shows Server Pairing card.
- Server Pairing screen opens.
- Laptop Test preset fills `127.0.0.1:8080`.
- Booth Router preset fills `192.168.4.1:8080`.
- Save works.
- Pair with Server works when Python server is running.
- Failed pairing shows helpful troubleshooting guidance.
- Theme Gallery still works.
- Create Event still works.
- Continue Event still opens Event Details.

### Python Server

```powershell
cd server
py -m unittest discover tests
py -m mybooth_server
```

Open these URLs while the server is running:

```text
http://127.0.0.1:8080/health
http://127.0.0.1:8080/status
http://127.0.0.1:8080/modules
```

Expected result: JSON responses with server metadata and module boundaries.

## Router Test Notes

When the private router arrives:

1. Connect the laptop to the private booth Wi-Fi.
2. Start the Python server.
3. Find the laptop's Wi-Fi IPv4 address with `ipconfig`.
4. Connect the Android tablet to the same Wi-Fi.
5. Enter the laptop IP and port `8080` in Server Pairing.
6. Tap Pair with Server.

The `192.168.4.1` preset should only be used when the laptop/server is actually using that address on the booth network.

## Git Commit Message

```bash
git add .
git commit -m "Release MyBooth v0.14 server pairing polish"
git push origin feature/theme-engine
```
