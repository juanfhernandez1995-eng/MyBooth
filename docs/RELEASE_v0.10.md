# MyBooth v0.10 - Server Foundation

## Release Goal

Prepare MyBooth for the real commercial architecture where the Android tablet is the client and the gaming laptop is the MyBooth Server.

This release does not connect the Canon EOS R50 or DNP DS-RX1HS yet. It creates the clean app-side foundation for server status, hardware module boundaries, and future local API communication.

## Changed Files

- `lib/main.dart`
- `lib/branding/mybooth_brand.dart`
- `lib/screens/home_screen.dart`
- `lib/screens/settings_screen.dart`
- `lib/widgets/dashboard_menu.dart`
- `lib/widgets/system_status_card.dart`
- `docs/ARCHITECTURE.md`
- `docs/COMMUNICATION_PROTOCOL.md`
- `docs/HARDWARE.md`
- `docs/ROADMAP.md`

## New Files

- `lib/models/server_module.dart`
- `lib/models/server_status.dart`
- `lib/providers/server_status_provider.dart`
- `lib/services/server_status_service.dart`
- `lib/screens/server_dashboard_screen.dart`
- `docs/RELEASE_v0.10.md`

## Folder Changes

No new top-level folders were added.

The server foundation follows the existing architecture:

```text
lib/
  models/
  providers/
  screens/
  services/
  widgets/
```

## What Was Added

- MyBooth Server status model.
- Server module model.
- Server status provider.
- Server status service.
- Server Details screen.
- Dashboard Server Status navigation.
- Server Foundation card on the dashboard.
- Status placeholders for:
  - MyBooth Server laptop
  - Android tablet client
  - Private Wi-Fi network
  - Canon EOS R50
  - DNP DS-RX1HS printer
  - AI background engine
  - Local gallery storage

## Architecture Notes

The tablet still does not directly control hardware.

Target architecture:

```text
Android Tablet Client
        |
   Private Wi-Fi
        |
Gaming Laptop MyBooth Server
        |
  Camera / Printer / AI / Gallery / Event Storage
```

## Testing Checklist

Run:

```powershell
flutter clean
flutter pub get
flutter analyze
flutter run -d chrome
```

Then test:

- App opens with splash screen.
- Dashboard loads.
- Dashboard shows Server Foundation card.
- Tap Server Details from the card.
- Tap Server Status from the dashboard menu.
- Server Details screen opens.
- Refresh button works without errors.
- Theme Gallery still works.
- Create Event still works.
- Continue Event still opens Event Details.
- No analyzer issues.

## Git Commit Message

```bash
git add .
git commit -m "Release MyBooth v0.10 server foundation"
git push origin feature/theme-engine
```
