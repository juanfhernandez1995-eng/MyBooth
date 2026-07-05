# MyBooth v0.15 Router Field Test Prep

MyBooth v0.15 prepares the project for real Android-tablet + private-router + laptop-server testing.

## Release goals

- Make the Server Pairing screen more useful during field setup.
- Add a router field test checklist inside the app.
- Add laptop IPv4 discovery instructions inside the app.
- Clarify firewall and endpoint troubleshooting.
- Keep the real v0.13/v0.14 server handshake working.
- Keep Flutter analyzer clean.

## Changed files

```text
README.md
lib/branding/mybooth_brand.dart
lib/screens/local_connection_screen.dart
server/README.md
server/config/server_config.json
server/mybooth_server/config.py
server/requirements.txt
server/tests/test_server_payloads.py
docs/RELEASE_v0.15.md
docs/ROUTER_FIELD_TEST.md
docs/COMMUNICATION_PROTOCOL.md
docs/ROADMAP.md
docs/SERVER_APP.md
```

## App changes

### Server Pairing

Added a Router Field Test Checklist that walks through:

1. connecting the laptop to the booth Wi-Fi,
2. starting the Python server,
3. finding the laptop IPv4 address,
4. connecting the tablet to the same Wi-Fi, and
5. confirming `/health` and `/status` responses.

### Laptop IP discovery

Added a dedicated card that explains how to run `ipconfig`, find the Wi-Fi IPv4 address, and enter it with port `8080`.

### Documentation

Added `docs/ROUTER_FIELD_TEST.md` with the real field-test steps and troubleshooting checklist.

## Testing checklist

```powershell
flutter clean
flutter pub get
flutter analyze
flutter run -d chrome
```

Server tests:

```powershell
cd server
py -m unittest discover tests
py -m mybooth_server
```

Manual test:

- Dashboard opens.
- Server Pairing opens.
- Router Field Test Checklist displays.
- Laptop IP discovery instructions display.
- Pair with Server still works against `127.0.0.1:8080`.
- Server endpoints still return JSON.
- Create Event still works.
- Continue Event still opens Event Details.

## Git commit

```powershell
git add .
git commit -m "Release MyBooth v0.15 router field test prep"
git push origin feature/theme-engine
```
