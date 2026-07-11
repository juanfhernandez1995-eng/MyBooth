# MyBooth v0.21 — Router Pairing Improvements

## Release goal

Make the real router/tablet/laptop setup easier and less confusing after field testing the AX1500 router.

## What changed

- Improved Server Pairing screen copy.
- Added a stronger real-router setup guide inside the app.
- Added last successful server address tracking.
- Added **Use Last Successful** action.
- Added saved successful endpoint display.
- Added clearer instructions for using the laptop Wi-Fi IPv4 address from `ipconfig`.
- Clarified that the Booth Router preset is only an example.
- Added warnings not to use `127.0.0.1` or `0.0.0.0` from the tablet.
- Updated Dashboard connection card with the remembered address guidance.
- Added server route: `GET /pairing/router-field-plan`.
- Updated server version to `v0.21`.
- Added `docs/ROUTER_PAIRING.md`.

## Changed files

- `lib/branding/mybooth_brand.dart`
- `lib/models/local_connection.dart`
- `lib/providers/local_connection_provider.dart`
- `lib/services/local_connection_service.dart`
- `lib/screens/local_connection_screen.dart`
- `lib/widgets/connection_status_card.dart`
- `server/config/server_config.json`
- `server/mybooth_server/config.py`
- `server/mybooth_server/routes.py`
- `server/tests/test_server_payloads.py`
- `server/README.md`
- `server/requirements.txt`
- `docs/ROUTER_PAIRING.md`
- `docs/RELEASE_v0.21.md`

## Testing checklist

- Run `flutter clean`.
- Run `flutter pub get`.
- Run `flutter analyze`.
- Run `flutter run -d chrome`.
- Open Server Pairing.
- Enter the real laptop Wi-Fi IPv4 address from `ipconfig`.
- Run Pair with Server.
- Confirm the address is saved as the last successful server address.
- Tap Use Last Successful and confirm the fields update.
- Run server tests:

```powershell
cd server
py -m unittest discover tests
py -m mybooth_server
```

- Test these routes:

```text
http://127.0.0.1:8080/health
http://127.0.0.1:8080/status
http://127.0.0.1:8080/pairing/router-field-plan
```

## Commit message

```text
Release MyBooth v0.21 router pairing improvements
```
